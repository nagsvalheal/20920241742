@isTest
public class BI_PSPB_PssQuestionnaireActionCtrlTest {
	@isTest
    static void testProcessPssQuestionnairesWithNoSymptoms() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account account = new Account(
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'psspatient@wayneenterprises.com',
				RecordTypeId = personAccountRecordType.Id
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
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
        Test.startTest();
        BI_PSPB_PssQuestionnaireActionCtrl.processPssQuestionnaires();
        Test.stopTest();
		List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size(), 'No tasks should be created without symptoms.');
    }
    @isTest
    static void testProcessPssQuestionnairesWithSymptoms() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];
			// Create Person Account
			Account account = new Account(
				FirstName = 'PSS',
				LastName = 'Patient',
				PersonEmail = 'pssPatient@gmail.com',
                BI_PSP_Birthdate__c = Date.newInstance(2000, 9, 4),
				RecordTypeId = personAccountRecordType.Id
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
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
		BI_PSP_Symptom_Tracker__c symptom = new BI_PSP_Symptom_Tracker__c(
        	BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            Name = 'symptom'
        	);
        insert symptom;
        Test.startTest();
        BI_PSPB_PssQuestionnaireActionCtrl.processPssQuestionnaires();
        Test.stopTest();
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        System.assertEquals(1, tasks.size(), 'One task should be created for the symptom.');
    }
    @isTest
    static void testProcessPssQuestionnairesWithCaregiver() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];
			// Create Person Account
			Account account = new Account(
				FirstName = 'PSS',
				LastName = 'Patient',
				PersonEmail = 'pssPatient@gmail.com',
                BI_PSP_Birthdate__c = Date.newInstance(2023, 9, 4),
				RecordTypeId = personAccountRecordType.Id
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
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
		BI_PSP_Symptom_Tracker__c symptom = new BI_PSP_Symptom_Tracker__c(
        	BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            Name = 'symptom'
        	);
        insert symptom;
        Test.startTest();
        BI_PSPB_PssQuestionnaireActionCtrl.processPssQuestionnaires();
        Test.stopTest();
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        System.assertEquals(2, tasks.size(), 'Two task should be created for the symptom with caregiver.');
    }
}