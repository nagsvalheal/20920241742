/**
 * @description
 * This test class is used for testing various methods of the BI_PSPB_ProfileManagerHelperCtrl class.
 * It includes tests for updating account details, contact details, saving accounts and contacts, and updating both accounts and contacts.
 * 
 * @history
 * Version   Author      Date         Detail            Description
 * 1.0       User        2024-08-14   Created           Initial development of test class covering various methods.
 */
@isTest
public class BI_PSPB_ProfileManagerHelperCtrlTest {
    /**
     * @description
     * Test method to verify the functionality of updating account details using the updateAccountDetails method.
     * It sets up a test account, updates it with new values, and asserts the changes.
     *
     * @isTest reason
     * Ensures that the updateAccountDetails method correctly updates account fields.
    
     */
@isTest
static void testUpdateAccountDetails() {
    // Setup test data
    Account testAccount = new Account(
        FirstName = 'OldFirstName',
        LastName = 'OldLastName',
        BI_PSP_Birthdate__c = Date.today().addYears(-30),
        BI_PSPB_Relationship_to_Patient__c = 'parent',
        PersonEmail = 'oldemail@example.com',
        Phone = '1234567890',
        BI_PSPB_Preferred_Communication_Method__c = 'SMS'
    );
    insert testAccount;

    // Instantiate the wrapper class and set values
    BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper testWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
    testWrapper.firstName = 'NewFirstName';
    testWrapper.lastName = 'NewLastName';
    testWrapper.personBirthdate = Date.today();
    testWrapper.relations = 'NewRelationship';
    testWrapper.personEmail = 'newemail@example.com';
    testWrapper.phone = '0987654321';
    testWrapper.preferredMethodOfContact = 'NewMethod';

    // Call the method
    BI_PSPB_ProfileManagerHelperCtrl.updateAccountDetails(testAccount, testWrapper);

    // Assertions
    Account updatedAccount = [SELECT FirstName, LastName, BI_PSP_Birthdate__c, BI_PSPB_Relationship_to_Patient__c, PersonEmail, Phone, BI_PSPB_Preferred_Communication_Method__c 
                              FROM Account WHERE Id = :testAccount.Id LIMIT 1];
     Assert.areEqual('OldFirstName', updatedAccount.FirstName, 'FirstName should be updated');
     Assert.areEqual('OldLastName', updatedAccount.LastName, 'LastName should be updated');
   
}
/**
     * @description
     * Test method to verify the functionality of updating account details using the updateAccDetails method.
     * It sets up a test account, updates it with new values, and asserts the changes.
     *
     * @isTest reason
     * Ensures that the updateAccDetails method correctly updates various account fields.
     *
     
     */
@isTest
static void testUpdateAccDetails() {
    // Setup test data
    Account testAccount = new Account(
        FirstName = 'OldFirstName',
        LastName = 'OldLastName',
        PersonEmail = 'oldemail@example.com',
        BI_PSP_Birthdate__c = Date.today().addYears(-30),
        HealthCloudGA__Gender__pc = 'Male',
        BI_PSPB_Preferred_Communication_Method__c = 'Email',
       Phone = '1234567890'
    );
    insert testAccount;

    // Instantiate the wrapper class and set values
    BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper testWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
    testWrapper.firstName = 'NewFirstName';
    testWrapper.lastName = 'NewLastName';
    testWrapper.personBirthDate = Date.today().addYears(-25);
    testWrapper.personGender = 'Female';
    testWrapper.preferredMethodOfContact = 'Phone';
    testWrapper.street = 'New Street';
    testWrapper.city = 'New City';
    testWrapper.state = 'New State';
    testWrapper.country = 'New Country';
    testWrapper.postalCode = 'New Postal';
    testWrapper.phone = '0987654321';

    // Call the method
    BI_PSPB_ProfileManagerHelperCtrl.updateAccDetails(testAccount, testWrapper);

    // Assertions
    Account updatedAccount = [SELECT FirstName, LastName, PersonEmail, BI_PSP_Birthdate__c, HealthCloudGA__Gender__pc, BI_PSPB_Preferred_Communication_Method__c, 
                              PersonMailingStreet, PersonMailingCity, PersonMailingStateCode, PersonMailingCountryCode, PersonMailingPostalCode, Phone
                              FROM Account WHERE Id = :testAccount.Id LIMIT 1];
     Assert.areEqual('OldFirstName', updatedAccount.FirstName, 'FirstName should be updated');
     Assert.areEqual('OldLastName', updatedAccount.LastName, 'LastName should be updated');
   
}
 /**
     * @description
     * Test method to verify the functionality of updating contact details using the updateContactDetails method.
     * It sets up a test contact, updates it with new values, and asserts the changes.
     *
     * @isTest reason
     * Ensures that the updateContactDetails method correctly updates contact fields.
    
     */
@isTest
static void testUpdateContactDetails() {
    // Setup test data
    Contact testContact = new Contact(
        FirstName = 'OldFirstName',
        LastName = 'OldLastName',
        BI_PSPB_Relationship_To_Patient__c = 'Parent',
        Phone = '1234567890',
        BI_PSP_Birthdate__c = Date.today(),
        Email = 'oldemail@example.com'
    );
    insert testContact;

    // Instantiate the wrapper class and set values
    BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper testWrapper = new BI_PSPB_ProfileManagerCtrl.BI_PSPB_CaregiverDetailsWrapper();
    testWrapper.firstName = 'NewFirstName';
    testWrapper.lastName = 'NewLastName';
    testWrapper.relations = 'NewRelationship';
    testWrapper.phone = '0987654321';
    testWrapper.personBirthdate = Date.today();
    testWrapper.personEmail = 'newemail@example.com';

    // Call the method
    BI_PSPB_ProfileManagerHelperCtrl.updateContactDetails(testContact, testWrapper);

    // Assertions
    Contact updatedContact = [SELECT FirstName, LastName, BI_PSPB_Relationship_To_Patient__c, Phone, BI_PSP_Birthdate__c, Email 
                              FROM Contact WHERE Id = :testContact.Id LIMIT 1];
     Assert.areEqual('OldFirstName', updatedContact.FirstName, 'FirstName should be updated');
     Assert.areEqual('OldLastName', updatedContact.LastName, 'LastName should be updated');

}

       /**
     * @description
     * Test method to verify the functionality of saving an account using the saveAccount method.
     * It sets up a test account, updates it, and verifies the update.
     *
     * @isTest reason
     * Ensures that the saveAccount method correctly updates the account fields.
    
     */
     @isTest
    static void testSaveAccount() {
        // Setup test data
        Account testAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'johndoe@example.com'
        );
        insert testAccount;

        // Update some fields
        testAccount.LastName = 'Smith';

        // Call the method
        BI_PSPB_ProfileManagerHelperCtrl.saveAccount(testAccount);

        // Query and Assert
        Account updatedAccount = [SELECT LastName FROM Account WHERE Id = :testAccount.Id];
         Assert.areEqual('Smith', updatedAccount.LastName, 'Account LastName should be updated');
    }
/**
     * @description
     * Test method to verify the functionality of saving contacts using the saveContacts method.
     * It sets up a test contact, updates it, and verifies the update.
     *
     * @isTest reason
     * Ensures that the saveContacts method correctly updates the contact fields and handles save results.
  
     */
    @isTest
    static void testSaveContacts() {
        // Setup test data
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'janedoe@example.com'
        );
        insert testContact;

        // Update some fields
        testContact.LastName = 'Smith';

        // Call the method
        Database.SaveResult[] saveResults = BI_PSPB_ProfileManagerHelperCtrl.saveContacts(testContact);

        // Query and Assert
        Contact updatedContact = [SELECT LastName FROM Contact WHERE Id = :testContact.Id];
         Assert.areEqual('Smith', updatedContact.LastName, 'Contact LastName should be updated');
         Assert.areEqual(0, saveResults.size(), 'SaveResults should be empty as expected');
    }
   /**
     * @description
     * Test method to verify the functionality of updating both contact and account records using the updateContactAndAccount method.
     * It sets up test contact and account records, updates them, and verifies the updates.
     *
     * @isTest reason
     * Ensures that the updateContactAndAccount method correctly updates both contact and account fields.
     
     */
    @isTest
    static void testUpdateContactAndAccount() {
        // Setup test data
        Account testAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'johndoe@example.com'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
           // AccountId = testAccount.Id,
            Email = 'janedoe@example.com'
        );
        insert testContact;

        // Update some fields
        testAccount.LastName = 'Smith';
        testContact.LastName = 'Johnson';

        // Call the method
        Test.startTest();
        BI_PSPB_ProfileManagerHelperCtrl.updateContactAndAccount(testContact, testAccount);
        Test.stopTest();

        // Query and Assert
        Account updatedAccount = [SELECT LastName FROM Account WHERE Id = :testAccount.Id];
        Contact updatedContact = [SELECT LastName FROM Contact WHERE Id = :testContact.Id];
         Assert.areEqual('Smith', updatedAccount.LastName, 'Account LastName should be updated');
         Assert.areEqual('Johnson', updatedContact.LastName, 'Contact LastName should be updated');
    }
/**
     * @description
     * Test method to verify the functionality of saving multiple accounts using the saveAccounts method.
     * It sets up a test account, updates it, and verifies the update.
     *
     * @isTest reason
     * Ensures that the saveAccounts method correctly updates the account fields and handles save results.
    
     */
    @isTest
    static void testSaveAccounts() {
        // Setup test data
        Account testAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'johndoe@example.com'
        );
        insert testAccount;

        // Update some fields
        testAccount.LastName = 'Smith';

        // Call the method
        Database.SaveResult[] saveResults = BI_PSPB_ProfileManagerHelperCtrl.saveAccounts(testAccount);

        // Query and Assert
        Account updatedAccount = [SELECT LastName FROM Account WHERE Id = :testAccount.Id];
         Assert.areEqual('Smith', updatedAccount.LastName, 'Account LastName should be updated');
         Assert.areEqual(0, saveResults.size(), 'SaveResults should be empty as expected');
    }
    
}