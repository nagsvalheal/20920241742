@isTest
/**
* @description This class contains test methods to verify the behaviour of
creating tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskCreationCtrlTest {
    @isTest
    static void testCreateTasks() {
        List<Id> enrollees = new List<Id>();
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{acc1, acc2};
        enrollees.add(acc1.Id);
        enrollees.add(acc2.Id);
        BI_PSPB_TaskParameters taskParams = new BI_PSPB_TaskParameters(
            'Test Subject',
            'SMS',
            'Category A',
            'Type B',
            'New'
        );
        List<Task> tasks = BI_PSPB_TaskCreationCtrl.createTasks(enrollees, taskParams);
        Assert.areEqual(2, tasks.size(), 'Two tasks should be created');
        for (Task task : tasks) {
            Assert.areEqual(taskParams.subject, task.Subject, 'Subject should match');
            Assert.areEqual(taskParams.notificationType, task.BI_PSP_Notification_Type__c, 'Notification Type should match');
            Assert.areEqual(taskParams.category, task.BI_PSP_Category__c, 'Category should match');
            Assert.areEqual(taskParams.treatmentType, task.BI_PSPB_Treatment_Type__c, 'Treatment Type should match');
            Assert.areEqual(taskParams.status, task.Status, 'Status should match');
        }
    }
}