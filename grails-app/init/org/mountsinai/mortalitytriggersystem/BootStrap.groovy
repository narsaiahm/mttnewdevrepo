package org.mountsinai.mortalitytriggersystem

import org.mountsinai.mortalitytriggersystem.Facility
import org.mountsinai.mortalitytriggersystem.Role
import org.mountsinai.mortalitytriggersystem.ReviewStatus

class BootStrap {

    def init = { servletContext ->
        def facilities = Facility.findAll()
        def roles = Role.findAll()
        def reviewStatuses = ReviewStatus.findAll()

        servletContext.facilities = facilities
        servletContext.roles = roles
        servletContext.reviewStatuses = reviewStatuses
    }
    def destroy = {
    }
}
