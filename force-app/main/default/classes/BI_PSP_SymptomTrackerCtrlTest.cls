/*
    * @description  This Test class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,
        BI_PSP_SymptomTracker,AllergyIntolerance Insert and Upadte Return values use this class  
    *                
    * History:
    * Version	Author			Date			Detail				@description
    * 1.0		Karthikeyan	    05-01-2024     	Created				Initial development
    */

	@isTest
	public class BI_PSP_SymptomTrackerCtrlTest {
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
		static void testCheckUniqueDateWithActiveRecord() {
			System.runAs(userPatient) {
				Date editedDate = Date.today();
	
				BI_PSP_Symptom_Tracker__c record = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
					BI_PSP_EditEntrydates__c = editedDate,
					BI_PSP_Symptom_Staus__c = BI_PSP_SymptomTrackerConstant.activeLable
				);
				insert record;
	
				Boolean result = BI_PSP_SymptomTrackerCtrl.checkUniqueDate(
					editedDate,
					testCareProgramEnrolle.id
				);
	
				Assert.areEqual(
					false,
					result,
					'The result should be false when there are active records for the same date.'
				);
			}
		}
		@isTest
		static void testCheckUniqueDateWithInactiveRecord() {
			System.runAs(userPatient) {
				// Create a sample BI_PSP_Symptom_Tracker__c record with inactive status
				Date testDate = Date.today();
				String inActiveStatusValue = BI_PSP_SymptomTrackerConstant.inActiveRecord;
	
				BI_PSP_Symptom_Tracker__c inactiveRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
					BI_PSP_EditEntrydates__c = testDate,
					BI_PSP_Symptom_Staus__c = inActiveStatusValue
				);
				insert inactiveRecord;
	
				Boolean result = BI_PSP_SymptomTrackerCtrl.checkUniqueDate(
					testDate,
					testCareProgramEnrolle.id
				);
	
				Assert.areEqual(
					true,
					result,
					'The result should be true when there is an inactive record for the same date.'
				);
			}
		}
		@isTest
		static void testCheckUniqueDateNoRecords() {
			System.runAs(userPatient) {
				try {
					Date testDate = Date.today();
	
					BI_PSP_SymptomTrackerCtrl.checkUniqueDate(testDate, null);
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
		static void testInsertSymptomTrackerSuccess() {
			System.runAs(userPatient) {
				Date testDate = Date.today();
				Test.startTest();
				Id resultId = BI_PSP_SymptomTrackerCtrl.insertSymptomTracker(
					testDate
				);
	
				Assert.areNotEqual(
					null,
					resultId,
					'The inserted symptom tracker Id should not be null.'
				);
	
				// Verify that the record is created
				BI_PSP_Symptom_Tracker__c insertedRecord = [
					SELECT
						Id,
						BI_PSP_Care_Program_Enrollee__c,
						BI_PSP_EditEntrydates__c,
						BI_PSP_Symptom_Staus__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :resultId
				];
	
				Assert.areEqual(
					testCareProgramEnrolle.Id,
					insertedRecord.BI_PSP_Care_Program_Enrollee__c,
					'The Care Program Enrollee should match.'
				);
				Assert.areEqual(
					testDate,
					insertedRecord.BI_PSP_EditEntrydates__c,
					'The Edit Entry Date should match.'
				);
				Assert.areEqual(
					BI_PSP_SymptomTrackerConstant.activeLable,
					insertedRecord.BI_PSP_Symptom_Staus__c,
					'The Symptom Status should be active.'
				);
	
				Test.stopTest();
			}
		}
		@isTest
		static void testInsertSymptomTrackerWithNullValues() {
			System.runAs(userPatient) {
				try {
					Id resultId = BI_PSP_SymptomTrackerCtrl.insertSymptomTracker(
						null
					);
	
					Assert.areEqual(
						null,
						resultId,
						'The result should be null when input values are null.'
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
		static void testUpdateSymptomTrackerSuccess() {
			System.runAs(userPatient) {
				Date testDate = Date.today();
				String inActiveStatusValue = BI_PSP_SymptomTrackerConstant.inActiveRecord;
	
				BI_PSP_Symptom_Tracker__c inactiveRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
					BI_PSP_EditEntrydates__c = testDate,
					BI_PSP_Symptom_Staus__c = inActiveStatusValue,
					BI_PSP_Are_you_currently_experiencing__c = false
				);
				insert inactiveRecord;
	
				Test.startTest();
				BI_PSP_SymptomTrackerCtrl.updateSymptomTracker(
					inactiveRecord.Id,
					true,
					Date.today().addDays(1)
				);
				Test.stopTest();
	
				BI_PSP_Symptom_Tracker__c updatedRecord = [
					SELECT
						BI_PSP_Are_you_currently_experiencing__c,
						BI_PSP_EditEntrydates__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :inactiveRecord.Id
				];
	
				Assert.areEqual(
					true,
					updatedRecord.BI_PSP_Are_you_currently_experiencing__c,
					'The GPP status should be updated.'
				);
				Assert.areEqual(
					Date.today().addDays(1),
					updatedRecord.BI_PSP_EditEntrydates__c,
					'The Edit Entry Date should be updated.'
				);
			}
		}
		@isTest
		static void testUpdateSymptomTrackerNegative() {
			System.runAs(userPatient) {
				try {
					Test.startTest();
					BI_PSP_SymptomTrackerCtrl.updateSymptomTracker(
						null,
						true,
						Date.today().addDays(1)
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
		static void testUpdateGppValueSuccess() {
			System.runAs(userPatient) {
				Date testDate = Date.today();
				String inActiveStatusValue = BI_PSP_SymptomTrackerConstant.inActiveRecord;
	
				BI_PSP_Symptom_Tracker__c inactiveRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
					BI_PSP_EditEntrydates__c = testDate,
					BI_PSP_Symptom_Staus__c = inActiveStatusValue,
					BI_PSP_Are_you_currently_experiencing__c = false
				);
				insert inactiveRecord;
				Test.startTest();
				BI_PSP_SymptomTrackerCtrl.updateGppValue(inactiveRecord.Id, true);
				Test.stopTest();
	
				// Then: The record should be updated
				BI_PSP_Symptom_Tracker__c updatedRecord = [
					SELECT BI_PSP_Are_you_currently_experiencing__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :inactiveRecord.Id
				];
	
				Assert.areEqual(
					true,
					updatedRecord.BI_PSP_Are_you_currently_experiencing__c,
					'The GPP status should be updated.'
				);
			}
		}
		@isTest
		static void testUpdateGppValueNegative() {
			System.runAs(userPatient) {
				try {
					Test.startTest();
					BI_PSP_SymptomTrackerCtrl.updateGppValue(null, true);
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
		static void testUpdateGppValueInvalidId() {
			System.runAs(userPatient) {
				try {
					Test.startTest();
					BI_PSP_SymptomTrackerCtrl.updateGppValue(account.id, true);
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
		static void testUpdateRecentSymptomActivitySuccess() {
			System.runAs(userPatient) {
				Date testDate = Date.today();
				String inActiveStatusValue = BI_PSP_SymptomTrackerConstant.inActiveRecord;
	
				BI_PSP_Symptom_Tracker__c inactiveRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.id,
					BI_PSP_EditEntrydates__c = testDate,
					BI_PSP_Symptom_Staus__c = inActiveStatusValue,
					BI_PSP_Are_you_currently_experiencing__c = false
				);
				insert inactiveRecord;
	
				// Define values to update
				List<String> valuesToUpdate = new List<String>{
					'Stress',
					'Excessive sun exposure',
					'Had an infection'
				};
	
				// When: Calling updateRecentSymptomActivity with valid data
				Test.startTest();
				BI_PSP_SymptomTrackerCtrl.updateRecentSymptomActivity(
					inactiveRecord.Id,
					valuesToUpdate
				);
				Test.stopTest();
	
				// Then: The record should be updated with the new activities
				BI_PSP_Symptom_Tracker__c updatedRecord = [
					SELECT BI_PSP_Recent_Activities__c
					FROM BI_PSP_Symptom_Tracker__c
					WHERE Id = :inactiveRecord.Id
				];
	
				Assert.areEqual(
					'Had an infection;Stress;Excessive sun exposure',
					updatedRecord.BI_PSP_Recent_Activities__c,
					'The Recent Activities field should be updated.'
				);
			}
		}
		@isTest
		static void testUpdateRecentSymptomActivityNegative() {
			System.runAs(userPatient) {
				try {
					// Define values to update
					List<String> valuesToUpdate = new List<String>{
						'Stress',
						'Excessive sun exposure',
						'Had an infection'
					};
	
					// When: Calling updateRecentSymptomActivity with valid data
					Test.startTest();
					BI_PSP_SymptomTrackerCtrl.updateRecentSymptomActivity(
						null,
						valuesToUpdate
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
				Test.stopTest();
			}
		}
		@isTest
		static void testRecordInsertAllergyIntoleranceSuccess() {
			System.runAs(userPatient) {
				Date editedDate = Date.today();
	
				BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_EditEntrydates__c = editedDate,
					BI_PSP_Symptom_Staus__c = 'active'
				);
				insert symptomTestRecord;
				HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
					Name = 'Itchiness',
					HealthCloudGA__Active__c = true
				);
				insert cpt;
				HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
					HealthCloudGA__CareProgram__c = testCareProgram.Id,
					HealthCloudGA__CarePlanTemplate__c = cpt.id
				);
				insert careProgramPlanTemplate;
				BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod record = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
	
				record.symptomId = symptomTestRecord.Id;
				record.sliderValue = 5;
				record.valoF = 99.0;
				record.moodvalues = 'Happy';
				record.personGender = 'male';
				record.symptomname = 'Itchiness';
				record.careProgramId = testCareProgramEnrolle.Id;
	
				List<String> bodyParts = new List<String>{ 'Arms', 'Legs' };
	
				Test.startTest();
	
				Id allergyId = BI_PSP_SymptomTrackerCtrl.recordInsertAllergyIntolerance(
					record,
					bodyParts
				);
	
				Test.stopTest();
	
				Assert.areNotEqual(
					null,
					allergyId,
					'The AllergyIntolerance record should be inserted and ID should be returned.'
				);
	
				AllergyIntolerance aiRecord = [
					SELECT Id, BI_PSP_Symptoms__c, BI_PSP_Bodyparts__c
					FROM AllergyIntolerance
					WHERE Id = :allergyId
				];
	
				Assert.areNotEqual(
					null,
					aiRecord,
					'The AllergyIntolerance record should exist.'
				);
				Assert.areEqual(
					careProgramPlanTemplate.Id,
					aiRecord.BI_PSP_Symptoms__c,
					'The Care Program Plan Template should be linked.'
				);
			}
		}
		@isTest
		static void testRecordUpdateAllergyIntoleranceSuccess() {
			System.runAs(userPatient) {
				Date editedDate = Date.today();
	
				BI_PSP_Symptom_Tracker__c symptomTestRecord = new BI_PSP_Symptom_Tracker__c(
					BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
					BI_PSP_EditEntrydates__c = editedDate,
					BI_PSP_Symptom_Staus__c = 'active'
				);
				insert symptomTestRecord;
				HealthCloudGA__CarePlanTemplate__c cpt = new HealthCloudGA__CarePlanTemplate__c(
					Name = 'Itchiness',
					HealthCloudGA__Active__c = true
				);
				insert cpt;
				HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
					HealthCloudGA__CareProgram__c = testCareProgram.Id,
					HealthCloudGA__CarePlanTemplate__c = cpt.id
				);
				insert careProgramPlanTemplate;
				AllergyIntolerance existingRecord = new AllergyIntolerance(
					BI_PSP_Symptoms__c = careProgramPlanTemplate.Id,
					BI_PSP_Bodyparts__c = 'Arms;Legs',
					BI_PSP_Intensity__c = 4,
					BI_PSP_Mood__c = 'Sad',
					BI_PSP_Symptom_Name__c = symptomTestRecord.id,
					BI_PSP_Temperature__c = 34.4,
					PatientId = account.id
				);
				insert existingRecord;
	
				List<String> bodyParts = new List<String>{ 'Arms', 'Legs' };
	
				BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod newRecord = new BI_PSP_SymptomTrackerAllergyCtrl.BI_PSPB_Symptomtrackerwrapeermethod();
				newRecord.symptomId = symptomTestRecord.Id;
				newRecord.sliderValue = 5;
				newRecord.valoF = 99.0;
				newRecord.moodvalues = 'Happy';
				newRecord.personGender = 'male';
				newRecord.symptomname = 'Itchiness';
				newRecord.careProgramId = testCareProgramEnrolle.Id;
	
				Test.startTest();
	
				Id updatedAllergyId = BI_PSP_SymptomTrackerCtrl.recordUpdateAllergyIntolerance(
					newRecord,
					bodyParts
				);
	
				Test.stopTest();
	
				Assert.areNotEqual(
					null,
					updatedAllergyId,
					'The AllergyIntolerance record should be updated and ID should be returned.'
				);
	
				AllergyIntolerance updatedRecord = [
					SELECT Id, BI_PSP_Bodyparts__c
					FROM AllergyIntolerance
					WHERE Id = :updatedAllergyId
				];
	
				Assert.areNotEqual(
					null,
					updatedRecord,
					'The AllergyIntolerance record should exist.'
				);
				Assert.areEqual(
					String.join(bodyParts, ';'),
					updatedRecord.BI_PSP_Bodyparts__c,
					'The body parts should be correctly updated.'
				);
			}
		}
	}