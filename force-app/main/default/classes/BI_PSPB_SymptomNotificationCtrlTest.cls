@isTest
public class BI_PSPB_SymptomNotificationCtrlTest {
    @isTest
    static void testProcessSymptomNotifications() {
        try {
            Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName',
            BI_PSPB_FirstLoginDate__c = Date.newInstance(2024, 8, 12)
		);
		insert testCareProgramEnrolle;
        BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
			BI_PSP_Are_you_currently_experiencing__c = true,
			BI_PSP_EditEntrydates__c = Date.today(),
			BI_PSP_First_Symptom_Notification_Date__c = Date.today(),
			BI_PSP_Notification_Status__c = true
		);
        insert symptomTracker;
        Test.startTest();
        BI_PSPB_SymptomNotificationCtrl.processSymptomNotifications();
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    @isTest
    static void testProcessSymptomNoNotifications() {
        try {
            Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName',
            BI_PSPB_FirstLoginDate__c = Date.newInstance(2024, 8, 12)
		);
		insert testCareProgramEnrolle;
        Test.startTest();
        BI_PSPB_SymptomNotificationCtrl.processSymptomNotifications();
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    @isTest
    static void testProcessSymptomNoEnrollee() {
        try {
        Test.startTest();
        BI_PSPB_SymptomNotificationCtrl.processSymptomNotifications();
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    @isTest
    static void testProcessSymptomNotificationsMajor() {
        try {
            Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
            BI_PSP_Birthdate__c = Date.today(),
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName',
            BI_PSPB_FirstLoginDate__c = Date.newInstance(2024, 8, 12)
		);
		insert testCareProgramEnrolle;
        BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
			BI_PSP_Are_you_currently_experiencing__c = true,
			BI_PSP_EditEntrydates__c = Date.today(),
			BI_PSP_First_Symptom_Notification_Date__c = Date.today(),
			BI_PSP_Notification_Status__c = true
		);
        insert symptomTracker;
        Test.startTest();
        BI_PSPB_SymptomNotificationCtrl.processSymptomNotifications();
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    @isTest
    static void testProcessSymptomNotificationsCaregiver() {
        try {
            
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account account = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
                BI_PSP_Birthdate__c = Date.today().addYears(-25),
				PersonEmail = 'sfhdghgeirug@wayneenterprises.com',
				RecordTypeId = personAccountRecordType.Id
			);

			insert account;
                    Account testCaregiverdata = new Account(
    Name = 'Caregiver Business Account', // Business accounts require a Name field
    Phone = '123-456-7890',
    BI_PSPB_Preferred_Communication_Method__c = 'Email',
            BI_PSPB_User_Type__c = 'Caregiver'
);
insert testCaregiverdata;

		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;

		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Patient__c = account.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
            BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver1 = new BI_PSPB_Enrollee_Caregiver__c(
            Id = caregiver.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id
        );
        update testEnrolleeCaregiver1;
        
        BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
			BI_PSP_Are_you_currently_experiencing__c = true,
			BI_PSP_EditEntrydates__c = Date.today(),
			BI_PSP_First_Symptom_Notification_Date__c = Date.today(),
			BI_PSP_Notification_Status__c = true
		);
        insert symptomTracker;
        Test.startTest();
        BI_PSPB_SymptomNotificationCtrl.processSymptomNotifications();
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
}