@isTest
/**
 * @description    This BI_PSPB_EnrollmentCaregiverTest Testclass is used to verify the caregiver details. 
 * History:
 * Version    Author        Date         Detail              Description
 * 1.0        Ashif         05-07-2024   Created             Initial development
 */
public class BI_PSPB_EnrollmentCaregiverTest {
    
    @isTest
    static void testCaregiverCreate() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.DataWrapper caregiverData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        caregiverData.firstName = 'Alice';
        caregiverData.lastName = 'Johnson';
        caregiverData.email = 'alice.johnson@example.com';
        caregiverData.dob = '1975-02-20';
        caregiverData.phone = '1234567890';
        caregiverData.relation = 'Parent';
        
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Run the method
        Test.startTest();
        try{
        Id caregiverId = BI_PSPB_EnrollmentCaregiver.caregiverCreate(caregiverData, testLead.Id);
        Test.stopTest();

        // Validate the results
        BI_PSPB_Lead_Caregiver__c createdCaregiver = [SELECT Id, BI_PSPB_First_Name__c, BI_PSPB_Last_Name__c, BI_PSPB_E_mail_ID__c, BI_PSPB_Date_of_Birth__c, BI_PSPB_Phone_number__c, BI_PSPB_Relationship_to_Patient__c, BI_PSPB_Lead__c FROM BI_PSPB_Lead_Caregiver__c WHERE Id = :caregiverId];
        Assert.areEqual('Alice', createdCaregiver.BI_PSPB_First_Name__c,'null');
        Assert.areEqual('Johnson', createdCaregiver.BI_PSPB_Last_Name__c,'null');
        Assert.areEqual('alice.johnson@example.com', createdCaregiver.BI_PSPB_E_mail_ID__c,'null');
        Assert.areEqual(Date.valueOf('1975-02-20'), createdCaregiver.BI_PSPB_Date_of_Birth__c,'null');
        Assert.areEqual('1234567890', createdCaregiver.BI_PSPB_Phone_number__c,'null');
        Assert.areEqual('Parent', createdCaregiver.BI_PSPB_Relationship_to_Patient__c,'null');
        Assert.areEqual(testLead.Id, createdCaregiver.BI_PSPB_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testCaregiverCreateWithMissingData() {
        // Set up test data with missing required fields
        BI_PSPB_EnrollmentWrapper.DataWrapper caregiverData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        caregiverData.firstName = '';
        caregiverData.lastName = 'Johnson';
        caregiverData.email = 'alice.johnson@example.com';
        caregiverData.dob = '1975-02-20';
        caregiverData.phone = '1234567890';
        caregiverData.relation = 'Parent';
        
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Run the method and validate that an error is logged
        Test.startTest();
        try {
            BI_PSPB_EnrollmentCaregiver.caregiverCreate(caregiverData, testLead.Id);
            Assert.areEqual(false, 'Expected exception was not thrown',null);
        } catch (Exception e) {
             
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        
        Test.stopTest();
    }
 @isTest
    static void testCaregiverCreateException() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.DataWrapper caregiverData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        caregiverData.firstName = 'Alice';
        caregiverData.lastName = 'Johnson';
        caregiverData.email = 'alice.johnson@example.com';
        caregiverData.dob = '1975-02-20';
        caregiverData.phone = '1234567890';
        caregiverData.relation = 'Mother';
        
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Run the method
        Test.startTest();
        try{
        Id caregiverId = BI_PSPB_EnrollmentCaregiver.caregiverCreate(caregiverData, testLead.Id);
        Test.stopTest();

        // Validate the results
        BI_PSPB_Lead_Caregiver__c createdCaregiver = [SELECT Id, BI_PSPB_First_Name__c, BI_PSPB_Last_Name__c, BI_PSPB_E_mail_ID__c, BI_PSPB_Date_of_Birth__c, BI_PSPB_Phone_number__c, BI_PSPB_Relationship_to_Patient__c, BI_PSPB_Lead__c FROM BI_PSPB_Lead_Caregiver__c WHERE Id = :caregiverId];
        Assert.areEqual('Alice', createdCaregiver.BI_PSPB_First_Name__c,'null');
        Assert.areEqual('Johnson', createdCaregiver.BI_PSPB_Last_Name__c,'null');
        Assert.areEqual('alice.johnson@example.com', createdCaregiver.BI_PSPB_E_mail_ID__c,'null');
        Assert.areEqual(Date.valueOf('1975-02-20'), createdCaregiver.BI_PSPB_Date_of_Birth__c,'null');
        Assert.areEqual('1234567890', createdCaregiver.BI_PSPB_Phone_number__c,'null');
        Assert.areEqual('Mother', createdCaregiver.BI_PSPB_Relationship_to_Patient__c,'null');
        Assert.areEqual(testLead.Id, createdCaregiver.BI_PSPB_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
   
}