package org.mountsinai.mortalitytriggersystem

import static grails.util.Environment.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * Created by bansaa03 on 08/16/17.
 */
class AdminUtils {

    static Logger log = LoggerFactory.getLogger(AdminUtils.class)

    static String getBaseURL() {
        String serverName = System.getProperty("ms.hostname")
        if (serverName?.contains('msh-dev')) {
            return AdminConstants.DEV
        } else if (serverName?.contains("msh-qa")) {
            return AdminConstants.QA
        } else if (serverName?.contains('msh-app')) {
            return AdminConstants.PROD
        } else {
            if (currentEnvironment != DEVELOPMENT) {
                return AdminConstants.DEV
            } else {
                return AdminConstants.LOCAL
            }
        }
    }
}
