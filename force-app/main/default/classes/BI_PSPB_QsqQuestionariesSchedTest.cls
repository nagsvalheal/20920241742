@isTest
/**
* @description This class contains test methods to verify the behaviour of updating tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_QsqQuestionariesSchedTest {
	@isTest
	static void testExecute() {
		Test.startTest();
		BI_PSPB_QsqQuestionariesSched sched = new BI_PSPB_QsqQuestionariesSched();
		String cronExpression = '0 0 0 * * ?';
		System.schedule(
			'Test Treatment Reminders Scheduler',
			cronExpression,
			sched
		);
		Test.stopTest();
		List<CronTrigger> cronTriggers = [
			SELECT Id, CronJobDetail.Name, State
			FROM CronTrigger
			WHERE CronJobDetail.Name = 'Test Treatment Reminders Scheduler'
		];
		Assert.areEqual(
			1,
			cronTriggers.size(),
			'The job should be scheduled.'
		);
	}
}