@isTest
/**
* @description This class contains test methods to verify the behaviour of
creating parameters for task creation.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskCreationParamsTest {
    @isTest
    static void testConstructor() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
        insert testCareProgram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareProgram.Id);
        insert testEnrollee;
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
                BI_PSPB_Reminder_Type__c = 'Date of Treatment',
                BI_PSPB_Date_of_Treatment__c = Date.today(),
                BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive
        );
        insert testReminder;
        BI_PSPB_TreatmentReminderDaysCtrl mockDaysCtrl = new BI_PSPB_TreatmentReminderDaysCtrl();
        Test.startTest();        
        BI_PSPB_TaskCreationParams taskParams = new BI_PSPB_TaskCreationParams(
            testReminder,
            mockDaysCtrl
        );        
        Test.stopTest();
        Assert.areEqual(testReminder.Id, taskParams.reminder.Id, 'Reminder ID should match');
        Assert.areEqual(mockDaysCtrl, taskParams.pastDueDays, 'pastDueDays should match the mocked instance');
    }
}