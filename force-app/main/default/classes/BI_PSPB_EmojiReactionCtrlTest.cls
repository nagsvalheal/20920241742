/**
@description	This class contains test methods to verify the functionality of 
				methods related to reacting to the posts  and fetching reactions 
				with valid and invalid inputs.
@author					Deepa
@Last Modified On   	05/28/2024
@Last Modified By 		Deepa
*/
@isTest
public class BI_PSPB_EmojiReactionCtrlTest {
	// Test data Variables.
	public static User userPatientTest;
	public static User userPatient;
	public static User userWithoutEnrollee;
	public static Account account;
	public static Account accountWithoutCommunityUsername;
	public static CareProgramEnrollee testCareProgramEnrolle;
	public static CareProgramEnrollee testCareProgramEnrolleWithoutCommunityName;

	static {
		List<User> testUsers = new List<User>();
		List<Account> testAccounts = new List<Account>();
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

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'emojitestUser@gmail.com',
			Alias = 'emojis',
			Email = 'emojitestUser@gmail.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'emoji',
			LastName = 'user',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);
		insert portalAccountOwner1;
		System.runAs(portalAccountOwner1) {
			account = new Account(
				FirstName = 'TestPatientEmoji',
				LastName = 'PatientLastNameEmoji',
				PersonEmail = 'testpatientemoji@gmail.com',
				RecordTypeId = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account' AND Name = 'Person Account'
				]
				.Id,
				OwnerId = portalAccountOwner1.Id,
				Phone = '123456789'
			);
			accountWithoutCommunityUsername = new Account(
				FirstName = 'TestCaregiverUseremoji',
				LastName = 'CaregiverLastNameemoji',
				PersonEmail = 'testcaregiveremoji@gmail.com',
				RecordTypeId = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account' AND Name = 'Person Account'
				]
				.Id,
				OwnerId = portalAccountOwner1.Id,
				Phone = '12345678976'
			);

			testAccounts.add(account);
			testAccounts.add(accountWithoutCommunityUsername);
			// Creating all accounts.
			insert testAccounts;

			// User as a patient.
			userPatient = new User(
				FirstName = 'TestPatientEmoji',
				LastName = 'PatientLastNameEmoji',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :account.Id
					LIMIT 1
				]
				.Id,
				Email = 'testpatientemoji@gmail.com',
				Username = 'testpatientemoji@gmail.com',
				BI_PSPB_Caregiver__c = false,
				Alias = 'emoj32',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ProfileId = [
					SELECT Id
					FROM Profile
					WHERE Name = 'BI_PSP_Patient Profile'
					LIMIT 1
				]
				.Id
			);
			// User as a caregiver.
			userPatientTest = new User(
				FirstName = 'TestCaregiverUseremojis',
				LastName = 'CaregiverLastNameemojis',
				Email = 'testcaregiveremojis@gmail.com',
				Username = 'testcaregiveremojis@gmail.com',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :accountWithoutCommunityUsername.Id
					LIMIT 1
				]
				.Id,
				BI_PSPB_Caregiver__c = false,
				Alias = 'emoji45',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ProfileId = [
					SELECT Id
					FROM Profile
					WHERE Name = 'BI_PSP_Patient Profile'
					LIMIT 1
				]
				.Id
			);
			// User as a caregiver without account.
			userWithoutEnrollee = new User(
				FirstName = 'TestUserPatientemojj',
				LastName = 'WithoutAccountemojj',
				Email = 'testuserwithoutaccountemojj@gmail.com',
				Username = 'testuserwithoutaccountemojj@gmail.com',
				BI_PSPB_Caregiver__c = true,
				Alias = 'emoji12',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey = 'America/Los_Angeles',
				ProfileId = UserInfo.getProfileId()
			);
			testUsers.add(userPatientTest);
			testUsers.add(userPatient);
			testUsers.add(userWithoutEnrollee);
			// Creating all users.
			insert testUsers;

			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program',
				StartDate = Date.today()
			);
			insert testCareProgram;

			testCareProgramEnrolle = new CareProgramEnrollee(
				AccountId = account.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSP_CommunityUsername__c = 'patientemoji',
				BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
				Name = 'TestPatientFeed PatientLastName'
			);
			insert testCareProgramEnrolle;

			testCareProgramEnrolleWithoutCommunityName = new CareProgramEnrollee(
				AccountId = accountWithoutCommunityUsername.Id,
				BI_PSP_CommunityUsername__c = '',
				CareProgramId = testCareProgram.Id,
				BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
				Name = 'TestCaregiverUser CaregiverLastName'
			);
			insert testCareProgramEnrolleWithoutCommunityName;
		}
	}
	/**
	* @description Test method to verify the behavior of saving emoji
	with valid input.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmoji() {
		System.runAs(userPatient) {
			// Creating post without reaction.
			BI_PSP_FeedItem__c feedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category'
			);
			insert feedItem;
			// Creating reactions for the above post.
			BI_PSP_EmojiReactionController__c testEmoji = new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',
				BI_PSP_FeedItem__c = feedItem.Id,
				BI_PSP_CareProgramEnrolleeEmoji__c = testCareProgramEnrolle.Id
			);
			insert testEmoji;
			Test.startTest();
			BI_PSP_EmojiReactionController__c emojiResult = BI_PSPB_EmojiReactionCtrl.saveEmoji(
				'1',
				feedItem.Id
			);
			Test.stopTest();
			// Fetching list of reactions for that post after reacting.
			BI_PSP_EmojiReactionController__c expectedRecord = [
				SELECT
					Id,
					BI_PSP_ReactionResult__c,
					BI_PSP_FeedItem__c,
					BI_PSP_CareProgramEnrolleeEmoji__c
				FROM BI_PSP_EmojiReactionController__c
				WHERE
					BI_PSP_FeedItem__c = :feedItem.Id
					AND BI_PSP_CareProgramEnrolleeEmoji__c = :testCareProgramEnrolle.Id
			];
			// Checking for reactions that is updated.
			Assert.areEqual(
				expectedRecord.BI_PSP_ReactionResult__c,
				emojiResult.BI_PSP_ReactionResult__c,
				'Reactions updated for this post'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to cover exception.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiNullInput() {
		System.runAs(userPatient) {
			try {
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category'
				);
				insert testFeedItem;
				Test.startTest();
				BI_PSPB_EmojiReactionCtrl.saveEmoji(null, testFeedItem.Id);
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
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to cover exception.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiNullUser() {
		// Create a dummy user with no associated account
		User dummyUser = new User(
			FirstName = 'new',
			LastName = 'user',
			Username = 'testuserdummy@example.com',
			Alias = 'teuser',
			Email = 'testuserdummy@example.com',
			EmailEncodingKey = 'ISO-8859-1',
			LocaleSidKey = 'en_US',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			]
			.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LanguageLocaleKey = 'en_US'
		);
		insert dummyUser;
		System.runAs(dummyUser) {
			try {
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category'
				);
				insert testFeedItem;
				Test.startTest();
				BI_PSPB_EmojiReactionCtrl.saveEmoji(null, testFeedItem.Id);
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
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with invalid input to throw exception while reacting.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiInvalidInput() {
		System.runAs(userPatient) {
			try {
				// Creating post for reacting.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category'
				);
				insert testFeedItem;
				Test.startTest();
				BI_PSPB_EmojiReactionCtrl.saveEmoji(
					'Neededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexceptionNeededmorethan20characterstothrowexception',
					testFeedItem.Id
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
	/**
	* @description Test method to verify the behavior of the saveEmoji method
	with valid input to update the reaction over the existing reaction.
	* This method tests saving emoji reactions to posts.
	*/
	@isTest
	static void testSaveEmojiForExistingReaction() {
		System.runAs(userPatient) {
			// Creating post for reacting.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category'
			);
			insert testFeedItem;
			// Creating a reaction for the above post.
			BI_PSP_EmojiReactionController__c existingReaction = new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',
				BI_PSP_FeedItem__c = testFeedItem.Id,
				BI_PSP_CareProgramEnrolleeEmoji__c = testCareProgramEnrolle.Id
			);
			insert existingReaction;
			Test.startTest();
			// Method call to react for that post.
			BI_PSPB_EmojiReactionCtrl.saveEmoji('4', testFeedItem.Id);
			Test.stopTest();
			// Retrieving the updated existing reaction record.
			existingReaction = [
				SELECT Id, BI_PSP_ReactionResult__c
				FROM BI_PSP_EmojiReactionController__c
				WHERE Id = :existingReaction.Id
			];
			// Verify the emoji
			Assert.areequal(
				'4',
				existingReaction.BI_PSP_ReactionResult__c,
				'Existing reaction record is updated'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with valid and invalid input.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testGetReactionsByFeedItemId() {
		System.runAs(userPatient) {
			// Creating post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category'
			);
			insert testFeedItem;
			// Creating one reaction for the above post.
			BI_PSP_EmojiReactionController__c firstReaction = new BI_PSP_EmojiReactionController__c();
			firstReaction.BI_PSP_FeedItem__c = testFeedItem.Id;
			firstReaction.BI_PSP_ReactionResult__c = '3';
			firstReaction.BI_PSP_CareProgramEnrolleeEmoji__c = testCareProgramEnrolle.Id;
			insert firstReaction;
			// Creating another reaction for the above post.
			BI_PSP_EmojiReactionController__c secondReaction = new BI_PSP_EmojiReactionController__c();
			secondReaction.BI_PSP_FeedItem__c = testFeedItem.Id;
			secondReaction.BI_PSP_ReactionResult__c = '3';
			secondReaction.BI_PSP_CareProgramEnrolleeEmoji__c = testCareProgramEnrolleWithoutCommunityName.Id;
			insert secondReaction;
			Test.startTest();
			// Method call for fetching reactions with valid input.
			String emojiResult = BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
				testFeedItem.Id
			);
			Test.stopTest();
			// Checking for the reactions for that post.
			Assert.areNotequal(
				null,
				emojiResult,
				'The reaction emoji should not contain null'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with invalid input as user without account.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testGetReactionsForUserWithoutAccount() {
		System.runAs(userWithoutEnrollee) {
			try {
				// Creating post.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category'
				);
				insert testFeedItem;
				Test.startTest();
				// Method call for fetching reactions with valid input.
				BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(
					testFeedItem.Id
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
	/**
	* @description Test method to verify the behavior of the 
	getReactionsByFeedItemId method with invalid input as null value.
	* This method tests the retrieval of emoji reactions by feed item ID.
	*/
	@isTest
	static void testGetReactionNullInput() {
		System.runAs(userPatient) {
			try {
				// Creating post.
				BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category'
				);
				insert testFeedItem;
				Test.startTest();
				// Method call for fetching reactions with valid input.
				BI_PSPB_EmojiReactionCtrl.getReactionsByFeedItemId(null);
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
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with valid and invalid inputs.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReaction() {
		System.runAs(userPatient) {
			// Creating post.
			BI_PSP_FeedItem__c postRecord = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase1',
				BI_PSP_Category__c = 'Test Category1'
			);
			insert postRecord;
			// Creating reaction for that post.
			BI_PSP_EmojiReactionController__c firstReaction = new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',
				BI_PSP_FeedItem__c = postRecord.Id,
				BI_PSP_CareProgramEnrolleeEmoji__c = testCareProgramEnrolle.Id
			);
			insert firstReaction;
			Test.startTest();
			// Method call with valid input.
			BI_PSPB_EmojiReactionCtrl.deleteemojireaction(postRecord.Id);
			Test.stopTest();
			// Fetching reaction to check that is deleted or not.
			List<BI_PSP_EmojiReactionController__c> reactionDeleted = [
				SELECT Id
				FROM BI_PSP_EmojiReactionController__c
				WHERE
					BI_PSP_FeedItem__c = :postRecord.Id
					AND BI_PSP_CareProgramEnrolleeEmoji__c = :testCareProgramEnrolle.Id
			];
			// Checking for the reaction that is deleted.
			Assert.areequal(
				0,
				reactionDeleted.size(),
				'The emoji reaction is deleted.'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with invalid input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionInvalidInput() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Method call with invalid input.
				BI_PSPB_EmojiReactionCtrl.deleteemojireaction(
					'invalid feed ID'
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
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with null value as input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionNullInputValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Method call with null value as input.
				BI_PSPB_EmojiReactionCtrl.deleteemojireaction(null);
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
	/**
	* @description Test method to verify the behavior of the 
	deleteemojireaction method with invalid input.
	* This method tests deletion of emoji reactions by feed item ID.
	*/
	@isTest
	static void testDeleteEmojiReactionForUserWithoutAccount() {
		System.runAs(userWithoutEnrollee) {
			try {
				Test.startTest();
				// Method call with invalid input.
				BI_PSPB_EmojiReactionCtrl.deleteemojireaction(
					'invalid feed ID'
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
	/**
	* @description Test method to verify the behavior of the 
	totalReactionsByType method with valid inputs.
	* This method tests the retrieval of total  reactions for a post.
	*/
	@isTest
	static void testTotalReactionsByType() {
		System.runAs(userPatient) {
			// Creating post.
			BI_PSP_FeedItem__c testFeedItem = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category'
			);
			insert testFeedItem;
			// Creating a reaction with thumbs up for the above post.
			BI_PSP_EmojiReactionController__c thumbsUpReaction = new BI_PSP_EmojiReactionController__c(
				BI_PSP_ReactionResult__c = '1',
				BI_PSP_FeedItem__c = testFeedItem.Id
			);
			insert thumbsUpReaction;
			Test.startTest();
			List<BI_PSP_EmojiReactionController__c> totalReactionRecords = BI_PSPB_EmojiReactionCtrl.totalReactionsByType(
				testFeedItem.Id,
				'1'
			);
			Test.stopTest();
			// Fetching reactions for that post.
			List<BI_PSP_EmojiReactionController__c> reactionAfterReacting = [
				SELECT Id
				FROM BI_PSP_EmojiReactionController__c
				WHERE
					BI_PSP_FeedItem__c = :testFeedItem.Id
					AND BI_PSP_ReactionResult__c = '1'
					AND BI_PSP_AccountE__c != NULL
			];
			// Checking for number of reactions for that post.
			Assert.areequal(
				reactionAfterReacting.size(),
				totalReactionRecords.size(),
				'There should be one thumbs up reaction.'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	totalThumbsUp method with invalid input.
	* This method tests the retrieval of total thumbs-up reactions for a post.
	*/
	@isTest
	static void testTotalReactionsByTypeInvalid() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Method call with null value as input.
				BI_PSPB_EmojiReactionCtrl.totalReactionsByType(null, null);
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
	/**
	* @description Test method to verify the following status of two different 
	account with valid input.
	*/
	@isTest
	static void testCheckFollowingStatus() {
		System.runAs(userPatient) {
			// Creating post.
			BI_PSP_FeedFollow__c followRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
				BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id
			);
			insert followRecord;
			Test.startTest();
			// Method call to check following status.
			List<BI_PSP_FeedFollow__c> emoji = BI_PSPB_EmojiReactionCtrl.checkFollowingStatus(
				testCareProgramEnrolle.Id,
				testCareProgramEnrolleWithoutCommunityName.Id
			);
			// Fetching follow status.
			List<BI_PSP_FeedFollow__c> feedFollowRecords = [
				SELECT
					Id,
					BI_PSP_CareProgramEnrolleeAccount__c,
					BI_PSP_AccountUser__c,
					BI_PSP_Type__c
				FROM BI_PSP_FeedFollow__c
				WHERE
					BI_PSP_CareProgramEnrolleeAccount__c = :testCareProgramEnrolle.Id
					AND BI_PSP_CareProgramEnrolleeFollow__c = :testCareProgramEnrolleWithoutCommunityName.Id
					AND BI_PSP_Type__c = 'Following'
			];
			// Checking for follow records.
			Assert.areEqual(
				feedFollowRecords,
				emoji,
				'Expected following records are found'
			);
		}
	}
	/**
	* @description Test method to verify the following status of two different 
	account with invalid input.
	*/
	@isTest
	static void testCheckFollowingStatusNullInput() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Method call to check following status with null parameter.
				BI_PSPB_EmojiReactionCtrl.checkFollowingStatus(null, null);
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
}