@isTest
public class BI_PSPB_SupportCenterCtrlTest {
	
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
	  // Call the method to be tested
	  Test.startTest();
	  BI_PSPB_SupportCenterCtrl.updateCase(
		caseUpdate.Id,
		'Medical Information Enquiry',
		'Updated Description',
		fileIds
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
  static void testlinkFilesToCase() {
	try {
	  Test.startTest();
		BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(null,null);
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
   * @description Test method to verify the behavior of updateCase method.
   */
  @isTest
  static void getCatchDraft() {
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
	  BI_PSPB_SupportCenterCtrl.updateCase('', '', '', null);
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
   * @description Test method to verify the behavior of updateCase method.
   */
  @isTest
  static void getCatchUpdateDraft() {
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
	  BI_PSPB_SupportCenterCtrl.updateDraft('', '', '', null);
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
   * @description Test method to verify the behavior of UpdateDraft method.
   */
  @isTest
  static void testUpdateDraft() {
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
	  BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
	  supportWrapper.accountId = cpe.Id;
	  supportWrapper.type = 'Medical Information Enquiry';
	  supportWrapper.subType = 'Treatment';
	  supportWrapper.description = 'description';
	  // Call the method to be tested
	  Test.startTest();
	  BI_PSPB_SupportCenterCtrl.updateDraft(
		caseUpdate.Id,
		'Medical Information Enquiry',
		'Updated Description',
		fileIds
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
	
  
}