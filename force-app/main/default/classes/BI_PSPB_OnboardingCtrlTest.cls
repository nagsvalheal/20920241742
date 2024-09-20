@isTest
/**
 * @description This BI_PSPB_OnboardingCtrlTset Tsetclass used to verify the Onboarding the Patient.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif           20-7-2024     Created             Initial development
 */
public class BI_PSPB_OnboardingCtrlTest {

    @isTest
    static void testUpdateAccounts() {
        // Create a CareProgram record for testing
        CareProgram cpvalue = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today() 
        );
        insert cpvalue;

        // Setup test data
        Lead firstLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            BI_PSPB_Care_Program__c = cpvalue.Id,
            Company = 'Test Company',
            Status = 'Open - Not Contacted',
            Email = 'john.doe@testcompany.com',
            MobilePhone = '1234567890',
            HealthCloudGA__Gender__c = 'Male',
            HealthCloudGA__BirthDate__c = Date.newInstance(1990, 1, 1),
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
            BI_PSPB_Enrolled_By__c = 'Patient/Caregiver'
        );

      

        insert new List<Lead>{firstLead};

        // Convert leads to accounts
        Database.LeadConvert firstLeadConvert = new Database.LeadConvert();
        firstLeadConvert.setLeadId(firstLead.Id);
        firstLeadConvert.setConvertedStatus('Converted');
        firstLeadConvert.setDoNotCreateOpportunity(true);

       
        Database.LeadConvertResult result1 = Database.convertLead(firstLeadConvert);
     

        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        leadMap.put(result1.getAccountId(), [SELECT Id, FirstName, LastName, Email, BI_PSPB_Care_Program__c, MobilePhone, HealthCloudGA__Gender__c, HealthCloudGA__BirthDate__c, BI_PSPB_Preferred_Communication_Method__c, BI_PSPB_Enrolled_By__c, convertedAccountId FROM Lead WHERE Id = :firstLead.Id]);
       
        // Test updateAccounts method
        Test.startTest();
        List<Account> accountsToUpdate = BI_PSPB_OnboardingCtrl.updateAccounts(leadMap);
        BI_PSPB_OnboardingCtrl.convertLead(new List<Id>{firstLead.Id});
        Test.stopTest();

        // Verify results
        Assert.areEqual(1, accountsToUpdate.size(), 'Two accounts should be updated.');
        for (Account acc : accountsToUpdate) {
            if (acc.PersonEmail == 'john.doe@testcompany.com') {
                Assert.areEqual('Male', acc.HealthCloudGA__Gender__pc, 'Gender should be updated.');
                Assert.areEqual(Date.newInstance(1990, 1, 1), acc.BI_PSP_Birthdate__c, 'Birthdate should be updated.');
                Assert.areEqual('Email', acc.BI_PSPB_Preferred_Communication_Method__c, 'Preferred communication method should be updated.');
                Assert.areEqual('1234567890', acc.PersonMobilePhone, 'Mobile phone should be updated.');
                Assert.areEqual('Patient/Caregiver', acc.BI_PSPB_Enrolled_By__c, 'Enroller should be updated.');
            }
        }
    }

    
    @isTest
    static void testConvertLeadSuccess() {
        // Setup test data
        Lead testLead = new Lead(LastName='Test Lead', Status='Open - Not Contacted',HealthCloudGA__Gender__c = 'Male');
        insert testLead;

        // Prepare the lead ID list
        List<Id> leadIdList = new List<Id>{ testLead.Id };
        
        // Call the method
        Test.startTest();
        BI_PSPB_OnboardingCtrl.convertLead(leadIdList);
        Test.stopTest();
        
        // Verify lead conversion
        Lead convertedLead = [SELECT Id, ConvertedAccountId FROM Lead WHERE Id = :testLead.Id LIMIT 1];
       assert.areNotEqual(null, convertedLead.ConvertedAccountId, 'Lead should have a converted Account Id.');
        
        // Verify account update
        Account updatedAccount = [SELECT Id FROM Account WHERE Id = :convertedLead.ConvertedAccountId LIMIT 1];
        assert.areNotEqual(null, updatedAccount, 'Account should have been created/updated.');
    }

   
    @isTest
    static void testConvertLeadPartialSuccess() {
        // Setup test data
        Lead testLead1 = new Lead(LastName='Test Lead 1', Status='Open - Not Contacted',HealthCloudGA__Gender__c = 'Male');
        Lead testLead2 = new Lead(LastName='Test Lead 2', Status='Open - Not Contacted',HealthCloudGA__Gender__c = 'Male');
        insert new List<Lead>{ testLead1, testLead2 };
        
        // Prepare lead ID list with an invalid ID
        List<Id> leadIdList = new List<Id>{ testLead1.Id, testLead2.Id };
        
        // Call the method
        Test.startTest();
        BI_PSPB_OnboardingCtrl.convertLead(leadIdList);
        Test.stopTest();
        
        // Verify partial success
        Lead convertedLead1 = [SELECT Id, ConvertedAccountId FROM Lead WHERE Id = :testLead1.Id LIMIT 1];
        Lead convertedLead2 = [SELECT Id, ConvertedAccountId FROM Lead WHERE Id = :testLead2.Id LIMIT 1];
        
        assert.areNotEqual(null, convertedLead1.ConvertedAccountId, 'Lead 1 should have a converted Account Id.');
        assert.areNotEqual(null, convertedLead2.ConvertedAccountId, 'Lead 2 should have a converted Account Id.');
        
       
    }


}