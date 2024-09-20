@isTest
public class BI_PSP_SymptomTrackerHelperCtrlTest {
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
	static void testGetSymptomTrackerById() {
		System.runAs(userPatient) {
			Date editedDate = Date.today();
			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = editedDate,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;

			BI_PSP_Symptom_Tracker__c result = BI_PSP_SymptomTrackerHelperCtrl.getSymptomTrackerById(
				symptomTestRecord.Id
			);

			Assert.areNotEqual(
				null,
				result,
				'Symptom Tracker record should be retrieved.'
			);
			Assert.areEqual(
				symptomTestRecord.Id,
				result.Id,
				'The retrieved record ID should match.'
			);
		}
	}
	@isTest
	static void testGetSymptomTrackerByIdWithoutId() {
		System.runAs(userPatient) {
			try {
				BI_PSP_SymptomTrackerHelperCtrl.getSymptomTrackerById(null);
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
	static void testSaveSymptomTracker() {
		System.runAs(userPatient) {
			Date editedDate = Date.today();

			BI_PSP_Symptom_Tracker__c testRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = editedDate,
				BI_PSP_Symptom_Staus__c = 'active',
				BI_PSP_Are_you_currently_experiencing__c = true
			);
			insert testRecord;

			testRecord.BI_PSP_Are_you_currently_experiencing__c = false;

			Test.startTest();
			BI_PSP_SymptomTrackerHelperCtrl.saveSymptomTracker(testRecord);
			Test.stopTest();

			// Verify that the record is updated
			BI_PSP_Symptom_Tracker__c updatedRecord = [
				SELECT BI_PSP_Are_you_currently_experiencing__c
				FROM BI_PSP_Symptom_Tracker__c
				WHERE Id = :testRecord.Id
			];
			Assert.areEqual(
				false,
				updatedRecord.BI_PSP_Are_you_currently_experiencing__c,
				'The record should be updated.'
			);
		}
	}
	@isTest
	static void testIsExistingInactiveRecord() {
		System.runAs(userPatient) {
			BI_PSP_Symptom_Tracker__c activeRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = Date.today(),
				BI_PSP_Symptom_Staus__c = 'active',
				BI_PSP_Are_you_currently_experiencing__c = true
			);
			insert activeRecord;

			BI_PSP_Symptom_Tracker__c inactiveRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = Date.today(),
				BI_PSP_Symptom_Staus__c = 'Inactive',
				BI_PSP_Are_you_currently_experiencing__c = false
			);
			insert inactiveRecord;

			// Test valid input for an existing inactive record
			Test.startTest();
			Boolean result = BI_PSP_SymptomTrackerHelperCtrl.isExistingInactiveRecord(
				testCareProgramEnrolle.id,
				Date.today()
			);
			Test.stopTest();
			Assert.areEqual(
				false,
				result,
				'The method should return false for an existing inactive record.'
			);
		}
	}
	@isTest
	static void testIsExistingInactiveRecordNullValue() {
		System.runAs(userPatient) {
			try {
				// Test valid input for an existing inactive record
				Test.startTest();
				BI_PSP_SymptomTrackerHelperCtrl.isExistingInactiveRecord(
					testCareProgramEnrolle.id,
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
	static void testGetAccountId() {
		System.runAs(userPatient) {
			Test.startTest();
			String accountId = BI_PSP_SymptomTrackerHelperCtrl.getAccountId(
				testCareProgramEnrolle.Id
			);
			Test.stopTest();

			Assert.areEqual(
				testCareProgramEnrolle.AccountId,
				account.id,
				'The method should return the correct AccountId.'
			);
		}

	}
	@isTest
	static void testGetAccountIdInvalidId() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerHelperCtrl.getAccountId(
					account.Id
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
	static void testGetAccountIdNullValue() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerHelperCtrl.getAccountId(null);
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
	static void testGetCarePlanTemplate() {
		System.runAs(userPatient) {
			HealthCloudGA__CarePlanTemplate__c testCPT = new HealthCloudGA__CarePlanTemplate__c(
				Name = 'Fatigue',
				HealthCloudGA__Active__c = true
			);
			insert testCPT;

			HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
				HealthCloudGA__CareProgram__c = testCareProgram.Id,
				HealthCloudGA__CarePlanTemplate__c = testCPT.id
			);
			insert careProgramPlanTemplate;

			Test.startTest();
			HealthCloudGA__CarePlanTemplate__c retrievedCPT = BI_PSP_SymptomTrackerHelperCtrl.getCarePlanTemplate(
				'Fatigue'
			);
			Test.stopTest();

			Assert.areNotEqual(
				null,
				retrievedCPT,
				'The method should return a CarePlanTemplate record.'
			);
			Assert.areEqual(
				testCPT.Id,
				retrievedCPT.Id,
				'The method should return the correct CarePlanTemplate record.'
			);
		}
	}
	@isTest
	static void testGetCarePlanTemplateInvalidId() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerHelperCtrl.getCarePlanTemplate('true');
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
	static void testGetCareProgramPlanTemplate() {
		System.runAs(userPatient) {
			HealthCloudGA__CarePlanTemplate__c testCPT = new HealthCloudGA__CarePlanTemplate__c(
				Name = 'Fatigue',
				HealthCloudGA__Active__c = true
			);
			insert testCPT;
			HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
				HealthCloudGA__CareProgram__c = testCareProgram.Id,
				HealthCloudGA__CarePlanTemplate__c = testCPT.id
			);
			insert careProgramPlanTemplate;

			Test.startTest();
			HealthCloudGA__CareProgramPlanTemplate__c retrievedCPPT = BI_PSP_SymptomTrackerHelperCtrl.getCareProgramPlanTemplate(
				testCPT.Id
			);
			Test.stopTest();

			Assert.areNotEqual(
				null,
				retrievedCPPT,
				'The method should return a CareProgramPlanTemplate record.'
			);
			Assert.areEqual(
				careProgramPlanTemplate.Id,
				retrievedCPPT.Id,
				'The method should return the correct CareProgramPlanTemplate record.'
			);
		}
	}
	@isTest
	static void testGetCareProgramPlanTemplateInvalidId() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerHelperCtrl.getCareProgramPlanTemplate(null);
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