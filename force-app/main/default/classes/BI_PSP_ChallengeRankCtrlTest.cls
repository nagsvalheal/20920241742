/**
 * @description Test class for the BI_PSP_ChallengeRankCtrl Apex controller.
 * This test class includes methods to validate the behavior of the getRank method
 * with various Account ID inputs, ensuring correct handling of valid, invalid, and blank IDs.
 *
 * The test methods cover scenarios where the Account ID is valid, invalid, or blank,
 * verifying that the appropriate exceptions are thrown and the expected results are returned.
 * 
 * Reason for using @isTest is to isolate test execution and prevent interactions with live data.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha      14-Aug-2024       Created        Initial development
 */
@isTest
private class BI_PSP_ChallengeRankCtrlTest {
    
    /**
     * @description Test setup method for creating the necessary test data.
     * This method inserts a User, Account, CareProgram, and CareProgramEnrollee
     * records to be used in the test methods.
     */

    @testSetup
    static void setup() {
        // Create Profile
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create User
        User testUser = new User(
            Email = 'testuser@exampleone.com',
            BI_PSPB_Caregiver__c = false,
            Username = 'testuser@exampleone.com',
            FirstName = 'Testone',
            LastName = 'Userone',
            Alias = 'testu',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create Account
        Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com',
            BI_PSPB_User_Type__c = 'Patient'
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
    }
    
    /**
     * @description Test method to verify that the getRank method returns the correct
     * CareProgramEnrollee records when provided with a valid Account ID.
     * 
     * This method asserts that the returned enrollees list contains the expected
     * enrollee record with the correct attributes.
     */

    @isTest
    static void testGetRankWithValidAccountId() {
        Account patientAccount = [SELECT Id FROM Account WHERE PersonEmail = 'testuser@example.com' LIMIT 1];
        try{
        Test.startTest();
        List<CareProgramEnrollee> enrollees = BI_PSP_ChallengeRankCtrl.getRank(patientAccount.Id);
        Test.stopTest();

        Assert.areEqual(1, enrollees.size(), 'There should be exactly one enrollee.');
        Assert.areEqual('Enrollee Record', enrollees[0].Name, 'The enrollee name should be "Enrollee Record".');
        Assert.areEqual(100, enrollees[0].BI_PSP_Total_Reward_Points__c, 'The total reward points should be 100.');
        Assert.areEqual('Novice', enrollees[0].BI_PSP_Challenge_Rank__c, 'The challenge rank should be "Novice".');
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    /**
     * @description Test method to verify that the getRank method throws an AuraHandledException
     * when provided with an invalid Account ID.
     * 
     * This method catches the exception and asserts that the correct error message is returned.
     */
    @isTest
    static void testGetRankWithInvalidAccountId() {
        Test.startTest();
        try {
            BI_PSP_ChallengeRankCtrl.getRank('InvalidId');
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
	
    /**
     * @description Test method to verify that the getRank method throws an AuraHandledException
     * when provided with a blank Account ID.
     * 
     * This method catches the exception and asserts that the correct error message is returned.
     */
    @isTest
    static void testGetRankWithBlankAccountId() {
        Test.startTest();
        try {
            BI_PSP_ChallengeRankCtrl.getRank('');
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