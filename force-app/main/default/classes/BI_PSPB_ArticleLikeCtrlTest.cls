/**
 * @description This class provides functionality to check, update, and insert user reactions (like or dislike) for articles.
 *
 * Version  Author          Date          Detail      Description
 * 1.0      Angelin Irin    26-Jul-2024   Created     Initial development
 * 1.1      Angelin Irin    28-Jul-2024   Updated     Updated checkReaction and updateReaction test methods to retrieve the reaction (like or dislike)
 *                                                    and update an existing reaction or insert a new reaction.
 */

@isTest
private class BI_PSPB_ArticleLikeCtrlTest {

	public static User portalAccountOwner;
	public static User patientUser;

	static {
		UserRole portalRole = [
			SELECT Id
			FROM UserRole
			WHERE PortalType = 'None'
			LIMIT 1
		];

		Profile profile1 = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
		];

		portalAccountOwner = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test20@test.com',
			Alias = 'batman',
			Email = 'bruceaction3.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction3',
			LastName = 'Wayneaction3',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner;
		System.runAs(portalAccountOwner) {
		// Retrieve the Record Type ID for Person Accounts
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Account' AND Name = 'Person Account'
			LIMIT 1
		];

		// Create Person Account
		Account account = new Account(
			FirstName = 'Bruceaction23',
			LastName = 'Wayneaction3',
			PersonEmail = 'bruceaction3.wayne@wayneenterprises.com',
			OwnerId = portalAccountOwner.Id,
			RecordTypeId = personAccountRecordType.Id
		);

		insert account;

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
			WHERE AccountId = :account.Id
			LIMIT 1
		];
		patientUser = new User(
			Username = System.now().millisecond() + 'test12345@test.com',
			ContactId = personContact.Id,
			ProfileId = portalProfile.Id,
			Alias = 'test123',
			Email = 'test12345@test.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Account',
			FirstName = 'Test',
			CommunityNickname = 'test12345',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US'
		);

		insert patientUser;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Enrollee'
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
			AccountId = account.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCareProgram.Id
		);
		insert testCareProgramEnrollee;
		}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class
	*  when checking the reaction of an article for a user. It creates test data
	*  including a test user, a Person Account, a Care Program, and a Care Program Enrollee,
	*  and tests the checkReaction method to ensure it correctly identifies the reaction
	*  as 'Dislike' for a specified article.
	*/

	@isTest(SeeAllData=false)
	static void testRetrieveLike() {
		System.runAs(portalAccountOwner) {
		try {
			// Create test data
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'PSPB'
			);
			insert settings;
			String articleName = 'None';
			// Call the method being tested
			Test.startTest();
			System.runAs(patientUser) {
				String result = BI_PSPB_ArticleLikeCtrl.checkReaction(
					articleName
				);
				BI_PSPB_ArticleLikeCtrl.updateReaction('', '');
				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should be Dislike');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class
	 * when a user with no existing reaction attempts to retrieve and update the reaction
	 * to an article titled 'What is Gpp?'. It creates test data including a test user,
	 * a Person Account, a Care Program, and a Care Program Enrollee, and tests the
	 * checkReaction method to ensure it correctly identifies the reaction as 'Dislike'.
	 */
	@isTest(SeeAllData=false)
	static void testRetrieveLikeNullUser() {
	System.runAs(portalAccountOwner) {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
			String articleName = 'What is Gpp?';
			// Call the method being tested
			Test.startTest();
			System.runAs(patientUser) {
				String result = BI_PSPB_ArticleLikeCtrl.checkReaction(
					articleName
				);
				BI_PSPB_ArticleLikeCtrl.updateReaction(articleName, 'Like');
				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should be Dislike');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class
	 * when an empty article name is provided. It creates test data including a test user
	 * and tests the checkReaction method to ensure it correctly identifies the reaction as 'Dislike'.
	 */
	@isTest(SeeAllData=false)
	static void testCheckReactionEmptyArticle() {
	System.runAs(portalAccountOwner) {

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Call the method being tested
			Test.startTest();
			System.runAs(portalAccountOwner) {
				String result = BI_PSPB_ArticleLikeCtrl.checkReaction('  ');
				Test.stopTest();

				// Assert the results
				Assert.areEqual('Dislike', result, 'Result should be Dislike');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class
	 * when a user with an 'Acute' status attempts to retrieve and update the reaction
	 * to an article titled 'What is GPP?'. It creates test data including a test user,
	 * a Person Account, a Care Program, a Care Program Enrollee, and a BI_PSPB_Article_like__c record,
	 * and tests the checkReaction method to ensure it correctly identifies the reaction.
	 */
	@isTest
	static void testRetrieveLikeAcute() {
	System.runAs(portalAccountOwner) {

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
			Profile p = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			// Create test data for the scenario where BI_PSPB_Caregiver__c is false
			Account testAccountOne = new Account(
				Lastname = 'TestAccount1',
				PersonEmail = 'testusertamil123@example.com',
				RecordTypeId = personAccountRecordTypeId,
				OwnerId = portalAccountOwner.Id
			);
			insert testAccountOne;

			Contact con = new Contact(
				LastName = 'TestAccount1',
				Email = 'testusertamil1237@example.com'
			);
			insert con;
			Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];

			User testUser = new User(
				ProfileId = p.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil123@example.com',
				UserName = 'testusertamil123@example.com',
				Alias = 'tuser',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ContactId = personContact.Id,
				CommunityNickname = 'test1'
			);
			insert testUser;

			CareProgram testCareProgram = new CareProgram(
				Name = 'TestCareProgram',
				StartDate = Date.today()
			);
			insert testCareProgram;
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccountOne.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Acute'
			);
			insert testEnrolleeOne;

			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				Name = 'Testreaction',
				BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
				BI_PSPB_Reaction__c = 'View',
				BI_PSPB_Article_name__c = 'What is GPP?'
			);
			insert likeReact;

			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_ArticleLikeCtrl.checkReaction(
					'What is GPP?'
				);
				BI_PSPB_ArticleLikeCtrl.updateReaction('What is GPP?', 'Like');
				Test.stopTest();

				// Assertions
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class
	 * when a user with an 'Acute' status attempts to delete a 'Like' reaction for an article
	 * titled 'What is GPP?'. It creates test data including a test user, a Person Account,
	 * a Care Program, a Care Program Enrollee, and a BI_PSPB_Article_like__c record,
	 * and tests the updateReaction method to ensure the reaction is not deleted.
	 */
	@isTest
	static void testWithAcuteReactionDelete() {
	System.runAs(portalAccountOwner) {

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create test data
			Profile p = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];

			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			// Create test data for the scenario where BI_PSPB_Caregiver__c is false
			Account testAccountOne = new Account(
				Lastname = 'TestAccount1',
				PersonEmail = 'testusertamil1237@example.com',
				RecordTypeId = personAccountRecordTypeId,
				OwnerId = portalAccountOwner.Id
			);
			insert testAccountOne;
			Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];

			User testUser = new User(
				ProfileId = p.Id,
				LastName = 'TestAccount1',
				Email = 'testusertamil1237@example.com',
				UserName = 'testusertamil1237@example.com',
				Alias = 'tuser',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ContactId = personContact.Id
			);
			insert testUser;

			CareProgram testCareProgram = new CareProgram(
				Name = 'TestCareProgram',
				StartDate = Date.today()
			);
			insert testCareProgram;
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccountOne.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Acute'
			);
			insert testEnrolleeOne;

			BI_PSPB_Article_like__c viewReact = new BI_PSPB_Article_like__c(
				Name = 'View Reaction',
				BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
				BI_PSPB_Reaction__c = 'View',
				BI_PSPB_Article_name__c = 'Flares Article'
			);
			insert viewReact;

			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				Name = 'Like Reaction',
				BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
				BI_PSPB_Reaction__c = 'Like',
				BI_PSPB_Article_name__c = 'Flares Article'
			);
			insert likeReact;
			// Call the method to be tested
			Test.startTest();
			System.runAs(testUser) {
				String result = BI_PSPB_ArticleLikeCtrl.checkReaction(
					'Flares Article'
				);
				BI_PSPB_ArticleLikeCtrl.updateReaction(
					'Flares Article',
					'Dislike'
				);
				Test.stopTest();
				// Assertions
				Assert.areNotEqual(null, result, 'Result should not be null');
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class in 
	 * scenarios where the user dislikes an article reaction and the associated reaction 
	 * record is deleted. It tests the deletion of the reaction record when the user's reaction to 
	 * the article is changed to 'Dislike'.
	 */
	@isTest
	static void testDislikeReactionDelete() {
	System.runAs(portalAccountOwner) {

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// Create a test user
			Profile p = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			// Create test data for the scenario where BI_PSPB_Caregiver__c is false
			Account testAccountOne = new Account(
				Lastname = 'TestLikeuser',
				PersonEmail = 'testusertamil1237@example.com',
				RecordTypeId = personAccountRecordTypeId,
				OwnerId = portalAccountOwner.Id
			);
			insert testAccountOne;
			Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];
			User testUser = new User(
				ProfileId = p.Id,
				LastName = 'TestLikeuser',
				Email = 'testusertamil1237@example.com',
				UserName = 'testusertamil1237@example.com',
				Alias = 'tuser',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ContactId = personContact.Id
			);
			insert testUser;


			CareProgram testCareProgram = new CareProgram(
				Name = 'TestCareProgram',
				StartDate = Date.today()
			);
			insert testCareProgram;
			CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
				Name = 'TestCpa1',
				AccountId = testAccountOne.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSPB_PatientStatus__c = 'Chronic'
			);
			insert testEnrolleeOne;
			BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
				BI_PSPB_Reaction__c = 'Like',
				BI_PSPB_Article_name__c = 'articletest'
			);
			insert likeReact;

			// Call the method to be tested
			System.runAs(testUser) {
				Test.startTest();
				BI_PSPB_ArticleLikeCtrl.updateReaction(
					'articletest',
					'articletest'
				);
				Test.stopTest();
			}
			// Add more assertions based on the expected behavior of your method
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class when the 
	 * user changes their reaction to an article titled 'Manage flares' from 'Like' to 'Dislike'. 
	 * It tests the update of the reaction record to 'Dislike' and verifies that the record is deleted.
	 */
	@isTest
	static void testDislikeReaction() {
	System.runAs(portalAccountOwner) {

		// Create test data for BI_SFCOE_LOG_App_Settings__c
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		// Create a test user
		Profile p = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		// Create test Account and CareProgramEnrollee records
		Account testAccountOne = new Account(
			LastName = 'TestAccount1',
			PersonEmail = 'testusertamil1237@example.com',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId(),
				OwnerId = portalAccountOwner.Id
		);
		insert testAccountOne;
		Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];

		User testUser = new User(
			ProfileId = p.Id,
			LastName = 'TestAccount1',
			Email = 'testusertamil1237@example.com',
			UserName = 'testusertamil1237@example.com',
			Alias = 'tuser',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ContactId = personContact.Id
		);
		
		insert testUser;

		CareProgram testCareProgram = new CareProgram(
			Name = 'TestCareProgram',
			StartDate = Date.today()
		);
		insert testCareProgram;

		CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
			Name = 'TestCpa1',
			AccountId = testAccountOne.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSPB_PatientStatus__c = 'Acute'
		);
		insert testEnrolleeOne;

		// Insert a BI_PSPB_Article_like__c record
		BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
			BI_PSPB_Reaction__c = 'Dislike', // Initially set to Like for testing update
			BI_PSPB_Article_name__c = 'Manage flares',
			BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
			Name = 'testlikereaction'
		);
		insert likeReact;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'Manage flares';
			String reactionLike = 'Like';
			BI_PSPB_ArticleLikeCtrl.updateReaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areNotEqual(
			0,
			deletedRecords.size(),
			'Record should be deleted'
		);
	}
	}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class when a 
	 * caregiver user attempts to update the reaction to an article titled 'Manage flares' from 'Like' to 
	 * 'Dislike'. It inserts a BI_PSPB_Article_like__c record initially set to 'Like' and attempts to 
	 * update the reaction to 'Dislike'. Since the user is a caregiver, the update operation should not 
	 * be allowed, and the record should not be deleted.
	 */
	@isTest
	static void testDislikeReactionCaregiver() {
	System.runAs(portalAccountOwner) {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];

		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountOne;
		Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];

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
			LanguageLocaleKey = 'en_US',
			ContactId = personContact.Id
		);
		insert testUser;

		String currentUserNameTwo = 'Test User2';
		String currentUserEmailTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmailTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountTwo;
		Contact personContact2= [SELECT Id FROM Contact WHERE AccountId = :testAccountTwo.Id LIMIT 1];

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
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
			ContactId = personContact2.Id
		);
		insert testUserTwo;

		CareProgram careProgramRecord = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert careProgramRecord;

		CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeOne;
		CareProgramEnrollee testEnrolleeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountTwo.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeTwo;

		// Insert a BI_PSPB_Article_like__c record
		BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
			BI_PSPB_Reaction__c = 'Dislike', // Initially set to Like for testing update
			BI_PSPB_Article_name__c = 'Manage flares',
			BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
			Name = 'testlikereaction',
			ownerId = testUserTwo.Id
		);
		insert likeReact;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'Manage flares';
			String reactionLike = 'Like';
			BI_PSPB_ArticleLikeCtrl.updateReaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areNotEqual(
			0,
			deletedRecords.size(),
			'Record should not be deleted'
		);
	}
	}
	/**
	 * @description 
	 * This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class when a caregiver 
	 * user attempts to update the reaction to an article titled 'What is GPP?' from 'Like' to 'Dislike'. 
	 * It inserts a BI_PSPB_Article_like__c record initially set to 'Like' and attempts to update the 
	 * reaction to 'Dislike'. Since the user is a caregiver, the update operation should not be allowed, 
	 * and the record should not be deleted.
	 */
	@isTest
	static void testLikeReactionCaregiver() {
	System.runAs(portalAccountOwner){
		// Create a test user
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
			.get('PersonAccount')
			.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountOne;
		Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];


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
			LanguageLocaleKey = 'en_US',
			ContactId = personContact.Id
		);
		insert testUser;

		String currentUserNameTwo = 'Test User2';
		String currentUserEmailTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmailTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountTwo;
		Contact personContact2 = [SELECT Id FROM Contact WHERE AccountId = :testAccountTwo.Id LIMIT 1];
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
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
			ContactId = personContact2.Id
		);
		insert testUserTwo;

		CareProgram careProgramRecord = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert careProgramRecord;

		CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeOne;
		CareProgramEnrollee testEnrolleeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountTwo.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeTwo;



		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			// Insert a BI_PSPB_Article_like__c record
				BI_PSPB_Article_like__c likeReact = new BI_PSPB_Article_like__c(
				BI_PSPB_Reaction__c = 'Like', // Initially set to Like for testing update
				BI_PSPB_Article_name__c = 'What is GPP?',
				BI_PSPB_CareProgramEnrollee__c = testEnrolleeOne.Id,
				Name = 'testlikereaction'
			);
			insert likeReact;
			Test.startTest();
			String articleName = 'What is GPP?';
			String reactionLike = 'Dislike';
			BI_PSPB_ArticleLikeCtrl.updateReaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areEqual(0, deletedRecords.size(), 'Record should be deleted');
	
	}
}
	/**
	 * @description This test method verifies the behavior of the BI_PSPB_ArticleLikeCtrl class when 
	 * a caregiver user attempts to update the reaction to an article titled 'Manage flares' from 'Like'
	 * to 'Dislike'. It inserts a BI_PSPB_Article_like__c record initially set to 'Like' and attempts to 
	 * update the reaction to 'Dislike'. Since the user is a caregiver, the update operation 
	 * should not be allowed, and the record should not be deleted.
	 */
	@isTest
	static void testViewReactionCaregiver() {
	System.runAs(portalAccountOwner){
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String currentUserName = 'Test User';
		String currentUserEmail = 'testusernew@example.com';
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'BI_PSP_Patient Profile'
			LIMIT 1
		];
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('PersonAccount')
		.getRecordTypeId();

		Account testAccountOne = new Account(
			Lastname = currentUserName,
			PersonEmail = currentUserEmail,
			RecordTypeId = personAccountRecordTypeId,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountOne;
		Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccountOne.Id LIMIT 1];

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
			LanguageLocaleKey = 'en_US',
			ContactId = personContact.Id
		);
		insert testUser;

		String currentUserNameTwo = 'Test User2';
		String currentUserEmailTwo = 'testuser2new@example.com';
		Account testAccountTwo = new Account(
			Lastname = currentUserNameTwo,
			PersonEmail = currentUserEmailTwo,
			RecordTypeId = personAccountRecordTypeId,
			BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id,
			OwnerId = portalAccountOwner.Id
		);
		insert testAccountTwo;
		Contact personContactTwo = [SELECT Id FROM Contact WHERE AccountId = :testAccountTwo.Id LIMIT 1];

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
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US',
			ContactId = personContactTwo.Id
		);
		insert testUserTwo;
		
		CareProgram careProgramRecord = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert careProgramRecord;

		CareProgramEnrollee testEnrolleeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = testAccountOne.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeOne;
		CareProgramEnrollee testEnrolleeTwo = new CareProgramEnrollee(
			Name = 'TestCpa222',
			AccountId = testAccountTwo.Id,
			CareProgramId = careProgramRecord.Id
		);
		insert testEnrolleeTwo;

		// Call the method to be tested - updating reaction to Dislike
		System.runAs(testUser) {
			Test.startTest();
			String articleName = 'Manage flares';
			String reactionLike = 'View';
			BI_PSPB_ArticleLikeCtrl.updateReaction(articleName, reactionLike);
			Test.stopTest();
		}

		// Verify that the record is deleted
		List<BI_PSPB_Article_like__c> deletedRecords = [
			SELECT Id
			FROM BI_PSPB_Article_like__c
			WHERE BI_PSPB_Article_name__c = 'Manage flares'
		];
		Assert.areEqual(
			1,
			deletedRecords.size(),
			'Record should not be deleted'
		);
	}
	}
}