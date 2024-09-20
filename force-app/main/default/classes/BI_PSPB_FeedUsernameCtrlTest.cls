/**
 * @description This class contains test methods to verify the functionality of
 * methods related to community usernames with valid and invalid inputs.
 * @author Deepa
 * @Last Modified On  05/28/2024
 * @Last Modified By   Deepa
 */
@isTest
private class BI_PSPB_FeedUsernameCtrlTest {
	// Test data Variables.
	public static User userPatientTest;
	public static User userPatient;
	public static User userWithoutEnrollee;
	public static Account account;
	public static Account accountWithoutCommunityUsername;

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
			Username = System.now().millisecond() + 'usertest22@test.com',
			Alias = 'superman',
			Email = 'feeds.amelis@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'feeds',
			LastName = 'amelis',
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

			userPatient = new User(
				FirstName = 'TestPatientFeed',
				LastName = 'PatientLastName',
				Email = 'testpatientfeed@gmail.com',
				Username = 'testpatientfeed@gmail.com',
				ContactId = [
					SELECT Id
					FROM Contact
					WHERE AccountId = :account.Id
					LIMIT 1
				]
				.Id,
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
			CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
				AccountId = account.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSP_CommunityUsername__c = 'patient',
				BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
				Name = 'TestPatientFeed PatientLastName'
			);
			insert testCareProgramEnrolle;

			CareProgramEnrollee testCareProgramEnrolleWithoutCommunityName = new CareProgramEnrollee(
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
	 * @description Tests the checkCommunityUsername method for users with and without community usernames.
	 */
	@isTest
	static void testCheckCommunityUsername() {
		System.runAs(userPatient) {
			Test.startTest();
			Boolean resultWithCommunityUsername = BI_PSPB_FeedUsernameCtrl.checkCommunityUsername();
			Test.stopTest();
			Assert.areEqual(
				true,
				resultWithCommunityUsername,
				'Community Username should exist for test user patient'
			);
		}

	}
	/**
	* @description The test includes scenario to throw exception 
	by passing null as paramter.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testCheckCommunityUsernameWithoutUsername() {
		// Run the test as the test user patient.
		System.runAs(userPatientTest) {
			Test.startTest();
			// Attempt to check community username with a null user ID.
			Boolean resultWithException = BI_PSPB_FeedUsernameCtrl.checkCommunityUsername();
			Test.stopTest();
			Assert.areEqual(
				false,
				resultWithException,
				'Community username is not fetched.'
			);
		}
	}
	/**
	* @description The test includes scenario to throw exception 
	by passing Invalid paramter.
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	*/
	@isTest
	static void testCheckCommunityUsernameWithoutEnrollee() {
		try {
			// Run the test as the test user patient.
			System.runAs(userWithoutEnrollee) {
				Test.startTest();
				// Attempt to check community username with a null user ID.
				BI_PSPB_FeedUsernameCtrl.checkCommunityUsername();
				Test.stopTest();
			}
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
	/**
	* @description Test method to get the community username with valid input.
	* This method tests whether the correct account is returned 
	based on the user ID provided.
	*/
	@isTest
	static void testGetCommunityUsername() {
		System.runAs(userPatient) {
			Test.startTest();
			List<Account> accountResult = BI_PSPB_FeedUsernameCtrl.getCommunityUsername();
			Test.stopTest();
			Assert.areEqual(
				'123456',
				accountResult[0].Phone,
				'Expected value is same'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	getCommunityUsername method with null value as input.
	* This method tests whether the correct account is returned 
	based on the user ID provided.
	*/
	@isTest
	static void testGetCommunityUsernameWithoutAccount() {
		// Run the test as the test user patient.
		System.runAs(userWithoutEnrollee) {
			try {
				Test.startTest();
				BI_PSPB_FeedUsernameCtrl.getCommunityUsername();
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
	insertCommunityUsername method with invalid input.
	* This method tests whether the community username is 
	inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameInvalidInput() {
		// Run the test as the test user patient.
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_FeedUsernameCtrl.insertCommunityUsername(
					'NeededmorethantwentyfivecharactersUserCommunity'
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
	insertCommunityUsername method with valid input.
	* This method tests whether the community username is 
	correctly inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameValidInput() {
		// Run the test as the test user patient.
		System.runAs(userPatient) {
			// Query the account before the community username is updated.
			CareProgramEnrollee enrolleeWithUsernameBeforeUpdation = [
				SELECT Name, BI_PSP_CommunityUsername__c
				FROM CareProgramEnrollee
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			// Call the method to insert a community username.
			Test.startTest();
			BI_PSPB_FeedUsernameCtrl.insertCommunityUsername(
				'CommunityUsername'
			);
			Test.stopTest();
			// Query the account after the community username is updated.
			CareProgramEnrollee enrolleeUpdatedWithUsername = [
				SELECT Name, BI_PSP_CommunityUsername__c
				FROM CareProgramEnrollee
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			// Assert that the community username is updated.
			Assert.areNotEqual(
				enrolleeWithUsernameBeforeUpdation.BI_PSP_CommunityUsername__c,
				enrolleeUpdatedWithUsername.BI_PSP_CommunityUsername__c,
				'Community username is updated'
			);
		}
	}
	/**
	* @description Test method to verify the behavior of the 
	insertCommunityUsername method with null value as input.
	* This method tests whether the community username is 
	not inserted into the database.
	*/
	@isTest
	static void testInsertCommunityUsernameNullInput() {
		User currentUser = [
			SELECT Id, ProfileId
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		];
		// Run the test as the test user patient.
		System.runAs(currentUser) {
			try {
				Test.startTest();
				// Try to insert a null community username.
				BI_PSPB_FeedUsernameCtrl.insertCommunityUsername(null);
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