@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentPhysicianTest test class designed to test the functionality of the BI_PSP_LogMessagesUtility class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentPhysicianTest {

    @isTest
    static void testHcpCreate() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.DataWrapper hcpData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        hcpData.firstName = 'John';
        hcpData.lastName = 'Doe';
        hcpData.phone = '1234567890';
        hcpData.email = 'john.doe@example.com';
        hcpData.country = 'US';
        hcpData.state = 'CA';
        hcpData.city = 'San Francisco';
        hcpData.street = '123 Market St';
        hcpData.code = '94105';
       BI_PSPB_EnrollmentWrapper.HcpWrapper hcpdetail = new BI_PSPB_EnrollmentWrapper.HcpWrapper();
        hcpdetail.lisence = 'ABC123';
        hcpdetail.practice = 'General Practice';
        hcpdetail.type = 'Primary Care';
        hcpdetail.addressLine = 'Suite 100';
        // Run the method
        Test.startTest();
        try{
        Id hcpId = BI_PSPB_EnrollmentPhysician.hcpCreate(hcpData,hcpdetail );
        Test.stopTest();
  
        // Validate the results
        Contact createdContact = [SELECT Id, FirstName, LastName, BI_PSPB_License_number__c, BI_PSPB_Practice__c, BI_PSPB_Practice_Type__c, Phone, Email, MailingCountryCode, MailingStateCode, MailingCity, MailingStreet, MailingPostalCode, BI_PSPB_Address_Line__c, RecordTypeId FROM Contact WHERE Id = :hcpId];
        Assert.areEqual('John', createdContact.FirstName, 'Check first name');
        Assert.areEqual('Doe', createdContact.LastName, 'Check last name');
        Assert.areEqual('12345', createdContact.BI_PSPB_License_number__c, 'Check license number');
        Assert.areEqual('General Practice', createdContact.BI_PSPB_Practice__c, 'Check practice');
        Assert.areEqual('Primary Care', createdContact.BI_PSPB_Practice_Type__c, 'Check practice type');
        Assert.areEqual('1234567890', createdContact.Phone, 'Check phone number');
        Assert.areEqual('john.doe@example.com', createdContact.Email, 'Check email');
        Assert.areEqual('US', createdContact.MailingCountryCode, 'Check mailing country code');
        Assert.areEqual('CA', createdContact.MailingStateCode, 'Check mailing state code');
        Assert.areEqual('San Francisco', createdContact.MailingCity, 'Check mailing city');
        Assert.areEqual('123 Market St', createdContact.MailingStreet, 'Check mailing street');
        Assert.areEqual('94105', createdContact.MailingPostalCode, 'Check mailing postal code');
        Assert.areEqual('Suite 200', createdContact.BI_PSPB_Address_Line__c, 'Check address line');
        Assert.areEqual(
            Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BI_PSPB_Physician').getRecordTypeId(), 
            createdContact.RecordTypeId, 
            'Check record type'
        );
        
    } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
    @isTest
    static void testHcpCreateWithNullData() {
        // Set up test data with null values
        BI_PSPB_EnrollmentWrapper.DataWrapper hcpData = null;

        // Run the method and validate that an error is logged
        Test.startTest();
        try {
            BI_PSPB_EnrollmentPhysician.hcpCreate(hcpData, null);
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
    static void testHcpCreateWithMissingData() {
        // Set up test data with missing required fields
        BI_PSPB_EnrollmentWrapper.DataWrapper hcpData = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        hcpData.firstName = '';
        hcpData.lastName = 'Doe';
        hcpData.email = 'john.doe@example.com';

        // Run the method and validate that an error is logged
        Test.startTest();
        try {
            BI_PSPB_EnrollmentPhysician.hcpCreate(hcpData ,null);
            Assert.areEqual(true, 'Expected exception was not thrown',null);
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