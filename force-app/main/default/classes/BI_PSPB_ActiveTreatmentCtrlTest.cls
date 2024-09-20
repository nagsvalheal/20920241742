@isTest
public class BI_PSPB_ActiveTreatmentCtrlTest {

    /**
    * @description Test method to verify the getActiveReminders method with valid input.
    *This test will cover scenarios where active reminders exist for the given date.
    */
    @isTest
    static void testGetActiveRemindersValidInput() {
        // Create test data
        Account testAccount = new Account(
            Name = 'Test Account',
            BI_PSP_Birthdate__c = Date.today().addYears(-30)
        );
        insert testAccount;

        CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program');
        insert testCareProgram;

        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id,
            Name = 'Test Enrollee',
            CareProgramId = testCareProgram.Id
        );
        insert testEnrollee;

        // Create treatment reminders that match the criteria
        BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Date_of_Treatment__c = Date.today(),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypeTreatment
        );

        BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Date_of_Treatment__c = Date.today(),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypePrescription
        );

        insert new List<BI_PSPB_Treatment_Reminder__c>{reminder1, reminder2};

        // Test execution
        Test.startTest();
        List<BI_PSPB_Treatment_Reminder__c> result = BI_PSPB_ActiveTreatmentCtrl.getActiveReminders(Date.today());
        Test.stopTest();

        // Assert the expected results
        System.assertEquals(2, result.size(), 'The result should contain two active reminders.');
        System.assertEquals(reminder1.Id, result[0].Id, 'The first reminder should match reminder1.');
        System.assertEquals(reminder2.Id, result[1].Id, 'The second reminder should match reminder2.');
    }

    /**
     * @description Test method to verify the behavior when no active reminders exist for the given date.
     */
    @isTest
    static void testGetActiveRemindersNoMatchingRecords() {
        // Create test data without matching reminders
        Account testAccount = new Account(
            Name = 'Test Account',
            BI_PSP_Birthdate__c = Date.today().addYears(-30)
        );
        insert testAccount;

        CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program');
        insert testCareProgram;

        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id,
            Name = 'Test Enrollee',
            CareProgramId = testCareProgram.Id
        );
        insert testEnrollee;

        // Create treatment reminders with a different date
        BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Date__c = Date.today().addDays(-1),
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(-1),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypeTreatment
        );

        insert reminder;

        // Test execution
        Test.startTest();
        List<BI_PSPB_Treatment_Reminder__c> result = BI_PSPB_ActiveTreatmentCtrl.getActiveReminders(Date.today());
        Test.stopTest();

        // Assert that the result is empty as there are no matching records
        System.assertEquals(0, result.size(), 'The result should be empty when no active reminders match the given date.');
    }

    /**
     * @description Test method to verify the behavior when an exception occurs.
     */
    @isTest
    static void testGetActiveRemindersExceptionHandling() {
        // Test execution with an invalid parameter to force an exception
        Test.startTest();
        List<BI_PSPB_Treatment_Reminder__c> result = BI_PSPB_ActiveTreatmentCtrl.getActiveReminders(Date.newInstance(2024, 13, 32));
        Test.stopTest();

        // Assert that the result is empty due to exception handling
        System.assertEquals(0, result.size(), 'The result should be empty due to exception handling.');
    }
}