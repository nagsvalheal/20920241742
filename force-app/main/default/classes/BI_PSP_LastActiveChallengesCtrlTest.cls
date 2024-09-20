/**
 * @description Test class for the BI_PSP_LastActiveChallengesCtrl Apex controller.
 * This test class validates the behavior of the `getLastActiveChallenges` method with various enrollee ID inputs,
 * ensuring correct handling of valid, invalid, and blank IDs.
 *
 * The test methods cover scenarios where the enrollee ID is valid, invalid, or blank,
 * verifying that the appropriate records are returned or exceptions are thrown as expected.
 * 
 * Reason for using @isTest is to isolate test execution and prevent interactions with live data.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha      14-Aug-2024       Created        Initial development
 */
@isTest
private class BI_PSP_LastActiveChallengesCtrlTest {
    /**
     * @description Sets up test data for the test class.
     *              This includes creating records like `HealthCloudGA__CarePlanTemplate__c`, `CareProgram`, 
     *              `HealthCloudGA__CareProgramPlanTemplate__c`, `Account`, `CareProgramEnrollee`, and `Award`.
     */

    @testSetup
    static void setup() {
        

        // Create RecordType for Award
       
         RecordType challengeRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Award' AND DeveloperName = 'BI_PSP_Challenge' LIMIT 1];

        // Create HealthCloudGA__CarePlanTemplate__c record
        HealthCloudGA__CarePlanTemplate__c carePlanTemplate = new HealthCloudGA__CarePlanTemplate__c(
            Name = 'Test Challenge',
            HealthCloudGA__Description__c = 'Description of the challenge',
            BI_PSP_Challenge_Level__c = 'Level 1',
            BI_PSP_Challenge_Image__c = 'Image URL',
            BI_PSP_Challenge_Reward_Points__c = 100
        );
        insert carePlanTemplate;
         // Create CareProgram
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today() 
        );
        insert careProgram;

        // Create HealthCloudGA__CareProgramPlanTemplate__c record
        HealthCloudGA__CareProgramPlanTemplate__c careProgramPlanTemplate = new HealthCloudGA__CareProgramPlanTemplate__c(
             HealthCloudGA__CareProgram__c = careProgram.Id,
            HealthCloudGA__CarePlanTemplate__c = carePlanTemplate.Id
        );
        insert careProgramPlanTemplate;
        
         // Create Account
        Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com',
            BI_PSPB_User_Type__c = 'Patient'
        );
        insert patientAccount;

       // Create CareProgramEnrollee
        CareProgramEnrollee enrollee = new CareProgramEnrollee(
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            Name = 'Enrollee Record',
            BI_PSP_Total_Reward_Points__c = 100,
            BI_PSP_DOC_Novice__c = Date.today(),
            BI_PSP_DOC_Intermediate__c = Date.today(),
            BI_PSP_DOC_Proficient__c = Date.today(),
            BI_PSP_DOC_Expert__c = Date.today(),
            BI_PSP_Challenge_Rank__c = 'GPP novice',
            BI_PSP_DOC_Beginner__c = Date.today()
        );
        insert enrollee;

        // Create Award
        Award lastActiveAward = new Award(
            Name ='challenge',
            BI_PSP_Care_Program_Plan_Template__c = careProgramPlanTemplate.Id,
            BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
            BI_PSP_Status__c = BI_PSP_ChallengeConstant.challengeActive,
            RecordTypeId = challengeRecordType.Id
        );
        insert lastActiveAward;
    }
 /**
     * @description Tests the `getLastActiveChallenges` method with a valid enrollee ID.
     *              Verifies that the correct care plan template is returned with the expected details.
     */
    @isTest
    static void testGetLastActiveChallengesWithValidEnrolleeId() {
        CareProgramEnrollee enrollee = [SELECT Id FROM CareProgramEnrollee LIMIT 1];

        Test.startTest();
        HealthCloudGA__CarePlanTemplate__c carePlanTemplate = BI_PSP_LastActiveChallengesCtrl.getLastActiveChallenges(enrollee.Id);
        Test.stopTest();

    Assert.areEqual('Test Challenge', carePlanTemplate.Name, 'The care plan template name does not match');
    Assert.areEqual('Description of the challenge', carePlanTemplate.HealthCloudGA__Description__c, 'The care plan template description does not match');
    Assert.areEqual('Level 1', carePlanTemplate.BI_PSP_Challenge_Level__c, 'The care plan template level does not match');
    Assert.areEqual('Image URL', carePlanTemplate.BI_PSP_Challenge_Image__c, 'The care plan template image URL does not match');
    Assert.areEqual(100, carePlanTemplate.BI_PSP_Challenge_Reward_Points__c, 'The care plan template reward points do not match');
    }
 /**
     * @description Tests the `getLastActiveChallenges` method with an invalid enrollee ID.
     *              Ensures that an AuraHandledException is thrown with the expected error message.
     */
    @isTest
    static void testGetLastActiveChallengesWithInvalidEnrolleeId() {
        Test.startTest();
        try {
            BI_PSP_LastActiveChallengesCtrl.getLastActiveChallenges('InvalidId');
            Assert.areEqual(false,true, 'Expected AuraHandledException was not thrown');
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
     * @description Tests the `getLastActiveChallenges` method with a blank enrollee ID.
     *              Ensures that an AuraHandledException is thrown with the expected error message.
     */
    @isTest
    static void testGetLastActiveChallengesWithBlankEnrolleeId() {
        Test.startTest();
        try {
            BI_PSP_LastActiveChallengesCtrl.getLastActiveChallenges('');
            Assert.areEqual(false, true, 'Expected AuraHandledException was not thrown');
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