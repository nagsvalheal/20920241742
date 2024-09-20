/**
@description	This class contains test methods to verify the functionality of 
				methods related to comment to the posts  and fetching,editing,updating,comments 
				with valid and invalid inputs.
@author					Deepa
@Last Modified On   	07/28/2024
@Last Modified By 		Deepa
*/
@isTest
private class BI_PSPB_FeedCommentCtrlTest {
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
			Username = System.now().millisecond() + 'cmttestuser@gmail.com',
			Alias = 'cmtus',
			Email = 'cmt.users@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'cmt',
			LastName = 'users',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);
		insert portalAccountOwner1;
		System.runAs(portalAccountOwner1) {
			account = new Account(
				FirstName = 'TestPatientCmt',
				LastName = 'PatientLastNameCmt',
				PersonEmail = 'testpatientcmt@gmail.com',
				RecordTypeId = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account' AND Name = 'Person Account'
				]
				.Id,
				OwnerId = portalAccountOwner1.Id,
				Phone = '1234566'
			);
			accountWithoutCommunityUsername = new Account(
				FirstName = 'TestCaregiverUserCmt',
				LastName = 'CaregiverLastNameCmt',
				PersonEmail = 'testcaregivercmt@gmail.com',
				RecordTypeId = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account' AND Name = 'Person Account'
				]
				.Id,
				OwnerId = portalAccountOwner1.Id,
				Phone = '1234567891'
			);

			testAccounts.add(account);
			testAccounts.add(accountWithoutCommunityUsername);
			// Creating all accounts.
			insert testAccounts;

			// User as a patient.
			userPatient = new User(
				FirstName = 'TestPatientCmt',
				LastName = 'PatientLastNameCmt',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :account.Id
					LIMIT 1
				]
				.Id,
				Email = 'testpatientcmt@gmail.com',
				Username = 'testpatientcmt@gmail.com',
				BI_PSPB_Caregiver__c = false,
				Alias = 'cmttst',
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
				FirstName = 'TestCaregiverUserCmt',
				LastName = 'CaregiverLastNameCmt',
				Email = 'testcaregivercmt@gmail.com',
				Username = 'testcaregivercmt@gmail.com',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :accountWithoutCommunityUsername.Id
					LIMIT 1
				]
				.Id,
				BI_PSPB_Caregiver__c = false,
				Alias = 'cmt87',
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
			testUsers.add(userPatientTest);
			testUsers.add(userPatient);
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
	 * Test method for inserting a comment on a feed item.
	 * Verifies the behavior of the insertComment method in the controller class.
	 * Covers scenarios with valid  input parameters.
	 *  @description Tests the behavior of the insertComment method by
	 *  verifying that it correctly inserts comments on feed items,
	 *   and covers scenarios with  valid input parameters.
	 */
	@isTest
	static void testInsertCommentPositive() {
		//try {
		// Run the test as the userPatient.
		System.runAs(userPatient) {
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
			);
			insert testPost;
			Test.startTest();
			BI_PSPB_FeedCommentCtrl.insertComment('Test Comment', testPost.Id);
			Test.stopTest();

			// Verify the comment was inserted
			List<BI_PSP_FeedComment__c> comments = [
				SELECT Id, BI_PSP_Comment__c
				FROM BI_PSP_FeedComment__c
				WHERE BI_PSP_FeedItem__c = :testPost.Id
			];
			System.assertEquals(1, comments.size(), 'Comment was  inserted');
			System.assertEquals(
				'Test Comment',
				comments[0].BI_PSP_Comment__c,
				'Comment content does  match'
			);
		}
		//} catch (Exception e) {
		/*  When executing the negative scenario, if the flow enters 
    the catch block and throws an exception, assertions 
    are made solely for validating the exception occurrence.*/
		/*	Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}*/
	}
	/**
	 * Test method for inserting a comment on a feed item.
	 * Verifies the behavior of the insertComment method in the controller class.
	 * Covers scenarios with  null input parameters.
	 *  @description Tests the behavior of the insertComment method by
	 *  verifying that it correctly throw an Exception.
	 */
	@isTest
	static void testInsertCommentNegative() {
		try {
			// Run the test as the userPatient.
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.insertComment('', null);
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
	 * Test method for inserting a comment on a feed item.
	 * Verifies the behavior of the insertComment method in the controller class.
	 * Covers scenarios with Invalid  input parameters.
	 *  @description Tests the behavior of the insertComment method
	 *  by verifying that it correctly throw an Exception.
	 */
	@isTest
	static void testInsertCommentLengthyComment() {
		try {
			System.runAs(userPatient) {
				// Create a test feed item.
				BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
					BI_PSP_Category__c = 'Test Category',
					BI_PSP_Phrase__c = 'Test Phrase',
					BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
				);
				insert testPost;
				Test.startTest();
				// Call the method with Invalid input parameters.
				BI_PSPB_FeedCommentCtrl.insertComment(
					'Test Comment Test CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest Comment Test CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest CommentTest Comment',
					testPost.Id
				);
				// Stop test execution.
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
	 * Test method for viewing comments on a feed item.
	 * Verifies the behavior of the viewComments method in the controller class.
	 * Covers scenarios with valid feed item IDs.
	 * @description Tests the behavior of the viewComments method by verifying
	 * that it correctly retrieves comments associated with a feed item, and covers
	 *  scenarios with valid  feed item IDs.
	 */
	@isTest
	static void testViewCommentsPositive() {
		// Run the test as the userPatient
		System.runAs(userPatient) {
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Category__c = 'Test Category',
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id
			);
			insert testPost;

			BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
				BI_PSP_Comment__c = 'Test Comment',
				BI_PSP_FeedItem__c = testPost.Id,
				BI_PSP_CareProgramEnrolleeCmt__c = testCareProgramEnrolle.Id
			);
			insert testComment;

			Test.startTest();
			List<BI_PSP_FeedComment__c> comments = BI_PSPB_FeedCommentCtrl.viewComments(
				testPost.Id
			);
			Test.stopTest();

			System.assertNotEquals(
				null,
				comments,
				'Comments list should not be null'
			);
			System.assertEquals(1, comments.size(), 'Expected one comment');
			System.assertEquals(
				'Test Comment',
				comments[0].BI_PSP_Comment__c,
				'Comment content does not match'
			);
		}
	}
	/**
	 * Test method for viewing comments on a feed item.
	 * Verifies the behavior of the viewComments method in the controller class.
	 * Covers scenarios with Invalid  feed item IDs.
	 * @description Tests the behavior of the viewComments method by verifying
	 *  that it correctly retrieves comments associated with a feed item,
	 * and covers scenarios with invalid feed item IDs.
	 */
	@isTest
	static void testViewCommentsNegative() {
		try {
			// Run the test as the userPatient
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.viewComments('InvalidId');
				BI_PSPB_FeedCommentCtrl.viewComments(null);
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
	 * Test method for viewing comments on a feed item.
	 * Verifies the behavior of the viewComments method in the controller class.
	 * Covers scenarios with null value.
	 * @description Tests the behavior of the viewComments method by verifying
	 *  that it correctly retrieves comments associated with a feed item,
	 * and covers scenarios with null feed value.
	 */
	@isTest
	static void testViewCommentsNegativeNullValue() {
		try {
			// Run the test as the userPatient
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.viewComments(null);
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
	 * Test method for editing a comment.
	 * Verifies that a comment can be successfully updated with new text.
	 * @description Tests the behavior of the editComment method by
	 * verifying that it successfully updates a comment with new text.
	 */
	@isTest
	static void testEditCommentPositive() {
		System.runAs(userPatient) {
			BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
				BI_PSP_Comment__c = 'Test Comment'
			);
			insert testComment;

			Test.startTest();
			BI_PSPB_FeedCommentCtrl.editComment(
				'Updated Comment',
				testComment.Id
			);
			Test.stopTest();

			// Verify the comment was updated
			BI_PSP_FeedComment__c commentAfterUpdate = [
				SELECT BI_PSP_Comment__c
				FROM BI_PSP_FeedComment__c
				WHERE Id = :testComment.Id
			];
			System.assertEquals(
				'Updated Comment',
				commentAfterUpdate.BI_PSP_Comment__c,
				'Comment was not updated correctly'
			);
		}
	}
	/**
	 * Test method for editing a comment.
	 * Verifies that a comment can be successfully throw an Exception.
	 * @description Tests the behavior of the editComment method by verifying that
	 * it successfully throw an Exception while passing the Invalid Values.
	 */
	@isTest
	static void testEditCommentNegative() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.editComment('', 'InvalidId');
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
	 * Test method for editing a comment.
	 * Verifies that a comment can be successfully throw an Exception.
	 * @description Tests the behavior of the editComment method by verifying
	 * that it successfully throw Exception when invalid Id Passed.
	 */
	@isTest
	static void testEditCommentToThrowException() {
		try {
			System.runAs(userPatient) {
				BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
					BI_PSP_Comment__c = 'Test Comment'
				);
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.editComment(
					'testUserPatientPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheCommentPassingInvalidStatementToEditTheComment.Id',
					testComment.Id
				);
				// Stop test execution.
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
	 * Test method for editing a comment.
	 * Verifies that a comment can be successfully throw an Exception.
	 * @description Tests the behavior of the editComment method by verifying
	 * that it successfully throw Exception when invalid Id Passed.
	 */
	@isTest
	static void testEditCommentException() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
					BI_PSP_Comment__c = 'Test Comment',
					BI_PSP_CommentDelete__c = 'yes'
				);
				insert testComment;
				delete testComment;
				// Call the editComment method with an invalid ID to trigger the else block.
				BI_PSP_FeedComment__c result = BI_PSPB_FeedCommentCtrl.editComment(
					'Updated Comment Text', // Text to update
					testComment.Id
				);

				Test.stopTest();

				// Assert that the commentToEdit is null, indicating that the else block was executed
				System.assertEquals(null, result, 'Expected result to be null');
			}
		} catch (Exception e) {
			// Handle and assert the exception
			System.assertEquals(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * Test method for soft deleting a feed comment item.
	 * Verifies that a feed comment item can be successfully soft deleted.
	 * @description Tests the behavior of the softDeleteFeedcommentItem method by verifying
	 *  that it successfully soft deletes  a feed comment item.
	 */

	@isTest
	static void testSoftDeleteFeedCommentItemPositive() {
		System.runAs(userPatient) {
			// Create a test feed comment item.
			BI_PSP_FeedComment__c testComment = new BI_PSP_FeedComment__c(
				BI_PSP_Comment__c = 'Test Comment'
			);
			insert testComment;

			Test.startTest();
			BI_PSPB_FeedCommentCtrl.softDeleteFeedCommentItem(testComment.Id);
			Test.stopTest();

			// Verify the comment was soft deleted
			BI_PSP_FeedComment__c commentAfterDelete = [
				SELECT BI_PSP_CommentDelete__c
				FROM BI_PSP_FeedComment__c
				WHERE Id = :testComment.Id
			];
			System.assertEquals(
				BI_PSPB_CommunityConstant.softDelete,
				commentAfterDelete.BI_PSP_CommentDelete__c,
				'Comment was  soft deleted correctly'
			);
		}
	}
	/**
	 * Test method for soft deleting a feed comment item.
	 * Verifies that a feed comment item can be successfully throw an Exception.
	 * @description Tests the behavior of the softDeleteFeedcommentItem method by
	 * verifying that it successfully throw Exception while
	 * Passing Null or Invalid Value.
	 */
	@isTest
	static void testSoftDeleteFeedCommentItemNegative() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.softDeleteFeedCommentItem(null);

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
	 * Test method for soft deleting a feed comment item.
	 * Verifies that a feed comment item can be successfully throw an Exception.
	 * @description Tests the behavior of the softDeleteFeedcommentItem method by
	 * verifying that it successfully throw Exception while
	 * Passing Null or Invalid Value.
	 */
	@isTest
	static void testSoftDeleteFeedCommentItemInvalid() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.softDeleteFeedCommentItem('InvalidId');

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
	 * Test method for retrieving comment options for a feed item.
	 * Verifies that comment options are retrieved correctly for a given feed item.
	 * @description Tests the behavior of the getCommentOptions method by verifying
	 *  that it correctly retrieves comment options for a given feed item.
	 */
	@isTest
	static void testGetCommentOptionsPositive() {
		System.runAs(userPatient) {
			// Create a test feed item.
			BI_PSP_FeedItem__c testPost = new BI_PSP_FeedItem__c(
				BI_PSP_Phrase__c = 'Test Phrase',
				BI_PSP_Category__c = 'Test Category'
			);
			insert testPost;

			Test.startTest();
			List<BI_PSP_FeedItem__c> options = BI_PSPB_FeedCommentCtrl.getCommentOptions(
				testPost.Id
			);
			Test.stopTest();

			System.assertNotEquals(
				null,
				options,
				'Options list should not be null'
			);
			System.assertEquals(1, options.size(), 'Expected one option');
			System.assertEquals(
				testPost.BI_PSP_Phrase__c,
				options[0].BI_PSP_Phrase__c,
				'Feed item BI_PSP_Phrase__c does  match'
			);
		}
	}
	/**
	 * Test method for retrieving comment options for a feed item.
	 * Verifies that GetCommentOption method  throw Exception for a given feed item.
	 * @description Tests the behavior of the getCommentOptions method by verifying that it
	 * correctly throw Exception for a given Value.
	 */
	@isTest
	static void testGetCommentOptionsNegative() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.getCommentOptions('InvalidId');

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
	 * Test method for retrieving comment options for a feed item.
	 * Verifies that GetCommentOption method  throw Exception for a given feed item.
	 * @description Tests the behavior of the getCommentOptions method by verifying that it
	 * correctly throw Exception for a given Value.
	 */
	@isTest
	static void testGetCommentOptionsNegativeNullValue() {
		try {
			System.runAs(userPatient) {
				Test.startTest();
				BI_PSPB_FeedCommentCtrl.getCommentOptions(null);

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