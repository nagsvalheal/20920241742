@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentConsentTest test class designed to test the functionality of the BI_PSP_LogMessagesUtility class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentConsentTest {

    @isTest
    static void testConsentCreate() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Set up test data
        String leadId = testLead.Id;
        String category = 'Patient';

        // Run the method
        Test.startTest();
        try{
        Id consentId = BI_PSPB_EnrollmentConsent.consentCreate(leadId, category);
        Test.stopTest();

        // Validate the results
        BI_PSP_Lead_Consent__c createdConsent = [SELECT Id, BI_PSP_I_agree__c, BI_PSPB_Consent_Category__c, BI_PSP_Lead__c FROM BI_PSP_Lead_Consent__c WHERE Id = :consentId];
        Assert.areEqual(true, createdConsent.BI_PSP_I_agree__c,'null');
        Assert.areEqual('Patient', createdConsent.BI_PSPB_Consent_Category__c,'null');
        Assert.areEqual(testLead.Id, createdConsent.BI_PSP_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testConsentCreateWithNullLeadId() {
        // Set up test data with null leadId
        String leadId = '';
        String category = 'Test Category';

        // Run the method and validate that an error is logged
        Test.startTest();
        try {
            BI_PSPB_EnrollmentConsent.consentCreate(leadId, category);
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
    static void testConsentCreateexception() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Set up test data
        String leadId = testLead.Id;
        String category = 'Test category ';

        // Run the method
        Test.startTest();
        try{
        Id consentId = BI_PSPB_EnrollmentConsent.consentCreate(leadId, category);
        Test.stopTest();

        // Validate the results
        BI_PSP_Lead_Consent__c createdConsent = [SELECT Id, BI_PSP_I_agree__c, BI_PSPB_Consent_Category__c, BI_PSP_Lead__c FROM BI_PSP_Lead_Consent__c WHERE Id = :consentId];
        Assert.areEqual(true, createdConsent.BI_PSP_I_agree__c,'null');
        Assert.areEqual('Test category', createdConsent.BI_PSPB_Consent_Category__c,'null');
        Assert.areEqual(testLead.Id, createdConsent.BI_PSP_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

}