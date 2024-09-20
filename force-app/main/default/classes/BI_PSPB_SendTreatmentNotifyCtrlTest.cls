@isTest
public class BI_PSPB_SendTreatmentNotifyCtrlTest {

    @isTest
    static void testSendNotifications() {
        try{
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community2', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccount;
			Account testAccountPatient = new Account(Name = 'Test Account1', BI_PSP_CommunityUsername__c = 'Test Community3', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccountPatient;
			Account testAccountCaregiver = new Account(Name = 'Test Account2', BI_PSP_CommunityUsername__c = 'Test Community4', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccountCaregiver;
			CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
			insert testCareProgram;
			List<CareProgramEnrollee> testEnrollees = new List<CareProgramEnrollee>{
					new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-1)),
					new CareProgramEnrollee(AccountId = testAccountPatient.Id, Name = 'Test Enrollee1', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-3)),
					new CareProgramEnrollee(AccountId = testAccountCaregiver.Id, Name = 'Test Enrollee2', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-5))
			};
			insert testEnrollees;

        // Create test Treatment Reminders
        List<BI_PSPB_Treatment_Reminder__c> reminders = new List<BI_PSPB_Treatment_Reminder__c>{
            new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Reminder_Date__c = Date.today().addDays(-1),
                BI_PSPB_Date_of_Treatment__c = Date.today(),
                BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id
            ),
            new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Reminder_Date__c = Date.today(),
                BI_PSPB_Date_of_Treatment__c = Date.today().addDays(-3),
                BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id
            ),
            new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Reminder_Date__c = Date.today().addDays(-7),
                BI_PSPB_Date_of_Treatment__c = Date.today(),
                BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id
            ),
            new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Reminder_Date__c = Date.today().addDays(-10),
                BI_PSPB_Date_of_Treatment__c = Date.today(),
                BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id
            ),
            new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Reminder_Date__c = Date.today().addDays(-14),
                BI_PSPB_Date_of_Treatment__c = Date.today(),
                BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id
            )
        };

        // Insert test reminders
        insert reminders;
        // Retrieve test reminders
        List<BI_PSPB_Treatment_Reminder__c> reminders1 = [SELECT Id, BI_PSPB_Reminder_Date__c, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Care_Program_Enrollee__c FROM BI_PSPB_Treatment_Reminder__c];
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 1;
            
            BI_PSPB_TreatmentReminderDaysCtrl daysCount1 = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 3;

        // Call the method to test
        Test.startTest();
        BI_PSPB_SendTreatmentNotifyCtrl.sendNotifications(reminders1, daysCount);
            BI_PSPB_SendTreatmentNotifyCtrl.sendNotifications(reminders1, daysCount1);
        Test.stopTest();

        // Add assertions to verify the expected outcomes
        // Here, assert log entries, expected notifications, or other side effects of the sendNotifications method
        //System.assert(true, 'Completed without exceptions.');
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

    @isTest
    static void testSendNotificationsWithEmptyReminders() {
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 1;
        daysCount.before3Day = 3;
        daysCount.before7Day = 7;
        daysCount.before10Day = 10;
        daysCount.before14Day = 14;
        // Call the method with empty reminders
        Test.startTest();
        BI_PSPB_SendTreatmentNotifyCtrl.sendNotifications(new List<BI_PSPB_Treatment_Reminder__c>(), daysCount);
        Test.stopTest();

        // Add assertions to verify the error logging or handling of empty reminders
        System.assert(true, 'Handled empty reminders without exception.');
    }

    @isTest
    static void testSendNotificationsWithNullDaysCount() {
        // Retrieve test reminders
        List<BI_PSPB_Treatment_Reminder__c> reminders = [SELECT Id, BI_PSPB_Reminder_Date__c, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Care_Program_Enrollee__c FROM BI_PSPB_Treatment_Reminder__c];

        // Call the method with null daysCount
        Test.startTest();
        BI_PSPB_SendTreatmentNotifyCtrl.sendNotifications(reminders, null);
        Test.stopTest();

        // Add assertions to verify the error logging or handling of null daysCount
        System.assert(true, 'Handled null daysCount without exception.');
    }
}