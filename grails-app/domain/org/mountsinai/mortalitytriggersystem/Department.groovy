package org.mountsinai.mortalitytriggersystem

class Department {

    long id
    String departmentName
    boolean isQualityDept = false

    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy

    static belongsTo = [facility:Facility]

    static hasMany = [users:MortalityUser, specialities:Speciality]

    static constraints = {
        dateCreated (nullable:true)
        createdBy (nullable:true)
        dateUpdated (nullable:true)
        updatedBy (nullable:true)
    }

    static mapping = {
        version false
        facility fetch: 'join'
    }

    @Override
    String toString() {
        return facility?.facilityCode?.toString() + " : " +departmentName
    }
}
