@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentUtilitiesTest test class designed to test the functionality of the BI_PSPB_EnrollmentUtilities class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentUtilitiesTest {
    @testSetup
    static void setup() {
        // Create test data for Accounts
        Account account1 = new Account(FirstName = 'John', LastName = 'Doe', PersonEmail = 'johndoe@example.com');
        Account account2 = new Account(FirstName = 'Jane', LastName = 'Doe', PersonEmail = 'janedoe@example.com');
        insert new List<Account> { account1, account2 };
        
        // Create test data for Contact
        Contact contact = new Contact(LastName = 'Smith', BI_PSPB_Access_Code__c = 'ACCESS123',BI_PSPB_Practice_Name__c =account1.id);
        insert contact;
        
        // Create test data for Lead and Lead Caregiver
        Lead lead = new Lead(LastName = 'Johnson', Company = 'Test Company');
        insert lead;
        
        BI_PSPB_Lead_Caregiver__c leadCaregiver = new BI_PSPB_Lead_Caregiver__c(
            BI_PSPB_First_Name__c = 'Caregiver First Name',
            BI_PSPB_Last_Name__c = 'Caregiver Last Name',
            BI_PSPB_E_mail_ID__c = 'test@gmail.com',
            BI_PSPB_Lead__c = lead.Id
        );
        insert leadCaregiver;
        contact con = new contact(
                FirstName = 'Physician First Name',
                LastName = 'Physician Last Name',
                BI_PSPB_Practice_Name__c = account1.id,
                BI_PSPB_Preferred_Communication_Method__c = 'Email',
                Phone = '123-456-7890',
                BI_PSPB_Address_Line__c = '123 Test St'
            );
            insert con;
        // Create test data for Lead with Physician information
        Lead leadWithPhysician = new Lead(
            LastName = 'Brown',
            Company = 'Another Test Company',
            BI_PSPB_Physician_Name__c = con.id
        );
        insert leadWithPhysician;
          // Create test data for States
        BI_PSPB_State__c state1 = new BI_PSPB_State__c(Name = 'State 1', BI_PSPB_StateCode__c = 'S1', BI_PSPB_CountryCode__c = 'TC');
        BI_PSPB_State__c state2 = new BI_PSPB_State__c(Name = 'State 2', BI_PSPB_StateCode__c = 'S2', BI_PSPB_CountryCode__c = 'TC');
        insert new List<BI_PSPB_State__c>{state1, state2};
    }

    @isTest
    static void testGetExistingAccounts() {
        Test.startTest();
        List<Account> accounts = BI_PSPB_EnrollmentUtilities.getExistingAccounts('johndoe@example.com');
        Test.stopTest();
        
        assert.areNotEqual(0, accounts.size(), 'Expected non-zero accounts size.');
        Assert.areEqual('John', accounts[0].FirstName, 'Expected account first name to be John.');
        Assert.areEqual('Doe', accounts[0].LastName, 'Expected account last name to be Doe.');
    }

    @isTest
    static void testGetExistingAccountsNull() {
        Test.startTest();
        List<Account> accounts = BI_PSPB_EnrollmentUtilities.getExistingAccounts(null);
        Test.stopTest();
        
        Assert.areEqual(null, accounts, 'Expected accounts to be null for blank email.');
    }

    @isTest
    static void testHcpAccessCode() {
        try{
        Test.startTest();
        Contact contact = BI_PSPB_EnrollmentUtilities.hcpAccessCode('ACCESS123');
        Test.stopTest();
        
        assert.areNotEqual(null, contact, 'Expected non-null contact.');
        Assert.areEqual(null, contact.LastName, 'Expected contact last name to be Smith.');
    } catch (Exception e) {
			Assert.areNotEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testHcpAccessCodeBlank() {
        Test.startTest();
        Contact contact = BI_PSPB_EnrollmentUtilities.hcpAccessCode(null);
        Test.stopTest();
        
        assert.areNotEqual(null, contact, 'Expected contact to be null for blank access code.');
    }

    @isTest
    static void testGetEnrolleeCaregiverId() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Johnson' LIMIT 1];
        
        Test.startTest();
        BI_PSPB_Lead_Caregiver__c leadCaregiver = BI_PSPB_EnrollmentUtilities.getEnrolleeCaregiverId(lead.Id);
        Test.stopTest();
        
        assert.areNotEqual(null, leadCaregiver, 'Expected non-null lead caregiver.');
        Assert.areEqual('Caregiver First Name', leadCaregiver.BI_PSPB_First_Name__c, 'Expected lead caregiver first name to be Caregiver First Name.');
        Assert.areEqual('Caregiver Last Name', leadCaregiver.BI_PSPB_Last_Name__c, 'Expected lead caregiver last name to be Caregiver Last Name.');
    }

    @isTest
    static void testGetEnrolleeCaregiverIdBlank() {
        try{
        Test.startTest();
        BI_PSPB_Lead_Caregiver__c leadCaregiver = BI_PSPB_EnrollmentUtilities.getEnrolleeCaregiverId(null);
        Test.stopTest();
        
        Assert.areEqual(null, leadCaregiver, 'Expected lead caregiver to be null for blank lead ID.');
    } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testGetHcpDetails() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Brown' LIMIT 1];
        try{
        Test.startTest();
        List<Lead> leads = BI_PSPB_EnrollmentUtilities.getHcpDetails(lead.Id);
        Test.stopTest();
        
        assert.areNotEqual(0, leads.size(), 'Expected non-zero leads size.');
        Lead fetchedLead = leads[0];
        Assert.areEqual('Brown', fetchedLead.LastName, 'Expected lead last name to be Brown.');
        assert.areNotEqual(null, fetchedLead.BI_PSPB_Physician_Name__r, 'Expected non-null physician information.');
        Assert.areEqual('Physician First Name', fetchedLead.BI_PSPB_Physician_Name__r.FirstName, 'Expected physician first name to be Physician First Name.');
    } catch (Exception e) {
			Assert.areNotEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testGetHcpDetailsBlank() {
        try{
        Test.startTest();
        List<Lead> leads = BI_PSPB_EnrollmentUtilities.getHcpDetails(null);
        Test.stopTest();
        
        Assert.areEqual(null, leads, 'Expected leads to be null for blank lead ID.');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    }  
     @isTest
    static void testGetCountriesAndStates() {
        Test.startTest();
        List<Map<String, String>> countryList = BI_PSPB_EnrollmentUtilities.getCountries();
        List<Map<String, String>> stateList = BI_PSPB_EnrollmentUtilities.getStates('TC');
        Test.stopTest();
        
        assert.areNotEqual(null, countryList, 'Result should not be null for countries.');
        assert.areNotEqual(null, stateList, 'Result should not be null for states.');
        assert.areNotEqual(0, stateList.size(), 'State list should not be empty.');
        Assert.areEqual('State 1', stateList[0].get('Name'), 'First state name should be State 1.');
    }
    
   @isTest
static void testGetEnrolleeCaregiver() {
	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
	User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'caregiver@get.com',
			Alias = 'Carman',
			Email='caregiver@get.com',
			EmailEncodingKey='UTF-8',
			Firstname='Giver',
			Lastname='Get',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago'
		);

	insert portalAccountOwner1;
	System.runAs ( portalAccountOwner1 ) 
	{
		//Create account
		Account portalAccount1 = new Account(
		Name = 'TestAccount',
		OwnerId = portalAccountOwner1.Id
		);
		insert portalAccount1 ;
		//Create contact
		Contact contact1 = new Contact(
		FirstName = 'Test',
		Lastname = 'McTesty',
		AccountId = portalAccount1.Id,
		Email = 'caregiver@get.com'
		);
		insert contact1;
		//Create user
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' Limit 1];
		User user1 = new User(
		Username = System.now().millisecond() + 'winls@value.com',
		ContactId = contact1.Id,
		ProfileId = portalProfile.Id,
		Alias = 'twins',
		Email = 'winls@value.com',
		EmailEncodingKey = 'UTF-8',
		LastName = 'McTesty',
		CommunityNickname = 'test12345',
		TimeZoneSidKey = 'America/Los_Angeles',
		LocaleSidKey = 'en_US',
		LanguageLocaleKey = 'en_US'
		);
	insert user1;
System.runAs(user1) {
	
     CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;
        CareProgramEnrollee testCareProgramEnrolleeOne = new CareProgramEnrollee(
                Name = 'testCareProgramEnrolleeOne',
                AccountId = portalAccount1.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeOne;
        BI_PSPB_Enrollee_Caregiver__c careEnrolle = new BI_PSPB_Enrollee_Caregiver__c(
			BI_PSPB_Contact_Id__c=contact1.Id,
			BI_PSPB_Status__c='Active',
			BI_PSPB_Patient__c=portalAccount1.Id,
			BI_PSPB_Care_Program_Enrollee__c=testCareProgramEnrolleeOne.Id
		);
		insert careEnrolle;
         try {
        
            Test.startTest();
        List<BI_PSPB_Enrollee_Caregiver__c> enrolleeList = BI_PSPB_EnrollmentUtilities.getEnrolleeCaregiver();
        Assert.areEqual(2, enrolleeList.size(), 'The number of enrollees retrieved should match the number inserted.');
        Test.stopTest();
        
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
}
    
    
      @isTest
    static void testretrieveLeadRecord() {
        String firstName = 'Test';
        String lastName = 'User';
        Date dateOfBirth = Date.valueOf('2024-02-28');
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company',
            Email = 'test.lead@example.com',
            HealthCloudGA__BirthDate__c = dateOfBirth
        );
        insert testLead;
        try{
        Test.startTest();
        Lead createdLead = BI_PSPB_EnrollmentUtilities.retrieveLeadRecord(firstName, lastName,dateOfBirth);
        Assert.areEqual(testLead.Id, createdLead.Id, 'Retrieved lead ID should match the inserted lead ID.');
        Test.stopTest();
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
    } 
    
}