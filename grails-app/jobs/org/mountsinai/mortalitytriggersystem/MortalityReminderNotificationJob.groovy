package org.mountsinai.mortalitytriggersystem

class MortalityReminderNotificationJob {
    def mortalityTriggerService;

    static triggers = {
        //Every 15 th of the month at 2.00 AM midnight job will trigger
        cron name: 'cronMortalityReminderNotificationTrigger', cronExpression: "0 0 7 ? * MON-SUN"
    }

    def execute() {
        def system = System.getProperty("os.name")
        def serverName = System.getProperty("weblogic.Name")
        if (system != null && system.indexOf("Win") > -1) {
            serverName = "localhost"
        }
        if (serverName != null && !serverName.endsWith("node3")) {
            //mortalityTriggerService.sendReviewFormReminderNotification(serverName)
        } else {
            println "Server Name (${serverName}) does not match, Aborting the Job."
        }

    }
}
