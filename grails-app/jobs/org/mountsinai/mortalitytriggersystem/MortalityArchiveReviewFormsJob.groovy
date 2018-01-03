package org.mountsinai.mortalitytriggersystem

class MortalityArchiveReviewFormsJob {
    def mortalityTriggerService;

    static triggers = {
        //Every day at 1.00 AM midnight job will trigger
        cron name: 'cronMortalityArchiveReviewFormsTrigger', cronExpression: "0 0 1 ? * * *"
    }
    def execute() {
        def system = System.getProperty("os.name")
        def serverName = System.getProperty("weblogic.Name")
        if(system != null && system.indexOf("Win") > -1){
            serverName = "localhost"
        }
        if(serverName != null && !serverName.endsWith("node3")){
            mortalityTriggerService.archiveReviewForms()
        } else{
            println "Server Name (${serverName}) does not match, Aborting the Job."
        }

    }
}
