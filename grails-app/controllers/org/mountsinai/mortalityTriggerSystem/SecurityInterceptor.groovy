package org.mountsinai.mortalitytriggersystem

import org.slf4j.Logger
import org.slf4j.LoggerFactory


class SecurityInterceptor {

    int order = HIGHEST_PRECEDENCE
    static Logger log = LoggerFactory.getLogger(SecurityInterceptor.class)

    SecurityInterceptor() {
        match(controller:'mortality',action:'*')
    }

    boolean before() {
        if (!session.user) {
            redirect(controller: "auth", action: "login", params:params)
            return false
        }
        return true
    }
}
