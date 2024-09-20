@isTest
public class BI_PSPB_QsqQuestionnaireActionCtrlTest {
@isTest
    static void testProcessWpaiQuestionnairesWithNoSymptoms() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];
			Date birthDate = Date.newInstance(2000, 9, 4);
			// Create Person Account
			Account account = new Account(
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'Wpaipatient@wayneenterprises.com',
                BI_PSP_Birthdate__c = birthDate,
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
			Name = 'TestPatientFeed PatientLastName',
            BI_PSPB_FirstLoginDate__c = System.today().addDays(-1)
		);
		insert testCareProgramEnrolle;
        Test.startTest();
        try{
        BI_PSPB_QsqQuestionnaireActionCtrl.processQsqQuestionnaires();
        Test.stopTest();
        } catch (Exception e) {
            /**  While running negative scenario, the flow goes to catch.
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
	/** @description Test method to verify with caregiver
	*/
    static void testProcessWpaiQuestionnairesWithCaregiver() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];
			Date birthDate = Date.newInstance(2021, 9, 4);
			// Create Person Account
			Account account = new Account(
				FirstName = 'Wpai',
				LastName = 'Patient',
				PersonEmail = 'WpaiPatient@gmail.com',
                BI_PSP_Birthdate__c = birthDate,
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
			Name = 'TestPatientFeed PatientLastName',
            BI_PSPB_FirstLoginDate__c = System.today().addDays(-2)
		);
		insert testCareProgramEnrolle;
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
        Test.startTest();
        try{
        BI_PSPB_QsqQuestionnaireActionCtrl.processQsqQuestionnaires();
        } catch (Exception e) {
            /**  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
        }
        Test.stopTest();
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        Assert.areEqual(1, tasks.size(), 'Two task should be created for the symptom with caregiver.');
    }
	/**@description Test method to verify caregiver and major patient.
    */
	@isTest
    static void testProcessWpaiQuestionnairesWithMajorCaregiver() {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];
			Date birthDate = Date.newInstance(1990, 9, 4);
			// Create Person Account
			Account account = new Account(
				FirstName = 'Wpai',
				LastName = 'Patient',
				PersonEmail = 'WpaiPatient@gmail.com',
                BI_PSP_Birthdate__c = birthDate,
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
			Name = 'TestProgramEnrollee',
            BI_PSPB_FirstLoginDate__c = System.today().addDays(-2)
		);
		insert testCareProgramEnrolle;
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
		insert caregiver;
        Test.startTest();
        try{
        BI_PSPB_QsqQuestionnaireActionCtrl.processQsqQuestionnaires();
            } catch (Exception e) {
            /**  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
        }
        Test.stopTest();
    }
}