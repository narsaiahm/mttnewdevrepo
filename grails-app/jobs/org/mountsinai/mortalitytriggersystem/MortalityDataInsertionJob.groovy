package org.mountsinai.mortalitytriggersystem

class MortalityDataInsertionJob {

	def mortalityTriggerService;

	static triggers = {
		//Every day at 2 am Mon-Sun
		cron name: 'cronMortalityDataInsertionTrigger', cronExpression: "0 0 2 ? * MON-SUN"
	}

	def execute() {
		def system = System.getProperty("os.name")
		def serverName = System.getProperty("weblogic.Name")
		if(system != null && system.indexOf("Win") > -1){
			serverName = "localhost"
		}
		if(serverName != null && !serverName.endsWith("node3")){
			//mortalityTriggerService.insertMortalityData()
		} else{
			println "Server Name (${serverName}) does not match, Aborting the Job."
		}

	}
}
