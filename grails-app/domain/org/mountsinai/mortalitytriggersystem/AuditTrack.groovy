package org.mountsinai.mortalitytriggersystem

class AuditTrack {

    long id
    String mortalityReviewFormId
    String prevStatus
    String updatedStatus
    String updatedBy
    Date dateUpdated = new Date()
    String assignedUser

    static mapping = {
        version false
        id generator: 'sequence',
                params:[sequence:'AUDIT_SEQ']
    }

    static constraints = {
        mortalityReviewFormId nullable:true
        assignedUser nullable:true
    }
}
