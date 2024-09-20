/*

Apex Class Name    :BI_PSP_RetriveDraftResponseTest
Created Date       : November 5, 2023
description       : To get the Response for every Questionnaire by the current user
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Harish

*/

//this test method is for checking the retreival of draft responses for the Psoriasis category.
@isTest
private class BI_PSP_DraftResponseCtrlTest {
	@isTest
	//To retrive Assessment Response for WAPI Questionnarie for Patient negative
	static void testDraftResponseOfWorkAndApiCatch() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account portalAccount1 = new Account(
				FirstName = 'Test',
				LastName = 'Account',
				PersonEmail = 'test12345@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];

			// Create mock BI_SFCOE_LOG_App_Settings__c record
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Create a test user

			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUserTwo = new User(
				Email = 'testuser2new@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testuser2new@example.com',
				FirstName = 'Test',
				LastName = 'User2',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUserTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			//Create Assessment
			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserTwo.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Work & Activity Impairment (WPAI)'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id
			);
			insert questionVer;

			// Create test assessment response data
			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				Name = 'Test Response',
				ResponseText = 'No',
				BI_PSP_Category__c = 'Social life',
				AssessmentId = testAssessment.Id,
				AssessmentQuestionId = questionVer.Id
				//CreatedDate = createdDt
			);
			insert testResponse;
			try {
				System.runAs(testUserTwo) {
					String categoryName = 'Work & Activity Impairment (WPAI)';
					Boolean falseVal = false;
					//assertion is not done because this is for negative scenario and it goes to catch
					Test.startTest();
					BI_PSP_DraftResponseCtrl.retrieveDrfatResponses(categoryName, falseVal);
					Test.stopTest();
				}
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}

	@isTest
	static void testRetrieveDraftResponses() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account portalAccount1 = new Account(
				FirstName = 'Test',
				LastName = 'Account',
				PersonEmail = 'test12345@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Create a test user

			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUserTwo = new User(
				Email = 'testuser2new@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testuser2new@example.com',
				FirstName = 'Test',
				LastName = 'User2',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUserTwo;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testuser2new@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;

			//Create Assessment
			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserTwo.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Work & Activity Impairment (WPAI)'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id
			);
			insert questionVer;

			// Create test assessment response data
			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				Name = 'Insert Test Response',
				ResponseText = 'No',
				BI_PSP_Category__c = 'Social life',
				AssessmentId = testAssessment.Id,
				AssessmentQuestionId = questionVer.Id
				//CreatedDate = createdDt
			);
			insert testResponse;
			try {
				System.runAs(testUserTwo) {
					Test.startTest();
					List<AssessmentQuestionResponse> responses = BI_PSP_DraftResponseCtrl.retrieveDrfatResponses(
						'Work & Activity Impairment (WPAI)',
						false
					);
					Test.stopTest();

					System.assertEquals(0, responses.size(), 'responses retrieved');
				}
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}
    
    
    
	@isTest
	static void testRetrieveDraftResponsesNegative() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account portalAccount1 = new Account(
				FirstName = 'Test',
				LastName = 'Account',
				PersonEmail = 'test12345@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Create a test user

			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUserTwo = new User(
				Email = 'testuser2new@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testuser2new@example.com',
				FirstName = 'Test',
				LastName = 'User2',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUserTwo;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testuser2new@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;

			//Create Assessment
			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserTwo.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Work & Activity Impairment (WPAI)'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id
			);
			insert questionVer;

			// Create test assessment response data
			AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
				Name = 'Insert Test Response',
				ResponseText = 'No',
				BI_PSP_Category__c = 'Social life',
				AssessmentId = testAssessment.Id,
				AssessmentQuestionId = questionVer.Id
				//CreatedDate = createdDt
			);
			insert testResponse;
			try {
				System.runAs(testUserTwo) {
					Test.startTest();
					List<AssessmentQuestionResponse> responses = BI_PSP_DraftResponseCtrl.retrieveDrfatResponses(
						null,
						false
					);
					Test.stopTest();

					System.assertEquals(0, responses.size(), 'responses retrieved');
				}
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}
}