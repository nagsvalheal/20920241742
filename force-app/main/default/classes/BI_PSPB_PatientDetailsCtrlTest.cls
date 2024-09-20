@isTest
/** 
* @description       : This is a BI_PSPB_PatientDetailsCtrlTest test class designed to test the functionality of the BI_PSPB_PatientDetailsCtrl class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_PatientDetailsCtrlTest {
    @testSetup
    static void setup() {
        // Create test data for Enrollee Caregiver
        Account caregiverAccount = new Account(Name = 'Test Caregiver');
        insert caregiverAccount;
        
        Account patientAccount = new Account(Name = 'Test Patient');
        insert patientAccount;
        
        BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            Name = 'Test Enrollee Caregiver',
            BI_PSPB_Caregiver__c = caregiverAccount.Id,
            BI_PSPB_Patient__r = patientAccount,
            BI_PSPB_Status__c = 'Active'
        );
        insert enrolleeCaregiver;

        // Create an Account for caregiver switch testing
        Account switchAccount = new Account(Name = 'Switch Caregiver', BI_PSPB_CaregiverCheck__c = false);
        insert switchAccount;
    }

    @isTest
    static void testBuildConditions() {
        String currentUserName = 'Test Caregiver';
        String currentUserEmail = 'testcaregiver@example.com';
        Boolean isActive = true;

        String conditions = BI_PSPB_PatientDetailsCtrl.buildConditions(currentUserName, currentUserEmail, isActive);
        Assert.areEqual(
    'BI_PSPB_Caregiver__r.Name = \'Test Caregiver\' AND BI_PSPB_Caregiver__r.PersonEmail = \'testcaregiver@example.com\' AND BI_PSPB_Status__c = \'Active\'', 
    conditions, 
    'The query conditions do not match the expected string.'
);

    }

    @isTest
    static void testGetCareEnrolleeCaregiver() {
         try{
        Test.startTest();
        List<BI_PSPB_Enrollee_Caregiver__c> enrolleList = BI_PSPB_PatientDetailsCtrl.getCareEnrolleeCaregiver(true);
        Test.stopTest();
       assert.areNotEqual(0, enrolleList.size(), 'Expected non-zero enrolleList size.');
    } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
         }

    @isTest
    static void testGetcaregiverAccountforSwitch() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Switch Caregiver' LIMIT 1];

        Test.startTest();
        Account resultAccount = BI_PSPB_PatientDetailsCtrl.getcaregiverAccountforSwitch(testAccount.Id);
        Test.stopTest();

       assert.areNotEqual(null, resultAccount, 'Expected non-null resultAccount.');
        Assert.areEqual(testAccount.Id, resultAccount.Id, 'Expected account ID to match test account ID.');
    }

    @isTest
    static void testUpdateSwitchSelectedPatientID() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Switch Caregiver' LIMIT 1];
        Account patientAccount = [SELECT Id FROM Account WHERE Name = 'Test Patient' LIMIT 1];

        Test.startTest();
        Account updatedAccount = BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID(testAccount.Id, patientAccount.Id, true);
        Test.stopTest();

       assert.areNotEqual(null, updatedAccount, 'Expected non-null updatedAccount.');
        Assert.areEqual(patientAccount.Id, updatedAccount.BI_PSPB_Selected_Patient_ID__c, 'Expected selected patient ID to match patient account ID.');
        Assert.areEqual(true, updatedAccount.BI_PSPB_CaregiverCheck__c, 'Expected caregiver check to be true.');
    }

    @isTest
    static void testUpdateSwitchSelectedPatientIDNullCheck() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Switch Caregiver' LIMIT 1];

        Test.startTest();
        Account updatedAccount = BI_PSPB_PatientDetailsCtrl.updateSwitchSelectedPatientID(testAccount.Id, null, true);
        Test.stopTest();

        Assert.areEqual(null, updatedAccount, 'Expected null updatedAccount for invalid parameters.');
    }
   
    @IsTest
    static void testGetEnrolleeRecordsWithRecords() {
        // Retrieve the test Account created in the setup method
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        try{
        // Call the method being tested
        List<BI_PSPB_Enrollee_Caregiver__c> enrollees = BI_PSPB_PatientDetailsCtrl.getEnrolleeRecords(testAccount.Id);
       
        // Verify that the enrollees list is not empty and contains the expected record
        Assert.areNotEqual(0, enrollees.size(), 'Enrollee Caregiver records should be returned.');
        Assert.areEqual('Test Caregiver', enrollees[0].Name, 'The Caregiver Name should match.');
              } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
    
    @IsTest
    static void testGetEnrolleeRecordsNoRecords() {
        // Create an Account with no related Enrollee Caregiver records
        Account newAccount = new Account(Name = 'Account with No Enrollees');
        insert newAccount;
        try{
        // Call the method being tested with the new Account ID
        List<BI_PSPB_Enrollee_Caregiver__c> enrollees = BI_PSPB_PatientDetailsCtrl.getEnrolleeRecords(newAccount.Id);
        
        // Verify that the enrollees list is empty
        Assert.areEqual(0, enrollees.size(), 'No Enrollee Caregiver records should be returned.');
              } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }

}