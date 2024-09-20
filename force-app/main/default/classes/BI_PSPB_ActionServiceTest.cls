@isTest
/**
* @description This class contains test methods to get treatment reminder tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_ActionServiceTest {
    @isTest
    static void testGetTreatmentReminders() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Date__c = Date.today().addDays(-1),
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Type__c = 'Prescription'
        );
        insert testReminder;
        List<Id> whatIds = new List<Id>();
		whatIds.add(testReminder.Id); 
        Test.startTest();
        List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_ActionService.getTreatmentReminders(
            whatIds,
            'Prescription'
        );
        Test.stopTest();
        Assert.areEqual(testReminder.Id, reminders[0].Id, 'The returned reminder should match the test data');
    }

    @isTest
    static void testGetDateOfTreatmentReminder() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Date__c = Date.today().addDays(-1),
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Type__c = 'Date of Treatment'
        );
        insert testReminder;
        List<Id> whatIds = new List<Id>();
		whatIds.add(testReminder.Id); 
        Test.startTest();
        List<BI_PSPB_Treatment_Reminder__c> reminder = BI_PSPB_ActionService.getDateOfTreatmentReminder(
            whatIds,
            'Date of Treatment'
        );
        Test.stopTest();
        Assert.areEqual(testReminder.Id, reminder[0].Id, 'The returned reminder should match the test data');
    }
}