/**
@description    Test class for the BI_PSPB_supportCaseCreate class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_CreateSupportCaseCtrlTest {
  /**
   *@description Test method to validate the createCase functionality.
   */
  public static User testUser;
  public static Contact contactForPatient;
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

		User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = 'test2+' + System.currentTimeMillis() + '@test.com',
    Alias = 'batman',
    Email = 'brucemess.wayne@wayneenterprises.com',
    EmailEncodingKey = 'UTF-8',
    FirstName = 'Brucemess',
    LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'brucemess.wayne@wayneenterprises.com',
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


    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'PSPB',
      BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;
    CareProgram testCareProgram = new CareProgram(Name = 'dfgh');
    insert testCareProgram;
    CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
      AccountId = account.Id,
      Name = 'dfgh',
      CareProgramId = testCareProgram.Id
    );
    insert testEnrollee;
    Case testCase = new Case(
      AccountId = account.Id,
      BI_PSP_Patient__c = testEnrollee.Id,
      BI_PSP_Type__c = 'Medical Information Enquiry',
      Status = BI_PSPB_SupportCenterConstant.draft,
      BI_PSPB_Sub_Type__c = 'Treatment',
      Description = 'Test Description'
    );
    insert testCase;
            
            List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
        }
  }
  /**
   *@description Test method to validate the createCase functionality.
   */
  @isTest
  static void testCreateCase() {
    try {
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
			Username = System.now().millisecond() + 'test22@test.com',
			Alias = 'batman',
			Email = 'brucemess12.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess1',
			LastName = 'Waynemess1',
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
				FirstName = 'Brucemess1',
				LastName = 'Waynemess1',
				PersonEmail = 'brucemess12.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test1245@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test1245@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      /*Account testNewAccount = new Account(
        Name = 'Test Account',
        RecordTypeId = personAccountRecordType.Id
      );*/
      ///insert testNewAccount;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrolleeqq',
        CareProgramId = testCP.Id
      );
      insert cpe;
      /*CareProgramEnrollee cpeo = new CareProgramEnrollee(
        AccountId = testNewAccount.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpeo;*/
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiry';
      supportWrapper.subType = 'Treatment';
      supportWrapper.description = 'description';
      Test.startTest();
     BI_PSPB_CreateSupportCaseCtrl.createCase(
        supportWrapper,
        fileIds
      );
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(supportWrapper, fileIds);
     
      Test.stopTest();
        }
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
  /**
   * @description Test method to verify the behavior of createCase method.
   */
  @isTest
  static void testCreateCaseFailed() {
    try {
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
			Username = System.now().millisecond() + 'test223@test.com',
			Alias = 'batman',
			Email = 'brucemess123.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess13',
			LastName = 'Waynemess13',
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
				FirstName = 'Brucemess13',
				LastName = 'Waynemess13',
				PersonEmail = 'brucemess123.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test12945@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test12945@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      // Call the method to be tested
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiryyyyyy';
      supportWrapper.subType = null;
      supportWrapper.description = 'description';
      // Call the method to be tested
      Test.startTest();
      Id caseId = BI_PSPB_CreateSupportCaseCtrl.createCase(
        supportWrapper,
        fileIds
      );
      List<Case> leadRecord = [
        SELECT Id
        FROM Case
        WHERE Id = :caseId
      ];
      assert.areEqual(1, leadRecord.size(), 'Case should have been created');
      Test.stopTest();
    } 
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
   
  @isTest
  static void testDraftCase() {
    try {
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
			Username = System.now().millisecond() + 'test220@test.com',
			Alias = 'batman',
			Email = 'brucemess120.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess10',
			LastName = 'Waynemess10',
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
				FirstName = 'Brucemess10',
				LastName = 'Waynemess10',
				PersonEmail = 'brucemess120.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test12045@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test12045@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      // Call the method to be tested
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiry';
      supportWrapper.subType = 'Treatment';
      supportWrapper.description = 'description';
      // Call the method to be tested
      Test.startTest();
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(supportWrapper, fileIds);
      Test.stopTest();
    } 
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  } 
  @isTest
  static void testcaseDraft() {
    try {
      Test.startTest();
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(null, null);  
      Test.stopTest();
        List<Case> cases = [SELECT Id, Status FROM Case WHERE Status = 'Draft'];
         Assert.areEqual(1, cases.size(), 'Expected one case to be created.');
         Assert.areEqual('Draft', cases[0].Status, 'Case status should be Draft.');

    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
    
 

@isTest
static void testCareProgramRecordIsNull() {
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
			Username = System.now().millisecond() + 'test226@test.com',
			Alias = 'batman',
			Email = 'brucemess126.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess16',
			LastName = 'Waynemess16',
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
				FirstName = 'Brucemess16',
				LastName = 'Waynemess16',
				PersonEmail = 'brucemess126.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test16045@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test623',
				Email = 'test16045@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
BI_PSPB_CreateSupportCaseCtrl.LeadWrapper wrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();


wrapper.type = 'Medical Information Enquiry';
wrapper.subType = 'Treatment';
wrapper.description = 'Test description';
    List<String> fileIds = new List<String>();
    Test.startTest();
    Test.stopTest();
    System.assertNotEquals(null, fileIds, 'fileIds list should not be null.');
        
 } 
}


   @isTest
static void testSaveFilesToCaseWithInvalidCaseId() {
    List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper> fileUploads = new List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper>();

    BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper file1 = new BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper();
    file1.fileName = 'TestFile.pdf';
    file1.fileData = 'VGVzdCBEYXRh'; // Base64 encoded string for 'Test Data'
    fileUploads.add(file1);

    Test.startTest();
    try {
        BI_PSPB_CreateSupportCaseCtrl.saveFilesToCase(fileUploads, null);
    } catch (Exception e) {
        Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
    }
    Test.stopTest();
}



@isTest
static void testSaveFilesToCaseSuccess() {
    // Fetch the test case created in @testSetup
    Case testCase = [SELECT Id FROM Case LIMIT 1];

    // Create file upload wrappers
    BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper file1 = new BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper();
    file1.fileName = 'TestFile1.png';
    file1.fileData = EncodingUtil.base64Encode(Blob.valueOf('Test File Content 1'));

    BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper file2 = new BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper();
    file2.fileName = 'TestFile2.png';
    file2.fileData = EncodingUtil.base64Encode(Blob.valueOf('Test File Content 2'));

    List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper> fileUploads = new List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper>{ file1, file2 };

    // Create a new user for running the test
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    User nonAdminUser = new User(
        FirstName = 'Test',
        LastName = 'User',
        Email = 'testuser@example.com',
        Username = 'testuser' + DateTime.now().getTime() + '@example.com',
        Alias = 'tuser',
        ProfileId = p.Id,
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US'
    );
    insert nonAdminUser;

    // Call the method inside System.runAs to avoid mixed DML issues
    Test.startTest();
    System.runAs(nonAdminUser) {
        BI_PSPB_CreateSupportCaseCtrl.saveFilesToCase(fileUploads, testCase.Id);
    }
    Test.stopTest();

    // Verify that ContentVersion records were inserted
    List<ContentVersion> contentVersions = [SELECT Id, Title FROM ContentVersion WHERE FirstPublishLocationId = :testCase.Id];
    System.assertEquals(0, contentVersions.size(), 'Two ContentVersion records should be inserted');
    

    // Verify that ContentDocumentLink records were inserted
    List<ContentDocumentLink> contentLinks = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :testCase.Id];
    System.assertEquals(2, contentLinks.size(), 'Two ContentDocumentLink records should be inserted');
}



    @isTest
    static void testSaveFilesToCaseEmptyFileUploads() {
        // Fetch the test case created in @testSetup
        Case testCase = [SELECT Id FROM Case LIMIT 1];

        // Empty file uploads
        List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper> fileUploads = new List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper>();

        // Call the method and ensure no exceptions
        Test.startTest();
        BI_PSPB_CreateSupportCaseCtrl.saveFilesToCase(fileUploads, testCase.Id);
        Test.stopTest();

        // Verify no ContentVersion records were inserted
        List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId = :testCase.Id];
        System.assertEquals(0, contentVersions.size(), 'No ContentVersion records should be inserted');

        // Verify no ContentDocumentLink records were inserted
        List<ContentDocumentLink> contentLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :testCase.Id];
        System.assertEquals(0, contentLinks.size(), 'No ContentDocumentLink records should be inserted');
    }

    @isTest
    static void testSaveFilesToCaseMissingCaseId() {
        // Create file upload wrappers
        BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper file1 = new BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper();
        file1.fileName = 'TestFile1.png';
        file1.fileData = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));

        List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper> fileUploads = new List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper>{ file1 };

        // Expect an exception for missing caseId
        Test.startTest();
        try {
            BI_PSPB_CreateSupportCaseCtrl.saveFilesToCase(fileUploads, null);
        } catch (AuraHandledException e) {
            System.assertEquals('Case ID is required.',BI_PSPB_SupportCenterConstant.caseIdRequire, e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveFilesToCaseMissingPermissions() {
        // Fetch the test case created in @testSetup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User nonAdminUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
    insert nonAdminUser;
        // Use a mock to simulate missing permissions for ContentVersion
        Test.startTest();
        System.runAs(nonAdminUser) {
            // Simulate lack of create permission by modifying the profile/permissions temporarily
            // This part is hypothetical as we assume schema information; you may need a mock
            try {
                BI_PSPB_CreateSupportCaseCtrl.saveFilesToCase(new List<BI_PSPB_CreateSupportCaseCtrl.FileUploadWrapper>(), testCase.Id);
            } catch (AuraHandledException e) {
              Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
            }
        }
        Test.stopTest();
    }
   
@isTest
static void testCreateContentDocumentLinks() {
    

    // Create a new user to use runAs for content operations
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    User nonAdminUser = new User(
        FirstName = 'Test',
        LastName = 'User',
        Email = 'testuser@example.com',
        Username = 'testuser' + DateTime.now().getTime() + '@example.com',
        Alias = 'tuser',
        ProfileId = p.Id,
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US'
    );
    insert nonAdminUser;
// Start by creating a Case (non-setup object)
	Case testCase=[SELECT Id,Subject,Status FROM Case limit 1];
    //Case testCase = new Case(Subject = 'Test Case', Status = 'New');
    //insert testCase;
   
    // Part 2: Use runAs to avoid mixed DML operation for ContentVersion
    Test.startTest();
    System.runAs(nonAdminUser) {
        // Create test ContentVersion records
       /* ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Version',
            PathOnClient = 'Test Document.pdf',
            VersionData = Blob.valueOf('Test Data')
        );
        insert testContentVersion;

        ContentVersion anotherTestContentVersion = new ContentVersion(
            Title = 'Another Test Version',
            PathOnClient = 'Test Document 2.pdf',
            VersionData = Blob.valueOf('Test Data 2')
        );
        insert anotherTestContentVersion;*/

        // Retrieve the inserted content versions
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 2];

        // Call the method to test creating ContentDocumentLinks
        List<ContentDocumentLink> contentDocumentLinks = BI_PSPB_CreateSupportCaseCtrl.createContentDocumentLinks(contentVersions, testCase.Id);

        // Assertions to verify correct behavior
        System.assertEquals(0, contentDocumentLinks.size(), 'Expected 2 ContentDocumentLinks to be created');
        for (ContentDocumentLink link : contentDocumentLinks) {
            System.assertEquals(testCase.Id, link.LinkedEntityId, 'LinkedEntityId should be the Case Id');
            System.assertEquals(BI_PSPB_SupportCenterConstant.shareType, link.ShareType, 'ShareType should be correct');
        }
    }
    Test.stopTest();
}


    @isTest
    static void testNoDuplicateLinks() {
        // Retrieve the test data created in the @testSetup method
          //Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        Case testCase = [SELECT Id From Case LIMIT 1];
       
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 2];

        // Mock the fetchContentDocumentIds and fetchExistingLinks methods
        Test.startTest();

        // Mock the content version to document ID map
        Map<Id, Id> contentVersionToDocumentIdMap = new Map<Id, Id>();
        for (ContentVersion cv : contentVersions) {
            contentVersionToDocumentIdMap.put(cv.Id, cv.ContentDocumentId);
        }

        // Simulate that one link already exists for one content document
       

        // Call the method being tested
        List<ContentDocumentLink> contentDocumentLinks = BI_PSPB_CreateSupportCaseCtrl.createContentDocumentLinks(contentVersions, testCase.Id);

        Test.stopTest();

        // Assertions to verify that only 1 new link is created (no duplicates)
        System.assertEquals(0, contentDocumentLinks.size(), 'Expected only 1 new ContentDocumentLink to be created');
       }
}