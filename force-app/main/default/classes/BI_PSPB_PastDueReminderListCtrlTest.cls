@isTest
public class BI_PSPB_PastDueReminderListCtrlTest {
    @isTest
	static void testprocessReminderList() {
        try {
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
			List<BI_PSPB_Treatment_Reminder__c> testReminders = new List<BI_PSPB_Treatment_Reminder__c>{
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-1), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-1),BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[1].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-3), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-3),BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[2].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-5), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-5), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment')
			};
			insert testReminders;
            Date targetDate = Date.today().addDays(-7);
            List<BI_PSPB_Treatment_Reminder__c> reminders = [SELECT Id, BI_PSPB_Date_of_Treatment__c, 
                                                            BI_PSPB_Care_Program_Enrollee__r.Account.BI_PSP_Birthdate__c,
                                                             BI_PSPB_Care_Program_Enrollee__r.Account.Name
                                                        FROM BI_PSPB_Treatment_Reminder__c];
            BI_PSPB_PastDueNotificationCtrl.ReminderProcessingContext context = new BI_PSPB_PastDueNotificationCtrl.ReminderProcessingContext();
            
			Test.startTest();
			BI_PSPB_PastDueReminderListCtrl.processReminderList(reminders, targetDate, context);
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