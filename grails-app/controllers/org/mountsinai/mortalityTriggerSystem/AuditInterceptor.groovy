package org.mountsinai.mortalitytriggersystem

import org.slf4j.Logger
import org.slf4j.LoggerFactory


class AuditInterceptor {

    int order = HIGHEST_PRECEDENCE
    static Logger log = LoggerFactory.getLogger(AuditInterceptor.class)
    def auditService

    AuditInterceptor() {
        //match status update actions
        match(controller: "mortality", action: ~/(acceptReviewForm|assignLeadReviewer|saveMortalityReviewForm|submitMortalityForm|saveAmendmentComments|saveAndReview|sendReminder|submitFormThroughHospiceOption)/)
    }

    boolean before() {
        auditService.auditRequest(params, session?.user?.name, actionName)
    }
}
