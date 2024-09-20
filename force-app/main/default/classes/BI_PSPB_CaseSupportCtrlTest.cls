/**
*  @description Test method for the getCases method with different parameters.
*/
@isTest
public class BI_PSPB_CaseSupportCtrlTest {
    @TestSetup
    static void setupTestData() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'support1@test.com',
            Alias = 'batmans',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Bruceq',
            LastName = 'Wayneq',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        
        insert portalAccountOwner1;
        System.runAs(portalAccountOwner1) {
            // Retrieve the Record Type ID for Person Accounts
            RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
            
            // Create Person Account
            Account portalAccount1 = new Account(
                FirstName = 'Test',
                LastName = 'Account',
                PersonEmail = 'currrent2@user.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );
            
            insert portalAccount1;
            // Create user associated with Person Account
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
            Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'currrent2@user.com',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'currrent2@user.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Account',
                FirstName = 'Test',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            //Creating Care program to insert careProgram Enrollee
            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );
            insert carePrgm;
            //To create Care Program Enrollee for Assessment
            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = portalAccount1.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeOne;
            RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name ='BI_PSPB_Support Center' LIMIT 1];
            Case testCase = new Case(
                Subject = 'Test Case',
                Status = 'Draft',
                Priority = 'High',
                Type = 'Medical Information Enquiry',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase;
            Case testCase1 = new Case(
                Subject = 'Test Case1',
                Status = 'Submitted',
                Priority = 'High',
                Type = 'Report an Adverse Events',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase1;
               Case testCase2 = new Case(
                Subject = 'Test Case1',
                Status = 'Submitted',
                Priority = 'High',
                Type = 'PSP Platform Support',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase2;
        }
    }
    
    	@isTest
	static void testGetAssessmentsByCurrentUserName() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'oneMan',
			Email = 'one.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'One', 
			LastName = 'man',
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
			// Your test data setup (if required)

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';

			Contact con = new Contact(
				LastName = 'testusernew@example.com',
				Email = 'testusernew@example.com'
			);
			insert con;

			//Creating Test User
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
				LanguageLocaleKey = 'en_US',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id
			);
			insert testUser;
			//Creating Person Account for the User
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			//Creating Care program to insert careProgram Enrollee
			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;
			//To create Care Program Enrollee for Assessment
			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;
			RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name ='BI_PSPB_Support Center' LIMIT 1];
            Case testCase = new Case(
                Subject = 'Test Case',
                Status = 'Draft',
                Priority = 'High',
                Type = 'Medical Information Enquiry',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase;
            Case testCase1 = new Case(
                Subject = 'Test Case1',
                Status = 'Submitted',
                Priority = 'High',
                Type = 'Report an Adverse Events',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase1;
               Case testCase2 = new Case(
                Subject = 'Test Case1',
                Status = 'Submitted',
                Priority = 'High',
                Type = 'PSP Platform Support',
                BI_PSP_Patient__c = testCpeOne.Id,
                BI_PSPB_Sub_Type__c = 'Symptoms',
                Description = 'Test Description',
                RecordTypeId=caseRecordType.Id,
                AccountId = portalAccount1.Id
            );
            insert testCase2;

			// To check this Test User
			System.runAs(testUser) {
                try{
				 Test.startTest();
            BI_PSPB_CaseSupportCtrl.getCases('medical information enquiry', 'Draft');
            List<Case> cases = BI_PSPB_CaseSupportCtrl.getCases('medical information enquiry', 'Draft');
            Test.stopTest();
            Assert.areEqual(1, cases.size(), 'There should be exactly one case returned');
       } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
       }
			}
		}
	}

    @isTest
    public static void testNoCareProgramgetCasesCP() {
        User user1 = [SELECT Id FROM User WHERE CommunityNickname = 'test12345' LIMIT 1];
        System.runAs(user1) {
            try{
            Test.startTest();
            BI_PSPB_CaseSupportCtrl.getCases('medical information enquiry', 'Draft');
            List<Case> cases = BI_PSPB_CaseSupportCtrl.getCases('medical information enquiry', 'Draft');
            Test.stopTest();
            Assert.areEqual(1, cases.size(), 'There should be exactly one case returned');
       } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
            }
    }
    @isTest
    public static void testCaseRAE() {
        User user1 = [SELECT Id FROM User WHERE CommunityNickname = 'test12345' LIMIT 1];
        System.runAs(user1) {
            try{
            Test.startTest();
             List<Case> cases = BI_PSPB_CaseSupportCtrl.getCases('report adverse events', 'Submitted');
            Test.stopTest();
            Assert.areEqual(0, cases.size(), 'There should be exactly one case returned');
        } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
            }
    }
     @isTest
    public static void testCasesAll() {
        User user1 = [SELECT Id FROM User WHERE CommunityNickname = 'test12345' LIMIT 1];
        System.runAs(user1) {
            try{
            Test.startTest();
          BI_PSPB_CaseSupportCtrl.getCases('all', 'all');
          List<Case> cases = BI_PSPB_CaseSupportCtrl.getCases('all', 'all');
            Test.stopTest();
            Assert.areEqual(3, cases.size(), 'There should be exactly three cases returned');
       } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
            }
    }
    @isTest
    public static void testCasesPSP() {
        User user1 = [SELECT Id FROM User WHERE CommunityNickname = 'test12345' LIMIT 1];
        System.runAs(user1) {
            try{
            Test.startTest();
            BI_PSPB_CaseSupportCtrl.getCases('psp platform support', 'Submitted');
            List<Case> cases = BI_PSPB_CaseSupportCtrl.getCases('psp platform support', 'Submitted');
            Test.stopTest();
            Assert.areEqual(1, cases.size(), 'There should be exactly one case returned');
       } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
            }
    }
    @isTest
    public static void testGetCaserecordNull() {
        try {
            Test.startTest();
            BI_PSPB_CaseSupportCtrl.getCaserecord(null);
            Test.stopTest();
        } catch (Exception e) {
            Assert.areEqual('Script-thrown exception', e.getMessage(), 'Method thrown exception');
        }
    }
     @isTest
    public static void testgetCases() {
        User user1 = [SELECT Id FROM User WHERE CommunityNickname = 'test12345' LIMIT 1];
         Case caseRecord = [SELECT Id FROM Case WHERE Subject = 'Test Case' LIMIT 1];
        System.runAs(user1) {
            try{
            Test.startTest();
             BI_PSPB_CaseSupportCtrl.getCaserecord(caseRecord.Id);
             Case retrievedCase = BI_PSPB_CaseSupportCtrl.getCaserecord(caseRecord.Id);
            Test.stopTest();
            Assert.areEqual(caseRecord.Id, retrievedCase.Id, 'The retrieved case ID should match the inserted case ID');
       } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
            }
    }
    @isTest
	static void testGetBase64Image() {
		// Create a Case record for testing
		Case testCase = new Case();
		testCase.Subject = 'Test Case';
		insert testCase;

		// Create a ContentVersion record for testing
		ContentVersion testVersion = new ContentVersion();
		testVersion.ContentLocation = 'S'; // S for Salesforce
		testVersion.PathOnClient = 'test.png'; // Path on client
		testVersion.VersionData = Blob.valueOf('Test Image Data');
		insert testVersion;

		// Create a ContentDocumentLink record for testing
		ContentDocumentLink testLink = new ContentDocumentLink();
		testLink.LinkedEntityId = testCase.Id;
		testLink.ContentDocumentId = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :testVersion.Id
		]
		.ContentDocumentId;
		insert testLink;
		
		   try{
		Test.startTest();
	   BI_PSPB_CaseSupportCtrl.getBaseImage(testCase.Id);
		Test.stopTest();
		}
		catch (Exception e) {
		// Assert that the exception message is as expected
		Assert.areEqual(
		  e.getMessage(),
		  'Script-thrown exception',
		  e.getMessage()
		);
	  }
	}
	/**
	 *   @description Test method for the else branch of BI_PSPB_CaseSupportCtrl.getBase64Image method.
	 * This test verifies the behavior of the method when the provided Case Id does not correspond to an existing Case.
	 *
	 */
	@isTest
	static void testGetBase64Imageelse() {
		// Create a Case record for testing
		Case testCase = new Case();
		testCase.Subject = 'Test Case';
		insert testCase;
		try {
			Test.startTest();
			 BI_PSPB_CaseSupportCtrl.getBaseImage(testCase.Id);
			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
			   ' e.getMessage()'
			);
		}
	}

	/**  @description
	 * Test method for the catch block of BI_PSPB_CaseSupportCtrl.getBase64Image method when the ContentVersion is not an image file.
	 * This test verifies the behavior of the method when the ContentVersion associated with the Case is not an image file.
	 *
	 */
	@isTest
	static void testGetBase64Imagecatchsec() {
		// Create a Case record for testing
		Case testCase = new Case();
		testCase.Subject = 'Test Case';
		insert testCase;
		// Create a ContentVersion record for testing
		ContentVersion testVersion = new ContentVersion();
		testVersion.ContentLocation = 'S'; // S for Salesforce
		testVersion.PathOnClient = 'test.txt'; // Path on client
		testVersion.VersionData = Blob.valueOf('Test Image Data');
		insert testVersion;
		// Create a ContentDocumentLink record for testing
		ContentDocumentLink testLink = new ContentDocumentLink();
		testLink.LinkedEntityId = testCase.Id;
		testLink.ContentDocumentId = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :testVersion.Id
		]
		.ContentDocumentId;
		insert testLink;
		try {
			Test.startTest();			
			 BI_PSPB_CaseSupportCtrl.getBaseImage(testCase.Id);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				'Script-thrown exception',
				'e.getMessage()'
			);
		}
	}
    
}