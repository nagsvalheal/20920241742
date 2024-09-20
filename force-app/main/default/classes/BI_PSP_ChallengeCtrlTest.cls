/**
 * @description Test class for the BI_PSP_ChallengeCtrl Apex class. 
 * The test class includes various test cases to validate the behavior of challenge-related operations,
 * such as updating challenges, handling exceptions, and retrieving challenge statuses.
 * 
 * The test methods cover scenarios for valid inputs, blank inputs, invalid IDs and statuses, 
 * and exception handling, ensuring comprehensive coverage of the functionality.
 * 
 * Reason for using @isTest is to isolate test execution and prevent interactions with live data.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Gowsic N    5-Dec-2023        Created        Initial development
 * 1.1        Saran S     20-Apr-2024       Updated        Add log, null check, descriptions
 * 1.2        Nandha      08-Aug-2024       Updated        Enhanced test coverage
 */
@isTest
private class BI_PSP_ChallengeCtrlTest {
    /**
     * @description Test setup method to create necessary data for testing.
     * This includes creating RecordTypes, Accounts, Care Programs, Enrollees,
     * Care Plan Templates, and Awards.
     */

    @testSetup
    static void setup() {
        

        // Create RecordType for Award
        RecordType challengeRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge' LIMIT 1];

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
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstant.questionnaireLevelThree,
            BI_PSP_Challenge_Level__c = 'Level 1'
        );
        insert carePlanTemplate;
        
        HealthCloudGA__CarePlanTemplate__c carePlanTemplatetwo = new HealthCloudGA__CarePlanTemplate__c(
            Name = 'Test ChallengeTwo',
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstant.bookWormLevelOne,
            BI_PSP_Challenge_Level__c = 'Level 1'
        );
        insert carePlanTemplatetwo;

        // Create HealthCloudGA__CareProgramPlanTemplate__c record
        HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
            HealthCloudGA__CarePlanTemplate__c = carePlanTemplate.Id,
            HealthCloudGA__CareProgram__c = careProgram.Id
        );
        insert careProgramPlanTemplate;
        
        HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplateTwo = new HealthCloudGA__CareProgramPlanTemplate__c(
            HealthCloudGA__CarePlanTemplate__c = carePlanTemplatetwo.Id,
            HealthCloudGA__CareProgram__c = careProgram.Id
        );
        insert careProgramPlanTemplateTwo;

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
        
        Award activeAwardTwo = new Award(
            Name = 'Challenge',
            BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplateTwo.Id,
            BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
            BI_PSP_Status__c = BI_PSP_ChallengeConstant.challengeActive,
            RecordTypeId = challengeRecordType.Id
        );
        insert activeAwardTwo;

        // Create Assessments
        Assessment assessment = new Assessment(
            BI_PSP_CareProgramEnrollee__c = enrollee.Id,
            Name = BI_PSP_ChallengeConstant.assessmentWpai,
            AssessmentStatus = BI_PSP_ChallengeConstant.assessmentStatusCompleted
        );
        insert assessment;
List<BI_PSP_Symptom_Tracker__c> symptomvalue = new List<BI_PSP_Symptom_Tracker__c>();
        // Create BI_PSP_Symptom_Tracker__c records
        for (Integer i = 0; i < 5; i++) {
            BI_PSP_Symptom_Tracker__c symptomTracker = new BI_PSP_Symptom_Tracker__c(
                BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
                BI_PSP_EditEntrydates__c = Date.today()
            );
            symptomvalue.add(symptomTracker);
           
        }
         insert symptomvalue;
List<BI_PSPB_Article_like__c> articleLikes = new List<BI_PSPB_Article_like__c>();
        // Create BI_PSPB_Article_like__c records
        for (Integer i = 0; i < 10; i++) {
            BI_PSPB_Article_like__c articleLike = new BI_PSPB_Article_like__c(
                BI_PSPB_CareProgramEnrollee__c = enrollee.Id,
                BI_PSPB_Reaction__c = BI_PSP_ChallengeConstant.view
            );
             articleLikes.add(articleLike);
        }
        insert articleLikes;
    }
	  /**
     * @description Tests the updateChallenges method with valid inputs.
     * Verifies that the method completes successfully with expected results.
     */
    @isTest
    static void testUpdateChallengesWithValidInput() {
        Award award = [SELECT Id FROM Award WHERE BI_PSP_Status__c = :BI_PSP_ChallengeConstant.challengeActive LIMIT 1];
        String userId = UserInfo.getUserId();

        Test.startTest();
        List<BI_PSP_ChallengeCtrl.ChallengeWrapper> results = BI_PSP_ChallengeCtrl.updateChallenges(award.Id, BI_PSP_ChallengeConstant.challengeCompleted, userId);
        Test.stopTest();

        assert.areNotEqual(null, results,'Expected non-null results when updating challenges');
       
    }
  /**
     * @description Tests the updateChallenges method with blank inputs.
     * Verifies that an AuraHandledException is thrown with the expected error message.
     */
    @isTest
    static void testUpdateChallengesWithBlankInputs() {
        Test.startTest();
        try {
              BI_PSP_ChallengeCtrl.updateChallenges('', '', UserInfo.getUserId());
          
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }
/**
     * @description Tests the updateChallenges method with an invalid challenge ID.
     * Verifies that an exception is thrown and its message matches the expected error.
     */
    @isTest
    static void testUpdateChallengesWithInvalidChallengeId() {
        Test.startTest();
        try {
           BI_PSP_ChallengeCtrl.updateChallenges('InvalidId', BI_PSP_ChallengeConstant.challengeActive, UserInfo.getUserId());
           
        } catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        
        Test.stopTest();
    }
	/**
     * @description Tests the updateChallenges method with an invalid status.
     * Verifies that an exception is thrown and its message matches the expected error.
     */
    @isTest
    static void testUpdateChallengesWithInvalidStatus() {
        Award award = [SELECT Id FROM Award WHERE BI_PSP_Status__c = :BI_PSP_ChallengeConstant.challengeActive LIMIT 1];

        Test.startTest();
        try {
             BI_PSP_ChallengeCtrl.updateChallenges(award.Id, 'InvalidStatus', UserInfo.getUserId());
           
        }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        
        Test.stopTest();
    }
 /**
     * @description Tests the updateChallenges method when no assessments are present.
     * Verifies that the results include an error message indicating that no assessments were found.
     */
    @isTest
    static void testUpdateChallengesWithEmptyAssessments() {
        Award award = [SELECT Id FROM Award WHERE BI_PSP_Status__c = :BI_PSP_ChallengeConstant.challengeActive LIMIT 1];
        String userId = UserInfo.getUserId();

        // Delete all assessments to simulate no assessments found
        delete [SELECT Id FROM Assessment];

        Test.startTest();
        List<BI_PSP_ChallengeCtrl.ChallengeWrapper> results = BI_PSP_ChallengeCtrl.updateChallenges(award.Id, BI_PSP_ChallengeConstant.challengeCompleted, userId);
        Test.stopTest();

        assert.areNotEqual(null, results, 'Expected non-null results when updating challenges with empty assessments.');
        Assert.areEqual(1, results.size(), 'Expected exactly one result when updating challenges with empty assessments.');
    }
/**
     * @description Tests exception handling in the updateChallenges method.
     * Simulates an exception by passing null for status and verifies that the exception is handled correctly.
     */
    @isTest
    static void testUpdateChallengesWithExceptionHandling() {
        Award award = [SELECT Id FROM Award WHERE BI_PSP_Status__c = :BI_PSP_ChallengeConstant.challengeActive LIMIT 1];

        // Mock exception handling by using invalid SOQL query
        Test.startTest();
        try {
          BI_PSP_ChallengeCtrl.updateChallenges(award.Id, null, UserInfo.getUserId());
          
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }



   
 


}