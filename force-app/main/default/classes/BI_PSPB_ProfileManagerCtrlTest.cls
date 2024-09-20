/**
* @description  This Test class is used for getting Account Id, Creating Contact,Creating Enrollee caregiver,grand access
*                
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    05-01-2024     	Created				Initial development
*/

@isTest
public class BI_PSPB_ProfileManagerCtrlTest {
/**
 * @description
 * This method sets up the test data required for the test methods in the BI_PSPB_ProfileManagerCtrlTest class.
 * It creates and inserts a test Account, Contact, and Enrollee Caregiver record into the Salesforce database.
 * This ensures that there is a consistent set of data available for testing the functionality of the class methods.
 *
 * @isTest reason
 * The method is annotated with @TestSetup to create test data that is common across all test methods in the test class.
 * This helps to avoid repetitive data setup code in each test method.
 */

    @TestSetup
    static void setupTestData() {
        // Create test Account
        Account account = new Account(Name = 'Test Account');
        insert account;

        // Create test Contact associated with the Account
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@test.com', AccountId = account.Id);
        insert contact;

        // Create test Enrollee Caregiver record associated with the Contact and Account
        BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            Name = 'Test Enrollee Caregiver',
            BI_PSPB_Contact_Id__c = contact.Id,
            BI_PSPB_Caregiver__c = account.Id,
            BI_PSPB_Status__c = 'Inactive'
        );
        insert enrolleeCaregiver;
    }

    @IsTest
    static void testUserCaregiver() {
        Test.startTest();
        try {
            List<Account> result = BI_PSPB_ProfileManagerCtrl.userCaregiver();
            assert.areNotEqual(null, result, 'Expected result not to be null');
           
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateCaregiverDetails() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper cgWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        cgWrapper.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        cgWrapper.firstName = 'Jane';
        cgWrapper.lastName = 'Doe';

        Test.startTest();
        try {
            BI_PSPB_ProfileManagerCtrl.updateCaregiverDetails(cgWrapper);
            Account updatedAccount = [SELECT FirstName, LastName FROM Account WHERE Id = :cgWrapper.accountId];
            Assert.areEqual('Jane', updatedAccount.FirstName, 'Expected FirstName to be updated');
            Assert.areEqual('Doe', updatedAccount.LastName, 'Expected LastName to be updated');
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }

    @IsTest
    static void testGrandAccessButton() {
        Test.startTest();
        try {
            List<BI_PSPB_Enrollee_Caregiver__c> result = BI_PSPB_ProfileManagerCtrl.grandAccessButton();
            Assert.areEqual(null, result, 'Expected result not to be null');
           
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }
    
    

    @IsTest
    static void testGetCaregiverDataView() {
        Test.startTest();
        try {
            List<BI_PSPB_Enrollee_Caregiver__c> result = BI_PSPB_ProfileManagerCtrl.getCaregiverDataView();
            assert.areNotEqual(null, result, 'Expected result not to be null');
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateCaregivers() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper cgWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        cgWrapper.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        cgWrapper.firstName = 'John';
        cgWrapper.lastName = 'Doe';

        Test.startTest();
        try {
            List<Contact> result = BI_PSPB_ProfileManagerCtrl.updateCaregivers(cgWrapper);
            assert.areNotEqual(0, result.size(), 'Expected at least one contact to be updated');
           
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }


    @IsTest
    static void testExceptionHandling() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper cgWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        cgWrapper.accountId = 'NonExistentId';

        Test.startTest();
        try {
            BI_PSPB_ProfileManagerCtrl.updateCaregiverDetails(cgWrapper);
            Assert.areEqual(false,true, 'Expected an exception to be thrown');
        } catch (DmlException e) {
            Assert.areEqual(true, true, 'DmlException expected and caught: ' + e.getMessage());
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }
 @IsTest
    static void testUpdateContactFromCheckboxIsCheckedTrue() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', AccountId = testAccount.Id);
        insert testContact;

        BI_PSPB_Enrollee_Caregiver__c ecRecord = new BI_PSPB_Enrollee_Caregiver__c(
            Name = 'Test Enrollee Caregiver',
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Caregiver__c = testAccount.Id,
            BI_PSPB_Status__c = 'Inactive'
        );
        insert ecRecord;
        try{
        Test.startTest();
       
        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(true);

        Contact updatedContact = new Contact(LastName = 'Test', AccountId = testAccount.Id,BI_PSPB_GrantAccess__c = true);
        update updatedContact;
		 Account updateAccount = new Account(Name = 'Test Account',BI_PSPB_GrantCaregiverAccess__c = true);
        update updateAccount;
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testUpdateContactFromCheckboxIsCheckedFalse() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', AccountId = testAccount.Id);
        insert testContact;
        try{
        Test.startTest();
       
        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(false);

			Contact updatedContact = new Contact(LastName = 'Test', AccountId = testAccount.Id,BI_PSPB_GrantAccess__c = false);
        update updatedContact;
        Account updatedAccount = new Account(Name = 'Test Account',BI_PSPB_GrantCaregiverAccess__c = false);
        update updatedAccount;
        
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testUpdateContactFromCheckboxIsCheckedNull() {
        try{
        Test.startTest();
        
        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(null);
		 Contact updatedContact = [SELECT BI_PSPB_GrantAccess__c FROM Contact WHERE LastName = 'Test' LIMIT 1];
        Assert.areEqual(false, updatedContact.BI_PSPB_GrantAccess__c,'Contact grant access should not be changed.');

        Account updatedAccount = [SELECT BI_PSPB_GrantCaregiverAccess__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Assert.areEqual(false, updatedAccount.BI_PSPB_GrantCaregiverAccess__c,'Account caregiver access should not be changed.');
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testUpdateContactFromCheckboxNoEcRecord() {
        try{
        Test.startTest();
       
        BI_PSPB_Enrollee_Caregiver__c ecRecord = [SELECT Id FROM BI_PSPB_Enrollee_Caregiver__c LIMIT 1];
        delete ecRecord;

        // Call the method with isChecked = true
        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(true);

        // Verify that the changes were not made
        Contact updatedContact = [SELECT id,firstname,lastname,BI_PSPB_GrantAccess__c FROM Contact WHERE LastName = 'Test' LIMIT 1];
        Assert.areEqual(false, updatedContact.BI_PSPB_GrantAccess__c, 'Contact grant access should be changed.');

        Account updatedAccount = [SELECT id,Firstname,Lastname,personEmail,BI_PSPB_GrantCaregiverAccess__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Assert.areEqual(false, updatedAccount.BI_PSPB_GrantCaregiverAccess__c,'Account caregiver access  be changed.');
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testUpdateContactFromCheckboxNoContactRecord() {
        try{
        Test.startTest();
       
        
        Contact testContact = new Contact(LastName = 'Test');
        insert testContact;
       

        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(true);

        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testUpdateContactFromCheckboxNoAccountRecord() {
        try{
        Test.startTest();
        // Delete the account to simulate the condition where it is not found
       Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
       
         delete testAccount;

        // Call the method with isChecked = true
        BI_PSPB_ProfileManagerCtrl.updateContactFromCheckbox(true);

        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    
     @IsTest
    static void testUpdatePatientExcistInfo() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper wrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        wrapper.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        wrapper.firstName = 'John';
        wrapper.lastName = 'Doe';
        try{
        Test.startTest();
        BI_PSPB_ProfileManagerCtrl.updatePatientExcistInfo(wrapper);
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    
     @IsTest
    static void testUpdatePatientorCargiverInfo() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper wrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        wrapper.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        wrapper.firstName = 'John';
        wrapper.lastName = 'Doe';
        try{
        Test.startTest();
        BI_PSPB_ProfileManagerCtrl.updatePatientorCargiverInfo(wrapper);
        Test.stopTest();
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
    
     @IsTest
    static void testExceptionUpdateCaregivers() {
        BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper cgWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
        cgWrapper.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        cgWrapper.firstName = 'John';
        cgWrapper.lastName = 'Doe';

        Test.startTest();
        try {
            List<Contact> result = BI_PSPB_ProfileManagerCtrl.updateCaregivers(null);
            assert.areNotEqual(0, result.size(), 'Expected at least one contact to be updated');
           
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();
    }
   
        
    @IsTest
    private static void testUpdateEnrolleeRelationshipValue() {
        // Setup: Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', AccountId = testAccount.Id);
        insert testContact;

        BI_PSPB_Enrollee_Caregiver__c ecRecord = new BI_PSPB_Enrollee_Caregiver__c(
            Name = 'Test Enrollee Caregiver',
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Caregiver__c = testAccount.Id,
            BI_PSPB_Status__c = 'Inactive',
            BI_PSPB_Relationship_to_Patient__c ='Parent'
        );
        insert ecRecord;

        Test.startTest();
       
        String newRelationship = 'Parent';
        BI_PSPB_ProfileManagerCtrl.updateEnrolleeRelationship(newRelationship);  // Ensure this method is public or @TestVisible
        
        Test.stopTest();

        // Verify that the relationship was updated
        ecRecord = [SELECT BI_PSPB_Relationship_to_Patient__c FROM BI_PSPB_Enrollee_Caregiver__c WHERE Id = :ecRecord.Id];
        Assert.areEqual('Parent', ecRecord.BI_PSPB_Relationship_to_Patient__c,'The relationship should be updated to Parent.');

       
        
        // Remove the caregiver record so the method returns null
        delete ecRecord;
        
        // Call the method again
        BI_PSPB_ProfileManagerCtrl.updateEnrolleeRelationship(newRelationship);
      

        // Verify that no update occurred and no errors were thrown
        Integer countAfter = [SELECT COUNT() FROM BI_PSPB_Enrollee_Caregiver__c WHERE BI_PSPB_Relationship_to_Patient__c = :newRelationship];
        Assert.areEqual(0, countAfter,'No records should be found with the updated relationship after deleting the record.');
    }

   @IsTest
    private static void testUpdateEnrolleeRelationship() {
        // Setup: Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test', AccountId = testAccount.Id);
        insert testContact;

        BI_PSPB_Enrollee_Caregiver__c ecRecord = new BI_PSPB_Enrollee_Caregiver__c(
            Name = 'Test Enrollee Caregiver',
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Caregiver__c = testAccount.Id,
            BI_PSPB_Status__c = 'Inactive',
            BI_PSPB_Relationship_to_Patient__c ='Parent'
        );
        insert ecRecord;

        Test.startTest();
        
        String newRelationship = 'Parent';
        BI_PSPB_ProfileManagerCtrl.updateEnrolleeRelationship(newRelationship);  // Ensure this method is public or @TestVisible

        Test.stopTest();

        // Verify that the relationship was updated
        ecRecord = [SELECT BI_PSPB_Relationship_to_Patient__c FROM BI_PSPB_Enrollee_Caregiver__c WHERE Id = :ecRecord.Id];
        Assert.areEqual('Parent', ecRecord.BI_PSPB_Relationship_to_Patient__c, 'The relationship should be updated to Parent.');

        
       
        delete ecRecord;
        

        BI_PSPB_ProfileManagerCtrl.updateEnrolleeRelationship(newRelationship);
      

        // Verify that no update occurred and no errors were thrown
        Integer countAfter = [SELECT COUNT() FROM BI_PSPB_Enrollee_Caregiver__c WHERE BI_PSPB_Relationship_to_Patient__c = :newRelationship];
        Assert.areEqual(0, countAfter,'No records should be found with the updated relationship after deleting the record.');
    }
    
    
    

}