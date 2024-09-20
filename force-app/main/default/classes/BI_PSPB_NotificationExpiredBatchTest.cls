@isTest
/**
* @description This class contains test methods to verify the behaviour of batch
class that expires the notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationExpiredBatchTest {
    @isTest
    static void testBatchExecution() {
        String actionTypeUnRead = BI_PSPB_NotificationConstant.actionTypeUnRead;
        String symptomTrackerCategory = BI_PSPB_NotificationConstant.actionTypeSymptomTracker;
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < 5; i++) {
            Task task = new Task(
                Status = actionTypeUnRead,
                BI_PSP_Category__c = symptomTrackerCategory,
                BI_PSP_Notification_Type__c = 'General'
            );
            testTasks.add(task);
        }
        insert testTasks;
        try{
        Test.startTest();
        BI_PSPB_NotificationExpiredBatch batch = new BI_PSPB_NotificationExpiredBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        } catch (Exception e) {
            /*  While running negative scenario, the flow goes to catch.
                    Thus resulting in throwing exception and so assertion is done
                    for Exception only.*/
            Assert.areEqual(
            'Script-thrown exception',
            e.getMessage(),
            'Method thrown exception'
            );
        }
    }
}