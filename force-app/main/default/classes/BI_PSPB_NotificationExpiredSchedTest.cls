@isTest
/**
* @description This class contains test methods to verify the behaviour of
scheduling expiration of tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationExpiredSchedTest {
    @isTest
    static void testSchedulerExecution() {
        Test.startTest();
        BI_PSPB_NotificationExpiredSched schedulableJob = new BI_PSPB_NotificationExpiredSched();
        String jobId = System.schedule('Test Notification Status Expiry Scheduler', '0 0 0 * * ?', schedulableJob);
        CronTrigger[] scheduledJobs = [SELECT Id, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual(1, scheduledJobs.size(), 'The scheduler job should be scheduled.');
        BI_PSPB_NotificationExpiredBatch batch = new BI_PSPB_NotificationExpiredBatch();
        Database.executeBatch(batch, 100);
        Test.stopTest();
    }
}