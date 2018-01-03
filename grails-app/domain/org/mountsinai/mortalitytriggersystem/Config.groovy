package org.mountsinai.mortalitytriggersystem

class Config {

    long id
    String key
    String value
    String codeSet
    Boolean activeFlag
    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy

    static constraints = {
        codeSet nullable:true
        dateCreated (nullable:true)
        createdBy (nullable:true)
        dateUpdated (nullable:true)
        updatedBy (nullable:true)
    }

    static mapping = {
        version false
    }
}
