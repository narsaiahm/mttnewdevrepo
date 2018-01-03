package org.mountsinai.mortalitytriggersystem

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/" (controller: 'auth')
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
