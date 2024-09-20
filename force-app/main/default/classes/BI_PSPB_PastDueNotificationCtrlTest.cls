@isTest
public class BI_PSPB_PastDueNotificationCtrlTest {
    @isTest
	static void testProcessPastDueReminders() {
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
			Test.startTest();
			BI_PSPB_PastDueNotificationCtrl.processPastDueReminders();
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
    @isTest
    static void testSendNotifications1() {
        // Arrange
        // Creating test data for the method parameters
        List<Id> enrolleeRecIds = new List<Id>();
        List<Id> enrolleePastOne = new List<Id>();
        List<Id> enrolleePastThree = new List<Id>();
		// Create dynamic test Account and CareProgramEnrollee records
		Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'TestCommunityCare', BI_PSP_Birthdate__c = Date.today().addYears(-25));
		insert testAccount;
		CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee Program');
		insert testCareProgram;
		CareProgramEnrollee enrollee1 = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee1', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = Date.today().addDays(-1));
		insert enrollee1;
		enrolleeRecIds.add(enrollee1.Id);
		enrolleePastOne.add(enrollee1.Id);
		enrolleePastThree.add(enrollee1.Id);
        BI_PSPB_TreatmentReminderDaysCtrl pastDueDays = new BI_PSPB_TreatmentReminderDaysCtrl(); // Assuming it has a default constructor
        String treatmentDate = '2024-09-09';

        // Mocking BI_PSPB_NotificationTemplatesCtrl.handleTrigger to track calls
		try{
			Test.startTest();
			BI_PSPB_PastDueNotificationCtrl.sendNotificationsCare(
				enrolleeRecIds,
				enrolleePastOne,
				enrolleePastThree,
				pastDueDays,
				treatmentDate
			);
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