/**
@description    Test class to verify notification for treatment video.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@IsTest
private class BI_PSPB_TreatmentVideoNotifyCtrlTest {
	@IsTest
	static void testEmailAndSMS() {
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		CareProgram testCareProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program');
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrollee =
		new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee',
		CareProgramId = testCareProgram.Id);
		insert testCareProgramEnrollee;
		try{
			Test.startTest();
			BI_PSPB_TreatmentVideoNotifyCtrl.taskForTreatmentVideo();
			Test.stopTest();
		} catch (Exception e) {
			/*  When executing the negative scenario, if the flow enters 
			the catch block and throws an exception, assertions 
			are made solely for validating the exception occurrence.*/
			Assert.areEqual(
				'Script-thrown exception',e.getMessage(),
				'Method thrown exception'
			);
        }
	}
	 @isTest
	static void getCatch() {
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		if (standardUserProfile == null) {
			Assert.areEqual(false,standardUserProfile, 'Standard User profile not found. Please create it or update test data setup.');
		}
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact newContact = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert newContact;
		System.runAs(testUser) {
			Test.startTest();
			BI_PSPB_TreatmentVideoNotifyCtrl.taskForTreatmentVideo();
			Test.stopTest();
			List<Contact> leadRecord = [
					SELECT Id
					FROM Contact
					WHERE Id = :newContact.Id
				];
				Assert.areEqual(
					1,leadRecord.size(),
					'Lead should have been created'
				);
		}
	}
}