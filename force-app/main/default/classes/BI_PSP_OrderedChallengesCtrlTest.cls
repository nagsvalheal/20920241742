/**
 * @description Test class for the BI_PSP_OrderedChallengesCtrl Apex class.
 * The test class includes various test cases to validate the behavior of challenge-related operations,
 * such as retrieving challenges, handling blank and invalid IDs, and exception handling.
 *
 * The test methods cover scenarios for valid inputs, blank inputs, invalid IDs, and exception handling,
 * ensuring comprehensive coverage of the functionality.
 *
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0		  Sowmitha	  30-Aug-2024		Created		   Initial development
 */
@IsTest
public class BI_PSP_OrderedChallengesCtrlTest {
	@testSetup
	static void setup() {
		// Create RecordType for Award
		RecordType challengeRecordType = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge'
			LIMIT 1
		];

		// Create Account
		Account patientAccount = new Account(
			LastName = 'Patient User',
			PersonEmail = 'testuser@example.com'
		);
		insert patientAccount;

		CareProgram careProgram = new CareProgram(
			Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
			StartDate = Date.today()
		);
		insert careProgram;

		// Create CareProgramEnrollee
		CareProgramEnrollee enrollee = new CareProgramEnrollee(
			Name = 'CPE',
			AccountId = patientAccount.Id,
			CareProgramId = careProgram.Id,
			BI_PSP_Challenge_Rank__c = 'GPP beginner'
		);
		insert enrollee;

		// Create HealthCloudGA__CarePlanTemplate__c record
		HealthCloudGA__CarePlanTemplate__c carePlanTemplate = new HealthCloudGA__CarePlanTemplate__c(
			Name = 'Test Challenge',
			HealthCloudGA__Description__c = System.Label.BI_PSP_QuestionnaireLevelOne,
			BI_PSP_Challenge_Level__c = 'Level 1'
		);
		insert carePlanTemplate;

		// Create HealthCloudGA__CareProgramPlanTemplate__c record
		HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CarePlanTemplate__c = carePlanTemplate.Id,
			HealthCloudGA__CareProgram__c = careProgram.Id
		);
		insert careProgramPlanTemplate;

		// Create Awards
		Award activeAward = new Award(
			Name = 'Challenge',
			BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Status__c = BI_PSP_ChallengeConstant.challengeActive,
			RecordTypeId = challengeRecordType.Id
		);
		insert activeAward;

		Award completedAward = new Award(
			Name = 'Challenge',
			BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Status__c = BI_PSP_ChallengeConstant.assessmentStatusCompleted,
			RecordTypeId = challengeRecordType.Id
		);
		insert completedAward;
	}
	/**
	 * @description Test method for BI_PSP_OrderedChallengesCtrl.getChallenges()
	 * when provided with a valid CareProgramPlanTemplate ID.
	 *
	 * @test Verifies that the method returns a non-empty list of Care Plan Templates
	 * associated with the provided CareProgramPlanTemplate ID.
	 */
	@IsTest
	static void testGetChallengesSuccess() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			HealthCloudGA__CareProgramPlanTemplate__c cpPlanTemplate = [
				SELECT Id
				FROM HealthCloudGA__CareProgramPlanTemplate__c
			];
			Test.startTest();
			List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_OrderedChallengesCtrl.getChallenges(
				cpPlanTemplate.Id
			);
			Assert.areEqual(1, results.size(), 'Expected result list when challengeId is valid');
			Test.stopTest();
		}
	}

	/**
	 * @description Test method for BI_PSP_IndividualChallengesCtrl.getIndividualChallenges()
	 * when provided with a blank ID.
	 *
	 * @test Verifies that the method handles a blank ID gracefully and returns an empty list,
	 * ensuring no records are retrieved.
	 */

	@IsTest
	static void testGetIndividualChallengesBlankId() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			try {
				Test.startTest();
				List<HealthCloudGA__CarePlanTemplate__c> result = BI_PSP_OrderedChallengesCtrl.getChallenges(
					''
				);
				Test.stopTest();
				Assert.areEqual(
					0,
					result.size(),
					'Expected empty result list when challengeId is blank'
				);
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}
	}

	/**
	 * @description Test method for BI_PSP_IndividualChallengesCtrl.getIndividualChallenges()
	 * when provided with an invalid ID.
	 *
	 * @test Verifies that the method handles an invalid ID correctly by returning an empty list,
	 * ensuring no records are retrieved.
	 */

	@IsTest
	static void testGetIndividualChallengesInvalidId() {
		// Test handling of an invalid challengeId
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'parangi',
			Email = 'parangi@malai.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'parangi',
			LastName = 'malai',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			try {
				Test.startTest();
				List<HealthCloudGA__CarePlanTemplate__c> result = BI_PSP_OrderedChallengesCtrl.getChallenges(
					'InvalidId'
				);
				Test.stopTest();
				Assert.areEqual(
					0,
					result.size(),
					'Expected empty result list when challengeId is invalid'
				);
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}
	}
}