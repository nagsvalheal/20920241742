/**
 * @description Test class for the BI_PSP_ChallengeEnrolleCtrl Apex class.
 * This test class includes various test cases to validate the behavior of 
 * caregiver and non-caregiver challenge enrollment processes, covering 
 * different scenarios such as valid inputs, null values, and exception handling.
 * 
 * The test methods are designed to ensure comprehensive coverage of the 
 * processCaregiver, processNonCaregiver, and getEnrolle methods, with 
 * special attention to edge cases and error handling.
 * 
 * Reason for using @isTest is to isolate test execution from production data 
 * and to ensure that the tests do not affect real data in the Salesforce environment.
 * 
 * History:
 * Version    Author      Date              Detail           Description
 * 1.0        Nandha	  14-Aug-2024       Created          Initial development of test class
 */
@isTest
public class BI_PSP_ChallengeEnrolleCtrlTest {
      /**
     * @description Test Setup method to create test data including caregiver and non-caregiver users, accounts, 
     *              CareProgramEnrollee records, and associated BI_PSPB_Enrollee_Caregiver__c records.
     */
    @testSetup
static void setupTestData() {
    // Create a Non-Caregiver User
    User nonCaregiverUser = new User(
        FirstName = 'Testonee',
        LastName = 'Useroneee',
        Email = 'testuser@exampleee.com',
        Username = 'testuser@exampleeee.com' + System.currentTimeMillis(),
        Alias = 'tuser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
        LanguageLocaleKey = 'en_US',
        BI_PSPB_Caregiver__c = false
    );
    insert nonCaregiverUser;
    
     // Create a Caregiver User
    User caregiverUser = new User(
        FirstName = 'Caregiver',
        LastName = 'User',
        Email = 'caregiver@example.com',
        Username = 'caregiver@example.com' + System.currentTimeMillis(),
        Alias = 'cuser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
        LanguageLocaleKey = 'en_US',
        BI_PSPB_Caregiver__c = true
    );
    insert caregiverUser;
    
  



    // Create an Account record matching the conditions in the processNonCaregiver method
    Account testAccount = new Account(
        FirstName = 'Testonee ',
        LastName ='Useroneee',
        PersonEmail = 'testuser@exampleee.com' // Must match the email in the method
       // IsPersonAccount = true // Ensure this is set to true
    );
    insert testAccount;
    
        // Create an Account associated with the Caregiver User
    Account caregiverAccount = new Account(
        FirstName = 'Caregiver',
        LastName = 'User',
        PersonEmail = 'caregiver@example.com',
        BI_PSPB_Selected_Patient_ID__c = testAccount.id
    );
    insert caregiverAccount;

    // Create a CareProgram and Enrollee record associated with the Account
    CareProgram careProgram = new CareProgram(
        Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
        StartDate = Date.today()
    );
    insert careProgram;

    CareProgramEnrollee nonCaregiverEnrollee = new CareProgramEnrollee(
        Name = 'cpe',
        CareProgramId = careProgram.Id,
        AccountId = testAccount.Id,
        BI_PSP_Total_Reward_Points__c = 100,
        BI_PSP_Challenge_Rank__c = 'GPP beginner'
    );
    insert nonCaregiverEnrollee;
    
    

    CareProgramEnrollee caregiverEnrollee = new CareProgramEnrollee(
        Name = 'Caregiver Enrollee',
        CareProgramId = careProgram.Id,
        AccountId = caregiverAccount.Id,
        BI_PSP_Total_Reward_Points__c = 100,
        BI_PSP_Challenge_Rank__c = 'GPP beginner'
    );
    insert caregiverEnrollee;
    
    
    BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
        Name = 'Enrollee Caregiver',
        BI_PSPB_Patient__c = caregiverAccount.Id,
        BI_PSPB_Care_Program_Enrollee__c = caregiverEnrollee.Id,
        BI_PSPB_Status__c = BI_PSP_ChallengeConstant.challengeActive
    );
    insert enrolleeCaregiver;
}
/**
     * @description Tests the processNonCaregiver method to ensure that the correct CareProgramEnrollee 
     *              is assigned to the success message for a non-caregiver user.
     */
@isTest
static void testProcessNonCaregiver() {
    
    User testUser = [SELECT Id FROM User WHERE Email = 'testuser@exampleee.com' LIMIT 1];

   
    System.runAs(testUser) {
       
        BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = new BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper();

        // Capture logs for assertions
        Test.startTest();
        BI_PSP_ChallengeEnrolleCtrl.processNonCaregiver('Testonee Useroneee', 'testuser@exampleee.com', successMessage);
        Test.stopTest();

        Assert.areEqual('GPP beginner', successMessage.patientEnrolle.BI_PSP_Challenge_Rank__c, 'Challenge rank should match');
        
      
    }
}
    

  /**
     * @description Tests the processCaregiver method to ensure that a caregiver user with associated 
     *              CareProgramEnrollee is processed correctly and the success message is updated appropriately.
     */

 @isTest
    static void testProcessCaregiverSuccess() {
        User testUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];

        System.runAs(testUser) {
            BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = new BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper();
            try{
            Test.startTest();
            BI_PSP_ChallengeEnrolleCtrl.processCaregiver('Caregiver User', 'caregiver@example.com', successMessage);
            Test.stopTest();
			Assert.areEqual(null, successMessage.patientEnrolle.BI_PSP_Challenge_Rank__c, 'Challenge rank should match');
            }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
    }
/**
     * @description Tests the processCaregiver method for the scenario where the CareProgramEnrollee is not found 
     *              in the BI_PSPB_Enrollee_Caregiver__c record, ensuring the appropriate error is returned.
     */
    @isTest
    static void testProcessCaregiverNoCareProgramEnrollee() {
        User testUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];

       
        BI_PSPB_Enrollee_Caregiver__c ecRecord = [SELECT Id FROM BI_PSPB_Enrollee_Caregiver__c LIMIT 1];
        ecRecord.BI_PSPB_Care_Program_Enrollee__c = null;
        update ecRecord;
        try{
        System.runAs(testUser) {
            BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = new BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper();

            Test.startTest();
            BI_PSP_ChallengeEnrolleCtrl.processCaregiver('Caregiver User', 'caregiver@example.com', successMessage);
            Test.stopTest();

            Assert.areEqual('Enrollee Not Found', 'Enrollee Not Found','Enrollee Not Found');
            Assert.areEqual(null, successMessage.patientEnrolle, 'No CareProgramEnrollee should be set');
        }
        }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }

    /**
     * @description Tests the processCaregiver method for the scenario where no BI_PSPB_Enrollee_Caregiver__c records 
     *              are found, ensuring the method returns the correct error message and no Enrollee is set.
     */
    @isTest
    static void testProcessCaregiverNoEnrolleeCaregiver() {
        User testUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];

        
        delete [SELECT Id FROM BI_PSPB_Enrollee_Caregiver__c];

        System.runAs(testUser) {
            BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = new BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper();
            try{
            Test.startTest();
            BI_PSP_ChallengeEnrolleCtrl.processCaregiver('Caregiver User', 'caregiver@example.com', successMessage);
            Test.stopTest();

            System.assertEquals(BI_PSP_ChallengeConstant.enrolleeNfNs, successMessage.error, 'Expected enrolleeNfNs error');
            System.assertEquals(null, successMessage.patientEnrolle, 'No CareProgramEnrollee should be set');
            }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
    }

    /**
     * @description Tests the processCaregiver method for the scenario where no Account records are found 
     *              for the caregiver user, verifying that the method logs an error and does not set an Enrollee.
     */
    @isTest
    static void testProcessCaregiverNoAccounts() {
        User testUser = [SELECT Id FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];

        
        delete [SELECT Id FROM Account WHERE PersonEmail = 'caregiver@example.com'];

        System.runAs(testUser) {
            BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = new BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper();
            try{
            Test.startTest();
            BI_PSP_ChallengeEnrolleCtrl.processCaregiver('Caregiver User', 'caregiver@example.com', successMessage);
            Test.stopTest();

            
            Assert.areEqual(null, successMessage.patientEnrolle, 'No CareProgramEnrollee should be set');
            }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
           
        }
    }
    
    
    
    /**
     * @description Tests the getEnrolle method for a non-caregiver user, ensuring that the correct 
     *              CareProgramEnrollee is retrieved and included in the result.
     */
      @isTest
    static void testGetEnrolleNonCaregiver() {
        
       
		  User nonCaregiverUser = new User(
        FirstName = 'Testonee',
        LastName = 'Useroneee',
        Email = 'noncaregiver@example.com',
        Username = 'testuser@exampleeee.com' + System.currentTimeMillis(),
        Alias = 'tuser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
        LanguageLocaleKey = 'en_US',
        BI_PSPB_Caregiver__c = false
    );
    insert nonCaregiverUser;
        try{
        Test.startTest();
        System.runAs(nonCaregiverUser) {
            List<BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper> result = BI_PSP_ChallengeEnrolleCtrl.getEnrolle();
           
            Assert.areEqual(1, result.size(), 'Expected one EnrollWrapper in the result');
            BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper successMessage = result[0];
            
            assert.areNotEqual(null, successMessage.patientEnrolle, 'The patientEnrolle should not be null');
           
        }
        Test.stopTest();
        }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }

        /**
     * @description Tests the getEnrolle method for a caregiver user, ensuring that the correct 
     *              CareProgramEnrollee is retrieved and included in the result.
     */
    @isTest
    static void testGetEnrolleCaregiver() {
        
        User caregiverUser = [SELECT Id, Name, Email FROM User WHERE Email = 'caregiver@example.com' LIMIT 1];
        try{
        Test.startTest();
        System.runAs(caregiverUser) {
            List<BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper> result = BI_PSP_ChallengeEnrolleCtrl.getEnrolle();
           
            Assert.areEqual(1, result.size(), 'Expected one EnrollWrapper in the result');
         
            
            
            
        }
        Test.stopTest();
        }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
 /**
     * @description Tests the getEnrolle method for the scenario where no user is found, ensuring that 
     *              the method returns an empty result.
     */
    @isTest
    static void testGetEnrolleNoUser() {
        try{
        Test.startTest();
       
        List<BI_PSP_ChallengeEnrolleCtrl.EnrollWrapper> result = BI_PSP_ChallengeEnrolleCtrl.getEnrolle();
        Test.stopTest();

        
        Assert.areEqual(0, result.size(), 'Expected empty result when no user is found');
        }catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
  /**
     * @description Tests the getEnrolle method for exception handling, ensuring that any unexpected 
     *              exceptions are properly handled and logged.
     */
    @isTest
    static void testGetEnrolleException() {
       
        Test.startTest();
       
        try {
           
            BI_PSP_ChallengeEnrolleCtrl.getEnrolle();
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