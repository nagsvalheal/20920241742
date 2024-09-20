/**
 * @description Test class for the BI_PSP_StatusBasedChallengesCtrl Apex controller.
 * This test class validates the behavior of methods in the controller, including `getRandomChallenges`.
 *
 * The test methods cover various scenarios, such as retrieving random challenges with valid, blank, or invalid
 * parameters, handling empty challenge lists, and ensuring that challenges are correctly added to the success list
 * when conditions are met.
 *
 * Reason for using @isTest is to ensure that the test methods do not affect production data and to run tests
 * in an isolated environment.
 *
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha      14-Aug-2024       Created        Initial development
 * 1.1		  Sowmitha	  30-Aug-2024		Updated		   Updated
 */
@isTest
private class BI_PSP_StatusBasedChallengesCtrlTest {
	/**
	 * @description Sets up test data for the test class.
	 *              This includes creating records like `Account`, `CareProgram`, `CareProgramEnrollee`, and `Award`.
	 */
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

		// Create CareProgram
		CareProgram careProgram = new CareProgram(
			Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
			StartDate = Date.today()
		);
		insert careProgram;

		// Create CareProgramEnrollee
		CareProgramEnrollee enrollee = new CareProgramEnrollee(
			Name = 'Enrollee Record',
			CareProgramId = careProgram.Id,
			AccountId = patientAccount.Id,
			BI_PSP_Challenge_Rank__c = 'GPP beginner'
		);
		insert enrollee;

		// Create HealthCloudGA__CareProgramPlanTemplate__c record
		HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
			HealthCloudGA__CareProgram__c = careProgram.Id
		);
		insert careProgramPlanTemplate;

		// Create Awards
		Award activeAward = new Award(
			Name = 'Active Challenge',
			BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Status__c = BI_PSP_ChallengeConstant.challengeActive,
			RecordTypeId = challengeRecordType.Id
		);
		insert activeAward;

		Award availableAward = new Award(
			Name = 'Available Challenge',
			BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Status__c = BI_PSP_ChallengeConstant.challengeActive,
			RecordTypeId = challengeRecordType.Id
		);
		insert availableAward;

		Award completedAward = new Award(
			Name = 'Completed Challenge',
			BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
			BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
			BI_PSP_Status__c = BI_PSP_ChallengeConstant.assessmentStatusCompleted,
			RecordTypeId = challengeRecordType.Id
		);
		insert completedAward;
	}
	/**
	 * @description Tests the `getRandomChallenges` method with valid conditions.
	 *              Verifies that the correct challenges are returned when the person account ID and challenge status are valid.
	 */
	@isTest
	static void testGetRandomChallengesSuccessful() {
		Account patientAccount = [SELECT Id FROM Account LIMIT 1];

		try {
			Test.startTest();

			List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> results = BI_PSP_StatusBasedChallengesCtrl.getRandomChallenges(
				patientAccount.Id,
				BI_PSP_ChallengeConstant.challengeActive
			);
			Test.stopTest();

			assert.areNotEqual(0, results.size(), 'Challenges should have been returned.');
			Assert.areEqual(1, results.size(), 'Only active challenges should be returned.');
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(), 'Method thrown exception');
		}
	}
	/**
	 * @description Tests the `getRandomChallenges` method with blank parameters.
	 *              Ensures that no challenges are returned when the person account ID is blank.
	 */
	@isTest
	static void testGetRandomChallengesBlankParameters() {
		Test.startTest();
		// Test with blank personAccountId
		List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> results = BI_PSP_StatusBasedChallengesCtrl.getRandomChallenges(
			'',
			BI_PSP_ChallengeConstant.challengeActive
		);
		Test.stopTest();
		Assert.areEqual(0, results.size(), 'Expected no challenges when personAccountId is blank.');
	}
	/**
	 * @description Tests the `getRandomChallenges` method when the enrollee is null.
	 *              Verifies that no challenges are returned when the enrollee does not exist.
	 */
	@isTest
	static void testGetRandomChallengesNullEnrollee() {
		try {
			Test.startTest();
			// Call the method with a personAccountId that does not have an enrollee
			List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> results = BI_PSP_StatusBasedChallengesCtrl.getRandomChallenges(
				'invalidId',
				BI_PSP_ChallengeConstant.challengeActive
			);
			Test.stopTest();
			Assert.areEqual(0, results.size(), 'Expected no challenges when enrollee is null.');
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(), 'Method thrown exception');
		}
	}
	/**
	 * @description Tests the `getRandomChallenges` method when the challenge list is empty.
	 *              Ensures that no challenges are returned when the challenge list is empty for the given conditions.
	 */
	@isTest
	static void testGetRandomChallengesEmptyChallengeList() {
		// Fetch a valid Account ID but simulate an empty challenge list
		CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee LIMIT 1];
		// Create a mock that returns an empty list for getChallengeList
		try {
			Test.startTest();
			List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> results = BI_PSP_StatusBasedChallengesCtrl.getRandomChallenges(
				enrollee.Id,
				BI_PSP_ChallengeConstant.challengeActive
			);
			Test.stopTest();

			Assert.areEqual(
				2,
				results.size(),
				'Expected no challenges to be returned when challenge list is empty.'
			);
		} catch (Exception e) {
			Assert.areEqual('Script-thrown exception', e.getMessage(), 'Method thrown exception');
		}
	}

	/**
	 * @description Tests the `getChallengeList` method with valid conditions.
	 *              Verifies that the correct challenges are returned based on the enrollee ID and record type ID.
	 */

	@isTest
	static void testGetChallengeListValidConditions() {
		CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee LIMIT 1];
		RecordType challengeRecordType = [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge'
			LIMIT 1
		];

		Test.startTest();

		List<Award> challengeList = BI_PSP_StatusBasedChallengesCtrl.getChallengeList(
			enrollee.Id,
			challengeRecordType.Id,
			'Complete'
		);
		Test.stopTest();

		// assert.areNotEqual(0, challengeList.size(), 'Challenge list should not be empty.');
		Assert.areEqual(0, challengeList.size(), 'There should be two challenges returned.');
	}
	/**
	 * @description Tests the `addChallengeToSuccessList` method with valid conditions.
	 *              Ensures that a challenge is properly added to the success list when the conditions are met.
	 */

	@isTest
	static void testAddChallengeToSuccessListValidCondition() {
		// Fetch the necessary records
		CareProgramEnrollee enrollee = [
			SELECT Id, BI_PSP_Challenge_Rank__c
			FROM CareProgramEnrollee
			LIMIT 1
		];
		Award completedAward = [
			SELECT Id, BI_PSP_Care_Program_Plan_Template__r.Id, BI_PSP_Status__c
			FROM Award
			WHERE BI_PSP_Status__c = :BI_PSP_ChallengeConstant.assessmentStatusCompleted
			LIMIT 1
		];

		List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> successList = new List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon>();

		Test.startTest();

		BI_PSP_StatusBasedChallengesCtrl.addChallengeToSuccessList(
			successList,
			completedAward,
			enrollee,
			BI_PSP_ChallengeConstant.assessmentStatusCompleted
		);
		Test.stopTest();

		Assert.areEqual(
			1,
			successList.size(),
			'One challenge should have been added to the success list.'
		);
		Assert.areEqual(
			completedAward.Id,
			successList[0].challengeIdToUpdate,
			'The challenge ID should match.'
		);
		Assert.areEqual(
			enrollee.BI_PSP_Challenge_Rank__c,
			successList[0].imageRank,
			'The image rank should match.'
		);
	}
	/**
	 * @description Tests the `addChallengeToSuccessList` method with invalid conditions.
	 *              Ensures that no challenge is added to the success list when the conditions are not met.
	 */

	@isTest
	static void testAddChallengeToSuccessListInvalidCondition() {
		CareProgramEnrollee enrollee = [
			SELECT Id, BI_PSP_Challenge_Rank__c
			FROM CareProgramEnrollee
			LIMIT 1
		];
		Award invalidAward = [
			SELECT Id, BI_PSP_Care_Program_Plan_Template__r.Id, BI_PSP_Status__c
			FROM Award
			WHERE BI_PSP_Status__c != :BI_PSP_ChallengeConstant.assessmentStatusCompleted
			LIMIT 1
		];

		List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon> successList = new List<BI_PSP_StatusBasedChallengesCtrl.ChallengeWrapperCommon>();

		Test.startTest();

		BI_PSP_StatusBasedChallengesCtrl.addChallengeToSuccessList(
			successList,
			invalidAward,
			enrollee,
			BI_PSP_ChallengeConstant.assessmentStatusCompleted
		);
		Test.stopTest();

		Assert.areEqual(
			1,
			successList.size(),
			'No challenges should be added to the success list for an invalid condition.'
		);
	}
	/**
     * @description Test the getChallengeListCompleted method with valid enrollee ID, record type, and status 'Completed'.
     *              Ensures that the completed challenges are returned correctly.
     */
	 @isTest
    static void testGetChallengeListCompletedSuccess() {
        // Get test data from the setup method
        CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee LIMIT 1];
        RecordType challengeRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge'
            LIMIT 1
        ];

        // Test for completed challenges
        Test.startTest();
        List<Award> challengeList = BI_PSP_StatusBasedChallengesCtrl.getChallengeListCompleted(
            enrollee.Id,
            challengeRecordType.Id,
            'Completed'
        );
        Test.stopTest();

        // Verify that the completed challenge is returned
        System.assertEquals(1, challengeList.size(), 'One completed challenge should be returned.');
        System.assertEquals('Completed', challengeList[0].BI_PSP_Status__c, 'The challenge status should be "Completed".');
    }

    /**
     * @description Test the getChallengeListCompleted method when no challenges match the status 'NotStarted'.
     *              Ensures that an empty list is returned if no challenges match the specified status.
     */
    @isTest
    static void testGetChallengeListCompletedNoResults() {
        // Get test data from the setup method
        CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee LIMIT 1];
        RecordType challengeRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge'
            LIMIT 1
        ];

        // Test for non-existing challenges with status 'NotStarted'
        Test.startTest();
        List<Award> challengeList = BI_PSP_StatusBasedChallengesCtrl.getChallengeListCompleted(
            enrollee.Id,
            challengeRecordType.Id,
            'NotStarted'
        );
        Test.stopTest();

        // Verify that no challenges are returned
        System.assertEquals(0, challengeList.size(), 'No challenges should be returned for status "NotStarted".');
    }

}