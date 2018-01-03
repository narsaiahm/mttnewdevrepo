package org.mountsinai.mortalitytriggersystem

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonOutput
import groovy.sql.Sql
import groovyx.gpars.GParsPool
import oracle.jdbc.OracleTypes
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.Future
import org.springframework.context.ApplicationContextAware
import org.springframework.context.ApplicationContext

/**
 * @author bansaa03
 * @since 09/01/2017
 */
@Transactional
class AuditService implements ApplicationContextAware{

    def dataSource
    static Logger log = LoggerFactory.getLogger(AuditService.class)
    ApplicationContext applicationContext

    def auditRequest(def params, def userName, def actionName) {
        def auditing = {
            try {
                def mortalityReviewId = params.reviewId
                def prevStatus = params.status
                def updatedStatus
                def assignedUser
                if (actionName.equals('acceptReviewForm')) {
                    updatedStatus = MortalityConstants.ACCEPTED
                } else if (actionName.equals('assignLeadReviewer')) {
                    if (params.status.equals(MortalityConstants.UNASSIGNED)) {
                        updatedStatus = MortalityConstants.ASSIGNED
                    } else if (params.status.equals(MortalityConstants.ASSIGNED) || params.status.equals(MortalityConstants.UPDATED) || params.status.equals(MortalityConstants.REASSIGNED)) {
                        updatedStatus = MortalityConstants.REASSIGNED
                    }
                    assignedUser = params.assignedUser
                } else if (actionName.equals('saveMortalityReviewForm')) {
                    updatedStatus = MortalityConstants.UPDATED
                } else if (actionName.equals('submitMortalityForm')) {
                    updatedStatus = MortalityConstants.SUBMITTED
                }else if (actionName.equals('submitFormThroughHospiceOption')) {
                    updatedStatus = MortalityConstants.SUBMITTED
                }else if(actionName.equals('saveAmendmentComments')){
                    updatedStatus= MortalityConstants.AMENDED
                }else if (actionName.equals('saveAndReview')) {
                        updatedStatus = MortalityConstants.UPDATED
                }else if(actionName.equals('sendReminder')){
                    updatedStatus = MortalityConstants.REMINDER
                }

                def updatedBy = userName
                Sql sql = new Sql(dataSource)
                sql.call '{ call MTT_FRONTEND.auditTrack(?,?,?,?,?,?)}', [mortalityReviewId, prevStatus, updatedStatus, updatedBy, assignedUser, Sql.out(OracleTypes.NUMBER)], { status ->

                }
            } catch (Exception e) {
                e.printStackTrace()
                log.error(e.message)
            }
        }
        //for asynchronous call
        GParsPool.withPool {
            Future result = auditing.callAsync()
        }
        return true
    }
}
