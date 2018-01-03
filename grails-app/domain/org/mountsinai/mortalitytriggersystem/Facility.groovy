package org.mountsinai.mortalitytriggersystem

class Facility {

    long id
    String facilityCode
    String facilityName
    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy

    static hasMany = [depts:Department]

    static constraints = {
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
        return facilityCode + " : " +facilityName
    }
}
