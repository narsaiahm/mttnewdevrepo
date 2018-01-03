package org.mountsinai.mortalitytriggersystem

import grails.transaction.Transactional
import com.xlson.groovycsv.CsvParser
import groovy.io.FileType
import groovy.sql.Sql
import groovyx.gpars.GParsPool
import oracle.jdbc.OracleTypes
import org.springframework.mail.MailException
import org.mountsinai.mortalitytriggersystem.EmailHandler
import java.util.concurrent.Future
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.context.ApplicationContextAware
import org.springframework.context.ApplicationContext

@Transactional
class MortalityTriggerService implements ApplicationContextAware {

    def dataSource
    def dataSource_SECURE
    def groovyPageRenderer
    def exportService
    def grailsApplication
    def servletContext

    static Logger log = LoggerFactory.getLogger(MortalityTriggerService.class)

    ApplicationContext applicationContext

    def insertMortalityData() {
        try {
            mortalityReviewUpdate()
        } catch (Exception e) {
            e.printStackTrace()
        }

    }

    def mortalityReviewUpdate() {
        def hospitalSite = ""
        def facilityCode = ""

        def facility
        def deptMap = [:]
        def specialityMap = [:]
        def mortalityReviewForm
        def mortalityReviewFormMap = [:]
        def auditTrack
        def auditTrackMap = [:]

        def unassignedStatus = ReviewStatus.findByStatus(MortalityConstants.UNASSIGNED)
        def assignedStatus = ReviewStatus.findByStatus(MortalityConstants.ASSIGNED)

        Sql sql = new Sql(dataSource)
        sql.call '{ call MTT_FRONTEND.getLatestMortalityData(?)}', [Sql.out(OracleTypes.CURSOR)], { rows ->

            rows.eachRow() { row ->
                mortalityReviewForm = new MortalityReviewForm()
                mortalityReviewForm.admitUnit = row.ADMIT_UNIT
                mortalityReviewForm.patientName = row.PATIENT_NAME
                mortalityReviewForm.mrn = row.MRN
                mortalityReviewForm.dischargeUnit = row.DISCHARGE_UNIT
                if (row.SOURCE_FILE_NAME.indexOf(MortalityConstants.MSQ) > -1 || row.SOURCE_FILE_NAME.indexOf(MortalityConstants.MSH) > -1) {
                    StringBuffer sb = new StringBuffer(row.ADMIT_DATE);
                    sb.insert(6, "20");
                    mortalityReviewForm.admitDateTime = new Date().parse("MM/dd/yyyyHH:mm", (sb.toString() + row.ADMIT_TIME).toString())
                } else {
                    mortalityReviewForm.admitDateTime = new Date().parse("MM/dd/yyyyHH:mm", (row.ADMIT_DATE + row.ADMIT_TIME).toString())

                }
                mortalityReviewForm.expiredDateTime = new Date().parse("MM/dd/yyyyHH:mm", (row.DATE_EXPIRED + row.TIME_EXPIRED).toString())
                mortalityReviewForm.hospService = row.HOSP_SERVICE
                mortalityReviewForm.lastAttending = row.LAST_ATTENDING
                mortalityReviewForm.dictationCode = row.DICTATION_CODE
                mortalityReviewForm.serviceTeam = row.SERVICE_TEAM
                mortalityReviewForm.visitId = row.VISIT_ID
                mortalityReviewForm.gender = row.GENDER
                mortalityReviewForm.admittingDiagnosis = row.ADMITTING_DIAGNOSIS
                mortalityReviewForm.dischargeDiagnosis = row.DISCHARGE_DIAGNOSIS
                mortalityReviewForm.dateUpdated = new Date()

                def sourceFileName = row.SOURCE_FILE_NAME?.toString()?.toUpperCase()

                if (sourceFileName.indexOf(MortalityConstants.MSQ) > -1) {
                    facilityCode = MortalityConstants.MSQ
                } else if (sourceFileName.indexOf(MortalityConstants.BIPETRIE) > -1) {
                    facilityCode = MortalityConstants.MSBI
                } else if (sourceFileName.indexOf(MortalityConstants.MSB) > -1) {
                    facilityCode = MortalityConstants.MSB
                } else if (sourceFileName.indexOf(MortalityConstants.MSWEST) > -1) {
                    facilityCode = MortalityConstants.MSW
                } else if (sourceFileName.indexOf(MortalityConstants.STLUKES) > -1) {
                    facilityCode = MortalityConstants.MSSL
                } else {
                    facilityCode = MortalityConstants.MSH
                }

                if (facilityCode.equals("") || !hospitalSite.equals(facilityCode)) {
                    facility = Facility.findByFacilityCode(facilityCode)
                    def depts = Department.findAllByFacility(facility)
                    def specialities = Speciality.findAllByFacility(facility)
                    depts.each {
                        deptMap[it?.departmentName?.toUpperCase()] = it
                    }

                    specialities.each {
                        specialityMap[it?.specialityName?.toUpperCase()] = it
                    }
                    hospitalSite = facilityCode
                }

                mortalityReviewForm.hospitalSite = facilityCode

                mortalityReviewForm.createdBy = MortalityConstants.MTT_SYSTEM

                mortalityReviewForm.facility = facility
                mortalityReviewForm.dept = deptMap[mortalityReviewForm.hospService.toUpperCase()]
                if(specialityMap[mortalityReviewForm.hospService.toUpperCase()]?.lead){
                    mortalityReviewForm.speciality = specialityMap[mortalityReviewForm.hospService.toUpperCase()]
                    mortalityReviewForm.lead = mortalityReviewForm.speciality?.lead
                }
                mortalityReviewForm.isArchive = false

                if (mortalityReviewForm.speciality) {
                    mortalityReviewForm.status = assignedStatus
                } else {
                    mortalityReviewForm.status = unassignedStatus
                }

                mortalityReviewFormMap[row.MRN] = mortalityReviewForm

            }

        }

        if (mortalityReviewFormMap.size() > 0) {
            //batch insert
            mortalityReviewFormMap.each {
                def mortalityReviewFormObj = it.value
                MortalityReviewForm.withTransaction {
                    mortalityReviewFormObj.save(failOnError: true)
                }
                auditTrack = new AuditTrack()
                auditTrack.mortalityReviewFormId = mortalityReviewFormObj.id
                auditTrack.updatedBy = MortalityConstants.MTT_SYSTEM
                auditTrack.prevStatus = ''
                auditTrack.updatedStatus = mortalityReviewFormObj.status
                auditTrack.assignedUser = mortalityReviewFormObj?.lead?.name

                auditTrackMap[mortalityReviewFormObj.mrn] = auditTrack
            }

            MortalityReviewForm.withSession { session ->
                session.flush()
            }
            println "MortalityReviewForm Information inserted at " + new Date()

            if (auditTrackMap.size() > 0) {
                //AuditTrail batch insert data
                auditTrackMap.each {
                    def auditTrackObj = it.value
                    AuditTrack.withTransaction {
                        auditTrackObj.save(failOnError: true)
                    }
                }

                AuditTrack.withSession { session ->
                    session.flush()
                }

            }

            println "MortalityReviewForm AuditTrack information inserted at " + new Date()

        }
    }

    /**
     * function to send notification once review form is inserted and assigned by cron job
     * @param serverName
     * @return
     */
    def sendMortalityNotification(serverName) {
        def today = new Date()+1
        def reviewList = MortalityReviewForm.executeQuery("select mrf.id, mrf.mrn, mrf.patientName, mrf.lead ,to_char(mrf.expiredDateTime,'mm/dd/yyyy') as expiredDateTime from MortalityReviewForm mrf where mrf.lead is not null and trunc(mrf.dateCreated) <= trunc(:dateCreated)", [dateCreated: today])
        def toAddr = ''
        if (serverName.contains(AdminConstants.SERVER_NAME_LOCALHOST)) {
            toAddr = "anshul.bansal@mountsinai.org" //personnel email address for local testing
        }
        reviewList.each {

            def reviewFormLink = AdminUtils.getBaseURL() + '/mortality/review?reviewId=' + it[0] + '&isEmailLink=1'

            def isEmailNotificationEnabled = checkEnableEmailNotificationConfig()
            /*if(isEmailNotificationEnabled){
                toAddr = it[3]?.email
            }*/

            /*if (!serverName.contains(AdminConstants.SERVER_NAME_LOCALHOST) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_DEV) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_QA)) {
                toAddr = it[3]?.email
            }*/
            //sendEmail(it[3]?.name, it[2], it[4], it[1], reviewFormLink, toAddr)

        }
        log.info("Email Notifications sent on " +new Date() + " to - " +reviewList*.getAt(3)?.email)
        log.info("Total email notifications sent - " +reviewList.size())

    }

    /**
     * Method to get Review List from MTT_FRONTEND.getReviewList based on facilities.
     * @param facilities
     * @param leadEmail
     * @param specialityId
     * @return reviewList
     */
    def getReviewList(facilities, leadEmail, specialityId) {

        Sql sql = new Sql(dataSource)
        def reviewList = []
        sql.call '{ call MTT_FRONTEND.getReviewList(?,?,?,?)}', [facilities, leadEmail, specialityId, Sql.out(OracleTypes.CURSOR)], { row ->
            row.eachRow() {

                def review = [:]
                review.id = row.ID
                review.patientName = row.PATIENT_NAME
                review.dischargeDateTime = row.EXPIRED_DATE
                review.facilityName = row.FACILITY_NAME
                review.facilityCode = row.FACILITY_CODE
                review.dischargingDivision = row.DISCHARGING_DIVISION
                review.dischargeUnit = row.DISCHARGE_UNIT
                review.statusDateTime = row.DATE_UPDATED
                review.status = row.status
                review.mrn = row.mrn
                review.lead = row.LEAD_ID
                review.role = row.ROLE_NAME
                if (review.status.equals(MortalityConstants.ASSIGNED) || (review.status.equals(MortalityConstants.REASSIGNED))) {
                    review.statusStr = "Not Accepted"
                } else if (review.status.equals(MortalityConstants.UPDATED)) {
                    review.statusStr = "Partially Complete"
                } else if (review.status.equals(MortalityConstants.ACCEPTED)) {
                    review.statusStr = "Accepted"
                }
                reviewList.add(review)
            }
        }
        return reviewList
    }

    /**
     * Method to send email notification to the user, if review form is assigned to that user.
     * @param assignedUser
     * @param patientName
     * @param expiredDateTime
     * @param mrn
     * @param reviewFormLink
     * @param toAddr
     * @return
     */
    def sendEmail(assignedUser, patientName, expiredDateTime, mrn, reviewFormLink, toAddr) {
        def fromAddr = AdminConstants.EMAIL_FROM_ADDRESS
        def ccAddr = ''
        def subject = AdminConstants.EMAIL_REVIEW_FORM_NOTIFICATION_SUBJECT
        try {
            def text = groovyPageRenderer.render template: '/email/templates/notificationEmail', model: [assignedUser: assignedUser, patientName: patientName, expiredDateTime: expiredDateTime, reviewFormLink: reviewFormLink]
            //EmailHandler.sendEmail(fromAddr, toAddr, ccAddr, subject, text, false)
            log.info('Email Notifications sent on ' +new Date() + ' to - ' +toAddr)
        } catch (Exception ex) {
            ex.printStackTrace()
            return false
        }
    }
    /**
     * Method to get Admin Review List from MTT_FRONTEND.getReviewList based on facilities
     * @param facilities
     * @return adminReviewList
     */
    def getAdminReviewList(facilities) {
        Sql sql = new Sql(dataSource)
        def adminReviewList = []
        def completeStatusList = []

        sql.call '{call MTT_FRONTEND.getReviewList(?,?,?,?)}', [facilities, "", "", Sql.out(OracleTypes.CURSOR)], { rows ->
            rows.eachRow() { row ->
                def review = [:]
                if (row.status.equals(MortalityConstants.SUBMITTED) || row.status.equals(MortalityConstants.AMENDED)) {
                    review.id = row.ID
                    review.patientName = row.PATIENT_NAME
                    review.expiredDateTime = row.EXPIRED_DATE
                    review.facilityCode = row.FACILITY_CODE
                    review.dischargeUnit = row.DISCHARGE_UNIT
                    review.dischargingDivision = row.DISCHARGING_DIVISION
                    review.assignedTo = row.ASSIGNED_TO
                    review.mrn = row.MRN
                    review.assignedTo_role = row.ROLE
                    review.daysSinceDeath = row.DAYS_SINCE_DEATH
                    review.statusDateTime = row.FORM_DATE_UPDATED
                    review.status = row.status
                    review.lead = row.LEAD_ID
                    review.role = row.ROLE_NAME
                    completeStatusList.add(review)
                } else {
                    review.id = row.ID
                    review.patientName = row.PATIENT_NAME
                    review.expiredDateTime = row.EXPIRED_DATE
                    review.facilityCode = row.FACILITY_CODE
                    review.dischargeUnit = row.DISCHARGE_UNIT
                    review.dischargingDivision = row.DISCHARGING_DIVISION
                    review.hospService = row.hosp_service
                    review.assignedTo = row.ASSIGNED_TO
                    review.mrn = row.MRN
                    review.assignedTo_role = row.ROLE
                    review.daysSinceDeath = row.DAYS_SINCE_DEATH
                    review.statusDateTime = row.FORM_DATE_UPDATED
                    review.status = row.status
                    review.lead = row.LEAD_ID
                    review.role = row.ROLE_NAME
                    if (review.status.equals(MortalityConstants.ASSIGNED) || (review.status.equals(MortalityConstants.REASSIGNED))) {
                        review.statusStr = "Not Accepted "
                    } else if (review.status.equals(MortalityConstants.UPDATED)) {
                        review.statusStr = "Partially Complete"
                    } else if (review.status.equals(MortalityConstants.ACCEPTED)) {
                        review.statusStr = "Accepted"
                    }
                    adminReviewList.add(review)
                }
            }
        }
        completeStatusList.sort { i1, i2 -> i2.statusDateTime <=> i1.statusDateTime }
        adminReviewList += completeStatusList
        return adminReviewList
    }

    /**
     * Method to get facilityList, specialityList, leadList and adhocList from MTT_FRONTEND.getAdminSearchFields based on facilityId Passed
     * @param facilityId
     * @return facilityList , specialityList, leadList, adhocList
     */
    def getAdminSearchFields(facilityId) {
        def facilityList = []
        def specialityList = []
        def leadList = []
        def adhocList = []
        Sql sql = new Sql(dataSource)
        sql.call '{call MTT_FRONTEND.getAdminSearchFields(?,?,?,?,?)}', [facilityId, Sql.out(OracleTypes.CURSOR), Sql.out(OracleTypes.CURSOR), Sql.out(OracleTypes.CURSOR), Sql.out(OracleTypes.CURSOR)], { facilityListCursor, specialityListCursor, leadListCursor, adhocListCursor ->
            facilityListCursor.eachRow() { facilityRs ->
                def facility = [:]
                facility.id = facilityRs.id
                facility.facilityName = facilityRs.facility_name
                facility.facilityCode = facilityRs.facility_code
                facilityList.add(facility)
            }

            specialityListCursor.eachRow() { specialityRs ->
                def speciality = [:]
                speciality.id = specialityRs.id
                speciality.specialityName = specialityRs.speciality_name
                specialityList.add(speciality)
            }

            leadListCursor.eachRow() { leadRs ->
                def lead = [:]
                lead.id = leadRs.id
                lead.name = leadRs.name
                leadList.add(lead)
            }
            adhocListCursor.eachRow() { adhocRs ->
                def adhoc = [:]
                adhoc.id = adhocRs.id
                adhoc.name = adhocRs.name
                adhocList.add(adhoc)
            }
        }
        return ['facilityList': facilityList, 'specialityList': specialityList, 'leadList': leadList, 'adhocList': adhocList]
    }

    /**
     * Method to get Search Result list for admin board by passing params from admin dashboard
     * @param params
     * @return resultList
     */
    def searchReview(params) {
        def sb = StringBuilder.newInstance();
        def basicSql = """
                        SELECT mr.id,
                          mr.patient_Name,
                          mr.mrn,
                          to_char(mr.expired_date_time,'mm/dd/yyyy hh24:mi') as expired_date_time,
                          to_char(mr.expired_date_time,'mm/dd/yyyy hh24:mi'),                          
                          fac.facility_code,
                          fac.facility_name,
                          mr.DISCHARGE_UNIT,
                          spec.speciality_name as discharging_division,
                          mr.hosp_service as hosp_service,
                          mu.name as assigned_to,
                          role.role_name role,
                          extract (DAY FROM(sysdate - mr.expired_date_time)) AS days_since_death,
                          to_char(mr.date_updated,'mm/dd/yyyy hh24:mi') as form_date_updated,
                          status.status,
                          aut.prev_status,
                          aut.updated_status,
                          aut.assigned_user,
                          aut.updated_by,
                          to_char(aut.date_updated,'mm/dd/yyyy hh24:mi') as status_date_updated,
                          mu.id as LEAD_ID
                        FROM
                          review_status status,
                          audit_track aut,
                          facility fac,
                          mortality_review_form mr 
                          left outer join  speciality spec
                          on  mr.speciality_id = spec.id
                          left outer join  mortality_user mu
                          on mr.lead_id = mu.id
                          left outer join  role role
                          on mu.role_id = role.id
                          WHERE fac.id    = mr.facility_id
                          AND INSTR(','||'$params.facility'||',', ','||mr.facility_id||',') <> 0 
                          AND status.id   = mr.status_id
                          AND aut.mortality_review_form_id = mr.id
                        """
        sb << basicSql
        if (params.formStatus && params.formStatus != '') {
            if (params.formStatus.equals(MortalityConstants.UNASSIGNED)) {
                sb << " and status.status != '$MortalityConstants.SUBMITTED' and status.status != '$MortalityConstants.AMENDED'"
            } else if (params.formStatus.equals(MortalityConstants.SUBMITTED) || params.formStatus.equals(MortalityConstants.AMENDED)) {
                sb << " and status.status = '$params.formStatus'"
            }
        }
        if (params.speciality && params.speciality != '') {
            sb << " and mr.speciality_id = $params.speciality "
        }
        if (params.qualityLead && params.qualityLead != '') {
            sb << " and mr.lead_id = $params.qualityLead "
        }
        if (params.assignedTo && !params.assignedTo.equals('ALL')) {
            if (params.assignedTo?.toString().equals(AdminConstants.QUALITY_LEAD)) {
                //Role role = Role.findByRoleName(AdminConstants.QUALITY_LEAD)
                Role role = servletContext.roles.find { it.roleName.equals(AdminConstants.QUALITY_LEAD) }
                sb << " and mu.role_id = " + role.id
            }
            if (params.assignedTo?.toString().equals(AdminConstants.ADHOC)) {
                //Role role = Role.findByRoleName(AdminConstants.ADHOC)
                Role role = servletContext.roles.find { it.roleName.equals(AdminConstants.ADHOC) }
                sb << " and mu.role_id = " + role.id
            }
        }
        if (params.mrn && params.mrn != '') {
            sb << " and mrn = '$params.mrn' "
        }
        if (params.patientName && params.patientName != '') {
            sb << " and LOWER(patient_name) like LOWER('%$params.patientName%')"
        }
        if (params?.dateOfDeathRadio?.toString()?.indexOf(MortalityConstants.DATE_OF_DEATH) > -1) {
            sb << " and trunc(expired_date_time) = to_date('$params.dateOfDeath', 'mm/dd/yyyy')"
        }

        if (params.dateOfDeathRadio?.toString()?.indexOf(MortalityConstants.DATE_RANGE) > -1) {
            sb << " and trunc(expired_date_time) between to_date('$params.fromDeathDate','mm/dd/yyyy') and  to_date('$params.toDeathDate','mm/dd/yyyy') "
        }

        if (params.dateCompletedRadio?.toString()?.indexOf(MortalityConstants.DATE_COMPLETED) > -1) {
            sb << " and ( status.status = 'SUBMITTED' or status.status = 'AMENDED' )"
            sb << " and trunc(mr.date_updated) = to_date('$params.dateCompleted','mm/dd/yyyy') "
        }

        if (params.dateCompletedRadio?.toString()?.indexOf(MortalityConstants.COMPLETED_RANGE) > -1) {
            sb << " and ( status.status = 'SUBMITTED' or status.status = 'AMENDED' ) "
            sb << " and trunc(mr.date_updated) between to_date('$params.fromDateCompleted','mm/dd/yyyy') and to_date('$params.toDateCompleted','mm/dd/yyyy') "

        }

        if (params.dateCompletedRadio?.toString()?.indexOf(MortalityConstants.DATE_COMPLETED) < 0 && params.dateCompletedRadio?.toString()?.indexOf(MortalityConstants.COMPLETED_RANGE) < 0) {
            sb << " and mr.is_archive = 0"
        }

        if (params.requiredFurtherReview) {
            sb << " and does_death_require_further_rev = 1"
        }
        if (params.expectedPatToDieAdmission) {
            sb << " and expected_pat_to_die_admission = 1"
        }

        sb << " order by mr.expired_date_time, aut.date_updated"
        Sql sql = new Sql(dataSource)
        def resultList = []
        def unassignedResultList = []
        def incompleteResultList = []
        def completeResultList = []
        sql.call '{call MTT_FRONTEND.searchReview(?,?)}', [sb.toString(), Sql.out(OracleTypes.CURSOR)], { results ->
            results.eachRow() { result ->
                def searchResult = [:]
                searchResult.id = result.ID
                searchResult.patientName = result.PATIENT_NAME
                searchResult.mrn = result.MRN
                searchResult.expiredDateTime = result.EXPIRED_DATE_TIME
                searchResult.facilityCode = result.FACILITY_CODE
                searchResult.dischargeUnit = result.DISCHARGE_UNIT
                searchResult.dischargingDivision = result.DISCHARGING_DIVISION
                searchResult.hospService = result.hosp_service
                searchResult.assignedTo = result.ASSIGNED_TO
                searchResult.assignedTo_role = result.ROLE
                searchResult.daysSinceDeath = result.DAYS_SINCE_DEATH
                searchResult.statusDateTime = result.FORM_DATE_UPDATED
                searchResult.lead = result.LEAD_ID
                searchResult.role = result.ROLE
                searchResult.status = result.STATUS
                searchResult.history_prev_status = result.PREV_STATUS
                searchResult.history_updated_status = result.UPDATED_STATUS
                searchResult.history_assigned_user = result.ASSIGNED_USER
                searchResult.history_updated_by = result.UPDATED_BY
                searchResult.history_date_updated = result.STATUS_DATE_UPDATED

                if (searchResult.status.equals(MortalityConstants.ASSIGNED) || (searchResult.status.equals(MortalityConstants.REASSIGNED))) {
                    searchResult.statusStr = "Not Accepted "
                } else if (searchResult.status.equals(MortalityConstants.UPDATED)) {
                    searchResult.statusStr = "Partially Complete"
                } else if (searchResult.status.equals(MortalityConstants.ACCEPTED)) {
                    searchResult.statusStr = "Accepted"
                }

                if (result.status.equals(MortalityConstants.UNASSIGNED)) {
                    searchResult.excelStatus = MortalityConstants.UNASSIGNED
                    unassignedResultList.add(searchResult)
                } else if (result.status.equals(MortalityConstants.ASSIGNED) || result.status.equals(MortalityConstants.REASSIGNED) || result.status.equals(MortalityConstants.ACCEPTED) || result.status.equals(MortalityConstants.UPDATED)) {
                    searchResult.excelStatus = MortalityConstants.INCOMPLETE
                    incompleteResultList.add(searchResult)
                } else if (result.status.equals(MortalityConstants.SUBMITTED) || result.status.equals(MortalityConstants.AMENDED)) {
                    searchResult.excelStatus = MortalityConstants.COMPLETE
                    completeResultList.add(searchResult)
                }

            }
        }
        completeResultList.sort { i1, i2 -> i2.statusDateTime <=> i2.statusDateTime }

        resultList += unassignedResultList
        resultList += incompleteResultList
        resultList += completeResultList

        def statusHistoryResultMap = [:]

        resultList.each {
            def statusMap = [:]
            statusMap.history_prev_status = (it.history_prev_status == null || it.history_prev_status == '') ? MortalityConstants.MTT_SYSTEM : it.history_prev_status
            statusMap.history_updated_status = it.history_updated_status
            statusMap.history_assigned_user = it.history_assigned_user
            statusMap.history_updated_by = it.history_updated_by
            statusMap.history_date_updated = it.history_date_updated
            if (!statusHistoryResultMap[it.id]) {
                statusHistoryResultMap[it.id] = [statusMap]
            } else {
                statusHistoryResultMap[it.id] << statusMap
            }
        }
        resultList = resultList.unique { it.id }
        return [resultList, statusHistoryResultMap]
    }

    /**
     * Method to get History details in proper format grouping based on status
     * @param reviewList
     * @param statusHistoryMap
     * @return
     */
    def formatReviewResultsWithHistory(reviewList, statusHistoryMap, isExport) {
        reviewList.each { review ->
            def statusHistory = statusHistoryMap[review.id]
            statusHistory.sort { i1, i2 -> i2.history_date_updated <=> i1.history_date_updated }
            def sb = new StringBuilder()
            statusHistory.each { history ->
                if (history.history_updated_status.equals(MortalityConstants.UNASSIGNED)) {
                    sb.append(history.history_updated_status + ' by ' + history.history_updated_by + " (" + history.history_date_updated + ')')
                } else if (history.history_updated_status.equals(MortalityConstants.ACCEPTED) || history.history_updated_status.equals(MortalityConstants.UPDATED)) {
                    sb.append(history.history_updated_status + " by " + history.history_updated_by + ' (' + history.history_date_updated + ')' /*"[Form Status : Assigned: Incomplete]"*/)
                } else if (history.history_updated_status.equals(MortalityConstants.ASSIGNED)) {
                    sb.append("ASSIGNED to " + history.history_assigned_user + " by " + history.history_updated_by + " (" + history.history_date_updated + ")")
                } else if (history.history_updated_status.equals(MortalityConstants.REASSIGNED)) {
                    sb.append("REASSIGNED to " + history.history_assigned_user + " by " + history.history_updated_by + " (" + history.history_date_updated + ")"/*"[Form Status : Assigned: Incomplete]"*/)

                } else if (history.history_updated_status.equals(MortalityConstants.SUBMITTED) || history.history_updated_status.equals(MortalityConstants.AMENDED)) {
                    sb.append(history.history_updated_status + " by " + history.history_updated_by + " (" + history.history_date_updated + ")"/*"[Form Status : Complete]"*/)
                }
                if (isExport) {
                    sb.append("\r\n")
                } else {
                    sb.append("<br>")
                }
            }
            review.statusHistoryStr = sb.toString()
        }
        return reviewList
    }

    /**
     * Method to export search data to Excel format
     * @return
     */
    def exportData(params, response, reviewResults) {
        params.format = "excel" //pdf
        params.extension = "xls" //pdf

        if (params?.format) {
            response.contentType = grailsApplication.config.grails.mime.types[params.format]
            response.setHeader("Content-disposition", "attachment; filename=mttExport.${params.extension}")

            List fields = ["patientName", "mrn", "expiredDateTime", "facilityCode", "dischargeUnit", "dischargingDivision", "assignedTo", "daysSinceDeath", "statusDateTime", "status", "statusHistoryStr", "excelStatus"]
            Map labels = ["patientName": "Patient Name", "mrn": "MRN", "expiredDateTime": "Discharge Date", "facilityCode": "Hospital", "dischargeUnit": "Discharging Unit", "dischargingDivision": "Specialty",
                          "assignedTo" : "Assigned To", "daysSinceDeath": "Days Since Death", "statusDateTime": "Status Date/Time", "status": "Status", "statusHistoryStr": "Status History", "excelStatus": "Grouping Status"]



            Map formatters = [:]
            Map parameters = [:]

            exportService.export(params.format, response.outputStream, reviewResults, fields, labels, formatters, parameters)
            return response.outputStream

        }
    }

    /**
     * Method to check the IsReviewFormEditable.
     * @param user
     * @param mReviewForm
     * @return isFormEditable
     */
    def checkIsReviewFormEditable(user, mReviewForm) {
        def isFormEditable = false
        MortalityUser mUser = user
        MortalityReviewForm reviewForm = mReviewForm
        def formStatus = reviewForm?.status?.status

        if (reviewForm?.lead) {
            if (formStatus.equals(MortalityConstants.ACCEPTED) || formStatus.equals(MortalityConstants.UPDATED)) {
                if (mUser.email.toString().toLowerCase().equals(reviewForm?.lead?.email?.toString()?.toLowerCase())) {
                    isFormEditable = true
                }
            }
        }
        return isFormEditable
    }

    /**
     * Method to send email notification to the user, if review form is assigned to that user.
     * @param params
     * @return returnMap
     */
    def sendNotification(params) {
        def returnMap = [:]
        def toAddr
        def reviewFormLink
        if (params.lead) {
            MortalityUser leadObj = MortalityUser.findById(params.lead)
          //  toAddr = leadObj.email
            reviewFormLink = AdminUtils.getBaseURL() + '/mortality/review?reviewId=' + params.reviewId + '&isEmailLink=1'
        } else if (params.reviewerSelect) {
            MortalityUser reviewerObj = MortalityUser.findById(params.reviewerSelect)
           // toAddr = reviewerObj.email
            reviewFormLink = AdminUtils.getBaseURL() + '/mortality/review?reviewId=' + params.reviewId + '&isEmailLink=1'
        }
        def notification = {
            try {
                def patientName = params.patientName
                def assignedUser = params.assignedUser
                def mrn = params.mrn
                def expiredDateTime
                if (params.expiredDateTime) {
                    expiredDateTime = params.expiredDateTime.split(" ")[0]
                }

                toAddr = "anshul.bansal@mountsinai.org" //personnel email address for local testing
                //sendEmail(assignedUser, patientName, expiredDateTime, mrn, reviewFormLink, toAddr)
                log.info("Email Notifications sent on " +new Date() + " to - " +toAddr)
                returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
            } catch (Exception e) {

                e.printStackTrace()
                log.error(e.message)
                returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
                returnMap[MortalityConstants.MESSAGE] = e.message
            }

        }

        //for asynchronous call
        GParsPool.withPool {
            Future result = notification.callAsync()
        }
        return returnMap
    }

    /**
     * Method to update the assigned  Lead or Reviewer to the mortality Review Form .
     * @param params
     * @param userName
     * @return returnMap
     */

    def updateAssignLeadReviewer(params, userName) {
        def returnMap = [:]
        def MortalityUser mshsuser
        def users = []
        try {
            def existingForm = MortalityReviewForm.findById(params.reviewId)
            //Check User Exist OR not
            if(params?.userEmailId){
                users = MortalityUser.findAllByEmailIlikeAndFacilityAndActiveFlag(params?.userEmailId,existingForm.facility,true)

                if(users && users.size() > 0) {
                    mshsuser = users[0]
                } else {
                    // Insert user details as Reviewer
                    MortalityUser   user = new MortalityUser()
                    user.name = params?.assignedUser
                    user.email = params?.userEmailId
                    user.facility = existingForm.facility
                    user.speciality = existingForm.speciality
                    user.role = Role.findByRoleName(AdminConstants.ADHOC)
                    user.activeFlag = true
                    mshsuser =   user.save(failOnError: true, flush: true)

                }
            }
            if (params.status.equals(MortalityConstants.ASSIGNED)) {
                ReviewStatus statusObj = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.REASSIGNED)
                }

                existingForm.status = statusObj
            } else if (params.status.equals(MortalityConstants.UNASSIGNED)) {
                ReviewStatus statusObj = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.ASSIGNED)
                }
                existingForm.status = statusObj
            } else if (params.status.equals(MortalityConstants.UPDATED) || params.status.equals(MortalityConstants.REASSIGNED)) {
                def newForm = new MortalityReviewForm()
                def id = existingForm.id
                newForm.admitUnit = existingForm.admitUnit
                newForm.patientName = existingForm.patientName
                newForm.mrn = existingForm.mrn
                newForm.dischargeUnit = existingForm.dischargeUnit
                newForm.admitDateTime = existingForm.admitDateTime
                newForm.expiredDateTime = existingForm.expiredDateTime
                newForm.hospService = existingForm.hospService
                newForm.lastAttending = existingForm.lastAttending
                newForm.dictationCode = existingForm.dictationCode
                newForm.serviceTeam = existingForm.serviceTeam
                newForm.visitId = existingForm.visitId
                newForm.gender = existingForm.gender
                newForm.admittingDiagnosis = existingForm.admittingDiagnosis
                newForm.dischargeDiagnosis = existingForm.dischargeDiagnosis
                newForm.hospitalSite = existingForm.hospitalSite
                newForm.facility = existingForm.facility

                existingForm.properties = newForm.properties
                existingForm.id = id
                ReviewStatus statusObj = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.REASSIGNED)
                }
                existingForm.status = statusObj
            }
            if (params.lead) {
                MortalityUser leadObj = MortalityUser.findById(params.lead)
                existingForm.speciality = leadObj.speciality
                existingForm.lead = leadObj
            } else if (mshsuser) {
                existingForm.speciality = mshsuser.speciality
                existingForm.lead = mshsuser
            }
            existingForm.dateUpdated = new Date()
            existingForm.updatedBy = userName
            existingForm.save(failOnError: true, flush: true)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS

        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }

        return returnMap
    }

    /**
     * Method to update  mortality Review Form status to ACCEPTED ,if user accept the assigned form  .
     * @param params
     * @param userName
     * @return returnMap
     */
    def acceptReviewForm(params, userName) {
        def returnMap = [:]
        try {
            MortalityReviewForm patientForm = MortalityReviewForm.findById(params.reviewId)
            ReviewStatus statusObj = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.ACCEPTED)
            }
            patientForm.status = statusObj
            patientForm.dateUpdated = new Date()
            patientForm.updatedBy = userName
            patientForm.save(failOnError: true, flush: true)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }
        return returnMap
    }


    def saveAssignUserAsQL(params) {
        def returnMap = [:]
        try {
            def mshsuser = new MortalityUser()
            def userSpeciality = Speciality.get(Integer.parseInt(params?.speciality))
            mshsuser.name = params.username
            mshsuser.email = params.email
            mshsuser.facility = Facility.get(Integer.parseInt(params?.facility))
            mshsuser.speciality = userSpeciality
            mshsuser.role = Role.findByRoleName(AdminConstants.QUALITY_LEAD)
            mshsuser.activeFlag = true
            mshsuser.save(failOnError: true, flush: true)

            //update lead Id for the speciality
            userSpeciality.lead = mshsuser
            userSpeciality.save(failOnError: true, flush: true)

            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
            returnMap[MortalityConstants.MESSAGE] = " User : " + mshsuser.name + " successfully added to the speciality: " + userSpeciality.specialityName + " as Quality Lead."
        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }
        return returnMap
    }


    def saveAssignUserAsReviewer(params) {
        def returnMap = [:]
        try {
            def mshsuser = new MortalityUser()
            def userSpeciality = Speciality.get(Integer.parseInt(params?.specialityId))
            mshsuser.name = params.userName
            mshsuser.email = params.email
            mshsuser.facility = Facility.get(Integer.parseInt(params?.facilityId))
            mshsuser.speciality = userSpeciality
            mshsuser.role = Role.findByRoleName(AdminConstants.ADHOC)
            mshsuser.activeFlag = true
            mshsuser.save(failOnError: true, flush: true)

            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS

        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }
        return returnMap
    }

    /**
     * This method will unAssign MSHS user, clears all assigned, accepted, updated, reassigned forms
     * @param params
     * @param adminUserName
     * @return returnMap
     */
    def unAssignMSHSUser(params, adminUserName) {
        def returnMap = [:]
        Sql sql = new Sql(dataSource)
        try {

            MortalityUser userDetails = MortalityUser.get(params?.userId)
            ReviewStatus assignedStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.ASSIGNED)
            }
            ReviewStatus acceptedStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.ACCEPTED)
            }
            ReviewStatus updatedStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.UPDATED)
            }
            ReviewStatus reassignedStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.REASSIGNED)
            }
            //check if any review forms assigned to the user or not
            ArrayList<MortalityReviewForm> reviewFormsList = MortalityReviewForm.findAllByLeadAndStatusInList(userDetails, [assignedStatus, acceptedStatus, updatedStatus, reassignedStatus])

            reviewFormsList.each { it ->

                def newForm = new MortalityReviewForm()
                def id = it.id

                newForm.admitUnit = it.admitUnit
                newForm.patientName = it.patientName
                newForm.mrn = it.mrn
                newForm.dischargeUnit = it.dischargeUnit
                newForm.admitDateTime = it.admitDateTime
                newForm.expiredDateTime = it.expiredDateTime
                newForm.hospService = it.hospService
                newForm.lastAttending = it.lastAttending
                newForm.dictationCode = it.dictationCode
                newForm.serviceTeam = it.serviceTeam
                newForm.visitId = it.visitId
                newForm.gender = it.gender
                newForm.admittingDiagnosis = it.admittingDiagnosis
                newForm.dischargeDiagnosis = it.dischargeDiagnosis
                newForm.hospitalSite = it.hospitalSite
                newForm.facility = it.facility
                newForm.isArchive = false
                it.properties = newForm.properties
                it.id = id

                ReviewStatus statusObj = ReviewStatus.findByStatus(MortalityConstants.UNASSIGNED)
                it.status = statusObj
                it.dateUpdated = new Date()
                it.updatedBy = adminUserName
                it.save(failOnError: true, flush: true)

                //audit track the review form status
                sql.call '{ call MTT_FRONTEND.auditTrack(?,?,?,?,?,?)}', [id, it.status.status, statusObj.status, adminUserName, null, Sql.out(OracleTypes.NUMBER)], { status ->

                }
            }

            def userSpeciality = Speciality.findBySpecialityName(params?.speciality)
            //update Lead
            if (userSpeciality) {
                userSpeciality?.lead = null
                userSpeciality.save(failOnError: true, flush: true)
            }
            //update user details
            userDetails.speciality = null
            userDetails.activeFlag = false

            userDetails.save(failOnError: true, flush: true)

            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
            returnMap[MortalityConstants.MESSAGE] = "User: " + userDetails.name + " successfully unassigned."

        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }
        return returnMap
    }


    def updateReviewForm(params, user, isFormEditableReq) {
        def returnMap = [:]
        def patientForm
        def isFormEditable
        if( params.statusChangeTo != null && !params.statusChangeTo.equals(MortalityConstants.NONE)){
            try {
                ReviewStatus statusObj = servletContext.reviewStatuses.find { it.status.equals(params.statusChangeTo) }
                patientForm = MortalityReviewForm.findById(params.reviewId)
                params.remove('status')
                patientForm.status = statusObj
                patientForm.dateUpdated = new Date()
                patientForm.updatedBy = user?.name
                patientForm.properties = params
                patientForm.save(failOnError: true, flush: true)
            }catch (Exception e) {
                e.printStackTrace()
                log.error(e.message)
                returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
                returnMap[MortalityConstants.MESSAGE] = e.message
                return returnMap
            }

        }
        if(!params.statusChangeTo) {
            try {
                patientForm = MortalityReviewForm.findById(params.reviewId)
            } catch (Exception e) {
                e.printStackTrace()
                log.error(e.message)
                returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
                returnMap[MortalityConstants.MESSAGE] = e.message
                return returnMap
            }
        }

        if(isFormEditableReq){
            isFormEditable = checkIsReviewFormEditable(user, patientForm);
            returnMap = [patientForm: patientForm ,isFormEditable : isFormEditable , STATUS : MortalityConstants.SUCCESS]
            return  returnMap
        }
        else{
            returnMap = [patientForm: patientForm ]
        }

        if(!returnMap.isEmpty()){
            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
            return returnMap
        }
        else{

            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            return returnMap
        }
    }

    /**
     * This method will archive the review forms with status submitted/amended and submission date is
     * greater then 14 days from the current date.
     */
    def archiveReviewForms() {

        try {
            def dateToCompare = new Date() - 15

            ReviewStatus submitStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.SUBMITTED)
            }
            ReviewStatus amendedStatus = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.AMENDED)
            }
            //getting all the review forms those status are in submitted and amended
            def amendedReviewFormsList = MortalityReviewForm.executeQuery("from MortalityReviewForm mrf where mrf.status in ( :submitStatus , :amendedStatus ) and mf.dateUpdated  <=:searchDate ", [submitStatus: submitStatus, amendedStatus: amendedStatus, searchDate: dateToCompare])

            //batch update review forms
            amendedReviewFormsList.each {
                MortalityReviewForm.withTransaction {
                    it.isArchive = true
                    it.save(failOnError: true)
                }
            }

            MortalityReviewForm.withSession { session ->
                session.flush()
            }
        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            println("Exception :: while processing archiveReviewForms() method and exception message " + e.getMessage())
        }
    }
    /**
     * This method will send reminder email notification to the ql/reviewer whose review form has not been submitted or amended
     * even after 14 days from the date of form assigned.
     * @return
     */
    def sendReviewFormReminderNotification(serverName) {
        try {

            def sendNotification = { facility ->

                def dateToCompare = new Date() - 15
                dateToCompare = dateToCompare.toTimestamp()
                Date reminderDate = new Date() + 15
                def nextReminderDate = reminderDate.format('MM/dd/yyyy')
                Sql sql = new Sql(dataSource)

                ReviewStatus assignedStatus = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.ASSIGNED)
                }
                ReviewStatus acceptedStatus = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.ACCEPTED)
                }
                ReviewStatus updatedStatus = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.UPDATED)
                }
                ReviewStatus reassignedStatus = servletContext.reviewStatuses.find {
                    it.status.equals(MortalityConstants.REASSIGNED)
                }
                //get all the review forms those status are in ACCEPTED,UPDATED and REASSIGNED for the facility
                def allReviewFormsList = MortalityReviewForm.executeQuery("from MortalityReviewForm mf where mf.status in (:assignedStatus, :acceptedStatus, :updatedStatus, :reassignedStatus ) and mf.facility =:facility", [assignedStatus: assignedStatus, acceptedStatus: acceptedStatus, updatedStatus: updatedStatus, reassignedStatus: reassignedStatus, facility: facility])

                allReviewFormsList.each { it ->

                    def basicSql = """select to_char(max(date_updated),'mm/dd/yyyy') as UPDATED_DATE from audit_track where mortality_review_form_id ='$it.id' and (updated_status ='$MortalityConstants.ASSIGNED' or updated_status = '$MortalityConstants.REASSIGNED')"""

                    def result = sql.firstRow(basicSql)
                    def lastAcceptedStatusDate = result?.UPDATED_DATE
                    //compare the last assigned status date is 15th day - send one time reminder
                    if (lastAcceptedStatusDate.timestampValue() == dateToCompare) {
                        //getting user details to send email notification
                        MortalityUser user = MortalityUser.findById(it?.lead?.id)
                        def reviewFormLink = AdminUtils.getBaseURL() + '/mortality/review?reviewId=' + it.id + '&isEmailLink=1'
                        def toAddr = 'anshul.bansal@mountsinai.org'
                     /*   if (!serverName.contains(AdminConstants.SERVER_NAME_LOCALHOST) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_DEV) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_QA)) {
                            toAddr = user?.email
                        }*/
                        def subject = AdminConstants.EMAIL_FOURTEEN_DAYS_REMINDER_SUBJECT
                        sendReviewFormReminderEmail(user.name, it?.patientName, lastAcceptedStatusDate, it?.mrn, toAddr, reviewFormLink, nextReminderDate, subject)
                        //Audit Track for 14 days reminder notificaiton
                        sql.call '{ call MTT_FRONTEND.auditTrack(?,?,?,?,?,?)}', [it?.id,it.status?.status,MortalityConstants.REMINDER_14_DAYS, MortalityConstants.MTT_SYSTEM,'', Sql.out(OracleTypes.NUMBER)], {
                        }
                    }
                }
            }

            def facilitiesList = Facility.findAll()
            facilitiesList.each { facility ->
                GParsPool.withPool {
                    def result = sendNotification.callAsync(facility)
                }
            }
        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            println("Exception :: while processing sendReviewFormReminderNotification() method and exception message " + e.getMessage())
        }
    }

    /**
     * Method to send review form reminder email notification to the user
     * @param userName
     * @param patientName
     * @param acceptedDateTime
     * @param mrn
     * @param userEmail
     * @param reviewFormLink
     * @param nextReminderDate
     * @param subject
     * @return
     */
    def sendReviewFormReminderEmail(userName, patientName, acceptedDateTime, mrn, userEmail, reviewFormLink, nextReminderDate, subject) {
        def fromAddr = AdminConstants.EMAIL_FROM_ADDRESS
        def ccAddr = ''
        def text = groovyPageRenderer.render template: '/email/templates/reviewFormReminderNotificationMail', model: [userName: userName, patientName: patientName, acceptedDateTime: acceptedDateTime, mrn: mrn, reviewFormLink: reviewFormLink, reminderDate: nextReminderDate]
        try {
            //EmailHandler.sendEmail(fromAddr, userEmail, ccAddr, subject, text, true)
            log.info("Email Notifications sent on " +new Date() + " to - " +userEmail)
        } catch (MailException ex) {
            return false
        }
    }

    /**
     *
     * @param lastName
     * @param firstName
     * @return
     */
    def getEmployeeInfo(lastName, firstName) {
        Sql sql = new Sql(dataSource_SECURE)
        def userMap = [:]
        sql.call '{ call LDAP_ACCT_VERIFY.getadsuserbynameformtt(?,?,?)}', [lastName, '', Sql.out(OracleTypes.CURSOR)], { rows ->
            rows.eachRow() { row ->
                def user = [:]
                user.userId = row.USER_ID != null ? row.USER_ID : ''
                user.firstName = row.FIRST_NAME != null ? row.FIRST_NAME : ''
                user.lastName = row.LAST_NAME != null ? row.LAST_NAME : ''
                user.email = row.EMAIL !=  null ? row.EMAIL : ''
                if(!userMap[user.userId.toLowerCase()] || (userMap[user.userId.toLowerCase()] && user.email != "null" && user.email != '' )){
                    userMap[user.userId.toLowerCase()] = user
                }
            }
        }
        return userMap.values()
    }

    /**
     * This method will send reminder notification for the review form whose days since death is starting more then 21 days
     * @param params
     * @return returnMap
     */
    def sendTwentyOneDaysReminder(params, serverName) {
        def returnMap = [:]
        try {
            Sql sql = new Sql(dataSource)
            //getting review form details
            MortalityReviewForm reviewForm = MortalityReviewForm.findById(params?.reviewId)
            //Getting user details
            MortalityUser user = MortalityUser.findById(reviewForm?.lead?.id)

            //Get the last accepted date info from audit table
            def basicSql = """select to_char(max(date_updated),'mm/dd/yyyy') as UPDATED_DATE from audit_track where mortality_review_form_id ='$reviewForm.id' and (updated_status ='$MortalityConstants.ASSIGNED' or updated_status = '$MortalityConstants.REASSIGNED')"""
            def result = sql.firstRow(basicSql)
            def lastAcceptedStatusDate = result?.UPDATED_DATE
            def lastStatusDate = new Date(lastAcceptedStatusDate)
            Date reminderDate = lastStatusDate + 30
            def nextReminderDate = reminderDate.format('MM/dd/yyyy')
            //Construct review form link and email subject
            def reviewFormLink = AdminUtils.getBaseURL() + '/mortality/review?reviewId=' + reviewForm?.id + '&isEmailLink=1'
            def subject = AdminConstants.EMAIL_REMINDER_NOTICE_SUBJECT
            def toAddr
            toAddr = 'anshul.bansal@mountsinai.org'
            /*if (!serverName.contains(AdminConstants.SERVER_NAME_LOCALHOST) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_DEV) && !serverName.contains(AdminConstants.SERVER_NAME_MSH_QA)) {
                toAddr = user?.email
            }*/
            sendReviewFormReminderEmail(user?.name, reviewForm?.patientName, lastAcceptedStatusDate, reviewForm?.mrn, toAddr, reviewFormLink, nextReminderDate, subject)

            returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS
            returnMap[MortalityConstants.MESSAGE] = AdminConstants.REMINDER_SENT_SUCCESS_MSG

        } catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
            return returnMap
        }
        return returnMap
    }
    def submitFormThroughHospiceOption(params, userName){
        def returnMap = [:]
        MortalityReviewForm existingForm = MortalityReviewForm.findById(params.reviewId)
        try {
            def newForm = new MortalityReviewForm()
            def id = existingForm.id
            newForm.admitUnit = existingForm.admitUnit
            newForm.patientName = existingForm.patientName
            newForm.mrn = existingForm.mrn
            newForm.dischargeUnit = existingForm.dischargeUnit
            newForm.admitDateTime = existingForm.admitDateTime
            newForm.expiredDateTime = existingForm.expiredDateTime
            newForm.hospService = existingForm.hospService
            newForm.lastAttending = existingForm.lastAttending
            newForm.dictationCode = existingForm.dictationCode
            newForm.serviceTeam = existingForm.serviceTeam
            newForm.visitId = existingForm.visitId
            newForm.gender = existingForm.gender
            newForm.admittingDiagnosis = existingForm.admittingDiagnosis
            newForm.dischargeDiagnosis = existingForm.dischargeDiagnosis
            newForm.hospitalSite = existingForm.hospitalSite
            newForm.isArchive = false
            newForm.createdBy = existingForm.createdBy
            newForm.dateCreated = existingForm.dateCreated
            newForm.dept = existingForm.dept
            newForm.speciality =  existingForm.speciality
            newForm.facility = existingForm.facility
            newForm.admin = existingForm.admin
            newForm.lead = existingForm.lead
            newForm.reviewer = existingForm.reviewer

            existingForm.properties = newForm.properties

            existingForm.isPatInfoAccurate = params.isPatInfoAccurate.equals("true") ? true : false
            existingForm.patInfoComment = params.patInfoComment
            existingForm.wasPatTransferredFacility = params.wasPatTransferredFacility.equals("true") ? true : false
            existingForm.patTransferredComment = params.patTransferredComment
            existingForm.isHospice = params.isHospice.equals("true") ? true : false
            existingForm.id = id

            ReviewStatus statusObj = servletContext.reviewStatuses.find {
                it.status.equals(MortalityConstants.SUBMITTED)
            }
            existingForm.status = statusObj

            existingForm.dateUpdated = new Date()
            existingForm.updatedBy = userName

            if(existingForm.save(failOnError: true, flush: true))
                returnMap[MortalityConstants.STATUS] = MortalityConstants.SUCCESS

        }
        catch (Exception e) {
            e.printStackTrace()
            log.error(e.message)
            returnMap[MortalityConstants.STATUS] = MortalityConstants.FAILED
            returnMap[MortalityConstants.MESSAGE] = e.message
        }
        return returnMap
    }

    /**
     * function to check Enable Email Notification config param
     * @return
     */
    def checkEnableEmailNotificationConfig(){
        Config enableEmailNotification = Config.findByKeyAndActiveFlag("ENABLE_EMAIL_NOTIFICATION",true)
        return enableEmailNotification?.value?.toString()?.equals("true") ? true : false
    }
}

