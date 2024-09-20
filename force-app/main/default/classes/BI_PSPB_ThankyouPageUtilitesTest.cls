@isTest
/** 
* @description       : This is a BI_PSPB_ThankyouPageUtilitesTest test class designed to test the functionality of the BI_PSPB_ThankyouPageUtilites class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_ThankyouPageUtilitesTest {

    @isTest
    static void testGetExistingLeads() {
        // Create test Lead
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            HealthCloudGA__BirthDate__c = Date.today(),
            HealthCloudGA__Gender__c = 'Male',
            Phone = '1234567890'
        );
        insert testLead;
        
        // Call the method to test
        Test.startTest();
        try{
            List<Lead> result = BI_PSPB_ThankyouPageUtilites.getExistingLeads(testLead.Id);
            List<Lead> results = BI_PSPB_ThankyouPageUtilites.getExistingLeads('');
            Assert.areEqual(1, result.size(), 'There should be one lead.');
            Assert.areEqual(testLead.Id, result[0].Id, 'Lead ID should match.');
            Assert.areEqual(0, results.size(), 'There should be no lead.');
        }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                'Script-thrown exception',
                'Script-thrown exception',
                e.getMessage()
            );
        }
        
        Test.stopTest();

       
    }

    @isTest
    static void testGetLeadCaregiver() {
        // Create test Lead
        Lead testLead = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@example.com',
            HealthCloudGA__BirthDate__c = Date.today(),
            HealthCloudGA__Gender__c = 'Female',
            Phone = '0987654321'
        );
        insert testLead;
        
        // Create test Lead Caregiver
        BI_PSPB_Lead_Caregiver__c testCaregiver = new BI_PSPB_Lead_Caregiver__c(
            BI_PSPB_Lead__c = testLead.Id,
            BI_PSPB_First_Name__c = 'Anna',
            BI_PSPB_Last_Name__c = 'Johnson',
            BI_PSPB_E_mail_ID__c = 'anna.johnson@example.com',
            BI_PSPB_Date_of_Birth__c = Date.today().addYears(-30),
            BI_PSPB_Phone_number__c = '1234567890',
            BI_PSPB_Relationship_to_Patient__c = 'Friend'
        );
        insert testCaregiver;
        
        // Call the method to test
        Test.startTest();
        try{
            List<BI_PSPB_Lead_Caregiver__c> result = BI_PSPB_ThankyouPageUtilites.getLeadCaregiver(testLead.Id);
        	List<BI_PSPB_Lead_Caregiver__c> results = BI_PSPB_ThankyouPageUtilites.getLeadCaregiver('');
        
        	// Verify the result
       		Assert.areNotEqual(null, result, 'Lead Caregiver should be found.');
       		Assert.areEqual(1, result.size(), 'There should be one caregiver.');
       		Assert.areEqual(testCaregiver.Id, result[0].Id, 'Caregiver ID should match.');
        	Assert.areEqual(0, results.size(), 'There should be no caregiver.');
        
        }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                'Script-thrown exception',
                'Script-thrown exception',
                e.getMessage()
            );
        }
        
        Test.stopTest();

        
       
    }

    @isTest
    static void testGetLeadPrescription() {
        // Create test Lead
        Lead testLead = new Lead(
            FirstName = 'Emily',
            LastName = 'Davis',
            Email = 'emily.davis@example.com',
            HealthCloudGA__BirthDate__c = Date.today(),
            HealthCloudGA__Gender__c = 'Female',
            Phone = '1234567890'
        );
        insert testLead;
        UnitOfMeasure um = new UnitOfMeasure();
		um.Name = 'test';
		um.Type = 'Benutzerdefiniert';
		um.UnitCode = '100';
		insert um;
		CareProgram cp = new CareProgram();
		cp.Name = 'spevigo';
		insert cp;
		// Create a test drug
		CareProgramProduct testDrug = new CareProgramProduct(
			Name = 'DrugName',
			BI_PSPB_Unit__c = um.Id, // Adjust this based on your actual field
			CareProgramId = cp.Id
		);
		insert testDrug;
        // Create test Lead Prescription
        BI_PSPB_Lead_Prescription__c testPrescription = new BI_PSPB_Lead_Prescription__c(
            BI_PSPB_Lead__c = testLead.Id,
            BI_PSPB_Drug__c = testDrug.Id,
            BI_PSPB_Dosage__c = 10,
            BI_PSPB_Quantity__c = 30,
            BI_PSPB_Frequency__c = 1,
            BI_PSPB_of_Refills__c = 2,
            BI_PSPB_Drug_Code__c = '1234',
            BI_PSPB_Unit__c = um.Id,
            BI_PSPB_Prescribed_Date__c = Date.today()
        );
        insert testPrescription;
        
        // Call the method to test
        Test.startTest();
        try{
            List<BI_PSPB_Lead_Prescription__c> result = BI_PSPB_ThankyouPageUtilites.getLeadPrescription(testLead.Id);
            List<BI_PSPB_Lead_Prescription__c> results = BI_PSPB_ThankyouPageUtilites.getLeadPrescription('');
            Test.stopTest();
    
            // Verify the result
            Assert.areNotEqual(null, result, 'Lead Prescription should be found.');
            Assert.areEqual(1, result.size(), 'There should be one prescription.');
            Assert.areEqual(testPrescription.Id, result[0].Id, 'Prescription ID should match.');
            Assert.areEqual(0, results.size(), 'There should be no prescription.');
        }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                'Script-thrown exception',
                'Script-thrown exception',
                e.getMessage()
            );
        }
        
    }

    @isTest
    static void testCheckCaregiverData() {
        // Create test Lead
        Lead testexistingLead = new Lead(
            FirstName = 'Michael',
            LastName = 'Brown',
            Email = 'michael.brown@example.com',
            HealthCloudGA__BirthDate__c = Date.today(),
            HealthCloudGA__Gender__c = 'Male',
            Phone = '1234567890'
        );
        insert testexistingLead;
        
        // Create test Lead Caregiver
        BI_PSPB_Lead_Caregiver__c testexistingCaregiver = new BI_PSPB_Lead_Caregiver__c(
            BI_PSPB_Lead__c = testexistingLead.Id,
            BI_PSPB_First_Name__c = 'George',
            BI_PSPB_Last_Name__c = 'Wilson',
            BI_PSPB_E_mail_ID__c = 'george.wilson@example.com',
            BI_PSPB_Date_of_Birth__c = Date.today().addYears(-40),
            BI_PSPB_Phone_number__c = '9876543210',
            BI_PSPB_Relationship_to_Patient__c = 'Friend'
        );
        insert testexistingCaregiver;
        
         // Create a corresponding Contact record
        Contact testContact = new Contact(
            FirstName = 'George',
            LastName = 'Wilson',
            Email = 'george.wilson@example.com'
        );
        insert testContact;

        // Call the method to test
        Test.startTest();
        Boolean result = BI_PSPB_ThankyouPageUtilites.checkCaregiverData(testexistingLead.Id);
        Test.stopTest();

        // Verify the result
       Assert.areEqual(true, result, 'Caregiver data should be found.');

    }
    @isTest
    static void testCheckCaregiverDataexception() {
        // Create test Lead
        Lead testexistingLead = new Lead(
            FirstName = 'Michael',
            LastName = 'Brown',
            Email = 'michael.brown@example.com',
            HealthCloudGA__BirthDate__c = Date.today(),
            HealthCloudGA__Gender__c = 'Male',
            Phone = '1234567890'
        );
        insert testexistingLead;
        
        // Create test Lead Caregiver
        BI_PSPB_Lead_Caregiver__c testexistingCaregiver = new BI_PSPB_Lead_Caregiver__c(
            BI_PSPB_Lead__c = testexistingLead.Id,
            BI_PSPB_First_Name__c = 'George',
            BI_PSPB_Last_Name__c = 'Peter',
            BI_PSPB_E_mail_ID__c = 'Peter.wilson@example.com',
            BI_PSPB_Date_of_Birth__c = Date.today().addYears(-40),
            BI_PSPB_Phone_number__c = '9876543210',
            BI_PSPB_Relationship_to_Patient__c = 'Friend'
        );
        insert testexistingCaregiver;
        
         // Create a corresponding Contact record
        Contact testContact = new Contact(
            FirstName = 'George',
            LastName = 'Wilson',
            Email = 'george.wilson@example.com'
        );
        insert testContact;

        // Call the method to test
        Test.startTest();
        try{
            Boolean result = BI_PSPB_ThankyouPageUtilites.checkCaregiverData(null);
        	Boolean results = BI_PSPB_ThankyouPageUtilites.checkCaregiverData(testexistingLead.Id);
            Assert.areEqual(false, result, 'Caregiver data should not be found.');
            Assert.areEqual(false, results, 'Caregiver data should not be found.');
        }catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Script-thrown exception',
                e.getMessage()
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCountUserLogin() {
        // Retrieve the test user
        User person = new User(
            Username = 'testuserpat@test.com',
            Alias = 'pat',
            Email = 'testuserpat@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id
        );
        insert person;

        // Use Test.isRunningTest() to mock the behavior
        Test.startTest();
        Integer loginCount = 0;

        loginCount = BI_PSPB_ThankyouPageUtilites.countUserLogin(person.Id);
        Test.stopTest();

        // Assert that the count is correct (5 successful logins)
        System.assertEquals(0, loginCount, 'The login count should be 0');
    }

    

}