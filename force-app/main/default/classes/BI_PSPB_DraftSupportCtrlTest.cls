/**
   *@description Test method to validate the Prepopulate functionality.
   */
@isTest
public class BI_PSPB_DraftSupportCtrlTest {

  @isTest
  static void testCreateCase() {
	try {
	  RecordType testRecordType = [
		SELECT Id
		FROM RecordType
		WHERE SObjectType = 'Account'
		LIMIT 1
	  ];
	  // Create test data
	  Account testAccount = new Account(Name = 'Test Account');
	  insert testAccount;
	  Account testNewAccount = new Account(
		Name = 'Test Account',
		RecordTypeId = testRecordType.Id
	  );
	  insert testNewAccount;
	  CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
	  insert testCP;
	  CareProgramEnrollee cpe = new CareProgramEnrollee(
		AccountId = testAccount.Id,
		Name = 'Test Enrollee',
		CareProgramId = testCP.Id
	  );
	  insert cpe;
	  CareProgramEnrollee cpeo = new CareProgramEnrollee(
		AccountId = testNewAccount.Id,
		Name = 'Test Enrollee',
		CareProgramId = testCP.Id
	  );
	  insert cpeo;
	  //List<String> fileIds = new List<String>();
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
	  
	  List<Case> caseMedRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsMedical(
		cpe.Id
	  );
	  List<Case> caseRepRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsReport(
		cpe.Id
	  );
	  List<Case> casePlatformRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsPlatformSupport(
		cpe.Id
	  );
	  assert.areEqual(
		1,
		caseMedRecords.size(),
		'Case should have been created'
	  );
	  assert.areEqual(
		1,
		caseRepRecords.size(),
		'Case should have been created'
	  );
	  assert.areEqual(
		1,
		casePlatformRecords.size(),
		'Case should have been created'
	  );
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Attempt to de-reference a null object',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
	/**
   * @description Test method to verify the behavior of getPSPCaseRecordsMedical method.
   */
  @isTest
  static void testgetPSPCaseRecordsMedicalNull() {
	try {
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsMedical(null);
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
	/**
   * @description Test method to verify the behavior of getPSPCaseRecordsReport method.
   */
  @isTest
  static void testGetPSPCaseRecordsPlatformSupportPositive() {
	// Create test data
	Account testAccount = new Account(Name = 'Test Account');
	insert testAccount;
	CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
	insert testCP;
	CareProgramEnrollee cpe = new CareProgramEnrollee(
	  AccountId = testAccount.Id,
	  Name = 'Test Enrollee',
	  CareProgramId = testCP.Id
	);
	insert cpe;
	try {
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsPlatformSupport(cpe.Id);
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
	/**
   * @description Test method to verify the behavior of getPSPCaseRecordsReport method.
   */
  @isTest
  static void testGetPSPCaseRecordsReportWithCpe() {
	// Create test data
	Account testAccount = new Account(Name = 'Test Account');
	insert testAccount;
	CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
	insert testCP;
	CareProgramEnrollee cpe = new CareProgramEnrollee(
	  AccountId = testAccount.Id,
	  Name = 'Test Enrollee',
	  CareProgramId = testCP.Id
	);
	insert cpe;
	try {
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsReport(cpe.Id);
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
  
	 /**
   * @description Test method to verify the behavior of getPSPCaseRecordsReport method.
   */
  @isTest
  static void testGetPSPCaseRecordsReportNull() {
	try {
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsReport(null);
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
  
	 /**
   * @description Test method to verify the behavior of UpdateCase method.
   */
  @isTest
  static void testUpdateCase() {
	try {
	  RecordType testRecordType = [
		SELECT Id
		FROM RecordType
		WHERE SObjectType = 'Account'
		LIMIT 1
	  ];
	  // Create test data
	  Account testAccount = new Account(Name = 'Test Account');
	  insert testAccount;
	  Account testNewAccount = new Account(
		Name = 'Test Account',
		RecordTypeId = testRecordType.Id
	  );
	  insert testNewAccount;
	  CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
	  insert testCP;
	  CareProgramEnrollee cpe = new CareProgramEnrollee(
		AccountId = testAccount.Id,
		Name = 'Test Enrollee',
		CareProgramId = testCP.Id
	  );
	  insert cpe;
	  Case caseupdate = new Case(
		BI_PSP_Patient__c = cpe.Id,
		BI_PSP_Type__c = 'Medical Information Enquiry',
		BI_PSPB_Sub_Type__c = 'Treatment',
		Status = 'Submitted'
	  );
	  insert caseUpdate;
	  CareProgramEnrollee cpeo = new CareProgramEnrollee(
		AccountId = testNewAccount.Id,
		Name = 'Test Enrollee',
		CareProgramId = testCP.Id
	  );
	  insert cpeo;
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
	  List<Case> caseMedRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsMedical(
		cpe.Id
	  );
	  List<Case> caseRepRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsReport(
		cpe.Id
	  );
	  List<Case> casePlatformRecords = BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsPlatformSupport(
		cpe.Id
	  );
	  assert.areEqual(
		1,
		caseMedRecords.size(),
		'Case should have been created'
	  );
	  assert.areEqual(
		1,
		caseRepRecords.size(),
		'Case should have been created'
	  );
	  assert.areEqual(
		1,
		casePlatformRecords.size(),
		'Case should have been created'
	  );
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Attempt to de-reference a null object',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
	/**
   * @description Test method to verify the behavior of getPSPCaseRecordsMedical method.
   */
  @isTest
  static void getCatchGetMedical() {
	try {
	  RecordType testRecordType = [
		SELECT Id
		FROM RecordType
		WHERE SObjectType = 'Account'
		LIMIT 1
	  ];
	  Account testAccount = new Account(
		Name = 'Test Account',
		RecordTypeId = testRecordType.Id
	  );
	  insert testAccount;
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsMedical('qwqwwwqwqw');
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
  /**
   * @description Test method to verify the behavior of getPSPCaseRecordsReport method.
   */
  @isTest
  static void getCatchGetReport() {
	try {
	  RecordType testRecordType = [
		SELECT Id
		FROM RecordType
		WHERE SObjectType = 'Account'
		LIMIT 1
	  ];
	  Account testAccount = new Account(
		Name = 'Test Account',
		RecordTypeId = testRecordType.Id
	  );
	  insert testAccount;
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsReport('qwqwwwqwqw');
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
  /**
   * @description Test method to verify the behavior of getPSPCaseRecordsPlatformSupport method.
   */
  @isTest
  static void getCatchGetPlatform() {
	try {
	  RecordType testRecordType = [
		SELECT Id
		FROM RecordType
		WHERE SObjectType = 'Account'
		LIMIT 1
	  ];
	  Account testAccount = new Account(
		Name = 'Test Account',
		RecordTypeId = testRecordType.Id
	  );
	  insert testAccount;
	  Test.startTest();
	  BI_PSPB_DraftSupportCtrl.getPSPCaseRecordsPlatformSupport(
		'qwqwwwqwqw'
	  );
	  Test.stopTest();
	} catch (Exception e) {
	  Assert.areEqual(
		'Script-thrown exception',
		e.getMessage(),
		'Method thrown exception'
	  );
	}
  }
 @isTest
    static void testGetSavedImageUrls() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Case testCase = new Case(AccountId = testAccount.Id, Status = 'Draft');
        insert testCase;

        ContentVersion testVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.png',
            VersionData = Blob.valueOf('Test Image Content')
        );
        insert testVersion;

        // Fetch the document ID after insertion
        String documentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testVersion.Id].ContentDocumentId;

        // Link content to the Case
        ContentDocumentLink docLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = documentId,
            ShareType = 'V'
        );
        insert docLink;

        Test.startTest();
        List<Map<String, String>> imageUrls = BI_PSPB_DraftSupportCtrl.getSavedImageUrls(testCase.Id);
        Test.stopTest();

        Assert.areEqual(1, imageUrls.size(), 'One image should be linked to the Case');
        Assert.areEqual('Test Image', imageUrls[0].get('filename'), 'The filename should match the inserted ContentVersion title');
    }


}