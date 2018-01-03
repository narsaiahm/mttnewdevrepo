package org.mountsinai.mortalitytriggersystem

class Role {

    long id
    String roleName
    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy

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
        return roleName
    }
}
