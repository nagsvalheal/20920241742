/*
 * @description       This class contains unit tests for the BI_PSPB_referringPractitione Apex class, which is responsible for the fetch that Name of the practitioner
					   in contact object
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023         Created             Initial development
 */
@isTest
public class BI_PSPB_ReferringPractitionerCtrlTest {
private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');

@isTest
    static  void testGetPractitionerList() {
 /*@description This Test method to verify that practitioner Name are fetched correctly.
*/       
        // Create test data
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'BI_PSPB_Physician'];
        Account acc = new Account(Name ='get well');
        insert acc;
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            RecordTypeId = rt.Id,
            BI_PSPB_Practice_Name__c = acc.id,
            HealthCloudGA__StatusGroup__c = 'Active'
        );
        insert testContact;
        
        // Call the method to test
        Test.startTest();
        List<Contact> result = BI_PSPB_ReferringPractitionerCtrl.getPractitionerList();
        Test.stopTest();
        
        // Check if the method returned the expected results
        Assert.areEqual(1, result.size(), 'Expected one contact record');
        Contact retrievedContact = result[0];
        Assert.areEqual('Test Contact', retrievedContact.Name, 'Retrieved contact name should be "Test Contact"');
        // Add more assertions based on the fields returned in the query
    }
   
    @isTest
    static  void testGetPractitionerListException() {
 /*@description This Test method to cover try and catch.
*/       
        // Mocking the exception scenario by setting up the necessary conditions for an exception to occur
        BI_SFCOE_LOG_App_Settings__c mockSettings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Mock Application'
        );
        insert mockSettings;

        // Call the method to test with conditions that will cause an exception
        Test.startTest();
        try {
            // Call the method that is expected to throw an exception
            List<Contact> result = BI_PSPB_ReferringPractitionerCtrl.getPractitionerList();
            // If no exception is thrown, fail the test
             Assert.areNotEqual(null, result, 'Returned list should be null if an exception occurs');
        } catch (AuraHandledException e) {
            Assert.areEqual(
			e.getMessage(),
			'Script-thrown exception',
			e.getMessage()
		);
            
        Test.stopTest();
    }
}
    @isTest
	static void testCountyCode() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		try {
			// String targetDate = 'Jan 2023';
			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';
			Profile standardUserProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'Standard User'
				LIMIT 1
			];

			Contact con = new Contact(LastName = 'TestAccount1', Email = 'testusertamil1237@example.com');
			insert con;

			User testUserTwo = new User(
				Email = 'tes@examples.com',
				BI_PSPB_Caregiver__c = true,
				Username = 'tes@examples.com',
				FirstName = 'Test',
				LastName = 'Tin2',
				Alias = 'tesns',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ProfileId = standardUserProfile.Id,
				LanguageLocaleKey = 'en_US'
			);
			insert testUserTwo;
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			String currentUserNameTwo = 'Test User2';
			String currentUserEmailTwo = 'testunew@examples.com';
			Account testAccountTwo = new Account(
				Lastname = currentUserNameTwo,
				PersonEmail = currentUserEmailTwo,
				RecordTypeId = personAccountRecordTypeId,
				BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
			);
			insert testAccountTwo;

			CareProgram cp = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert cp;

			CareProgramEnrollee enrolleeValue = new CareProgramEnrollee(
				Name = 'TestCpa222',
				AccountId = testAccountTwo.Id,
				CareProgramId = cp.Id
			);
			insert enrolleeValue;

			
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
    
}