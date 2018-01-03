package org.mountsinai.mortalitytriggersystem

class ReviewStatus {
    
    long id
    String status
    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy

    static constraints = {
        status unique:true
        dateCreated (nullable:true)
        createdBy (nullable:true)
        dateUpdated (nullable:true)
        updatedBy (nullable:true)
    }

    static mapping = {
        version false
    }

    @Override
    String toString() {
        return status
    }
}
