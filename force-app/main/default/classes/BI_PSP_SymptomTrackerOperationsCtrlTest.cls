/**
 * @description Test class for the BI_PSP_SymptomTrackerOperationsCtrl Apex controller.
 * This class contains test methods for validating the functionality of various methods in
 * the BI_PSP_SymptomTrackerOperationsCtrl controller, ensuring that all operations related to
 * symptom tracking are performed correctly.
 */
@isTest
public class BI_PSP_SymptomTrackerOperationsCtrlTest {
	public static User userPatient;
	public static Account account;
	public static CareProgram testCareProgram;
	public static CareProgramEnrollee testCareProgramEnrolle;

	static {
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
		insert userPatient;

		//create Account
		account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
			HealthCloudGA__Gender__pc = 'Female',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			OwnerId = userPatient.Id,
			Phone = '123456'
		);
		insert account;

		//create careprogram
		testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;

		//create careprogram enrollee
		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_CommunityUsername__c = 'patient',
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
	}
	@isTest
	private static void testGetLastCareTemplate() {
		System.runAs(userPatient) {
			try {
				// Call the method
				Test.startTest();
				List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_SymptomTrackerOperationsCtrl.getLastCareTemplate();
				Test.stopTest();

				// Verify the results
				Assert.areNotEqual(
					null,
					results,
					'The results list should not be null.'
				);
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
	@isTest
	private static void testSaveFiles() {
		System.runAs(userPatient) {
			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Patient__c = account.Id,
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;

			 List<String> fileContents = new List<String>();
        fileContents.add('data:image/jpeg;base64,' + EncodingUtil.base64Encode(Blob.valueOf('Sample File Content 1')));
        fileContents.add('data:image/png;base64,' + EncodingUtil.base64Encode(Blob.valueOf('Sample File Content 2')));
        fileContents.add('data:application/pdf;base64,' + EncodingUtil.base64Encode(Blob.valueOf('%PDF-1.4 Sample PDF Content')));

			//List<String> fileName = new List<String>();            
			List<String> fileName = new List<String>{'file1', 'file2', 'file3'};
			// Call the method
			Test.startTest();
			List<String> contentDocumentIds = BI_PSP_SymptomTrackerOperationsCtrl.saveFiles(
				fileContents,
				symptomTestRecord.id,
                fileName
			);
			Test.stopTest();

			// Verify the results
			Assert.areNotEqual(
				null,
				contentDocumentIds,
				'The contentDocumentIds list should not be null.'
			);
			// Verify that ContentDocument records exist with the returned IDs
        List<ContentDocumentLink> documentLinks = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :symptomTestRecord.Id
        ];

        System.assertEquals(3, documentLinks.size(), 'There should be 3 ContentDocumentLink records associated with the symptom tracker.');
   
		}

	}
	@isTest
	private static void testSaveFilesWithoutAccount() {
		System.runAs(userPatient) {
			try {
				// Call the method
				Test.startTest();
				List<String> fileContents = new List<String>();
				fileContents.add(
					EncodingUtil.urlEncode('Sample File Content 1', 'UTF-8')
				);
				fileContents.add(
					EncodingUtil.urlEncode('Sample File Content 2', 'UTF-8')
				);

				BI_PSP_SymptomTrackerOperationsCtrl.saveFiles(
					fileContents,
					null,
                    null
				);
				Test.stopTest();
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
	@isTest
	private static void testCreateContentDocumentLinks() {
		System.runAs(userPatient) {
			try {
				BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Patient__c = account.Id,
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_Symptom_Staus__c = 'active'
				);
				insert symptomTestRecord;

				// Create ContentVersion records in bulk
				List<ContentVersion> contentVersions = new List<ContentVersion>();
				for (Integer i = 0; i < 3; i++) {
					ContentVersion contentVersion = new ContentVersion(
						VersionData = Blob.valueOf('Sample File Content ' + i),
						Title = 'Test File ' + i,
						PathOnClient = 'testfile' + i + '.txt',
						FirstPublishLocationId = symptomTestRecord.Id
					);
					contentVersions.add(contentVersion);
				}
				insert contentVersions;

				// Collect ContentDocumentIds after insert
				List<String> fileIds = new List<String>();
				for (ContentVersion contentVersion : contentVersions) {
					fileIds.add(contentVersion.ContentDocumentId);
				}

				// Call the method
				Test.startTest();
				BI_PSP_SymptomTrackerOperationsCtrl.createContentDocumentLinks(
					fileIds,
					symptomTestRecord.Id
				);
				Test.stopTest();

				// Verify that ContentDocumentLink records are created
				List<ContentDocumentLink> contentDocumentLinks = [
					SELECT Id, ContentDocumentId, LinkedEntityId, ShareType
					FROM ContentDocumentLink
					WHERE LinkedEntityId = :symptomTestRecord.Id
				];
				Assert.areEqual(
					fileIds.size(),
					contentDocumentLinks.size(),
					'The number of ContentDocumentLink records should match the number of file IDs.'
				);
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
	@isTest
	private static void testCreateContentDocumentLinksWithoutAccount() {
		System.runAs(userPatient) {
			try {
				BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Patient__c = account.Id,
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_Symptom_Staus__c = 'active'
				);
				insert symptomTestRecord;

				// Create ContentVersion records in bulk
				List<ContentVersion> contentVersions = new List<ContentVersion>();
				for (Integer i = 0; i < 3; i++) {
					ContentVersion contentVersion = new ContentVersion(
						VersionData = Blob.valueOf('Sample File Content ' + i),
						Title = 'Test File ' + i,
						PathOnClient = 'testfile' + i + '.txt',
						FirstPublishLocationId = symptomTestRecord.Id
					);
					contentVersions.add(contentVersion);
				}
				insert contentVersions;

				// Collect ContentDocumentIds after insert
				List<String> fileIds = new List<String>();
				for (ContentVersion contentVersion : contentVersions) {
					fileIds.add(contentVersion.ContentDocumentId);
				}

				// Call the method
				Test.startTest();
				BI_PSP_SymptomTrackerOperationsCtrl.createContentDocumentLinks(
					fileIds,
					null
				);
				Test.stopTest();
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
	@isTest
	private static void testDeleteContentDocumentLinks() {
		System.runAs(userPatient) {
			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Patient__c = account.Id,
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;

			// Create ContentVersion records in bulk
			List<ContentVersion> contentVersions = new List<ContentVersion>();
			for (Integer i = 0; i < 3; i++) {
				ContentVersion contentVersion = new ContentVersion(
					VersionData = Blob.valueOf('Sample File Content ' + i),
					Title = 'Test File ' + i,
					PathOnClient = 'testfile' + i + '.txt',
					FirstPublishLocationId = symptomTestRecord.Id
				);
				contentVersions.add(contentVersion);
			}
			insert contentVersions;

			// Collect ContentDocumentIds after insert
			List<String> fileIds = new List<String>();
			for (ContentVersion contentVersion : contentVersions) {
				fileIds.add(contentVersion.ContentDocumentId);
			}

			// Call the method to delete the ContentDocumentLink
			Test.startTest();
			BI_PSP_SymptomTrackerOperationsCtrl.deleteContentDocumentLinks(
				symptomTestRecord.Id
			);
			Test.stopTest();

			// Verify that the ContentDocumentLink record is deleted
			List<ContentDocumentLink> linksAfterDeletion = [
				SELECT Id
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :symptomTestRecord.Id
			];
			Assert.areEqual(
				2,
				linksAfterDeletion.size(),
				'ContentDocumentLink should be deleted.'
			);
		}
	}
	@isTest
	private static void testDeleteContentDocumentLinksInvalidId() {
		System.runAs(userPatient) {
			try {
				// Call the method to delete the ContentDocumentLink
				Test.startTest();
				BI_PSP_SymptomTrackerOperationsCtrl.deleteContentDocumentLinks(
					null
				);
				Test.stopTest();
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
	
	@isTest
	private static void testFetchAccountDetails() {
		System.runAs(userPatient) {
			Test.startTest();
			List<CareProgramEnrollee> results = BI_PSP_SymptomTrackerOperationsCtrl.fetchAccountDetails(
				testCareProgramEnrolle.Id
			);
			Test.stopTest();

			Assert.areNotEqual(null, results, 'The result should not be null.');
			Assert.areEqual(
				1,
				results.size(),
				'The result list should contain one record.'
			);
			CareProgramEnrollee result = results[0];

			// Verify that the Account details are correct
			Assert.areEqual(
				account.Id,
				result.AccountId,
				'The AccountId should match the inserted Account.'
			);
			Assert.areEqual(
				account.HealthCloudGA__Gender__pc,
				result.Account.HealthCloudGA__Gender__pc,
				'The Account Gender should match the inserted Account.'
			);
		}
	}
	@isTest
	private static void testFetchAccountDetailsWithoutAccount() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerOperationsCtrl.fetchAccountDetails(null);
				Test.stopTest();
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
}