@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentHcpAndPatientTest test class designed to test the functionality of the BI_PSPB_EnrollmentHcpAndPatient class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentHcpAndPatientTest {
    
    @isTest
    static void testCreateLeadWithCountry() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.DataWrapper testData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        testData.firstName = 'John';
        testData.lastName = 'Doe';
        testData.dob = '1990-01-01';
        testData.email = 'john.doe@example.com';
        testData.sex = 'Male';
        testData.phone = '1234567890';
        testData.country = 'USA';
        testData.state = 'CA';
        testData.city = 'San Francisco';
        testData.code = '94105';
        testData.street = '123 Market St';
        
        Id hcpId = createTestHcp();
        // Run the method
        Test.startTest();
        try{
        Id leadId = BI_PSPB_EnrollmentHcpAndPatient.createLead(testData, hcpId);
        Test.stopTest();
            

        // Validate the results
        Lead createdLead = [SELECT Id, FirstName, LastName, HealthCloudGA__BirthDate__c, Email, HealthCloudGA__Gender__c, Phone, BI_PSPB_Physician_Name__c, Country, State, City, PostalCode, Street, BI_PSPB_Enrolled_By__c, BI_PSPB_Preferred_Communication_Method__c FROM Lead WHERE Id = :leadId];
        Assert.areEqual('John', createdLead.FirstName,'Check first name');
        Assert.areEqual('Doe', createdLead.LastName,'Check last name');
        Assert.areEqual(Date.valueOf('1990-01-01'), createdLead.HealthCloudGA__BirthDate__c,'Check dob');
        Assert.areEqual('john.doe@example.com', createdLead.Email, 'Check email');
        Assert.areEqual('Male', createdLead.HealthCloudGA__Gender__c, 'Check gender');
        Assert.areEqual('1234567890', createdLead.Phone, 'Check phone');
        Assert.areEqual(hcpId, createdLead.BI_PSPB_Physician_Name__c, 'Check physician name');
        Assert.areEqual('USA', createdLead.Country, 'Check country');
        Assert.areEqual('CA', createdLead.State, 'Check state');
        Assert.areEqual('San Francisco', createdLead.City, 'Check city');
        Assert.areEqual('94105', createdLead.PostalCode, 'Check postal code');
        Assert.areEqual('123 Market St', createdLead.Street, 'Check street');
        Assert.areEqual('PatientCaregiver', createdLead.BI_PSPB_Enrolled_By__c, 'Check enrolled by'); 
    
  } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }
    @isTest
    static void testCreateLeadWithoutCountry() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.DataWrapper testData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        testData.firstName = 'Jane';
        testData.lastName = 'Smith';
        testData.dob = '1985-05-15';
        testData.email = 'jane.smith@example.com';
        testData.sex = 'Female';
        testData.phone = '0987654321';
        testData.country = null;
        
        Id hcpId = createTestHcp();
        // Run the method
        Test.startTest();
        try{
        Id leadId = BI_PSPB_EnrollmentHcpAndPatient.createLead(testData, hcpId);
        Test.stopTest();

        // Validate the results
        Lead createdLead = [SELECT Id, FirstName, LastName, HealthCloudGA__BirthDate__c, Email, HealthCloudGA__Gender__c, Phone, BI_PSPB_Physician_Name__c, BI_PSPB_Enrolled_By__c FROM Lead WHERE Id = :leadId];
            Assert.areEqual('Jane', createdLead.FirstName,'Check first name');
            Assert.areEqual('Smith', createdLead.LastName,'Check last name');
            Assert.areEqual(Date.valueOf('1985-05-15'), createdLead.HealthCloudGA__BirthDate__c, 'Check dob');
            Assert.areEqual('Female', createdLead.HealthCloudGA__Gender__c, 'Check gender');
            Assert.areEqual('jane.smith@example.com', createdLead.Email,'Check email' );
            Assert.areEqual('0987654321', createdLead.Phone,'Check phone');
            Assert.areEqual(hcpId, createdLead.BI_PSPB_Physician_Name__c,'Check physician name');
            Assert.areEqual('HealthcareProvider', createdLead.BI_PSPB_Enrolled_By__c,'Check Hcp');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    // Helper method to create a test HCP (Healthcare Provider)
    private static Id createTestHcp() {
        // Replace with actual logic to create a test HCP record and return its Id
        // For example:
        Account hcp = new Account(Name = 'Test HCP');
        insert hcp;
        return hcp.Id;
    }
}