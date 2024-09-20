@isTest
private class BI_PSP_SymptomTrackerGraphCtrlTest {
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

		// Create Account
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

		// Create Care Program
		testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;

		// Create Care Program Enrollee
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
	static void testGetSymptomTrackerDetails() {
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
				HealthCloudGA__CarePlanTemplate__c = cpt.Id
			);
			insert careProgramPlanTemplate;

			AllergyIntolerance ai = new AllergyIntolerance(
				BI_PSP_Graph_Symptom_Name__c = 'Itchiness',
				BI_PSP_Symptom_Name__c = symptomTestRecord.id,
				BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
				PatientId = account.Id,
				BI_PSP_Bodyparts__c = 'arm;leg',
				BI_PSP_Intensity__c = 5,
				BI_PSP_Temperature__c = 98.6,
				BI_PSP_Mood__c = 'happy'
			);
			insert ai;
			AllergyIntolerance allergyRecord = new AllergyIntolerance(
				BI_PSP_Graph_Symptom_Name__c = 'Redness',
				BI_PSP_Symptom_Name__c = symptomTestRecord.id,
				BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
				PatientId = account.Id,
				BI_PSP_Bodyparts__c = 'arm;leg',
				BI_PSP_Intensity__c = 6,
				BI_PSP_Temperature__c = 37.6,
				BI_PSP_Mood__c = 'sad'
			);
			insert allergyRecord;

			Test.startTest();

			// Call the method
			List<BI_PSP_SymptomTrackerGraphCtrl.SymptomTracker> result = BI_PSP_SymptomTrackerGraphCtrl.getSymptomTrackerDetails(
				testCareProgramEnrolle.Id
			);

			Test.stopTest();

			Assert.areNotEqual(null, result, 'The result should not be null.');
			Assert.areEqual(
				cpt.Name,
				result[0].name,
				'The symptom name should match.'
			);
		}
	}
  @isTest
	static void testGetSymptomTrackerDetailsWithDefaultSymptom() {
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
				HealthCloudGA__CarePlanTemplate__c = cpt.Id
			);
			insert careProgramPlanTemplate;

			Test.startTest();

			// Call the method
			List<BI_PSP_SymptomTrackerGraphCtrl.SymptomTracker> result = BI_PSP_SymptomTrackerGraphCtrl.getSymptomTrackerDetails(
				testCareProgramEnrolle.Id
			);

			Test.stopTest();

			Assert.areNotEqual(null, result, 'The result should not be null.');
			Assert.areEqual(
				'No Symptoms added',
				result[0].name,
				'The symptom name should match.'
			);
		}
	} 
}