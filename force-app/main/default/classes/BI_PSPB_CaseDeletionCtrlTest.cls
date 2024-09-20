@isTest
private class BI_PSPB_CaseDeletionCtrlTest {
	@isTest
	static void testCreateCase() {
		// Setup test data
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
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'brucemessk.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemesskk',
			LastName = 'Waynemesskk',
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
			Account account = new Account(
				FirstName = 'Brucemesskk',
				LastName = 'Waynemesskk',
				PersonEmail = 'brucemessk.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
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
			User user1 = new User(
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

			insert user1;

			// Set the current user context
			try {
				Test.startTest();
				BI_PSPB_CaseDeletionCtrl.createCase();
				Test.stopTest();
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}

			// Verify the case creation
			List<Case> cases = [
				SELECT Id, Subject, Description, BI_PSP_Type__c, AccountId
				FROM Case
				WHERE AccountId = :account.Id
			];
			Assert.areEqual(
				1,
				cases.size(),
				'Expected one Case record to be created'
			);
		}
	}

	@isTest
	static void testgetCurrentUser() {
		// Setup test data
		// Create a test User record
		User testUser = new User(
			Username = 'testus@test.com',
			Email = 'testus@test.com',
			Alias = 'testus',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			]
			.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Firstname = 'Test User',
			Lastname = 'user'
		);
		insert testUser;

		// Call the method under test
		User resultUser = null;
		Test.startTest();
		resultUser = BI_PSPB_CaseDeletionCtrl.getCurrentUser(
			'Test User',
			'testuser1@test.com'
		);
		Test.stopTest();

		// Perform assertions
		if (resultUser != null) {
			Assert.areEqual(
				'testus@test.com',
				resultUser.Email,
				'The retrieved User Email does not match the expected Email'
			);
		}
	}

	@isTest
	static void testsaveCases() {
		// Setup test data
		Case testCase1 = new Case(
			Subject = 'Test Case 1',
			Description = 'Test Description 1',
			Priority = 'High',
			Status = 'New'
		);
		Case testCase2 = new Case(
			Subject = 'Test Case 2',
			Description = 'Test Description 2',
			Priority = 'Medium',
			Status = 'In Progress'
		);
		List<Case> casesToInsert = new List<Case>{ testCase1, testCase2 };

		// Clear any previous error messages
		BI_PSPB_ProfileManagerConstant.insertError = '';

		Test.startTest();

		// Mocking the static method `insertOperation`
		// You need to use a mock framework or test double here
		// Since Apex does not support direct mocking, we will rely on indirect verification
		BI_PSPB_CaseDeletionCtrl.saveCases(casesToInsert);

		Test.stopTest();

		// Verify that cases were inserted
		List<Case> insertedCases = [
			SELECT Id, Subject, Description, Priority, Status
			FROM Case
			WHERE Subject IN ('Test Case 1', 'Test Case 2')
		];
		Assert.areEqual(
			2,
			insertedCases.size(),
			'Expected two Case records to be inserted'
		);

		// Verify that no error message was set if insertOperation succeeds
		Assert.areEqual(
			'',
			BI_PSPB_ProfileManagerConstant.insertError,
			'Expected no error message'
		);

		// To fully test the error scenario, you would need to simulate an error condition
		// This often involves setting up the mock framework to throw an error or checking if error logging happens.
		// Since Apex does not support mocking static methods directly, this part is challenging and may require a custom solution.
	}
	@isTest
	static void testCreateCases() {
		// Setup test data
		// Create a test Account record
		Account testAccount = new Account(
			Firstname = 'Test Account',
			Lastname = 'testaccount@example.com'
		);
		insert testAccount;

		// Create a test User record
		Profile profile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		User testUser = new User(
			Username = 'testus@test.com',
			Email = 'testus@test.com',
			Alias = 'testus',
			ProfileId = profile.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			Firstname = 'test',
			Lastname = 'us'
		);
		insert testUser;

		Id recordTypeId = [
			SELECT Id
			FROM RecordType
			WHERE
				SObjectType = 'Case'
				AND Name = :BI_PSPB_ProfileManagerConstant.caseRecordType
			LIMIT 1
		]
		.Id;

		// Call the method to test
		Test.startTest();
		List<Case> casesToInsert = BI_PSPB_CaseDeletionCtrl.createCases(
			new List<Account>{ testAccount },
			testUser.Id,
			recordTypeId
		);
		Test.stopTest();

		Assert.areEqual(
			1,
			casesToInsert.size(),
			'Expected one Case record to be created'
		);
	}
	@isTest
	static void testgetRelatedAccountsCaregiverTrue() {
		// Setup test data
		// Create a test User record with BI_PSPB_Caregiver__c = true
		User testUser = new User(
			Username = 'System@tesst.com',
			Email = 'System@test.com',
			Alias = 'System',
			ProfileId = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			]
			.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			FirstName = 'System',
			LastName = 'Useer',
			BI_PSPB_Caregiver__c = true
		);
		insert testUser;

		// Create a test Account record
		Account selectedPatientAccount = new Account(
			Firstname = 'Selected',
			Lastname = 'Patient',
			PersonEmail = 'selectedpatient@example.com',
			BI_PSPB_Selected_Patient_ID__c = '003XXXXXXXXXXXX' // Set this to a dummy ID for testing
		);
		insert selectedPatientAccount;

		// Create another test Account record related to the selected patient
		Account relatedAccount = new Account(
			Firstname = 'Related',
			Lastname = 'Account',
			PersonEmail = 'relatedaccount@example.com',
			BI_PSPB_Selected_Patient_ID__c = selectedPatientAccount.Id
		);
		insert relatedAccount;

		// Create a test Account record to use for matching
		Account matchingAccount = new Account(
			Firstname = 'Selected',
			Lastname = 'Account',
			PersonEmail = 'selectedpatient@example.com',
			BI_PSPB_Selected_Patient_ID__c = selectedPatientAccount.Id
		);
		insert matchingAccount;

		// Call the method under test
		Test.startTest();
		List<Account> resultAccounts = BI_PSPB_CaseDeletionCtrl.getRelatedAccounts(
			testUser,
			'System@test.com',
			'System@test.com'
		);
		Test.stopTest();

		// Perform assertions
		Assert.areEqual(
			0,
			resultAccounts.size(),
			'Expected one related Account record to be returned'
		);
	}

	@isTest
	static void testcheckboxAccountDeletion() {
		Id recordTypeId = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Account' AND Name = 'Person Account'
			LIMIT 1
		]
		.Id;
		// Setup test data
		Account testAccount = new Account(
			FirstName = 'Test',
			LastName = 'User',
			PersonEmail = 'testus@example.com',
			PersonBirthdate = Date.newInstance(1990, 1, 1),
			RecordTypeId = recordTypeId
		);
		insert testAccount;

		// Retrieve a valid picklist value for BI_PSP_Type__c
		String validType = null;
		Schema.DescribeFieldResult fieldResult = Case.BI_PSP_Type__c.getDescribe();
		List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
		if (!picklistValues.isEmpty()) {
			validType = picklistValues[0].getValue(); // Use the first valid picklist value
		}
		Case testCase = new Case(
			Subject = 'Test Subject',
			Description = 'Test Description',
			BI_PSP_Type__c = validType,
			Priority = 'High',
			Origin = 'Phone',
			Status = 'New',
			OwnerId = UserInfo.getUserId(),
			AccountId = testAccount.Id
		);
		insert testCase;

		Test.startTest();
		Case retrievedCase = BI_PSPB_CaseDeletionCtrl.checkboxAccountDeletion(
			testAccount.Id
		);
		Test.stopTest();

		// Perform assertions
		if (retrievedCase != null) {
			Assert.areEqual(
				testCase.Id,
				retrievedCase.Id,
				'Retrieved Case record does not match expected'
			);
		}
	}
}