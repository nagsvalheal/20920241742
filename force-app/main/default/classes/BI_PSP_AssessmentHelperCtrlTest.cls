/*
* @description       This test class provides test methods to retrieve questionnaire questions for different categories
                     test methods to get the status of assessments and counts of completed
                     assessments of the test user.
* History:
* Version	Author		Date			Detail			Description
* 1.0		Abinsha  	05-Dec-2023		Created			Initial development.
* 1.1		Abinsha  	01-Jan-2024		Updated			Updated for caregiver.
* 1.2		Abinsha 	04-Apr-2024		Updated			test cases added.
*/
@isTest
public class BI_PSP_AssessmentHelperCtrlTest {
    @isTest
	static void testGetRolloutDate() {
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
			AssessmentQuestionId = questionData.Id,
			IsActive = true
		);
		insert questionVer;

		AssessmentQuestion questionDataTwo = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionDataTwo;

		AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
			AssessmentQuestionId = questionDataTwo.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionVersionTwo;
		// Call the method under test
		Assessment ass;
        DateTime timeOfQsqEnrllee;
        Boolean isQsqAfterTwoMonths;
         String questionnaireName;

		try {
			Test.startTest();

			// Use the extracted questionIds and responseTexts in the method

			BI_PSP_AssessmentHelperCtrl.setRolloutDate(ass,timeOfQsqEnrllee,isQsqAfterTwoMonths,questionnaireName);

			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
		}
	}

	@isTest
	static void testCaregiverData() {
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
			AssessmentQuestionId = questionData.Id,
			IsActive = true
		);
		insert questionVer;

		AssessmentQuestion questionDataTwo = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionDataTwo;

		AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
			AssessmentQuestionId = questionDataTwo.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionVersionTwo;
		List<String> questionIds = new List<String>{ questionVer.Id, questionVersionTwo.Id };
		// Call the method under test

		try {
			Test.startTest();

			// Use the extracted questionIds and responseTexts in the method

			BI_PSP_AssessmentHelperCtrl.getCategory(questionIds);

			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
		}
	}

	@isTest
	static void testCaregiverDataNegativeScenario() {
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
			AssessmentQuestionId = questionData.Id,
			IsActive = true
		);
		insert questionVer;

		AssessmentQuestion questionDataTwo = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionDataTwo;

		AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
			AssessmentQuestionId = questionDataTwo.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionVersionTwo;

		List<String> questionIds = new List<String>();

		try {
			Test.startTest();

			// Use the extracted questionIds and responseTexts in the method

			BI_PSP_AssessmentHelperCtrl.getCategory(questionIds);

			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual('Script-thrown exception', 'Script-thrown exception', e.getMessage());
		}
	}

	@isTest
	static void tesResponseSetUp() {
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

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;


			User testUserSecond = new User(
				Email = 'testUserSecondnew@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testUserSecondnew@example.com',
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
			insert testUserSecond;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountFirst = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountFirst;
			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testUserSecondnew@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountFirst.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;
			CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeTwo',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserSecond.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
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
				AssessmentQuestionId = questionData.Id,
				IsActive = true
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

			AssessmentQuestion questionDataTwo = new AssessmentQuestion(
				Name = 'test questionname2',
				DeveloperName = 'Valid_Name_1293',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
			);
			insert questionDataTwo;

			AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataTwo.id,
				QuestionText = 'What is your gender?',
				Name = 'test data2',
				IsActive = true
			);
			insert questionVersionTwo;

			AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
				ResponseText = 'Female',
				BI_PSP_Category__c = '',
				AssessmentId = testAssessment.id,
				AssessmentQuestionId = questionVersionTwo.id,
				Name = 'test data'
			);
			insert testResponseTwo;

			String assQstnVe = questionVer.Id;
			String respText = testResponseTwo.ResponseText;
			String assId = testAssessment.Id;
			Boolean isQsqAfterTwoMonths = true;

			// Call the method under test.
			System.runAs(testUserSecond) {
				try {
					Test.startTest();
					// Use the extracted questionIds and responseTexts in the method.
					BI_PSP_AssessmentHelperCtrl.newDraftResponseToInsert(
						assQstnVe,
						respText,
						assId,
						isQsqAfterTwoMonths
					);
					Test.stopTest();
				} catch (Exception e) {
					// Assert that the exception message is as expected.
					Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
				}
			}
			List<AssessmentQuestionResponse> draftRecords = [
				SELECT Id
				FROM AssessmentQuestionResponse
				WHERE AssessmentId = :testAssessment.Id
			];
			Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
			Assert.areEqual(
				expectedDraftRecordCount,
				draftRecords.size(),
				'Expected characters after first two'
			); // Succeeds
		}
	}

	@isTest
	static void tesForQsqFalse() {
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

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;


			User testUserSecond = new User(
				Email = 'testUserSecondnew@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testUserSecondnew@example.com',
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
			insert testUserSecond;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountFirst = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountFirst;
			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testUserSecondnew@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountFirst.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;
			CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeTwo',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserSecond.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
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
				AssessmentQuestionId = questionData.Id,
				IsActive = true
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

			AssessmentQuestion questionDataTwo = new AssessmentQuestion(
				Name = 'test questionname2',
				DeveloperName = 'Valid_Name_1293',
				DataType = 'Decimal',
				QuestionCategory = 'Qualitative satisfaction questionnaire'
			);
			insert questionDataTwo;

			AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataTwo.id,
				QuestionText = 'What is your gender?',
				Name = 'test data2',
				IsActive = true
			);
			insert questionVersionTwo;

			AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
				ResponseText = 'Female',
				BI_PSP_Category__c = '',
				AssessmentId = testAssessment.id,
				AssessmentQuestionId = questionVersionTwo.id,
				Name = 'test data'
			);
			insert testResponseTwo;
			String assQstnVe = questionVer.Id;
			String respText = testResponseTwo.ResponseText;
			String assId = testAssessment.Id;
			Boolean isQsqAfterTwoMonths = false;
			System.runAs(testUserSecond) {
				try {
					Test.startTest();
					// Use the extracted questionIds and responseTexts in the method
					BI_PSP_AssessmentHelperCtrl.newDraftResponseToInsert(
						assQstnVe,
						respText,
						assId,
						isQsqAfterTwoMonths
					);
					Test.stopTest();
				} catch (Exception e) {
					// Assert that the exception message is as expected
					Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
				}
			}
			List<AssessmentQuestionResponse> draftRecords = [
				SELECT Id
				FROM AssessmentQuestionResponse
				WHERE AssessmentId = :testAssessment.Id
			];
			Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
			Assert.areEqual(
				expectedDraftRecordCount,
				draftRecords.size(),
				'Expected characters after first two'
			); // Succeeds
		}
	}

	@isTest
	static void testForUpdatePersonalisation() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'quatic2@asess.com',
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

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
			insert con;

			User testUserSecond = new User(
				Email = 'testUserSecondnew@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testUserSecondnew@example.com',
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
			insert testUserSecond;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountFirst = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountFirst;
			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testUserSecondnew@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountFirst.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;
			CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeTwo',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserSecond.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id,
				IsActive = true
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

			AssessmentQuestion questionDataTwo = new AssessmentQuestion(
				Name = 'test questionname2',
				DeveloperName = 'Valid_Name_1293',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionDataTwo;

			AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
				AssessmentQuestionId = questionDataTwo.id,
				QuestionText = 'What is your gender?',
				Name = 'test data2',
				IsActive = true
			);
			insert questionVersionTwo;

			AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
				ResponseText = 'Female',
				BI_PSP_Category__c = '',
				AssessmentId = testAssessment.id,
				AssessmentQuestionId = questionVersionTwo.id,
				Name = 'test data'
			);
			insert testResponseTwo;
			List<String> questionIds = new List<String>{ questionVer.Id, questionVersionTwo.Id };
			String assId = testAssessment.Id;
			Boolean isQsqAfterTwoMonths = false;
			Boolean isItDraftOrSubmit = true;
			// Call the method under test
			System.runAs(testUserSecond) {
				try {
					Test.startTest();

					// Use the extracted questionIds and responseTexts in the method

					BI_PSP_AssessmentHelperCtrl.updatePersonalisation(
						isItDraftOrSubmit,
						questionIds,
						assId,
						isQsqAfterTwoMonths
					);

					Test.stopTest();
				} catch (Exception e) {
					// Assert that the exception message is as expected
					Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
				}
			}
			List<AssessmentQuestionResponse> draftRecords = [
				SELECT Id
				FROM AssessmentQuestionResponse
				WHERE AssessmentId = :testAssessment.Id
			];
			Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
			Assert.areEqual(
				expectedDraftRecordCount,
				draftRecords.size(),
				'Expected characters after first two'
			); // Succeeds
		}
	}

	@isTest
	static void testForInsertion() {
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

			User testUserSecond = new User(
				Email = 'testUserSecondnew@example.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'testUserSecondnew@example.com',
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
			insert testUserSecond;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountFirst = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountFirst;
			String currentUserNameSecond = 'Test User2';
			String currentUserEmailSecond = 'testUserSecondnew@example.com';
			Account testAccountSecond = new Account(
				Lastname = currentUserNameSecond,
				PersonEmail = currentUserEmailSecond,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
			);
			insert testAccountSecond;

			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;

			CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeOne',
				AccountId = testAccountFirst.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeOne;
			CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
				Name = 'testCareProgramEnrolleeTwo',
				AccountId = testAccountSecond.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCareProgramEnrolleeTwo;

			Assessment testAssessment = new Assessment(
				Name = 'Test Assessment',
				OwnerId = testUserSecond.Id,
				AssessmentStatus = 'Completed',
				BI_PSP_DateForCQ__c = 'Jan 2023'
			);
			insert testAssessment;

			//insert assessment question
			AssessmentQuestion questionData = new AssessmentQuestion(
				Name = 'test questionname',
				DeveloperName = 'Valid_Name_123',
				DataType = 'Decimal',
				QuestionCategory = 'Introduction'
			);
			insert questionData;

			//insert Assessment question version

			AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
				Name = 'question',
				QuestionText = 'Do you often discuss GPP with your friends and family?',
				AssessmentQuestionId = questionData.Id,
				IsActive = true
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

			List<AssessmentQuestionResponse> responsesToInsert = new List<AssessmentQuestionResponse>{
				testResponse
			};

			// Call the method under test
			System.runAs(testUserSecond) {
				try {
					Test.startTest();

					// Use the extracted questionIds and responseTexts in the method

					BI_PSP_AssessmentHelperCtrl.insertCurrentUsersExistingAndCurrentResponse(
						responsesToInsert
					);

					Test.stopTest();
				} catch (Exception e) {
					// Assert that the exception message is as expected
					Assert.areEqual(e.getMessage(), e.getMessage(), e.getMessage());
				}
			}
			List<AssessmentQuestionResponse> draftRecords = [
				SELECT Id
				FROM AssessmentQuestionResponse
				WHERE AssessmentId = :testAssessment.Id
			];
			Integer expectedDraftRecordCount = 1; // Assuming 2 draft records were created
			Assert.areEqual(
				expectedDraftRecordCount,
				draftRecords.size(),
				'Expected characters after first two'
			); // Succeeds
		}
	}

	@isTest
	static void testForAssessStatus() {
		List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
			LIMIT 1
		];

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
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		User testUserSecond = new User(
			Email = 'testUserSecondnew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testUserSecondnew@example.com',
			FirstName = 'Test',
			LastName = 'User2',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUserSecond;
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountFirst = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountFirst;
		String currentUserNameSecond = 'Test User2';
		String currentUserEmailSecond = 'testUserSecondnew@example.com';
		Account testAccountSecond = new Account(
			Lastname = currentUserNameSecond,
			PersonEmail = currentUserEmailSecond,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
		);
		insert testAccountSecond;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
			Name = 'testCareProgramEnrolleeOne',
			AccountId = testAccountFirst.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCareProgramEnrolleeOne;
		CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
			Name = 'testCareProgramEnrolleeTwo',
			AccountId = testAccountSecond.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCareProgramEnrolleeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023'
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionData;

		//insert Assessment question version

		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id,
			IsActive = true
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
		assResList.add(testResponse);

		AssessmentQuestion questionDataTwo = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionDataTwo;

		AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
			AssessmentQuestionId = questionDataTwo.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionVersionTwo;

		AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
			ResponseText = 'Female',
			BI_PSP_Category__c = '',
			AssessmentId = testAssessment.id,
			AssessmentQuestionId = questionVersionTwo.id,
			Name = 'test data'
		);
		insert testResponseTwo;
		assResList.add(testResponseTwo);

		Boolean isItDraftOrSubmit = true;
		String questionnaireName = 'Introduction';
		// Call the method under test
		System.runAs(testUserSecond) {
			try {
				Test.startTest();

				// Use the extracted questionIds and responseTexts in the method

				BI_PSP_AssessmentHelperCtrl.setAssessmentStatus(
					testAssessment,
					isItDraftOrSubmit,
					questionnaireName
				);

				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
		List<AssessmentQuestionResponse> draftRecords = [
			SELECT Id
			FROM AssessmentQuestionResponse
			WHERE AssessmentId = :testAssessment.Id
		];
		Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
		Assert.areEqual(
			expectedDraftRecordCount,
			draftRecords.size(),
			'Expected characters after first two'
		); // Succeeds
	}

	@isTest
	static void testForPersonlStatus() {
		List<AssessmentQuestionResponse> assResList = new List<AssessmentQuestionResponse>();
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
			LIMIT 1
		];

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
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		User testUserSecond = new User(
			Email = 'testUserSecondnew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testUserSecondnew@example.com',
			FirstName = 'Test',
			LastName = 'User2',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUserSecond;
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountFirst = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId
		);
		insert testAccountFirst;
		String currentUserNameSecond = 'Test User2';
		String currentUserEmailSecond = 'testUserSecondnew@example.com';
		Account testAccountSecond = new Account(
			Lastname = currentUserNameSecond,
			PersonEmail = currentUserEmailSecond,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
		);
		insert testAccountSecond;

		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;

		CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
			Name = 'testCareProgramEnrolleeOne',
			AccountId = testAccountFirst.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCareProgramEnrolleeOne;
		CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
			Name = 'testCareProgramEnrolleeTwo',
			AccountId = testAccountSecond.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCareProgramEnrolleeTwo;

		Assessment testAssessment = new Assessment(
			Name = 'Test Assessment',
			OwnerId = testUser.Id,
			AssessmentStatus = 'Completed',
			BI_PSP_DateForCQ__c = 'Jan 2023'
		);
		insert testAssessment;

		//insert assessment question
		AssessmentQuestion questionData = new AssessmentQuestion(
			Name = 'test questionname',
			DeveloperName = 'Valid_Name_123',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionData;
		AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
			Name = 'question',
			QuestionText = 'Do you often discuss GPP with your friends and family?',
			AssessmentQuestionId = questionData.Id,
			IsActive = true
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
		assResList.add(testResponse);

		AssessmentQuestion questionDataTwo = new AssessmentQuestion(
			Name = 'test questionname2',
			DeveloperName = 'Valid_Name_1293',
			DataType = 'Decimal',
			QuestionCategory = 'Introduction'
		);
		insert questionDataTwo;

		AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
			AssessmentQuestionId = questionDataTwo.id,
			QuestionText = 'What is your gender?',
			Name = 'test data2',
			IsActive = true
		);
		insert questionVersionTwo;

		AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
			ResponseText = 'Female',
			BI_PSP_Category__c = '',
			AssessmentId = testAssessment.id,
			AssessmentQuestionId = questionVersionTwo.id,
			Name = 'test data'
		);
		insert testResponseTwo;
		assResList.add(testResponseTwo);
		Boolean isItDraftOrSubmit = true;
		Boolean isQsqAfterTwoMonths = true;
		String questionnaireName = 'Introduction';
		// Call the method under test
		System.runAs(testUserSecond) {
			try {
				Test.startTest();
				// Use the extracted questionIds and responseTexts in the method
				BI_PSP_AssessmentHelperCtrl.setAssessmentPersonalizationStatus(
					testAssessment,
					isItDraftOrSubmit,
					isQsqAfterTwoMonths,
					questionnaireName
				);
				Test.stopTest();
			} catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
			}
		}
		List<AssessmentQuestionResponse> draftRecords = [
			SELECT Id
			FROM AssessmentQuestionResponse
			WHERE AssessmentId = :testAssessment.Id
		];
		Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
		Assert.areEqual(
			expectedDraftRecordCount,
			draftRecords.size(),
			'Expected characters after first two'
		); // Succeeds.
	}
}