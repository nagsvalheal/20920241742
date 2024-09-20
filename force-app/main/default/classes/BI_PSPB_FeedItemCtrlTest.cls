/**
    @description			This class contains test methods for various functionalities
                            related to feed items and comments(Insert,Update,Fetch).
	@author					Deepa
	@Last Modified On   	07/28/2024
	@Last Modified By 		Deepa
*/
@isTest
public class BI_PSPB_FeedItemCtrlTest {
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
			Username = System.now().millisecond() + 'feedst@test.com',
			Alias = 'batmah',
			Email = 'feeds.amel@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'feeds',
			LastName = 'amel',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);
		insert portalAccountOwner1;
		System.runAs(portalAccountOwner1) {
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
				OwnerId = portalAccountOwner1.Id,
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
				OwnerId = portalAccountOwner1.Id,
				Phone = '1234567899'
			);

			testAccounts.add(account);
			testAccounts.add(accountWithoutCommunityUsername);
			// Creating all accounts.
			insert testAccounts;

			// User as a patient.
			userPatient = new User(
				FirstName = 'TestPatientFeed',
				LastName = 'PatientLastName',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :account.Id
					LIMIT 1
				]
				.Id,
				Email = 'testpatientfeed@gmail.com',
				Username = 'testpatientfeed@gmail.com',
				BI_PSPB_Caregiver__c = false,
				Alias = 'tuser3',
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
				FirstName = 'TestCaregiverUser',
				LastName = 'CaregiverLastName',
				Email = 'testcaregiverfeed@gmail.com',
				Username = 'testcaregiverfeed@gmail.com',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :accountWithoutCommunityUsername.Id
					LIMIT 1
				]
				.Id,
				BI_PSPB_Caregiver__c = false,
				Alias = 'tuser9',
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
				FirstName = 'TestUserPatient',
				LastName = 'WithoutAccount',
				Email = 'testuserwithoutaccount@gmail.com',
				Username = 'testuserwithoutaccount@gmail.com',
				BI_PSPB_Caregiver__c = true,
				Alias = 'tuser10',
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
	}

	/**
	 * Test method for testing the soft deletion of a feed item.
	 * Verifies the behavior of the softDeleteFeedItem method in the controller class.
	 * Covers scenarios where  valid  feed item IDs are provided.
	 * @description Verifies the behavior of the softDeleteFeedItem method by
	 * testing its functionality with  valid  feed item IDs.
	 */
	@isTest
	static void testSoftDeleteFeedItemForPositiveScenario() {
		// Run the test as the userPatient.
		System.runAs(userPatient) {
			Test.startTest();
			// Create a test feed item.
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
			);
			insert testPost;
			// Call the method to soft delete the test feed item.
			BI_PSPB_FeedItemCtrl.softDeleteFeedItem(testPost.Id);

			Test.stopTest();
			// Check if the test feed item was soft deleted successfully.
			List<BI_PSP_FeedItem__c> deletedPost = [
				SELECT Id
				FROM BI_PSP_FeedItem__c
				WHERE Id = :testPost.Id AND BI_PSP_SoftDelete__c = 'Yes'
			];
			// Assert the results.
			Assert.areEqual(
				1,
				deletedPost.size(),
				'The feed item should be soft deleted.'
			);
		}
	}
	/**
	 * Test method for testing the soft deletion of a feed item.
	 * Verifies the behavior of the softDeleteFeedItem method in the controller class.
	 * Covers scenarios where   Null feed item IDs are provided.
	 * @description Verifies the behavior of the softDeleteFeedItem method by
	 * testing its functionality with  Null feed item IDs.
	 */
	@isTest
	static void testSoftDeleteFeedItemForNegativeScenario() {
		try {
			// Run the test as the userPatient.
			System.runAs(userPatient) {
				Test.startTest();
				// Call the method to soft delete test feed item and test various scenarios.
				BI_PSPB_FeedItemCtrl.softDeleteFeedItem(null);
				BI_PSPB_FeedItemCtrl.softDeleteFeedItem(
					'patientWithoutAccount.Id'
				);

				Test.stopTest();
			}
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
	/**
	 * Test method for testing the soft deletion of a feed item.
	 * Verifies the behavior of the softDeleteFeedItem method in the controller class.
	 * Covers scenarios where  invalid  feed item IDs are provided.
	 * @description Verifies the behavior of the softDeleteFeedItem method by
	 * testing its functionality with  invalid  feed item IDs.
	 */
	@isTest
	static void testSoftDeleteFeedItemForInvalidIds() {
		try {
			// Run the test as the userPatient.
			System.runAs(userPatient) {
				Test.startTest();
				// Call the method to soft delete test feed item and test various scenarios.
				BI_PSPB_FeedItemCtrl.softDeleteFeedItem(
					'patientWithoutAccount56789Id'
				);

				Test.stopTest();
			}
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
	/**
	 * Test method for testing the soft deletion of a feed item.
	 * Verifies the behavior of the softDeleteFeedItem method in the controller class.
	 * Covers scenarios where  invalid feed item IDs are provided.
	 * @description Verifies the behavior of the softDeleteFeedItem method by
	 * testing its functionality with  invalid feed item IDs.
	 */
	@isTest
	static void testSoftDeleteFeedItemToThrowException() {
		try {
			// Run the test as the userPatient.
			System.runAs(userPatient) {
				//create FeedItem.
				BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_Category__c = 'Test Category',
					BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_SoftDelete__c = ''
				);
				insert testPost;
				delete testPost;

				Test.startTest();
				// Call the method to soft delete test feed item.
				BI_PSPB_FeedItemCtrl.softDeleteFeedItem(testPost.Id);

				Test.stopTest();
			}
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
	/**
	 * Test method for inserting a new feed item.
	 * Verifies the behavior of the insertFeedItem method in the controller class.
	 * Covers scenarios with valid  input parameters.
	 * @description Tests the behavior of the insertFeedItem method by
	 * inserting a new feed item.
	 */
	@isTest
	static void testInsertFeedItem() {
		// Run the test as the userPatient.
		System.runAs(userPatient) {
			// Query existing feed items for comparison before insertion.
			List<BI_PSP_FeedItem__c> testPost = [
				SELECT
					BI_PSP_CareProgramEnrollee__c,
					BI_PSP_Category__c,
					BI_PSP_Phrase__c
				FROM BI_PSP_FeedItem__c
				WHERE BI_PSP_CareProgramEnrollee__c = :testCareProgramEnrolle.Id
			];

			Test.startTest();
			// Insert feed items with different parameters.
			BI_PSPB_FeedItemCtrl.insertFeedItem('Category', 'Subcategory');

			Test.stopTest();
			// Query inserted feed items for comparison after insertion.
			List<BI_PSP_FeedItem__c> testPostAfterInsert = [
				SELECT
					BI_PSP_CareProgramEnrollee__c,
					BI_PSP_Category__c,
					BI_PSP_Phrase__c
				FROM BI_PSP_FeedItem__c
				WHERE BI_PSP_CareProgramEnrollee__c = :testCareProgramEnrolle.Id
			];
			// Assert the results.
			Assert.areNotEqual(
				testPost,
				testPostAfterInsert,
				'FeedItem  is  Inserted'
			);
		}
	}
	/**
	 * Test method for inserting a new feed item with Exception.
	 * Verifies the behavior of the insertFeedItem method in the controller class.
	 * Covers scenarios with invalid  input parameters.
	 * @description Tests the behavior of the insertFeedItem method when
	 * invalid or null input parameters are provided,and verifies that the method
	 * properly handles exceptions.
	 */
	@isTest
	static void testInsertFeedItemForNegativeScenario() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				// Insert a feed item with an invalid account ID.
				BI_PSPB_FeedItemCtrl.insertFeedItem(null, null);

				Test.stopTest();
			}
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
	/**
	 * Test method for inserting a new feed item with Exception.
	 * Verifies the behavior of the insertFeedItem method in the controller class.
	 * Covers scenarios with invalid input parameters.
	 * @description Tests the behavior of the insertFeedItem method when invalid
	 * input parameters are provided,and verifies that the method
	 * properly handles exceptions.
	 */
	@isTest
	static void testInsertFeedItemToThrowException() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				// Insert a feed item with an invalid input.
				BI_PSPB_FeedItemCtrl.insertFeedItem(
					'InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementItestUserPatient.InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementIdd',
					'userPatient.InvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementInvalidStatementId'
				);

				Test.stopTest();
			}
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
	/**
	 * Test method for retrieving feed items posted by a specific user.
	 * Verifies the behavior of the fetchMyPost method in the controller class.
	 * Covers scenarios with valid  input parameters.
	 * @description Tests the behavior of the fetchMyPost method by
	 * verifying that it correctly retrieves feed items posted
	 * by a specific user, and covers scenarios with  valid  input parameters.
	 */
	@isTest
	static void testMyPost() {
		System.runAs(userPatient) {
			// Create a test feed item associated with the user.
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id,
				OwnerId = userPatient.Id
			);
			insert testPost;

			Test.startTest();
			List<BI_PSP_FeedItem__c> myPostRecords = BI_PSPB_FeedItemCtrl.fetchMyPost();

			Test.stopTest();
			// Assert that the myPostRecords is notnull and contains expected feed item.
			Assert.areEqual(
				testPost.BI_PSP_Phrase__c,
				myPostRecords[0].BI_PSP_Phrase__c,
				'The list of feed items should not be null'
			);
		}
	}
	/**
	 * Test method for retrieving feed items posted by a specific user.
	 * Verifies the behavior of the fetchMyPost method in the controller class.
	 * Covers scenarios with Invalid and null input parameters.
	 * @description Tests the behavior of the fetchMyPost method by verifying
	 * that it correctly retrieves feed items posted by a specific user,
	 * and covers scenarios with both Invalid and null input parameters.
	 */
	@isTest
	static void testMyPostForCatch() {
		try {
			System.runAs(userWithoutEnrollee) {
				Test.startTest();
				BI_PSPB_FeedItemCtrl.fetchMyPost();

				Test.stopTest();
			}
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
	/**
	 * Test method for retrieving all feed items.
	 * Verifies the behavior of the getAllPost method in the controller class.
	 * Covers scenarios with valid input parameters, as well as multiple feed items.
	 * @description Tests the behavior of the testGetAllPost method by verifying
	 * that it correctly  retrieves feed items posted by a specific user,
	 * and covers scenarios with  valid  input parameters.
	 */
	@isTest
	static void testGetAllPost() {
		System.runAs(userPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_FollowStatus__c = 'Follow',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
			);
			insert testPost;
			// Create a test feed item.
			BI_PSP_FeedItem__c testPostFollowing = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_FollowStatus__c = 'Following',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
			);
			insert testPostFollowing;
			// Create a test follow record.
			BI_PSP_FeedFollow__c testFollowRecord = new BI_PSP_FeedFollow__c(
				BI_PSP_CareProgramEnrolleeAccount__c = testCareProgramEnrolle.Id,
				BI_PSP_CareProgramEnrolleeFollow__c = testCareProgramEnrolleWithoutCommunityName.Id,
				BI_PSP_Type__c = 'Following'
			);
			insert testFollowRecord;
			// Create a list to hold all test feed items.
			List<BI_PSP_FeedItem__c> listOfAllPosts = new List<BI_PSP_FeedItem__c>();
			listOfAllPosts.add(testPost);
			listOfAllPosts.add(testPostFollowing);
			Test.startTest();
			List<BI_PSP_FeedItem__c> postRecords = BI_PSPB_FeedItemCtrl.getAllPost();

			Test.stopTest();
			// Assert that the postRecords is not null and contains the expected feed items
			Assert.areEqual(
				2,
				postRecords.size(),
				'All relevant feed items are returned'
			);
		}
	}
	/**
	 * Test method for retrieving all feed items.
	 * Verifies the behavior of the getAllPost method in the controller class.
	 * Covers scenarios with Invalid or null input parameters.
	 * @description Tests the behavior of the testGetAllPost method by verifying
	 * that it correctly catch feed items posted by a specific user,
	 * and covers scenarios with  null input parameters.
	 */
	@isTest
	static void testGetAllPostForCatch() {
		try {
			System.runAs(userWithoutEnrollee) {
				Test.startTest();
				BI_PSPB_FeedItemCtrl.getAllPost();

				Test.stopTest();
			}
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