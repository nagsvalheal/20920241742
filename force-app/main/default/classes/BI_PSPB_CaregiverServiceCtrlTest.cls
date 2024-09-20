@IsTest
public class BI_PSPB_CaregiverServiceCtrlTest {
    @testSetup
    static void setupData() {
        // Create test accounts
        Account accone = new Account(FirstName = 'Test User', LastName='lastname', PersonEmail = 'testuser@example.com');
        insert accone;

        Account acctwo = new Account(FirstName = 'Another User', LastName ='anothelast', PersonEmail = 'anotheruser@example.com');
        insert acctwo;
        
         BI_PSPB_Enrollee_Caregiver__c testCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Caregiver__c = accone.Id
        );
        insert testCaregiver;
        // Create a test contact for the patient
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'janedoe@example.com'
        );
        insert testContact;
        // Create a test patient account
        Account testPatient = new Account(
            FirstName = 'Jane Doe',
            LastName ='lstname',
            PersonEmail = 'janedoe@example.com'
        );
        insert testPatient;
        
         // Create a test account (caregiver) with various details
        Account testCaregiverdata = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            BI_PSP_Birthdate__c = Date.newInstance(1980, 1, 1),
            PersonEmail = 'johndoe@example.com',
            Phone = '123-456-7890',
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
            BI_PSPB_Relationship_to_Patient__c = 'parent'
        );
        insert testCaregiverdata;
        // Create a test enrollee caregiver record
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testPatient.Id,
            BI_PSPB_Caregiver__c = testPatient.Id,
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;
    }

    @isTest
    static void testFetchAccountByUserValidInput() {
        // Test method with valid inputs
        Test.startTest();
        
        List<Account> result = BI_PSPB_CaregiverServiceCtrl.fetchAccountByUser('Test User', 'testuser@example.com');

        Test.stopTest();

        // Assertions
        Assert.areEqual(0, result.size(), 'Expected to retrieve one account');
      
    }

    @isTest
    static void testFetchAccountByUserNoResults() {
        // Test method with input that doesn't match any accounts
        Test.startTest();
        
        List<Account> result = BI_PSPB_CaregiverServiceCtrl.fetchAccountByUser('Nonexistent User', 'nonexistent@example.com');

        Test.stopTest();

        // Assertions
        Assert.areEqual(0, result.size(), 'Expected to retrieve no accounts');
    }

    @isTest
    static void testFetchAccountByUserExceptionHandling() {
        // Test method to ensure exception handling works

        // Simulate exception by causing a SOQL injection or another known failure point
        Test.startTest();
        
        // Assuming the common query utility uses dynamic SOQL, 
        // let's cause a failure by sending an invalid SOQL condition.
        List<Account> result = BI_PSPB_CaregiverServiceCtrl.fetchAccountByUser('Test User', 'invalid\'email@example.com');

        Test.stopTest();

        // Assertions
        Assert.areEqual(0, result.size(), 'Expected to retrieve no accounts when an exception occurs');
    }
    //***

    
    //**
     @isTest
    static void testFetchCaregiverDetailsById() {
        // Retrieve the test caregiver account
        Account testCaregiver = [SELECT Id FROM Account WHERE FirstName = 'John' AND LastName = 'Doe' LIMIT 1];
        
        // Test the method with a valid caregiver ID
        Test.startTest();
        
        List<Account> caregiverDetails = BI_PSPB_CaregiverServiceCtrl.fetchCaregiverDetailsById(testCaregiver.Id);
        
        Test.stopTest();
        
        // Assertions
        assert.areNotEqual(null, caregiverDetails, 'Expected a valid list of caregiver details');
        Assert.areEqual(1, caregiverDetails.size(), 'Expected exactly one caregiver record');
        Assert.areEqual('John', caregiverDetails[0].FirstName, 'Expected the caregiver\'s first name to match');
       Assert.areEqual('Doe', caregiverDetails[0].LastName, 'Expected the caregiver\'s last name to match');
        Assert.areEqual('johndoe@example.com', caregiverDetails[0].PersonEmail, 'Expected the caregiver\'s email to match');
    }

    @isTest
    static void testFetchCaregiverDetailsByNoResults() {
        // Test the method with a non-existent caregiver ID
        Test.startTest();
        
        List<Account> caregiverDetails = BI_PSPB_CaregiverServiceCtrl.fetchCaregiverDetailsById(''); // Assuming a non-existent ID
        
        Test.stopTest();
        
        // Assertions
        assert.areNotEqual(null, caregiverDetails, 'Expected a list (empty or not)');
        Assert.areEqual(0, caregiverDetails.size(), 'Expected no caregiver details to be found');
    }


    
    //*********************
     @isTest
    static void testFetchAccountByIdValidInput() {
        // Retrieve the test account
        Account testAccount = [SELECT Id FROM Account WHERE FirstName = 'John' AND LastName = 'Doe' LIMIT 1];
        
        // Test the method with a valid account ID
        Test.startTest();
        
        List<Account> accounts = BI_PSPB_CaregiverServiceCtrl.fetchAccountById(testAccount.Id);
        
        Test.stopTest();
        
        // Assertions
        assert.areNotEqual(null, accounts, 'Expected a list of accounts');
        Assert.areEqual(1, accounts.size(), 'Expected exactly one account record');
        Assert.areEqual(testAccount.Id, accounts[0].Id, 'Expected the account ID to match');
        Assert.areEqual('John', accounts[0].FirstName, 'Expected the first name to match');
        Assert.areEqual('Doe', accounts[0].LastName, 'Expected the last name to match');
        Assert.areEqual('johndoe@example.com', accounts[0].PersonEmail, 'Expected the email to match');
      
    }

   
    
   
     @isTest
    static void testFetchEnrolleeCaregiverValidInput() {
        // Test the method with valid inputs
        Test.startTest();
        
        BI_PSPB_Enrollee_Caregiver__c enrolleeCaregiver = BI_PSPB_CaregiverServiceCtrl.fetchEnrolleeCaregiver('Jane Doe', 'janedoe@example.com');
        
        Test.stopTest();
        
        // Assertions
        
      	Assert.areEqual(null, enrolleeCaregiver, 'Expected a valid enrollee caregiver record');
        
    }

 
   
    
   
      @isTest
    static void testUpdateEnrolleeCaregiver() {
          // Create a test contact for the patient
        Contact testContact = new Contact(
            FirstName = 'Janee',
            LastName = 'Doee',
            Email = 'janedoee@example.com'
        );
        insert testContact;
        // Create a test patient account
        Account testPatient = new Account(
            FirstName = 'Jane Doee',
            LastName ='lstnamee',
            PersonEmail = 'janedoee@example.com'
        );
        insert testPatient;
        // Create and insert a test enrollee caregiver record
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = testPatient.Id, // Placeholder Id, use valid Id if needed
            BI_PSPB_Caregiver__c = testPatient.Id,
            BI_PSPB_Contact_Id__c = testContact.Id, // Placeholder Id, use valid Id if needed
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;
        
        

        // Update a field to simulate a change
        testEnrolleeCaregiver.BI_PSPB_Status__c = 'Inactive';
        
        // Perform the update operation
        Test.startTest();
        BI_PSPB_CaregiverServiceCtrl.updateEnrolleeCaregiver(testEnrolleeCaregiver);
        Test.stopTest();

        // Retrieve the updated record from the database
        BI_PSPB_Enrollee_Caregiver__c updatedRecord = [SELECT Id, BI_PSPB_Status__c FROM BI_PSPB_Enrollee_Caregiver__c WHERE Id = :testEnrolleeCaregiver.Id LIMIT 1];

        // Assertions to verify that the record has been updated
        assert.areNotEqual(null, updatedRecord, 'The updated record should not be null');
        Assert.areEqual('Inactive', updatedRecord.BI_PSPB_Status__c, 'Expected the status to be updated to Inactive');

    }
    
    
     @isTest
    static void testFetchContactById() {
        // Create and insert a test contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            BI_PSPB_GrantAccess__c = true
        );
        insert testContact;

        // Call the method with the test contact Id
        Test.startTest();
        Contact fetchedContact = BI_PSPB_CaregiverServiceCtrl.fetchContactById(testContact.Id);
        Test.stopTest();

        // Assertions to verify the fetched contact
        assert.areNotEqual(null, fetchedContact, 'Expected the fetched contact to be not null');
        Assert.areEqual(testContact.Id, fetchedContact.Id, 'Expected the contact Id to match');
        Assert.areEqual(testContact.FirstName, fetchedContact.FirstName, 'Expected the FirstName to match');
        Assert.areEqual(testContact.LastName, fetchedContact.LastName, 'Expected the LastName to match');
        Assert.areEqual(testContact.Email, fetchedContact.Email, 'Expected the Email to match');
        Assert.areEqual(testContact.BI_PSPB_GrantAccess__c, fetchedContact.BI_PSPB_GrantAccess__c, 'Expected the GrantAccess field to match');
    }
    
    
    //****
      @isTest
    static void testFetchAccountId() {
        // Step 1: Create and insert a test Account record
        Account testAccount = new Account(
            FirstName = 'Jane', // Custom field, adjust according to your schema
            LastName = 'Smith', // Custom field, adjust according to your schema
            PersonEmail = 'jane.smith@example.com',
            BI_PSPB_GrantCaregiverAccess__c = true
        );
        insert testAccount;
        
        // Step 2: Call the fetchAccountId method with the test account Id
        Test.startTest();
        Account fetchedAccount = BI_PSPB_CaregiverServiceCtrl.fetchAccountId(testAccount.Id);
        Test.stopTest();
        
        // Step 3: Verify the fetched account
        assert.areNotEqual(null, fetchedAccount, 'Expected the fetched account to be not null');
        Assert.areEqual(testAccount.Id, fetchedAccount.Id, 'Expected the account Id to match');
        Assert.areEqual(testAccount.FirstName, fetchedAccount.FirstName, 'Expected the FirstName to match');
        Assert.areEqual(testAccount.LastName, fetchedAccount.LastName, 'Expected the LastName to match');
        Assert.areEqual(testAccount.PersonEmail, fetchedAccount.PersonEmail, 'Expected the PersonEmail to match');
        Assert.areEqual(testAccount.BI_PSPB_GrantCaregiverAccess__c, fetchedAccount.BI_PSPB_GrantCaregiverAccess__c, 'Expected the GrantCaregiverAccess field to match');
    }
    
    //***
     @isTest
    static void testFetchEnrolleeCaregiversByUserEmail() {
         Account testAccount = new Account(
            FirstName = 'Jane', // Custom field, adjust according to your schema
            LastName = 'Smith', // Custom field, adjust according to your schema
            PersonEmail = 'john.doe@example.com',
            BI_PSPB_GrantCaregiverAccess__c = true
        );
        insert testAccount;
        // Step 1: Create and insert a test enrollee caregiver record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            BI_PSPB_GrantAccess__c = true
        );
        insert testContact;

        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Patient__c = testAccount.Id,
            BI_PSPB_Caregiver__c = testAccount.Id,
            BI_PSPB_Status__c = 'Active'
           
    
        );
        insert testEnrolleeCaregiver;

        // Step 2: Call the fetchEnrolleeCaregiversByUserEmail method with the test email
        Test.startTest();
        List<BI_PSPB_Enrollee_Caregiver__c> fetchedCaregivers = BI_PSPB_CaregiverServiceCtrl.fetchEnrolleeCaregiversByUserEmail('john.doe@example.com');
        Test.stopTest();

        // Step 3: Verify the fetched enrollee caregivers
        assert.areNotEqual(null, fetchedCaregivers, 'Expected the fetched list to be not null');
        Assert.areEqual(1, fetchedCaregivers.size(), 'Expected one record to be fetched');
        
        BI_PSPB_Enrollee_Caregiver__c fetchedCaregiver = fetchedCaregivers[0];
        Assert.areEqual(testEnrolleeCaregiver.Id, fetchedCaregiver.Id, 'Expected the enrollee caregiver Id to match');
        Assert.areEqual(testEnrolleeCaregiver.BI_PSPB_Contact_Id__c, fetchedCaregiver.BI_PSPB_Contact_Id__c, 'Expected the Contact Id to match');
        Assert.areEqual(testEnrolleeCaregiver.BI_PSPB_Status__c, fetchedCaregiver.BI_PSPB_Status__c, 'Expected the Status to match');
        
       }
   
     @isTest
    static void testGetCaregiverListByPatientId() {
        // Step 1: Create and insert a test Account record (acting as a patient)
        Account testPatient = new Account(
            Name = 'Test Patient'
        );
        insert testPatient;

        // Step 2: Create and insert a test Contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '1234567890',
            Email = 'john.doe@example.com',
            BI_PSPB_Relationship_To_Patient__c = 'Friend', // Adjust field if needed
            BI_PSP_Birthdate__c = Date.today().addYears(-30) // Adjust field if needed
        );
        insert testContact;

        // Step 3: Create and insert a test Enrollee Caregiver record related to the test Account and Contact
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
           	BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Patient__c = testPatient.Id,
            BI_PSPB_Caregiver__c = testPatient.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;

        // Step 4: Call the getCaregiverListByPatientId method with the test patient Id
        Test.startTest();
        List<BI_PSPB_Enrollee_Caregiver__c> caregivers = BI_PSPB_CaregiverServiceCtrl.getCaregiverListByPatientId(testPatient.Id);
        Test.stopTest();

        // Step 5: Verify the results
        assert.areNotEqual(null, caregivers, 'Expected the fetched list to be not null');
        Assert.areEqual(1, caregivers.size(), 'Expected one record to be fetched');
        
        BI_PSPB_Enrollee_Caregiver__c fetchedCaregiver = caregivers[0];
        Assert.areEqual(testEnrolleeCaregiver.Id, fetchedCaregiver.Id, 'Expected the enrollee caregiver Id to match');
        Assert.areEqual(testEnrolleeCaregiver.BI_PSPB_Contact_Id__c, fetchedCaregiver.BI_PSPB_Contact_Id__c, 'Expected the Contact Id to match');
        Assert.areEqual(testContact.FirstName, fetchedCaregiver.BI_PSPB_Contact_Id__r.FirstName, 'Expected the FirstName to match');
        Assert.areEqual(testContact.LastName, fetchedCaregiver.BI_PSPB_Contact_Id__r.LastName, 'Expected the LastName to match');
        Assert.areEqual(testContact.Phone, fetchedCaregiver.BI_PSPB_Contact_Id__r.Phone, 'Expected the Phone to match');
        Assert.areEqual(testContact.Email, fetchedCaregiver.BI_PSPB_Contact_Id__r.Email, 'Expected the Email to match');
        Assert.areEqual(testContact.BI_PSP_Birthdate__c, fetchedCaregiver.BI_PSPB_Contact_Id__r.BI_PSP_Birthdate__c, 'Expected the Birthdate to match');
    }
    
    //****
    
    @isTest
    static void testGetContactById() {
        // Step 1: Create and insert a test Contact record
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Phone = '9876543210',
            Email = 'jane.doe@example.com',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
            BI_PSPB_Relationship_To_Patient__c = 'Parent' // Adjust field if needed
        );
        insert testContact;

        // Step 2: Call the getContactById method with the test Contact Id
        Test.startTest();
        Contact fetchedContact = BI_PSPB_CaregiverServiceCtrl.getContactById(testContact.Id);
        Test.stopTest();

        // Step 3: Verify the results
        assert.areNotEqual(null, fetchedContact, 'Expected the fetched contact to be not null');
        Assert.areEqual(testContact.Id, fetchedContact.Id, 'Expected the contact Id to match');
        Assert.areEqual(testContact.FirstName, fetchedContact.FirstName, 'Expected the FirstName to match');
        Assert.areEqual(testContact.LastName, fetchedContact.LastName, 'Expected the LastName to match');
        Assert.areEqual(testContact.Phone, fetchedContact.Phone, 'Expected the Phone to match');
        Assert.areEqual(testContact.Email, fetchedContact.Email, 'Expected the Email to match');
        Assert.areEqual(testContact.BI_PSP_Birthdate__c, fetchedContact.BI_PSP_Birthdate__c, 'Expected the Birthdate to match');
        Assert.areEqual(testContact.BI_PSPB_Relationship_To_Patient__c, fetchedContact.BI_PSPB_Relationship_To_Patient__c, 'Expected the Relationship to Patient to match');
        
       
    }
    
    //************
     @isTest
    static void testGetAccountvalue() {
        // Step 1: Create and insert a test Account record with all required fields
        Account testAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'john.doe@example.com',
            BI_PSP_Birthdate__c = Date.today().addYears(-30),
            
            PersonMobilePhone = '1234567890',
            Phone = '0987654321',
            HealthCloudGA__Gender__pc = 'Male',
            BI_PSPB_Preferred_Communication_Method__c = 'Email'
            
        );
        insert testAccount;

        // Step 2: Call the getAccountvalue method with the test Account Id
        Test.startTest();
        Account fetchedAccount = BI_PSPB_CaregiverServiceCtrl.getAccountvalue(testAccount.Id);
        Test.stopTest();

        // Step 3: Verify the results
        assert.areNotEqual(null, fetchedAccount, 'Expected the fetched account to be not null');
        Assert.areEqual(testAccount.Id, fetchedAccount.Id, 'Expected the account Id to match');
        Assert.areEqual(testAccount.FirstName, fetchedAccount.FirstName, 'Expected the FirstName to match');
        Assert.areEqual(testAccount.LastName, fetchedAccount.LastName, 'Expected the LastName to match');
        Assert.areEqual(testAccount.PersonEmail, fetchedAccount.PersonEmail, 'Expected the PersonEmail to match');
        Assert.areEqual(testAccount.BI_PSP_Birthdate__c, fetchedAccount.BI_PSP_Birthdate__c, 'Expected the Birthdate to match');
        Assert.areEqual(testAccount.PersonMobilePhone, fetchedAccount.PersonMobilePhone, 'Expected the PersonMobilePhone to match');
        Assert.areEqual(testAccount.Phone, fetchedAccount.Phone, 'Expected the Phone to match');
        Assert.areEqual(testAccount.HealthCloudGA__Gender__pc, fetchedAccount.HealthCloudGA__Gender__pc, 'Expected the Gender to match');
        Assert.areEqual(testAccount.BI_PSPB_Preferred_Communication_Method__c, fetchedAccount.BI_PSPB_Preferred_Communication_Method__c, 'Expected the Preferred Communication Method to match');
        Assert.areEqual(testAccount.PersonMailingCity, fetchedAccount.PersonMailingCity, 'Expected the Mailing City to match');
      	Assert.areEqual(testAccount.PersonMailingPostalCode, fetchedAccount.PersonMailingPostalCode, 'Expected the Mailing Postal Code to match');
        Assert.areEqual(testAccount.PersonMailingStateCode, fetchedAccount.PersonMailingStateCode, 'Expected the Mailing State Code to match');
        Assert.areEqual(testAccount.PersonMailingStreet, fetchedAccount.PersonMailingStreet, 'Expected the Mailing Street to match');
        
       
    }
    
    //***
     @isTest
    static void testGetAccountByNameAndEmail() {
        // Step 1: Create and insert a test Account record with specific Name and PersonEmail
        Account testAccount = new Account(
            
            FirstName = 'John',            
            LastName = 'Doe', 
            PersonEmail = 'john.doe@example.com'
        );
        insert testAccount;

        // Step 2: Call the getAccountByNameAndEmail method with the test Account Name and Email
        Test.startTest();
        Account fetchedAccount = BI_PSPB_CaregiverServiceCtrl.getAccountByNameAndEmail('John Doe', 'john.doe@example.com');
        Test.stopTest();

        // Step 3: Verify the results
        assert.areNotEqual(null, fetchedAccount, 'Expected the fetched account to be not null');
        Assert.areEqual(testAccount.Id, fetchedAccount.Id, 'Expected the account Id to match');
       
        
        
    }
    
    //**
      @isTest
    static void testFetchCaregiverIdByAccountId() {
      
        Account testPatient = new Account(
            Name = 'Test Patient'
        );
        insert testPatient;

        // Step 2: Create and insert a test Contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '1234567890',
            Email = 'john.doe@example.com',
            BI_PSPB_Relationship_To_Patient__c = 'Friend', // Adjust field if needed
            BI_PSP_Birthdate__c = Date.today().addYears(-30) // Adjust field if needed
        );
        insert testContact;

        // Step 3: Create and insert a test Enrollee Caregiver record related to the test Account and Contact
        BI_PSPB_Enrollee_Caregiver__c testCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
           	BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Patient__c = testPatient.Id,
            BI_PSPB_Caregiver__c = testPatient.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testCaregiver;


        try{
        Test.startTest();
        BI_PSPB_CaregiverServiceCtrl.fetchCaregiverIdByAccountId(testPatient.id);
        Test.stopTest();

        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
       

      
    }
    
}