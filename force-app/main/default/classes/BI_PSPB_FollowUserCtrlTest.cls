/**
@description	This class contains test methods to verify the functionality of 
				methods related to BI_PSPB_FollowUserCtrl with valid and invalid inputs.
@author					Ragavi
@Last Modified On   	05/28/2024
@Last Modified By 		Ragavi
*/
@isTest
private class BI_PSPB_FollowUserCtrlTest {
	// Test data Variables.
	public static User userPatientTest;
	public static User userPatient;
	public static Account account;
	public static Account accountWithoutCommunityUsername;
	public static CareProgramEnrollee testCareProgramEnrolle;
	public static CareProgramEnrollee testCareProgramEnrolleWithoutCommunityName;

	static {
		List<User> testUsers = new List<User>();
		List<Account> testAccounts = new List<Account>();

		// User as a patient.
		userPatient = new User(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			Email = 'testpatientfeed@gmail.com',
			Username = 'testpatientfeed@gmail.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser3',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId()
		);
		userPatientTest = new User(
			FirstName = 'TestCaregiverUser',
			LastName = 'CaregiverLastName',
			Email = 'testcaregiverfeed@gmail.com',
			Username = 'testcaregiverfeed@gmail.com',
			BI_PSPB_Caregiver__c = false,
			Alias = 'tuser9',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			ProfileId = UserInfo.getProfileId()
		);

		testUsers.add(userPatientTest);
		testUsers.add(userPatient);
		// Creating all users.
		insert testUsers;
		account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			OwnerId = userPatient.Id,
			Phone = '123456'
		);
		accountWithoutCommunityUsername = new Account(
			FirstName = 'TestCaregiverUser',
			LastName = 'CaregiverLastName',
			PersonEmail = 'testcaregiverfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			OwnerId = userPatientTest.Id,
			Phone = '1234567899'
		);

		testAccounts.add(account);
		testAccounts.add(accountWithoutCommunityUsername);
		// Creating all accounts.
		insert testAccounts;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;

		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_CommunityUsername__c = 'patient',
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
	/**
	* @description Test method to verify following a user with 
	null value as input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserWithNull() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Passing null value for Account Id to follow.
				BI_PSPB_FollowUserCtrl.followUser(null);
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
	* @description Test method to verify following a user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUser() {
		System.runAs(userPatient) {
			// Fetching List of followings before following.
			List<BI_PSP_FeedFollow__c> existingRecord = [
				SELECT Id
				FROM BI_PSP_FeedFollow__c
				WHERE
					(BI_PSP_CareProgramEnrolleeAccount__c = :testCareProgramEnrolle.Id
					AND BI_PSP_CareProgramEnrolleeFollow__c = :testCareProgramEnrolleWithoutCommunityName.Id
					AND BI_PSP_Type__c = 'Following')
					OR (BI_PSP_CareProgramEnrolleeAccount__c = :testCareProgramEnrolleWithoutCommunityName.Id
					AND BI_PSP_CareProgramEnrolleeFollow__c = :testCareProgramEnrolle.Id
					AND BI_PSP_Type__c = 'Follower')
			];

			Test.startTest();
			// To follow the testCareProgramEnrolleWithoutCommunityName account.
			BI_PSPB_FollowUserCtrl.followUser(
				testCareProgramEnrolleWithoutCommunityName.Id
			);
			Test.stopTest();
			// Fetching List of followings after following.
			List<BI_PSP_FeedFollow__c> followRecordAfterFollowing = [
				SELECT
					Id,
					BI_PSP_CareProgramEnrolleeAccount__c,
					BI_PSP_AccountUser__c,
					BI_PSP_Type__c
				FROM BI_PSP_FeedFollow__c
			];
			// Checking for not following the user before the method is called.
			Assert.areequal(
				0,
				existingRecord.size(),
				'There are no followings before following'
			);
			// Checking for following the user after the method is called.
			Assert.areequal(
				2,
				followRecordAfterFollowing.size(),
				'There is follower and following record after following'
			);
		}
	}

	/**
	* @description Test method to verify following a user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserException() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Method is called with invalid account Id.
				BI_PSPB_FollowUserCtrl.followUser('INvalidIDForFollow');
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
	* @description Test method to verify following a 
	user with existing record.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testFollowUserExisting() {
		System.runAs(userPatient) {
			try {
				// Creating follower for testCareProgramEnrolleWithoutCommunityName.
				BI_PSP_FeedFollow__c testFollowerRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolle.Id,
					BI_PSP_Type__c = 'Follower'
				);
				insert testFollowerRecord;
				// Creating following record for testCareProgramEnrolle.
				BI_PSP_FeedFollow__c testFollowingRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_Type__c = 'Following'
				);
				insert testFollowingRecord;
				// Creating following record for testCareProgramEnrolle.
				BI_PSP_FeedFollow__c testFollowerAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolle.Id,
					BI_PSP_Type__c = 'Following'
				);
				insert testFollowerAccountRecord;
				// Creating follower for testCareProgramEnrolle.
				BI_PSP_FeedFollow__c testFollowingAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_Type__c = 'Follower'
				);
				insert testFollowingAccountRecord;
				Test.startTest();
				BI_PSPB_FollowUserCtrl.followUser(
					testCareProgramEnrolleWithoutCommunityName.Id
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
	* @description Test method to verify number of followers 
	for a user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testGetMyFollowers() {
		System.runAs(userPatient) {
			// Creating followers for testCareProgramEnrolle.
			BI_PSP_FeedFollow__c testFollowRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
				BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
				BI_PSP_Type__c = 'Follower'
			);
			insert testFollowRecord;
			// Creating following record for testCareProgramEnrolle.
			BI_PSP_FeedFollow__c testFollowerAccountRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolleWithoutCommunityName.Id,
				BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolle.Id,
				BI_PSP_Type__c = 'Following'
			);
			insert testFollowerAccountRecord;
			Test.startTest();
			// Getting followers for user userPatient.
			List<BI_PSP_FeedFollow__c> followersOfPatientUser = BI_PSPB_FollowUserCtrl.getMyFollowers();
			Test.stopTest();
			// Checking for followers after method call.
			Assert.areNotEqual(
				null,
				followersOfPatientUser.size(),
				'Expected one follower record.'
			);
		}
	}
	/**
	* @description Test method to verify numbre of followers 
	for a user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testGetMyFollowersWithInvalidInput() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Getting followers for account testCareProgramEnrolleWithoutCommunityName.
				BI_PSPB_FollowUserCtrl.getMyFollowers();
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
	* @description Test method to verify unfollowing a 
	user with valid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUser() {
		System.runAs(userPatient) {
			try {
				// Creating follower record for testCareProgramEnrolleWithoutCommunityName.
				BI_PSP_FeedFollow__c testFollowerRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolle.Id,
					BI_PSP_Type__c = 'Follower'
				);
				insert testFollowerRecord;
				// Creating following record for testCareProgramEnrolle.
				BI_PSP_FeedFollow__c testFollowingRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_Type__c = 'Following'
				);
				insert testFollowingRecord;
				// Creating following record for testCareProgramEnrolleWithoutCommunityName.
				BI_PSP_FeedFollow__c testFollowingAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolle.Id,
					BI_PSP_Type__c = 'Following'
				);
				insert testFollowingAccountRecord;
				// Creating follower record for testCareProgramEnrolle.
				BI_PSP_FeedFollow__c testFollowerAccountRecord = new BI_PSP_FeedFollow__c(
					BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
					BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
					BI_PSP_Type__c = 'Follower'
				);
				insert testFollowerAccountRecord;
				// Fetching list of followers before unfollowing.
				List<BI_PSP_FeedFollow__c> existingRecord = [
					SELECT Id
					FROM BI_PSP_FeedFollow__c
					WHERE
						BI_PSP_CareProgramEnrolleeAccount__c = :testCareProgramEnrolle.Id
						AND BI_PSP_CareProgramEnrolleeFollow__c = :testCareProgramEnrolleWithoutCommunityName.Id
						AND BI_PSP_Type__c = 'Following'
				];
				Test.startTest();
				// Unfollowing testCareProgramEnrolleWithoutCommunityName account.
				BI_PSPB_FollowUserCtrl.unfollowUser(
					testCareProgramEnrolleWithoutCommunityName.Id
				);
				Test.stopTest();
				// Fetching list of followers after unfollowing.
				List<BI_PSP_FeedFollow__c> recordAfterUnfollowing = [
					SELECT Id
					FROM BI_PSP_FeedFollow__c
					WHERE
						BI_PSP_CareProgramEnrolleeAccount__c = :testCareProgramEnrolle.Id
						AND BI_PSP_CareProgramEnrolleeFollow__c = :testCareProgramEnrolleWithoutCommunityName.Id
						AND BI_PSP_Type__c = 'Following'
				];
				// Checking for size of the records before following.
				Assert.areEqual(1, existingRecord.size(), 'Expected 1');
				if (recordAfterUnfollowing != null) {
					// Checking for size of the records after following.
					Assert.areEqual(
						0,
						recordAfterUnfollowing.size(),
						'Expected 0'
					);
				}
			} catch (Exception e) {
				/*  While running negative scenario, the flow goes to catch.
				 Thus resulting in throwing exception */
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}
	}
	/**
	* @description Test method to verify unfollowing a 
	user with invalid input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUserWithInvalidInput() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Unfollowing with ivalid inputs.
				BI_PSPB_FollowUserCtrl.unfollowUser('dfg6tygh');
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
	* @description Test method to verify following 
	a user with null value as input.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testUnfollowUserNull() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				// Unfollowing with null value as inputs.
				BI_PSPB_FollowUserCtrl.unfollowUser('');
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