package org.mountsinai.mortalitytriggersystem

import grails.converters.JSON
import groovy.sql.Sql
import oracle.jdbc.OracleTypes

class MortalityController {

    static defaultAction = "dashboard"
    def mortalityTriggerService

    /**
     * Action to redirect to particular Dashboard based on user role.
     * @return
     */
    def dashboard() {
        def user = session?.user
        if (user.role.roleName.equals(AdminConstants.ADMIN)) {
            redirect action: 'adminDashboard'
        } else if (user.role.roleName.equals(AdminConstants.QUALITY_LEAD) || user.role.roleName.equals(AdminConstants.ADHOC)) {
            redirect action: 'qlDashboard'
        }
    }

    /**
     * Action to display Admin dashboard
     * @return
     */
    def adminDashboard() {
        def allUsers = session?.allUsers
        def adminUser = allUsers.find { it.role.roleName.equals(AdminConstants.ADMIN) }
        if (!adminUser) {
            render 'You are not authorised to visit this link'
            return
        }
        def facilities = ''
        if (session?.userFacilities) {
            session?.userFacilities?.each {
                facilities += it + ','
            }
            facilities = facilities[0..-2]
        } else {
            facilities = session?.user?.facility.id
        }
        def mortalityReviewList
        def reviewList
        def adminSearchFieldsMap
        def allLeadReviewer = []
        //to retaine the search
        if (params?.clearFilter) {
            session?.searchParams = null
        }
        if (session?.searchParams != null) {
            reviewList = mortalityTriggerService.searchReview(session?.searchParams);
            mortalityReviewList = reviewList[0]
            //this is to just fetch facility list for initial display of Admin Search layout
            if (session?.searchParams?.facility.indexOf(",") <= -1) {
                adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(session?.searchParams?.facility);
            } else {
                adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(0);
            }

            if (session?.searchParams?.assignedTo == MortalityConstants.ALL) {
                allLeadReviewer = adminSearchFieldsMap['leadList'] + adminSearchFieldsMap['adhocList']
            } else if (session?.searchParams?.assignedTo == AdminConstants.QUALITY_LEAD) {
                allLeadReviewer = adminSearchFieldsMap['leadList']
            } else if (session?.searchParams?.assignedTo == AdminConstants.ADHOC) {
                allLeadReviewer = adminSearchFieldsMap['adhocList']
            }
            allLeadReviewer = allLeadReviewer.sort { it.name }

        } else {
            reviewList = mortalityTriggerService.getAdminReviewList(facilities)
            mortalityReviewList = reviewList
            //this is to just fetch facility list for initial display of Admin Search layout
            adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(0);
        }
        def facilityMap = [:]
        adminSearchFieldsMap['facilityList'].each {
            if (session?.userFacilities?.toString()?.contains(it.id?.toString()) || session?.user?.facility.id?.toString().equals(it.id?.toString())) {
                facilityMap[it.id] = it.facilityName + " (" + it.facilityCode + ")"
            }
        }
        [mortalityReviewList: mortalityReviewList, facilityMap: facilityMap, specialities: adminSearchFieldsMap['specialityList'], leads: adminSearchFieldsMap['leadList'], adhocs: adminSearchFieldsMap['adhocList'], allLeadReviewer: allLeadReviewer, params: (session?.searchParams) ? session?.searchParams : params]
    }

    /**
     * Action to saveAmendmentComments
     * @return
     */
    def saveAmendmentComments() {
        def isFormEditableReq = false
        render mortalityTriggerService.updateReviewForm(params, session?.user, isFormEditableReq) as JSON

    }

    /**
     * Action to fetchDeptQlForFacility
     * @return
     */
    def fetchDeptQlForFacility() {
        def adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(params.facilityId);
        def allLeadReviewer = adminSearchFieldsMap['leadList'] + adminSearchFieldsMap['adhocList']
        allLeadReviewer = allLeadReviewer.sort { it.name }
        render(template: "/mortality/templates/adminSearchDeptQL", model: [specialities: adminSearchFieldsMap['specialityList'], leads: adminSearchFieldsMap['leadList'], adhocs: adminSearchFieldsMap['adhocList'], allLeadReviewer: allLeadReviewer])
    }

    /**
     * Action to fetch QL depending on facility
     * @return
     */
    def fetchQlForFacility() {
        def adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(params.facilityId);
        def allLeadReviewer = []
        if (params.role == MortalityConstants.ALL) {
            allLeadReviewer = adminSearchFieldsMap['leadList'] + adminSearchFieldsMap['adhocList']
        } else if (params.role == AdminConstants.QUALITY_LEAD) {
            allLeadReviewer = adminSearchFieldsMap['leadList']
        } else if (params.role == AdminConstants.ADHOC) {
            allLeadReviewer = adminSearchFieldsMap['adhocList']
        }
        allLeadReviewer = allLeadReviewer.sort { it.name }
        render(template: "/mortality/templates/adminSearchQL", model: [allLeadReviewer: allLeadReviewer])
    }

    /**
     * Action to display search result and show admin search dashboard
     * @return
     */
    def displaySearchResults() {
        if (params.facility?.equals("")) {
            def facilities = ''
            if (session?.userFacilities) {
                session?.userFacilities?.each {
                    facilities += it + ','
                }
                facilities = facilities[0..-2]
            } else {
                facilities = session?.user?.facility.id
            }
            params.facility = facilities
        }
        session?.searchParams = params
        def reviewResults = mortalityTriggerService.searchReview(params);

        render(template: '/mortality/templates/adminDashBoardLayout', model: [mortalityReviewList: reviewResults[0], fromPage: "displaySearchResults"], params: session?.searchParams)
    }

    def cancelSearchForm() {
    }

    /**
     * Action to get reports in admin screen
     * @return
     */
    def runReport() {
        def facilityId = session?.user?.facility.id
        def adminSearchFieldsMap = mortalityTriggerService.getAdminSearchFields(params.facilityId);
        render(view: "/mortality/runReport", model: [specialities: adminSearchFieldsMap['specialityList'], leads: adminSearchFieldsMap['leadList'], adhocs: adminSearchFieldsMap['adhocList']])
    }

    /**
     * Action to get list of review result and History list
     * @return
     */
    def exportData() {
        def facilitySelected = params.facility
        if (params.facility?.equals("")) {
            def facilities = ''
            if (session?.userFacilities) {
                session?.userFacilities?.each {
                    facilities += it + ','
                }
                facilities = facilities[0..-2]
            } else {
                facilities = session?.user?.facility.id
            }
            params.facility = facilities
        }
        def reviewResults = mortalityTriggerService.searchReview(params);
        def formattedReviewResults = mortalityTriggerService.formatReviewResultsWithHistory(reviewResults[0], reviewResults[1], false)
        params.remove('action')
        params.remove('controller')
        params.remove('format')
        params.remove('_action_exportData')
        def facilityCode = 'ALL'
        if (facilitySelected != '') {
            //facilityCode = Facility.findById(params.facility)?.facilityCode
            facilityCode = servletContext.facilities.find { it.id.toString().equals(params.facility) }?.facilityCode
        }
        def speciality = 'ALL'
        if (params?.speciality) {
            speciality = Speciality.findById(params?.speciality)?.specialityName
        }
        render(view: "/mortality/exportData", model: [mortalityReviewList: formattedReviewResults, params: params, facilityCode: facilityCode, speciality: speciality])
    }

    /**
     * Action to Export Search data in Excel format
     * @return
     */
    def exportSearchData() {
        if (params.facility?.equals("")) {
            def facilities = ''
            if (session?.userFacilities) {
                session?.userFacilities?.each {
                    facilities += it + ','
                }
                facilities = facilities[0..-2]
            } else {
                facilities = session?.user?.facility.id
            }
            params.facility = facilities
        }
        def reviewResults = mortalityTriggerService.searchReview(params);
        def formattedReviewResults = mortalityTriggerService.formatReviewResultsWithHistory(reviewResults[0], reviewResults[1], true)
        def dataExport = mortalityTriggerService.exportData(params, response, formattedReviewResults);
    }

    /**
     * Action to Assign Employee to QL
     * @return
     */
    def assignEmplToQl() {
        def facilityMap = [:]
        def specialitiesMap = [:]
        def departmentMap = [:]
        def leadsMap = [:]
        def facilityList =[]

        def qualityLeadRole = servletContext.roles.find { it.roleName.equals(AdminConstants.QUALITY_LEAD) }

        if (session?.userFacilities) {
            session?.userFacilities?.each { val ->
                Facility facility = servletContext.facilities.find { it.id == val }
                facilityList << facility
            }
        } else {
            Facility facility = servletContext.facilities.find { it.id == session?.user?.facility.id }
            facilityList << facility
        }

        ArrayList<MortalityUser> allUsers = MortalityUser.findAllByRoleAndFacilityInListAndActiveFlag(qualityLeadRole, facilityList, true)

        allUsers.each {
            def str = it.name
            if (it?.speciality) {
                str += " (" + it?.facility?.facilityCode + " - " + it?.speciality?.specialityName + ")"
            }
            leadsMap[it.id] = str
        }
        servletContext.facilities.each { it ->
            facilityMap[it.id] = it.facilityName + " (" + it.facilityCode + ")"
        }

        [leadsMap: leadsMap, facilityMap: facilityMap, departmentMap: departmentMap, specialitiesMap: specialitiesMap]
    }

    /**
     * This method will load the initial data for the assign and un assign users for MTT application
     * @param params
     * @return template
     */
    def getDataForAssignUser(params) {
        def facility
        def facilityMap = [:]
        def departmentMap = [:]
        def specialitiesMap = [:]
        def department
        def facilityList =[]

        def leadsMap = [:]

        def qualityLeadRole = servletContext.roles.find { it.roleName.equals(AdminConstants.QUALITY_LEAD) }

        if (session?.userFacilities) {
            session?.userFacilities?.each { val ->
                Facility facilityObj = servletContext.facilities.find { it.id == val }
                facilityList << facilityObj
            }
        } else {
            Facility facilityObj = servletContext.facilities.find { it.id == session?.user?.facility.id }
            facilityList << facilityObj
        }

        ArrayList<MortalityUser> allUsers = MortalityUser.findAllByRoleAndFacilityInListAndActiveFlag(qualityLeadRole, facilityList, true)

        allUsers.each {
            def str = it.name
            if (it?.speciality) {
                str += " (" + it?.facility?.facilityCode + " - " + it?.speciality?.specialityName + ")"
            }
            leadsMap[it.id] = str
        }
        servletContext.facilities.each { it ->
            facilityMap[it.id] = it.facilityName + " (" + it.facilityCode + ")"
        }

        if (params?.facility) {
            facility = Facility.findById(Integer.parseInt(params?.facility))

            def departmentList = Department.findAllByFacility(facility)

            departmentList?.each {
                departmentMap[it.id] = it.departmentName
            }
        }
        if (params.department) {
            department = Department.findById(Integer.parseInt(params?.department))
            def specialityList = Speciality.findByDept(department)

            specialityList?.each {
                specialitiesMap[it.id] = it.specialityName
            }
        }

        render template: '/mortality/templates/assignUser', model: [params: params, leadsMap: leadsMap, facilityMap: facilityMap, departmentMap: departmentMap, specialitiesMap: specialitiesMap]
    }
    /**
     * This method will load the users list for the unAssign user page
     * @param params
     * @return resp
     */
    def getDataForUnassignUser(params) {
        def resp  = [:]
        if(params?.leadId) {
            def lead = MortalityUser.findById(Integer.parseInt(params?.leadId))
            resp = [facility: lead?.facility?.facilityName, department: lead?.speciality?.dept?.departmentName, speciality: lead?.speciality?.specialityName, emailId: lead?.email]
        }
        render resp as JSON
    }

    /**
     * This method allow admin to assign an MSHS Employee as Quality Lead for the MTT application.
     * @return resultMap
     */
    def assignMSHSUserAsQL() {
        def speciality
        def resultMap = [:]
        if (params?.speciality) {
            speciality = Speciality.get(Integer.parseInt(params?.speciality))
            if (speciality.lead) {
                def str = "Please unassign " + speciality?.lead?.name + " for the Speciality " + speciality?.specialityName +
                        " before assigning MSHS employee " + params.username + " as Quality Lead"
                resultMap[MortalityConstants.STATUS] = MortalityConstants.ERROR
                resultMap[MortalityConstants.MESSAGE] = str
            } else {
                resultMap = mortalityTriggerService.saveAssignUserAsQL(params)
            }
        }
        render resultMap as JSON
    }

    /**
     * This method will un assign user and set the user activeFlag to false in the system.
     * @return resultMap
     */
    def unAssignMSHSUser() {
        def resultMap = [:]
        resultMap = mortalityTriggerService.unAssignMSHSUser(params, session?.user?.name)
        render resultMap as JSON
    }

    /**
     * Action to display qlLead or Reviewer dashboard
     * @return
     */
    def qlDashboard() {
        def allUsers = session?.allUsers
        def qlUser = allUsers.find {
            it.role.roleName.equals(AdminConstants.QUALITY_LEAD) || it.role.roleName.equals(AdminConstants.ADHOC)
        }
        if (!qlUser) {
            render 'You are not authorised to visit this link'
            return
        }
        def facilities = ''
        if (session?.userFacilities) {
            session?.userFacilities?.each {
                facilities += it + ','
            }
            facilities = facilities[0..-2]
        } else {
            facilities = session?.user?.facility.id
        }
        def leadEmail = session?.user?.email
        def specialityId = session?.user?.speciality?.id
        def reviewList = mortalityTriggerService.getReviewList(facilities, leadEmail, specialityId)
        [reviewList: reviewList]
    }

    /**
     * This method will check the review form etitable mode based on status of the Form.
     * @param params
     *
     */
    def review() {
        def user = session?.user
        MortalityReviewForm reviewForm = MortalityReviewForm.findById(params.reviewId)
        def isFormEditable = mortalityTriggerService.checkIsReviewFormEditable(user, reviewForm);
        if (reviewForm) {
            [mReviewForm: reviewForm, isFormEditable: isFormEditable]
        } else {
            redirect(action: 'dashboard')
        }
    }
/**
 * Action to to save the form and redirect to reviewFormOnSave action
 * @return
 */
    def saveAndReview() {
        def isFormEditableReq = false
        mortalityTriggerService.updateReviewForm(params, session?.user, isFormEditableReq)
        def reviewId = params.reviewId
        params.keySet().asList().each { params.remove(it) }
        params.reviewId = reviewId
        redirect action: "reviewFormOnSave", params: params
    }

    /**
     * Action to show the form in review mode.
     * @param params
     *
     */
    def reviewFormOnSave() {

        def isFormEditableReq = true
        def returnedMap = mortalityTriggerService.updateReviewForm(params, session?.user, isFormEditableReq)
        if (returnedMap[MortalityConstants.STATUS].equals(MortalityConstants.SUCCESS)) {
            if (session?.user.role.roleName.equals(AdminConstants.ADMIN)) {
                def latestStatus = AuditTrack.findAllByMortalityReviewFormId(params.reviewId)
                latestStatus.sort { i1, i2 -> i2.dateUpdated <=> i1.dateUpdated }
                if (!latestStatus.empty) {
                    def latestStatusOfReviewForm = latestStatus.first()
                    [mReviewForm: returnedMap['patientForm'], isFormEditable: returnedMap['isFormEditable'], latestStatus: latestStatusOfReviewForm]
                }
            } else {
                [mReviewForm: returnedMap['patientForm'], isFormEditable: returnedMap['isFormEditable']]
            }
        } else {
            render returnMap[MortalityConstants.MESSAGE]
        }
    }

    /**
     * This method will save and submit the final mortality review form changes.
     * @param params
     *
     */
    def submitMortalityForm() {
        def isFormEditableReq = false
        def saveReviewForm = mortalityTriggerService.updateReviewForm(params, session?.user, isFormEditableReq)
        if (saveReviewForm[MortalityConstants.STATUS].equals(MortalityConstants.SUCCESS)) {
            redirect action: 'qlDashboard'
        } else
            redirect action: "review", params: params
    }

    /**
     * Action to Accept Assigned reviewform by ql or reviewer
     * @param params
     * @return JSON
     */
    def acceptReviewForm() {
        def userName = session?.user?.name
        render mortalityTriggerService.acceptReviewForm(params, userName) as JSON
    }

    /**
     * Action to load Lead and Reviewer of facility  to assignForm.
     * @param params
     * @return
     */
    def assignReviewForm() {
        def leadId
        def assignedToUser

        def adminRole = Role.findByRoleName(AdminConstants.ADMIN)
        def facility = servletContext.facilities.find { it.facilityCode.equals(params?.reviewFacilityCode) }
        ArrayList<MortalityUser> allUsers = MortalityUser.findAllByRoleNotEqualAndFacilityAndActiveFlag(adminRole, facility, true)
        //allUsers = allUsers.grep({ it -> it.email != session?.user?.email })
        ArrayList<MortalityUser> leads = allUsers.grep { it -> it?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) }
        ArrayList<MortalityUser> reviewerList = allUsers.grep { it -> it?.role?.roleName.equals(AdminConstants.ADHOC) }
        def reviewerMap = [:]
        reviewerList.each {
            def str = it.name
            if (it?.speciality) {
                str += " (" + it?.speciality?.specialityName + ")"
            }
            reviewerMap[it.id] = str
        }

        if (params.status != MortalityConstants.UNASSIGNED) {
            if (!params.lead) {
                leadId = session?.assignParams?.leadId
            } else {
                leadId = params.lead
            }
            if (leadId) {
                assignedToUser = MortalityUser.findById(params.lead)
            }
        }
        //assign parms values from session
        if(!params){
        }

        [allLeadsList: leads, reviewerMap: reviewerMap, reviewinfo: params,assignedToUser:assignedToUser]
    }

    /**
     * This method will save  the  mortality review form changes to database.
     * @return
     */
    def saveMortalityReviewForm() {
        def isFormEditableReq = false
        render mortalityTriggerService.updateReviewForm(params, session?.user, isFormEditableReq) as JSON

    }

    /**
     * Action to assign Lead or Reviewer to the Review form.
     * @return
     */
    def assignLeadReviewer() {
        def userName = session?.user?.name
        def updateLead = mortalityTriggerService.updateAssignLeadReviewer(params, userName)
        if (updateLead[MortalityConstants.STATUS].equals(MortalityConstants.SUCCESS)) {
            mortalityTriggerService.sendNotification(params)
            redirect action: 'dashboard'
        } else {
            flash.errorMsg = MortalityConstants.ERROR_IN_PROCESS_REQUEST
            session?.assignParams = params
            redirect action: 'assignReviewForm'
        }
    }

    /**
     * Action to show the history of  Review Form changes.
     * @return
     */
    def showHistory() {
        def auditList = AuditTrack.findAllByMortalityReviewFormId(params.reviewId)
        auditList.sort { i1, i2 -> i2.dateUpdated <=> i1.dateUpdated }
        render template: '/mortality/templates/showHistory', model: [auditList: auditList]
    }

    def searchForEmployee() {
        def employeeList = mortalityTriggerService.getEmployeeInfo(params.lastName, params.firstName)
        render(template: '/mortality/templates/showEmployeeInfo', model: [empList: employeeList])
    }

    /**
     * Action to send remainder email notification, if death occurred 21 days ago
     * @param params
     * @return
     */
    def sendReminder() {
        def resultMap = mortalityTriggerService.sendTwentyOneDaysReminder(params, request.serverName)
        render resultMap as JSON
    }

    def testNotification() {
        render mortalityTriggerService.sendReviewFormReminderNotification("localhost")
    }
    def submitFormThroughHospiceOption(){
        def userName = session?.user?.name
        def status = mortalityTriggerService.submitFormThroughHospiceOption(params, userName)
        if (status[MortalityConstants.STATUS].equals(MortalityConstants.SUCCESS)) {
            redirect action: 'qlDashboard'
        } else{
            redirect action: "review", params: params
        }

    }
}
