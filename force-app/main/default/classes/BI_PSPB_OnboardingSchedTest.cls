@isTest
/**
 * @description This BI_PSPB_OnboardingSchedTest Testclass used to verify Schedule Lead details convert to Patient
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif           05-Nov-2023     Created             Initial development
 */
public class BI_PSPB_OnboardingSchedTest {
    @testSetup
    static void setup() {
        // Create test data for Leads
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead lead = new Lead(
                FirstName = 'Test',
                LastName = 'Lead' + i,
                Company = 'Test Company' + i,
                Status = BI_PSPB_EnrollmentConstant.getLabel('PATIENT_QUALIFIED_STATUS')
            );
            leads.add(lead);
        }
        insert leads;

        // Create a non-qualified lead to ensure it is not picked up
        Lead nonQualifiedLead = new Lead(
            FirstName = 'NonQualified',
            LastName = 'Lead',
            Company = 'Non Qualified Company',
            Status = 'Other Status'
        );
        insert nonQualifiedLead;
    }

    @isTest
    static void testFetchQualifiedLeads() {
        Test.startTest();
        BI_PSPB_OnboardingSched scheduler = new BI_PSPB_OnboardingSched();
        List<Id> qualifiedLeadsIds = scheduler.fetchQualifiedLeads();
        Test.stopTest();

        Assert.areEqual(5, qualifiedLeadsIds.size(), 'Should return 5 qualified leads');
    }

    @isTest
    static void testExecute() {
        // Create a mock for the BI_PSPB_OnboardingCtrl
        Test.startTest();
        BI_PSPB_OnboardingSched scheduler = new BI_PSPB_OnboardingSched();
        String jobId = System.schedule('Test Job', '0 0 0 ? * * *', scheduler);
        Test.stopTest();

        // Query the scheduled job
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];

            Assert.areEqual('0 0 0 ? * * *', ct.CronExpression, 'Cron expression does not match the expected value.');
            Assert.areEqual(0, ct.TimesTriggered, 'TimesTriggered is not 0 as expected.');
            Assert.areNotEqual(null, ct.NextFireTime, 'NextFireTime should not be null.');
                          
    }

    @isTest
    static void testLeadConversion() {
        // Ensure that the lead conversion is called correctly
        Test.startTest();
        BI_PSPB_OnboardingSched scheduler = new BI_PSPB_OnboardingSched();
        scheduler.execute(null);
        Test.stopTest();

        // Verify the conversion call
        List<Id> qualifiedLeadsIds = scheduler.fetchQualifiedLeads();
        Assert.areEqual(0, qualifiedLeadsIds.size(), 'Should have qualified leads to convert');
        
    }
}