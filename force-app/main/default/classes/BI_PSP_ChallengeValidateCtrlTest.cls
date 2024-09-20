/**
 * @description Test class for the BI_PSP_ChallengeValidateCtrl Apex controller.
 * This test class validates the behavior of the methods in the `BI_PSP_ChallengeValidateCtrl` class,
 * ensuring correct processing of symptom trackers and assessments.
 *
 * The test methods cover scenarios for validating symptom trackers by different levels,
 * including SymptomOne, SymptomTwo, and SymptomThree, and assessment validation.
 * Each method ensures that the percentage and status are set correctly based on the input data.
 * 
 * Reason for using @isTest is to isolate test execution and prevent interactions with live data.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha      14-Aug-2024       Created        Initial development
 */
@IsTest
public class BI_PSP_ChallengeValidateCtrlTest {
	 /**
     * @description Setup test data for the `BI_PSP_ChallengeValidateCtrl` test class.
     *              Creates records for Care Program, Care Plan Templates, Care Program Plan Template,
     *              Account, Care Program Enrollee, Award records, and Assessments for test methods.
     */
    @TestSetup
    static void setupTestData() {
        // Create Care Program
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today()
        );
        insert careProgram;

        // Create Care Plan Templates
        HealthCloudGA__CarePlanTemplate__c carePlanOne = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstant.symptomOne,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstant.challengeLevelOne
        );
        insert carePlanOne;

        HealthCloudGA__CarePlanTemplate__c carePlanTwo = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstant.symptomTwo,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstant.challengeLevelTwo
        );
        insert carePlanTwo;

        HealthCloudGA__CarePlanTemplate__c carePlanThree = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstant.symptomThree,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstant.challengeLevelThree
        );
        insert carePlanThree;

        // Create Care Program Plan Template
        HealthCloudGA__CareProgramPlanTemplate__c careProgramPlan = new HealthCloudGA__CareProgramPlanTemplate__c(
            HealthCloudGA__CareProgram__c = careProgram.Id,
            HealthCloudGA__CarePlanTemplate__c = carePlanOne.Id
        );
        insert careProgramPlan;

        // Create Account
        Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com'
        );
        insert patientAccount;

        // Create Care Program Enrollee
        CareProgramEnrollee enrollee = new CareProgramEnrollee(
            Name = 'CPE',
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            BI_PSP_Challenge_Rank__c = 'GPP beginner'
        );
        insert enrollee;

        // Create Award records
        Award awardOne = new Award(
            Name = 'Award One',
            BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
            BI_PSP_Care_Program_Plan_Template__c = careProgramPlan.Id,
            BI_PSP_Status__c = 'Active',
            BI_PSP_Reward_Points__c = 60
        );
        insert awardOne;

        Award awardTwo = new Award(
            Name = 'Award Two',
            BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
            BI_PSP_Care_Program_Plan_Template__c = careProgramPlan.Id,
            BI_PSP_Status__c = 'Active',
            BI_PSP_Reward_Points__c = 100
        );
        insert awardTwo;

        // Create Assessments
        List<Assessment> assessments = new List<Assessment>();
        assessments.add(new Assessment(
            Name = 'WPAI',
            AssessmentStatus = BI_PSP_ChallengeConstant.assessmentStatusCompleted,
            BI_PSP_DateForCQ__c = ''
        ));
        assessments.add(new Assessment(
            Name = 'PSS',
            AssessmentStatus = BI_PSP_ChallengeConstant.assessmentStatusCompleted,
            BI_PSP_DateForCQ__c = ''
        ));
        insert assessments;
    }
 /**
     * @description Tests the `validateSymptomTrackerByLevel` method with SymptomOne.
     *              Ensures that the percentage is correctly set to 0 when processing SymptomOne.
     */
    @IsTest
    static void testValidateSymptomTrackerByLevelSymptomOne() {
        // Retrieve Care Plan and Award records
        HealthCloudGA__CarePlanTemplate__c carePlanOne = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstant.symptomOne LIMIT 1];
        Award awardOne = [SELECT Id,Name,BI_PSP_Care_Program_Enrollee__r.Id,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,BI_PSP_Reward_Points__c FROM Award LIMIT 1];

        // Create ChallengeWrapper
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        // Execute method and assert
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateSymptomTrackerByLevel(carePlanOne, awardOne, wrapper);
        Test.stopTest();

        Assert.areEqual(0, result.percentage, 'Expected percentage to be 100% for SymptomOne.');
    }
/**
     * @description Tests the `validateSymptomTrackerByLevel` method with SymptomTwo.
     *              Ensures that the percentage is correctly set to 0 when processing SymptomTwo.
     */
    @IsTest
    static void testValidateSymptomTrackerByLevelSymptomTwo() {
        // Retrieve Care Plan and Award records
        HealthCloudGA__CarePlanTemplate__c carePlanTwo = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstant.symptomTwo LIMIT 1];
        Award awardTwo = [SELECT Id,Name,BI_PSP_Care_Program_Enrollee__r.Id,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,BI_PSP_Reward_Points__c FROM Award LIMIT 1];

        // Create ChallengeWrapper
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        // Execute method and assert
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateSymptomTrackerByLevel(carePlanTwo, awardTwo, wrapper);
        Test.stopTest();

        Assert.areEqual(0, result.percentage, 'Expected percentage to be 100% for SymptomTwo.');
    }
/**
     * @description Tests the `validateSymptomTrackerByLevel` method with SymptomThree.
     *              Ensures that the percentage is correctly set to 100 when processing SymptomThree.
     */
    @IsTest
    static void testValidateSymptomTrackerByLevelSymptomThree() {
       
        HealthCloudGA__CarePlanTemplate__c carePlanThree = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstant.symptomThree LIMIT 1];
        Award awardThree = [SELECT Id,Name,BI_PSP_Care_Program_Enrollee__r.Id,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,BI_PSP_Reward_Points__c FROM Award LIMIT 1];

        
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateSymptomTrackerByLevel(carePlanThree, awardThree, wrapper);
        Test.stopTest();

        Assert.areEqual(100, result.percentage, 'Expected percentage to be 100% for SymptomThree.');
    }
/**
     * @description Tests the `validateSymptomTracker` method.
     *              Ensures that the percentage is correctly set to 0 when the symptom tracker validation is successful.
     */
   /* @IsTest
    static void testValidateSymptomTracker() {
        
        Award award = [SELECT Id, BI_PSP_Care_Program_Enrollee__r.Id FROM Award LIMIT 1];

        
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateSymptomTracker(award, wrapper, 1, 'Minimum entries not met');
        Test.stopTest();

        Assert.areEqual(0, result.percentage, 'Expected percentage to be 100% when validation is successful.');
    }*/
/**
     * @description Tests the `validateAssessmentByLevel` method.
     *              Ensures that the percentage is correctly set to null when the assessment validation by level is successful.
     */
    @IsTest
    static void testValidateAssessmentByLevel() {
       
        HealthCloudGA__CarePlanTemplate__c carePlan = [SELECT Id, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c LIMIT 1];
        Award award = [SELECT Id FROM Award LIMIT 1];
        List<Assessment> assessments = [SELECT Id, Name, AssessmentStatus FROM Assessment LIMIT 1];

        
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

       
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateAssessmentByLevel(carePlan, assessments, award, wrapper);
        Test.stopTest();

        Assert.areEqual(null, result.percentage, 'Expected percentage to be 100% when assessment validation is successful.');
    }
/**
     * @description Tests the `validateAssessment` method.
     *              Ensures that the percentage is correctly set to 0 when the specific assessment is found.
     */
    @IsTest
    static void testValidateAssessment() {
       
        List<Assessment> assessments = [SELECT Id, Name, AssessmentStatus, BI_PSP_DateForCQ__c FROM Assessment LIMIT 1];
        Award award = [SELECT Id FROM Award LIMIT 1];

        // Create ChallengeWrapper
        BI_PSP_ChallengeCtrl.ChallengeWrapper wrapper = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        // Execute method and assert
        Test.startTest();
        BI_PSP_ChallengeCtrl.ChallengeWrapper result = BI_PSP_ChallengeValidateCtrl.validateAssessment(assessments, award, 'WPAI', wrapper, 'Assessment not found');
        Test.stopTest();

        Assert.areEqual(0, result.percentage, 'Expected percentage to be 100% when the specific assessment is found.');
    }
}