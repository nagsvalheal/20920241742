/**
 * @description Test class for the BI_PSP_ChallengeConstant Apex class.
 * The test class ensures that all challenge-related constants in the 
 * BI_PSP_ChallengeConstant class are properly initialized and non-null.
 * It checks various constants representing different challenge levels, statuses, 
 * and error messages to verify their presence and correctness.
 * 
 * The test method covers scenarios for validating that each constant retrieves 
 * a non-null label, which is essential for ensuring the correct configuration 
 * of challenge-related constants used throughout the application.
 * 
 * Reason for using @isTest is to isolate test execution and prevent interactions 
 * with live data, ensuring that the test results are reliable and consistent.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha J        14-Aug-2024       Initial         Created test class to validate BI_PSP_ChallengeConstant constants
 */
@IsTest
public class BI_PSP_ChallengeConstantTest {

    @IsTest
    public static void testChallengeConstants() {
        // Validate that each constant in BI_PSP_ChallengeConstantCtrl retrieves the correct label

        assert.areNotEqual(null, BI_PSP_ChallengeConstant.symptomOne, 'SymptomOne label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.symptomTwo, 'SymptomTwo label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.questionnaireLevelOne, 'QuestionnaireLevelOne label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.questionnaireLevelTwo, 'QuestionnaireLevelTwo label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.questionnaireLevelThree, 'QuestionnaireLevelThree label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.iamRegularLevelOne, 'IamRegularLevelOne label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.iamRegularLevelTwo, 'IamRegularLevelTwo label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.iamRegularLevelThree, 'IamRegularLevelThree label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.gppExpertLevelOne, 'GppExpertLevelOne label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.gppExpertLevelTwo, 'GppExpertLevelTwo label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.gppExpertLevelThree, 'GppExpertLevelThree label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.enrolleeNf, 'EnrolleeNf label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.caregiverNf, 'CaregiverNf label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.enrolleeNfNs, 'EnrolleeNfNs label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeActive, 'ChallengeActive label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeAvailable, 'ChallengeAvailable label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeCompleted, 'ChallengeCompleted label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeLevelOne, 'ChallengeLevelOne label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeLevelTwo, 'ChallengeLevelTwo label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengeLevelThree, 'ChallengeLevelThree label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.completeOneSt, 'CompleteOneSt label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.completeFourSt, 'CompleteFourSt label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.currentlyCompleted, 'CurrentlyCompleted label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.assessmentWpai, 'AssessmentWpai label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.assessmentStatusCompleted, 'AssessmentStatusCompleted label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.completeWpai, 'CompleteWpai label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.assessmentPss, 'AssessmentPss label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.completePss, 'CompletePss label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.assessmentDlqi, 'AssessmentDlqi label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.completeDlqi, 'CompleteDlqi label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.challengesErrorMessage, 'ChallengesErrorMessage label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.userIdErrorMessage, 'UserIdErrorMessage label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.careProgramTemplateErrorMessage, 'CareProgramTemplateErrorMessage label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.careProgramEnrolleeErrorMessage, 'CareProgramEnrolleeErrorMessage label should not be null');
        assert.areNotEqual(null, BI_PSP_ChallengeConstant.enrolleeCaregiverErrorMessage, 'EnrolleeCaregiverErrorMessage label should not be null');
      
    }
}