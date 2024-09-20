@isTest
/** 
* @description       : This is a BI_PSPB_PatientEntityCtrlTest test class designed to test the functionality of the BI_PSPB_PatientEntityCtrl class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_PatientEntityCtrlTest {
	
	// Create test data for Leads and related objects
	private static Lead createTestLead() {
		Lead testLead = new Lead(
			FirstName = 'Test',
			LastName = 'User',
			Company = 'Test Company',
			Phone = '1234567890',
			BI_PSPB_Preferred_Communication_Method__c = 'Email',
			CountryCode = 'US',
			StateCode = 'CA',
			City = 'San Francisco',
			Street = '123 Test St',
			PostalCode = '94105'
		);
		insert testLead;
		return testLead;
	}

	private static BI_PSPB_Lead_Caregiver__c createTestLeadCaregiver(Id leadId) {
		BI_PSPB_Lead_Caregiver__c caregiver = new BI_PSPB_Lead_Caregiver__c(
			BI_PSPB_Lead__c = leadId,
			BI_PSPB_Preferred_Communication_Method__c = 'Phone',
			BI_PSPB_Relationship_to_Patient__c = 'Parent',
			BI_PSPB_Phone_number__c = '0987654321'
		);
		insert caregiver;
		return caregiver;
	}

	// Test for updateLeadRecord method
	@isTest
	static void testUpdateLeadRecord() {
		// Prepare test data
		Lead testLead = createTestLead();
		BI_PSPB_PatientEntityCtrl.LeadWrapper leadWrapper = new BI_PSPB_PatientEntityCtrl.LeadWrapper();
		leadWrapper.leadId = testLead.Id;
		leadWrapper.phone = '0987654321';
		leadWrapper.prefferedMethodOfCom = 'Phone';
		leadWrapper.country = 'US';
		leadWrapper.state = 'CA';
		leadWrapper.city = 'Los Angeles';
		leadWrapper.street = '456 New St';
		leadWrapper.zipCode = '90001';

		// Execute the method
		Test.startTest();
		BI_PSPB_PatientEntityCtrl.updateLeadRecord(leadWrapper);
		Test.stopTest();

		// Verify the Lead was updated correctly
		Lead updatedLead = [SELECT Phone, BI_PSPB_Preferred_Communication_Method__c, CountryCode, StateCode, City, Street, PostalCode FROM Lead WHERE Id = :testLead.Id];
		Assert.areEqual('0987654321', updatedLead.Phone, 'Expected the phone number to be updated correctly.');
		Assert.areEqual('Phone', updatedLead.BI_PSPB_Preferred_Communication_Method__c, 'Expected the preferred communication method to be updated correctly.');
		Assert.areEqual('US', updatedLead.CountryCode, 'Expected the country code to be updated correctly.');
		Assert.areEqual('CA', updatedLead.StateCode, 'Expected the state code to be updated correctly.');
		Assert.areEqual('Los Angeles', updatedLead.City, 'Expected the city to be updated correctly.');
		Assert.areEqual('456 New St', updatedLead.Street, 'Expected the street address to be updated correctly.');
		Assert.areEqual('90001', updatedLead.PostalCode, 'Expected the postal code to be updated correctly.');
		

		// Verify a Lead Consent record was inserted
		BI_PSP_Lead_Consent__c consent = [SELECT BI_PSP_I_agree__c, BI_PSPB_Consent_Category__c FROM BI_PSP_Lead_Consent__c WHERE BI_PSP_Lead__c = :testLead.Id];
		Assert.areEqual(true, consent.BI_PSP_I_agree__c,'Expected the agree to be updated correctly');
		Assert.areEqual('Patient', consent.BI_PSPB_Consent_Category__c, 'Expected the consent category to be updated correctly');
	}

	// Test for updateLead method
	@isTest
	static void testUpdateLead() {
		// Prepare test data
		Lead testLead = createTestLead();
		BI_PSPB_Lead_Caregiver__c caregiver = createTestLeadCaregiver(testLead.Id);
		assert.areNotEqual(null, caregiver, 'Expected caregiver to be created.');

		// Execute the method
		Test.startTest();
		BI_PSPB_PatientEntityCtrl.updateLead(
			testLead.Id,
			'Email',
			'Parent',
			'1112223333'
		);
		Test.stopTest();

		// Verify the Caregiver record was updated correctly
		BI_PSPB_Lead_Caregiver__c updatedCaregiver = [SELECT BI_PSPB_Preferred_Communication_Method__c, BI_PSPB_Relationship_to_Patient__c, BI_PSPB_Phone_number__c FROM BI_PSPB_Lead_Caregiver__c WHERE BI_PSPB_Lead__c = :testLead.Id];
		Assert.areEqual('Email', updatedCaregiver.BI_PSPB_Preferred_Communication_Method__c, 'Expected the preferred communication method for the caregiver to be updated correctly.');
		Assert.areEqual('Parent', updatedCaregiver.BI_PSPB_Relationship_to_Patient__c, 'Expected the relationship to the patient to be updated correctly.');
		Assert.areEqual('1112223333', updatedCaregiver.BI_PSPB_Phone_number__c, 'Expected the caregiver\'s phone number to be updated correctly.');
		

		// Verify a Lead Consent record was inserted
		BI_PSP_Lead_Consent__c consent = [SELECT BI_PSPB_Consent_Category__c FROM BI_PSP_Lead_Consent__c WHERE BI_PSP_Lead__c = :testLead.Id];
		Assert.areEqual('Caregiver', consent.BI_PSPB_Consent_Category__c, 'Expected the consent category to be updated to "Caregiver".');

	}

	// Test for updateLeadCareRecord method
	@isTest
	static void testUpdateLeadCareRecord() {
		// Prepare test data
		Lead testLead = createTestLead();
		BI_PSPB_PatientEntityCtrl.LeadWrapper leadWrapper = new BI_PSPB_PatientEntityCtrl.LeadWrapper();
		leadWrapper.leadId = testLead.Id;
		leadWrapper.gender = 'Male';
		leadWrapper.country = 'US';
		leadWrapper.state = 'NY';
		leadWrapper.city = 'New York';
		leadWrapper.street = '789 Care St';
		leadWrapper.zipCode = '10001';

		// Execute the method
		Test.startTest();
		BI_PSPB_PatientEntityCtrl.updateLeadCareRecord(leadWrapper);
		Test.stopTest();

		// Verify the Lead record was updated correctly
		Lead updatedLead = [SELECT HealthCloudGA__Gender__c, CountryCode, StateCode, City, Street, PostalCode FROM Lead WHERE Id = :testLead.Id];
		Assert.areEqual('Male', updatedLead.HealthCloudGA__Gender__c, 'Expected the gender to be updated correctly.');
		Assert.areEqual('US', updatedLead.CountryCode, 'Expected the country code to be updated correctly.');
		Assert.areEqual('NY', updatedLead.StateCode, 'Expected the state code to be updated correctly.');
		Assert.areEqual('New York', updatedLead.City, 'Expected the city to be updated correctly.');
		Assert.areEqual('789 Care St', updatedLead.Street, 'Expected the street address to be updated correctly.');
		Assert.areEqual('10001', updatedLead.PostalCode, 'Expected the postal code to be updated correctly.');
		
	}
}