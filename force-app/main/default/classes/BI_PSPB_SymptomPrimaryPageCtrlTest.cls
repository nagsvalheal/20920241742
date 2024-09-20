/*
*	@description  This Test class is used for getting Account Id, Creating Contact,
	Creating Enrollee caregiver,BI_PSP_SymptomTracker,AllergyIntolerance Returns all Values
*                
* History:
* Version	Author			Date			Detail				Description
* 1.0		Karthikeyan	    05-01-2024     	Created				Initial development
* 2.0						10-04-2024		Update				Code Review.
*/

@isTest
public class BI_PSPB_SymptomPrimaryPageCtrlTest {
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
		insert account;
		testCareProgram = new CareProgram(
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
	}
	@isTest
	static void testGetSymptomRecordData() {
		System.runAs(userPatient) {
			Date testDate = Date.today();
			BI_PSP_Symptom_Tracker__c testSymptom = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
				BI_PSP_EditEntrydates__c = testDate,
				BI_PSP_Symptom_Staus__c = 'active',
				BI_PSP_Patient__c = account.id,
				BI_PSP_Recent_Activities__c = 'Stress',
				BI_PSP_Are_you_currently_experiencing__c = true
			);
			insert testSymptom;

			Test.startTest();
			List<BI_PSP_Symptom_Tracker__c> result = BI_PSPB_SymptomPrimaryPageCtrl.getSymptomRecordData(
				testSymptom.Id
			);
			Test.stopTest();

			// Verify the result
			Assert.areNotEqual(
				null,
				result,
				'The method should return a list of Symptom Tracker records.'
			);
			Assert.areEqual(
				1,
				result.size(),
				'The method should return exactly one record.'
			);

			BI_PSP_Symptom_Tracker__c retrievedSymptom = result[0];
			Assert.areEqual(
				testSymptom.Id,
				retrievedSymptom.Id,
				'The method should return the correct Symptom Tracker record.'
			);
			Assert.areEqual(
				testSymptom.BI_PSP_EditEntrydates__c,
				retrievedSymptom.BI_PSP_EditEntrydates__c,
				'The EditEntrydates field should match.'
			);
			Assert.areEqual(
				testSymptom.BI_PSP_Patient__c,
				retrievedSymptom.BI_PSP_Patient__c,
				'The Patient field should match.'
			);
			Assert.areEqual(
				testSymptom.BI_PSP_Recent_Activities__c,
				retrievedSymptom.BI_PSP_Recent_Activities__c,
				'The Recent Activities field should match.'
			);
			Assert.areEqual(
				testSymptom.BI_PSP_Are_you_currently_experiencing__c,
				retrievedSymptom.BI_PSP_Are_you_currently_experiencing__c,
				'The Are you currently experiencing field should match.'
			);
			Assert.areEqual(
				testSymptom.BI_PSP_Care_Program_Enrollee__c,
				retrievedSymptom.BI_PSP_Care_Program_Enrollee__c,
				'The Care Program Enrollee field should match.'
			);
		}
	}
	@isTest
	static void testGetSymptomRecordDataInvalidId() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_SymptomPrimaryPageCtrl.getSymptomRecordData(null);
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
	static void testGetAllergyIntoleranceData() {
		System.runAs(userPatient) {
			Date testDate = Date.today();
			BI_PSP_Symptom_Tracker__c testSymptom = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
				BI_PSP_EditEntrydates__c = testDate,
				BI_PSP_Symptom_Staus__c = 'active',
				BI_PSP_Patient__c = account.id,
				BI_PSP_Recent_Activities__c = 'Stress',
				BI_PSP_Are_you_currently_experiencing__c = true
			);
			insert testSymptom;

			AllergyIntolerance testAllergy = new AllergyIntolerance(
				BI_PSP_Symptom_Name__c = testSymptom.Id,
				BI_PSP_Bodyparts__c = 'Head',
				BI_PSP_Mood__c = 'Sad',
				BI_PSP_Intensity__c = 8,
				BI_PSP_Temperature__c = 35.6,
				PatientId = account.id
			);
			insert testAllergy;

			Test.startTest();
			List<AllergyIntolerance> result = BI_PSPB_SymptomPrimaryPageCtrl.getAllergyIntoleranceData(
				testSymptom.Id
			);
			Test.stopTest();

			AllergyIntolerance retrievedAllergy = result[0];
			Assert.areEqual(
				testAllergy.Id,
				retrievedAllergy.Id,
				'The method should return the correct AllergyIntolerance record.'
			);
			Assert.areEqual(
				testAllergy.BI_PSP_Bodyparts__c,
				retrievedAllergy.BI_PSP_Bodyparts__c,
				'The Bodyparts field should match.'
			);
			Assert.areEqual(
				testAllergy.BI_PSP_Mood__c,
				retrievedAllergy.BI_PSP_Mood__c,
				'The Mood field should match.'
			);
			Assert.areEqual(
				testAllergy.BI_PSP_Intensity__c,
				retrievedAllergy.BI_PSP_Intensity__c,
				'The Intensity field should match.'
			);
			Assert.areEqual(
				testAllergy.BI_PSP_Temperature__c,
				retrievedAllergy.BI_PSP_Temperature__c,
				'The Temperature field should match.'
			);
		}

	}
	@isTest
	static void testGetAllergyIntoleranceDataNullValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_SymptomPrimaryPageCtrl.getAllergyIntoleranceData(null);
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
	static void testGetBase64Image() {
		System.runAs(userPatient) {
			BI_PSP_Symptom_Tracker__c testSymptom = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_EditEntrydates__c = Date.today(),
				BI_PSP_Patient__c = account.Id,
				BI_PSP_Recent_Activities__c = 'Stress',
				BI_PSP_Are_you_currently_experiencing__c = true,
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id
			);
			insert testSymptom;

			ContentVersion testContentVersion1 = new ContentVersion(
				Title = 'Test Image 1',
				PathOnClient = 'TestImage1.jpg',
				VersionData = Blob.valueOf('Test Image Data 1')
			);
			insert testContentVersion1;

			// Wait for Salesforce to process the insert and populate ContentDocumentId
			ContentVersion retrievedContentVersion1 = [
				SELECT Id, ContentDocumentId
				FROM ContentVersion
				WHERE Id = :testContentVersion1.Id
			];
			ContentDocumentLink testDocLink1 = new ContentDocumentLink(
				ContentDocumentId = retrievedContentVersion1.ContentDocumentId,
				LinkedEntityId = testSymptom.Id,
				ShareType = 'V'
			);
			insert testDocLink1;

			ContentVersion testContentVersion2 = new ContentVersion(
				Title = 'Test Image 2',
				PathOnClient = 'TestImage2.png',
				VersionData = Blob.valueOf('Test Image Data 2')
			);
			insert testContentVersion2;

			// Wait for Salesforce to process the insert and populate ContentDocumentId
			ContentVersion retrievedContentVersion2 = [
				SELECT Id, ContentDocumentId
				FROM ContentVersion
				WHERE Id = :testContentVersion2.Id
			];
			ContentDocumentLink testDocLink2 = new ContentDocumentLink(
				ContentDocumentId = retrievedContentVersion2.ContentDocumentId,
				LinkedEntityId = testSymptom.Id,
				ShareType = 'V'
			);
			insert testDocLink2;

			// Call the method and verify the result
			Test.startTest();
			List<Map<String, String>> result = BI_PSPB_SymptomPrimaryPageCtrl.getBase64Image(
				testSymptom.Id
			);
			Test.stopTest();

			// Verify the result
			Assert.areNotEqual(
				null,
				result,
				'The method should return a list of base64 image URLs.'
			);
			System.assert(
				result.size() > 0,
				'The method should return at least one base64 image URL.'
			);
		}
	}

	@isTest
	static void testGetBase64ImageNullValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_SymptomPrimaryPageCtrl.getBase64Image(null);
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
	static void testDeleteSymptomTrackerRecords() {
		System.runAs(userPatient) {
			Date testDate = Date.today();
			BI_PSP_Symptom_Tracker__c testSymptom = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
				BI_PSP_EditEntrydates__c = testDate,
				BI_PSP_Symptom_Staus__c = 'active',
				BI_PSP_Patient__c = account.id,
				BI_PSP_Recent_Activities__c = 'Stress',
				BI_PSP_Are_you_currently_experiencing__c = true
			);
			insert testSymptom;

			Test.startTest();
			BI_PSPB_SymptomPrimaryPageCtrl.deleteSymptomTrackerRecords(
				testSymptom.Id
			);
			Test.stopTest();

			BI_PSP_Symptom_Tracker__c updatedSymptom = [
				SELECT BI_PSP_Symptom_Staus__c
				FROM BI_PSP_Symptom_Tracker__c
				WHERE Id = :testSymptom.Id
			];
			Assert.areEqual(
				BI_PSP_SymptomTrackerConstant.symptomTrackerInactive,
				updatedSymptom.BI_PSP_Symptom_Staus__c,
				'The status should be updated to "Inactive".'
			);
		}

	}

	@isTest
	static void testDeleteSymptomTrackerRecordsInvalidValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_SymptomPrimaryPageCtrl.deleteSymptomTrackerRecords(account.id);
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
	static void testDeleteSymptomTrackerRecordsNullValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSPB_SymptomPrimaryPageCtrl.deleteSymptomTrackerRecords(null);
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
	static void testGetLatestSymptomRecord() {
		System.runAs(userPatient) {
			// Step 2: Create and insert test BI_PSP_Symptom_Tracker__c records
			BI_PSP_Symptom_Tracker__c testSymptom1 = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_EditEntrydates__c = Date.today().addDays(-1),
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_Symptom_Staus__c = 'Inactive'
			);
			insert testSymptom1;

			BI_PSP_Symptom_Tracker__c testSymptom2 = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_EditEntrydates__c = Date.today(),
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert testSymptom2;

			Test.startTest();

			List<String> result = BI_PSPB_SymptomPrimaryPageCtrl.getLatestSymptomRecord();
			Test.stopTest();

			// Verify the result
			Assert.areNotEqual(
				null,
				result,
				'The method should return a list of values.'
			);
			Assert.areEqual(
				2,
				result.size(),
				'The method should return two values: Id and DateTime.'
			);

			// Verify the values of the returned result
			Assert.areEqual(
				testSymptom2.Id,
				result[0],
				'The method should return the latest record Id.'
			);
		}
	}
}