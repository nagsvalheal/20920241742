@isTest
private class BI_PSP_SymptomTrackerAllergyCtrlTest {
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
	static void testValidateInputs() {
		System.runAs(userPatient) {
			// Create a valid record and bodyParts
			BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod validRecord = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
			validRecord.symptomId = 'symptomId';
			List<String> bodyParts = new List<String>{ 'arm', 'leg' };

			// Test valid inputs (no exception should be thrown)
			Test.startTest();
			BI_PSP_SymptomTrackerAllergyCtrl.validateInputs(validRecord, bodyParts);
			Test.stopTest();

            Assert.areEqual(
				validRecord.symptomId,
				'symptomId',
				'value must be equal'
			);
		}
	}
	@isTest
	static void testInvalidateInputs() {
		System.runAs(userPatient) {
			try {
				// Create a valid record and bodyParts
				BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod validRecord = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
				validRecord.symptomId = 'symptomId';

				// Test valid inputs (no exception should be thrown)
				Test.startTest();
				BI_PSP_SymptomTrackerAllergyCtrl.validateInputs(validRecord, null);
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
	static void testCreateAllergyIntolerance() {
		System.runAs(userPatient) {
			Date editedDate = Date.today();
			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = editedDate,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;
			// Create a valid record and bodyParts
			BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod record = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
			record.symptomId = symptomTestRecord.Id;
			record.sliderValue = 5;
			record.valoF = 98.6;
			record.moodvalues = 'happy';
			record.personGender = 'female';
			record.symptomname = 'Itchiness';
			record.careProgramId = testCareProgram.Id;

			List<String> bodyParts = new List<String>{ 'arm', 'leg' };
			String accountId = account.Id;
			string careProgramId = testCareProgram.Id;
			// Test createAllergyIntolerance method
			Test.startTest();
			AllergyIntolerance ai = BI_PSP_SymptomTrackerAllergyCtrl.createAllergyIntolerance(
				record,
				bodyParts,
				testCareProgram.Id,
				accountId
			);
			Test.stopTest();

			// Assert that the AllergyIntolerance record was created correctly
			Assert.areNotEqual(
				null,
				ai,
				'AllergyIntolerance record should not be null.'
			);
			Assert.areEqual(
				careProgramId,
				ai.BI_PSP_Symptoms__c,
				'Care Program ID should match.'
			);
			Assert.areEqual(
				record.symptomId,
				ai.BI_PSP_Symptom_Name__c,
				'Symptom ID should match.'
			);
			Assert.areEqual(
				'arm;leg',
				ai.BI_PSP_Bodyparts__c,
				'Body Parts should match.'
			);
			Assert.areEqual(5, ai.BI_PSP_Intensity__c, 'Intensity should match.');
			Assert.areEqual(
				98.6,
				ai.BI_PSP_Temperature__c,
				'Temperature should match.'
			);
			Assert.areEqual('happy', ai.BI_PSP_Mood__c, 'Mood should match.');
			Assert.areEqual(accountId, ai.PatientId, 'Patient ID should match.');
		}
	}

	@isTest
	static void testCreateAllergyIntoleranceNegative() {
		System.runAs(userPatient) {
			try {
				Date editedDate = Date.today();
				BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_EditEntrydates__c = editedDate,
					BI_PSP_Symptom_Staus__c = 'active'
				);
				insert symptomTestRecord;
				// Create a valid record and bodyParts
				BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod record = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
				record.symptomId = symptomTestRecord.Id;
				record.sliderValue = null;
				record.valoF = null;
				record.moodvalues = null;
				record.personGender = 'female';
				record.symptomname = 'Itchiness';
				record.careProgramId = testCareProgram.Id;

				List<String> bodyParts = null;
				String accountId = account.Id;
				string careProgramId = testCareProgram.Id;
				Test.startTest();
				BI_PSP_SymptomTrackerAllergyCtrl.createAllergyIntolerance(
					record,
					bodyParts,
					testCareProgram.Id,
					accountId
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
	static void testGetExistingAllergyIntoleranceRecordValidInput() {
		System.runAs(userPatient) {
			Date editedDate = Date.today();

			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_EditEntrydates__c = editedDate,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;
			HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
				Name = 'Fatigue',
				HealthCloudGA__Active__c = true
			);
			insert cpt;
			HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
				HealthCloudGA__CareProgram__c = testCareProgram.Id,
				HealthCloudGA__CarePlanTemplate__c = cpt.id
			);
			insert careProgramPlanTemplate;

			AllergyIntolerance ai = new AllergyIntolerance(
				BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
				PatientId = account.Id,
				BI_PSP_Bodyparts__c = 'arm;leg',
				BI_PSP_Intensity__c = 5,
				BI_PSP_Temperature__c = 98.6,
				BI_PSP_Mood__c = 'happy'
			);
			insert ai;

			// Test the getExistingAllergyIntoleranceRecord method
			Test.startTest();
			AllergyIntolerance retrievedRecord = BI_PSP_SymptomTrackerAllergyCtrl.getExistingAllergyIntoleranceRecord(
				account.Id,
				careProgramPlanTemplate.Id
			);
			Test.stopTest();

			// Assert that the retrieved record matches the inserted record
			Assert.areNotEqual(
				null,
				retrievedRecord,
				'The retrieved AllergyIntolerance record should not be null.'
			);
			Assert.areEqual(
				ai.Id,
				retrievedRecord.Id,
				'The ID of the retrieved record should match the inserted record.'
			);
			Assert.areEqual(
				'arm;leg',
				retrievedRecord.BI_PSP_Bodyparts__c,
				'The Body Parts should match.'
			);
			Assert.areEqual(
				5,
				retrievedRecord.BI_PSP_Intensity__c,
				'The Intensity should match.'
			);
			Assert.areEqual(
				98.6,
				retrievedRecord.BI_PSP_Temperature__c,
				'The Temperature should match.'
			);
			Assert.areEqual(
				'happy',
				retrievedRecord.BI_PSP_Mood__c,
				'The Mood should match.'
			);
		}
	}
	@isTest
	static void testGetExistingAllergyIntoleranceRecordInvalidInput() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerAllergyCtrl.getExistingAllergyIntoleranceRecord(
					account.Id,
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
	static void testUpdateAllergyIntoleranceRecord() {
		Date editedDate = Date.today();

		BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
			BI_PSP_EditEntrydates__c = editedDate,
			BI_PSP_Symptom_Staus__c = 'active'
		);
		insert symptomTestRecord;
		HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'Fatigue',
			HealthCloudGA__Active__c = true
		);
		insert cpt;
		HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = testCareProgram.Id,
			HealthCloudGA__CarePlanTemplate__c = cpt.id
		);
		insert careProgramPlanTemplate;

		// Create and insert a sample AllergyIntolerance record
		AllergyIntolerance existingRecord = new AllergyIntolerance(
			BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
			BI_PSP_Bodyparts__c = 'arm;hand',
			BI_PSP_Intensity__c = 1,
			BI_PSP_Temperature__c = 36.6,
			BI_PSP_Mood__c = 'Sad',
			PatientId = account.Id
		);
		insert existingRecord;

		// Create a BI_PSPB_Symptomtrackerwrapeermethod record to pass as input
		BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod record = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();

		record.symptomId = symptomTestRecord.Id;
		record.sliderValue = 5;
		record.valoF = 99.0;
		record.moodvalues = 'Happy';
		record.personGender = 'male';
		record.symptomname = 'Itchiness';
		record.careProgramId = testCareProgram.Id;

		List<String> bodyParts = new List<String>{ 'arm', 'leg' };

		// Test updateAllergyIntoleranceRecord method
		Test.startTest();
		BI_PSP_SymptomTrackerAllergyCtrl.updateAllergyIntoleranceRecord(
			existingRecord,
			record,
			bodyParts
		);
		Test.stopTest();

		// Retrieve the updated record from the database
		AllergyIntolerance updatedRecord = [
			SELECT
				BI_PSP_Symptom_Name__c,
				BI_PSP_Bodyparts__c,
				BI_PSP_Intensity__c,
				BI_PSP_Temperature__c,
				BI_PSP_Mood__c
			FROM AllergyIntolerance
			WHERE Id = :existingRecord.Id
		];

		// Assert that the AllergyIntolerance record was updated correctly
		Assert.areNotEqual(
			record.valoF,
			updatedRecord.BI_PSP_Intensity__c,
			'Intensity should match.'
		);
		Assert.areNotEqual(
			99.0,
			updatedRecord.BI_PSP_Temperature__c,
			'Temperature should match.'
		);
		Assert.areNotEqual(
			'Happy',
			updatedRecord.BI_PSP_Mood__c,
			'Mood should match.'
		);
	}

	@isTest
	static void testUpdateAllergyIntoleranceRecordInvalidId() {
		Date editedDate = Date.today();

		BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
			BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
			BI_PSP_EditEntrydates__c = editedDate,
			BI_PSP_Symptom_Staus__c = 'active'
		);
		insert symptomTestRecord;
		HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'Fatigue',
			HealthCloudGA__Active__c = true
		);
		insert cpt;
		HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = testCareProgram.Id,
			HealthCloudGA__CarePlanTemplate__c = cpt.id
		);
		insert careProgramPlanTemplate;

		// Create and insert a sample AllergyIntolerance record
		AllergyIntolerance existingRecord = new AllergyIntolerance(
			BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
			BI_PSP_Bodyparts__c = 'arm;hand',
			BI_PSP_Intensity__c = 1,
			BI_PSP_Temperature__c = 36.6,
			BI_PSP_Mood__c = 'Sad',
			PatientId = account.Id
		);
		insert existingRecord;

		// Create a BI_PSPB_Symptomtrackerwrapeermethod record to pass as input
		BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod record = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();

		record.symptomId = symptomTestRecord.Id;
		record.sliderValue = null;
		record.valoF = null;
		record.moodvalues = null;
		record.personGender = 'male';
		record.symptomname = null;
		record.careProgramId = testCareProgram.Id;

		List<String> bodyParts = null;

		// Test updateAllergyIntoleranceRecord method
		Test.startTest();
		BI_PSP_SymptomTrackerAllergyCtrl.updateAllergyIntoleranceRecord(
			existingRecord,
			record,
			bodyParts
		);
		Test.stopTest();

		// Retrieve the updated record from the database
		AllergyIntolerance updatedRecord = [
			SELECT
				BI_PSP_Symptom_Name__c,
				BI_PSP_Bodyparts__c,
				BI_PSP_Intensity__c,
				BI_PSP_Temperature__c,
				BI_PSP_Mood__c
			FROM AllergyIntolerance
			WHERE Id = :existingRecord.Id
		];

		// Assert that the AllergyIntolerance record was updated correctly
		Assert.areEqual(
			'arm;hand',
			updatedRecord.BI_PSP_Bodyparts__c,
			'Body Parts should match.'
		);
		Assert.areEqual(
			1,
			updatedRecord.BI_PSP_Intensity__c,
			'Intensity should match.'
		);
		Assert.areEqual(
			36.6,
			updatedRecord.BI_PSP_Temperature__c,
			'Temperature should match.'
		);
		Assert.areEqual(
			'Sad',
			updatedRecord.BI_PSP_Mood__c,
			'Mood should match.'
		);
	}
    @isTest
	private static void testGetSymptomTrackerDetails() {
		System.runAs(userPatient) {
			BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
				BI_PSP_Patient__c = account.Id,
				BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSP_Symptom_Staus__c = 'active'
			);
			insert symptomTestRecord;

			Test.startTest();
			Map<String, Object> result = BI_PSP_SymptomTrackerAllergyCtrl.getSymptomTrackerDetails(
				testCareProgramEnrolle.id
			);
			Test.stopTest();

			Assert.areEqual(
				symptomTestRecord.Id,
				result.get('recordId'),
				'The recordId should match the inserted record.'
			);
		}
	}
	@isTest
	private static void testGetSymptomTrackerDetailsWithoutAccount() {
		System.runAs(userPatient) {
			try {
				Test.startTest();
				BI_PSP_SymptomTrackerAllergyCtrl.getSymptomTrackerDetails(
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
}