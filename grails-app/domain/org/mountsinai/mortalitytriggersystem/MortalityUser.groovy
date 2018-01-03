package org.mountsinai.mortalitytriggersystem

class MortalityUser {

    long id
    String name
    String email
    String networkId
    Role role
    Boolean activeFlag
    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy


    static belongsTo = [dept:Department, speciality: Speciality, facility:Facility]

    static constraints = {
        networkId nullable:true
        email nullable:true
        dept nullable: true
        speciality nullable: true
        dateCreated (nullable:true)
        createdBy (nullable:true)
        dateUpdated (nullable:true)
        updatedBy (nullable:true)
    }

    static mapping = {
        version false
        facility fetch: 'join'
        dept fetch: 'join'
        speciality fetch: 'join'
        role fetch: 'join'
    }

    @Override
    String toString() {
        return this?.facility?.facilityCode?.toString() + " : " +this?.name + " : " + role?.roleName
    }
}
