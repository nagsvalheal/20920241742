/*

Apex Class Name    :BI_PSP_QualitativeSatisfactionCtrlTest
Created Date       : November 5, 2023
description       : To get the date for 2 months and 14 weeks of the care program enrollee to enroll the Qsq Questionnaires.
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Harish

*/

@isTest
public class BI_PSP_QualitativeSatisfactionCtrlTest {
	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
	@isTest
	static void testGetPatientAfterThreemonthsAndFourteenWeeks() {
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
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			//To create user
			User testUser = new User(
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				FirstName = 'Test',
				LastName = 'User',
				Email = 'testuser@example.com',
				Alias = 'tuser',
				Username = 'testuser2312@example.com',
				CommunityNickname = 'tuser123',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			//Account for Patient
			Account testAccount = new Account(Name = 'Harish');
			insert testAccount;
			//Create Careprogram to insert careProgramEnrollee
			CareProgram testCareProgram = new CareProgram(
				Name = 'Spevigo',
				StartDate = Date.newInstance(2023, 7, 12)
			);
			insert testCareProgram;
			//CareProgram Enrollee for User to get the Assessment for the particular user
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'Harish',
				CareProgramId = testCareProgram.Id,
				AccountId = testAccount.Id
			);
			insert testEnrolleeOne;

			Test.startTest();
			try {
				System.runAs(testUser) {
					//Testing the method that returns the date of care program enrollee after
					BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks();

					//This is negative senario so there no need to check assert
				}

				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}

	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
	@isTest
	static void testGetTheDateInProgressForCard() {
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
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			// Create a test user
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';

			//Create Test User
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			//Person account
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			//TO create Account
			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			//Create careProgram to create
			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;
			//create CareProgram Enrollee
			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;
			Test.startTest();
			System.runAs(testUser) {
				// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is not a caregiver
				Map<String, Object> result = BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks();
				Assert.areNotEqual(0, result.size(), 'There is no record for the user');
			}
			Test.stopTest();
		}
	}

	// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is a caregiver
	@isTest
	static void testGetTheDateInProgressForCardscargiver() {
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
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			// Create a test user
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';

			//To create user for caregiver
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
			//Create Person account
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			//create Account for Patient
			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;
			//Create Account for caregiver
			String currentUserNameTwo = 'Test User2';
			String currentUserEmailTwo = 'testuser2new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmailTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;
			CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountTwo.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeTwo;

			// Create an assessment record
			Assessment testAssessment = new Assessment(
				Name = 'Dermatology Life Quality Index (DLQI)',
				BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id,
				AssessmentStatus = 'In Progress',
				EffectiveDateTime = Date.today()
			);
			insert testAssessment;
			try {
				Test.startTest();
				System.runAs(testUserTwo) {
					// Test method to verify the behavior of getPatientAfterThreemonthsAndFourteenWeeks when the user is a caregiver

					Map<String, Object> result = BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks();
					Assert.areEqual(4, result.size(), 'Date for the User');
				}
				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}
	@isTest
	//To cover the negative senario for patient
	static void testGetPatientAfterThreemonthsAndFourteenWeeksCatch() {
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

			//User profile
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			//TestUser for Patient
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			try {
				System.runAs(testUser) {
					Test.startTest();

					// Switch to the test caregiver context

					BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks();
					//This is negative senario so there no need to check assert

					Test.stopTest();
				}
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}
	@isTest
	//To cover the negative senario for caregiver
	static void testGetCaregiverAfterThreemonthsAndFourteenWeeks() {
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
			//User profile
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			//TestUser for Patient
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
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			try {
				Test.startTest();

				// Switch to the test caregiver context

				BI_PSP_QualitativeSatisfactionCtrl.getPatientEnrolleeDateAfterTwoMonthsAndFourteenWeeks();
				//This is negative senario so there no need to check assert
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
	}
	@isTest
	//To get the Qualitative Questionnaire (14 weeks)Response for Patient status expired
	static void getQsqTwoCompletedQuestionaresTest() {
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

			String targetDate = 'Jan 2023';
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
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
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmaiTwo = 'testuser2new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmaiTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserTwo.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
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
				AssessmentQuestionId = questionVer.Id,
				//CreatedDate = createdDt,
				BI_PSP_QsqAfterWeeks__c = 'pageTwo'
			);
			insert testResponse;

			System.runAs(testUserTwo) {
				try {
					Test.startTest();
					List<AssessmentQuestionResponse> result = BI_PSP_QualitativeSatisfactionCtrl.getQSQCompletedQuestionaresFourteenWks(
						targetDate
					);
					Test.stopTest();
					Assert.areEqual(
						1,
						result.size(),
						'There should be one qsq2 1 AssessmentQuestionResponse in the result'
					);
				} catch (Exception e) {
					// Assert that the exception message is as expected
					Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
				}
			}
		}
	}
	@isTest
	//To get the Qualitative Questionnaire Response for Patient for Expired
	static void getQsqFourteenWeeksCompletedQuestionaresTest() {
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

			String targetDate = 'Jan 2023';
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;

			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUser.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpeOne.Id
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
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
				AssessmentQuestionId = questionVer.Id,
				//CreatedDate = createdDt,
				BI_PSP_QsqAfterWeeks__c = 'pageTwo'
			);
			insert testResponse;

			System.runAs(testUser) {
				Test.startTest();
				List<AssessmentQuestionResponse> result = BI_PSP_QualitativeSatisfactionCtrl.getQSQCompletedQuestionaresFourteenWks(
					targetDate
				);
				Test.stopTest();
				Assert.areEqual(
					1,
					result.size(),
					'There should be one qsq2 2 AssessmentQuestionResponse in the result'
				);
			}
		}

	}
	//To get the Qualitative Questionnaire Response for Patient to cover negative Senario
	@isTest
	static void getQsqCompletedQuestionaresTestCatchNegative() {
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

			String targetDate = 'Jan 2023';
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmaiTwo = 'testuser2new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmaiTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUser.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
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
				AssessmentQuestionId = questionVer.Id,
				//CreatedDate = createdDt,
				BI_PSP_QsqAfterWeeks__c = 'pageTwo'
			);
			insert testResponse;
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_QualitativeSatisfactionCtrl.getQSQCompletedQuestionaresFourteenWks(
					targetDate
				);
				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}

	}

	@isTest
	static void getDateForQsqTestNegativeScenario() {
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
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmaiTwo = 'testuser2new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmaiTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUser.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
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
				AssessmentQuestionId = questionVer.Id,
				//CreatedDate = createdDt,
				BI_PSP_QsqAfterWeeks__c = 'pageTwo'
			);
			insert testResponse;
			try {
				//assertion is not done because this is for negative scenario and it goes to catch
				Test.startTest();
				BI_PSP_QualitativeSatisfactionCtrl.getDatesOfCompletedQsq();
				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}

	}

	@isTest
	//To get the Qualitative Questionnaire Response for Patient for Expired
	static void getDateForQsqTestPositiveScenario() {
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
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUser;

			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUser.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023',
				BI_PSP_CareProgramEnrollee__c = testCpeOne.Id
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
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
				AssessmentQuestionId = questionVer.Id,
				//CreatedDate = createdDt,
				BI_PSP_QsqAfterWeeks__c = 'pageTwo'
			);
			insert testResponse;

			System.runAs(testUser) {
				Test.startTest();
				List<AssessmentQuestionResponse> result = BI_PSP_QualitativeSatisfactionCtrl.getDatesOfCompletedQsq();
				Test.stopTest();
				Assert.areEqual(
					1,
					result.size(),
					'There should be one qsq2 2 AssessmentQuestionResponse in the result'
				);
			}
		}

	}
	@isTest
	//To get the Qualitative Questionnaire (14 weeks)Response for Patient status expired
	static void getQsqTwoCompletedQuestionaresTestNegative() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'zap@paz.com',
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

			String targetDate = 'Jan 2023';
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;
			User testUserTwo = new User(
				Email = 'testuser2new@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = System.now().millisecond() +'testuser21new@example.com',
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

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmaiTwo = 'testuser211new@example.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmaiTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeTwo;

			System.runAs(testUserTwo) {
				try {
					Test.startTest();
					List<AssessmentQuestionResponse> result = BI_PSP_QualitativeSatisfactionCtrl.getQSQCompletedQuestionaresFourteenWks(
						''
					);
					Test.stopTest();
					Assert.areEqual(
						1,
						result.size(),
						'There should be one qsq2 1 AssessmentQuestionResponse in the result'
					);
				} catch (Exception e) {
					// Assert that the exception message is as expected
					Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
				}
			}
		}
	}
}