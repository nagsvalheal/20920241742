@isTest
public class BI_PSPB_EnrolleeCaregiverCtrlTest {

    @isTest
    static void testCreateEnroleeCaregiverValidInput() {
         // Create Care Program
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today()
        );
        insert careProgram;
        
         Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com'
        );
        insert patientAccount;
        
        
        // Create Care Program Enrollee
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            Name = 'CPE',
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            BI_PSP_Challenge_Rank__c = 'GPP beginner'
        );
        insert testEnrollee;
        
        // Create a Contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com'
        );
        insert testContact;

        // Step 2: Test the method with valid inputs
        Test.startTest();
        Id caregiverId = BI_PSPB_EnrolleeCaregiverCtrl.createEnroleeCaregiver(
            testEnrollee.Id,
            'Jane Doe',
            'johndoe@example.com','Sibling'
        );
        Test.stopTest();
        
        // Assertions
        assert.areNotEqual(null, caregiverId, 'Expected a valid caregiver Id to be returned');
        
        BI_PSPB_Enrollee_Caregiver__c createdCaregiver = [SELECT Id, Name, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Patient__c, BI_PSPB_Contact_Id__c 
                                                        FROM BI_PSPB_Enrollee_Caregiver__c WHERE Id = :caregiverId LIMIT 1];
        Assert.areEqual('Jane Doe', createdCaregiver.Name, 'Expected the caregiver name to match');
        Assert.areEqual(testEnrollee.Id, createdCaregiver.BI_PSPB_Care_Program_Enrollee__c, 'Expected the enrollee Id to match');
        Assert.areEqual(testEnrollee.AccountId, createdCaregiver.BI_PSPB_Patient__c, 'Expected the patient Id to match');
        Assert.areEqual(testContact.Id, createdCaregiver.BI_PSPB_Contact_Id__c, 'Expected the contact Id to match');
    }

    @isTest
    static void testCreateEnroleeCaregiverInvalidInput() {
        // Create Care Program
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today()
        );
        insert careProgram;
         Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com'
        );
        insert patientAccount;
        // Create Care Program Enrollee
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            Name = 'CPE',
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            BI_PSP_Challenge_Rank__c = 'GPP beginner'
        );
        insert testEnrollee;
        
        // Create a Contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com'
        );
        insert testContact;

        // Step 2: Test the method with invalid inputs
        Test.startTest();
        Id caregiverId = BI_PSPB_EnrolleeCaregiverCtrl.createEnroleeCaregiver(
            null, // Invalid patientId
            'Jane Doe',
            'johndoe@example.com','Sibling'
        );
        Test.stopTest();
        
        // Assertions
        Assert.areEqual(null, caregiverId, 'Expected the caregiver Id to be null for invalid patientId');

    
    }

    @isTest
    static void testCreateEnroleeCaregiverNoEnrolleeFound() {
        // Create a Contact record
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com'
        );
        insert testContact;

        // Test the method with a non-existent enrolleeId
        try{
        Test.startTest();
        Id caregiverId = BI_PSPB_EnrolleeCaregiverCtrl.createEnroleeCaregiver(
            'nonExistentEnrolleeId',
            'Jane Doe',
            'johndoe@example.com','Sibling'
        );
        Test.stopTest();
        
        // Assertions
        Assert.areEqual(null, caregiverId, 'Expected the caregiver Id to be null when no enrollee record is found');
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @isTest
    static void testCreateEnroleeCaregiverNoContactFound() {
        // Create Care Program
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today()
        );
        insert careProgram;
         Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com'
        );
        insert patientAccount;
        
         // Create Care Program Enrollee
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            Name = 'CPE',
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            BI_PSP_Challenge_Rank__c = 'GPP beginner'
        );
        insert testEnrollee;

        // Test the method with a non-existent contact email
        Test.startTest();
        Id caregiverId = BI_PSPB_EnrolleeCaregiverCtrl.createEnroleeCaregiver(
            testEnrollee.Id,
            'Jane Doe',
            'nonExistentEmail@example.com','Sibling'
        );
        Test.stopTest();
        
        // Assertions
        Assert.areEqual(null, caregiverId, 'Expected the caregiver Id to be null when no contact record is found');
    }
}