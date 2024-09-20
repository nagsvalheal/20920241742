@isTest
/**
* @description This class contains test methods to verify status of triggering community notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_CommunityPostSchedTest {
	@isTest
	static void testExecute() {
		try {
			Test.startTest();
			String cronExpression = '0 0 0 * * ?';
			BI_PSPB_CommunityPostSched sched = new BI_PSPB_CommunityPostSched();
			System.schedule(
				'Test Community Post Scheduler',
				cronExpression,
				sched
			);
			Test.stopTest();
		} catch (Exception e) {
			/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	@isTest
	static void forCatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		BI_PSPB_CommunityPostSched schedulable = new BI_PSPB_CommunityPostSched();
		Test.startTest();
		String jobId = System.schedule(
			'BI_PSPB_CommunityPostSched',
			'0 0 0 * * ?',
			schedulable
		);
		Test.stopTest();
		CronTrigger cronTrigger = [
			SELECT Id, CronExpression, TimesTriggered, NextFireTime
			FROM CronTrigger
			WHERE Id = :jobId
		];
		Assert.areEqual('0 0 0 * * ?',cronTrigger.CronExpression,
			'Cron expression does not match');
		Assert.areEqual(0,cronTrigger.TimesTriggered,'Job has not been executed');
	}
}