@isTest
public class BI_PSPB_TreatmentWidgetCtrlTest {
 	public static User portalAccountOwner1;
    public static Account testAccount;
    public static CareProgramEnrollee testCareProgramEnrolle;
    
  
    	@isTest
	static void testGetTreatmentByCurrentUserName() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account portalAccount1 = new Account(
				FirstName = 'Test',
				LastName = 'Account',
				PersonEmail = 'test12345@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Your test data setup (if required)

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';

			Contact con = new Contact(
				LastName = 'testusernew@example.com',
				Email = 'testusernew@example.com'
			);
			insert con;

			//Creating Test User
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id
			);
			insert testUser;
			//Creating Person Account for the User
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			//Creating Care program to insert careProgram Enrollee
			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;
			//To create Care Program Enrollee for Assessment
			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;			
			System.runAs(testUser) {
			Test.startTest();
            try {
                Map<String, Object> prepopulatedValues = BI_PSPB_TreatmentWidgetCtrl.prepopulatedValues();
                System.assertNotEquals(null, prepopulatedValues, 'The prepopulated values map should not be null.');
                System.assertEquals(null, prepopulatedValues.get(System.Label.BI_PSPB_SelectedCheckBox), 'There should be no selected checkboxes value.');
            } catch (Exception e) {
                System.assertEquals('Script-thrown exception', e.getMessage(), 'Method thrown exception');
            }
            Test.stopTest();
        
			}
		}
	}

    	@isTest
	static void testGetTreatmentOneByCurrentUserName() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce',
			LastName = 'Wayne',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;

		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account portalAccount1 = new Account(
				FirstName = 'Test',
				LastName = 'Account',
				PersonEmail = 'test12345@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'ApplicationName',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			// Your test data setup (if required)

			String currentUserName = 'Test User';
			String currentUserEmail = 'testusernew@example.com';

			Contact con = new Contact(
				LastName = 'testusernew@example.com',
				Email = 'testusernew@example.com'
			);
			insert con;

			//Creating Test User
			User testUser = new User(
				Email = 'testusernew@example.com',
				BI_PSPB_Caregiver__c = false,
				Username = 'testusernew@example.com',
				FirstName = 'Test',
				LastName = 'User',
				Alias = 'tesn',
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id
			);
			insert testUser;
			//Creating Person Account for the User
			Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();

			Account testAccountOne = new Account(
				Lastname = currentUserName,
				PersonEmail = currentUserEmail,
				RecordTypeId = personAccountRecordTypeId
			);
			insert testAccountOne;

			//Creating Care program to insert careProgram Enrollee
			CareProgram carePrgm = new CareProgram(
				Name = 'testcp',
				StartDate = Date.valueOf('2024-02-28')
			);

			insert carePrgm;
			//To create Care Program Enrollee for Assessment
			CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
				Name = 'TestCpa111',
				AccountId = testAccountOne.Id,
				CareProgramId = carePrgm.Id
			);
			insert testCpeOne;			
			System.runAs(testUser) {
			Test.startTest();
            try {
				List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentWidgetCtrl.getTasksWithDateOfTreatment();
				System.assertEquals(0, reminders.size(), 'The reminders list should be empty.');
            } catch (Exception e) {
                System.assertEquals('Script-thrown exception', e.getMessage(), 'Method thrown exception');
            }
            Test.stopTest();
        
			}
		}
	}
    @isTest
static void testPrepopulatedValues() {
    UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
    Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = 'treatmentwidget@wayneenterprises.com',
        Alias = 'batman',
        Email = 'treatmentwidget@wayneenterprises.com',
        EmailEncodingKey = 'UTF-8',
        FirstName = 'Bruce',
        LastName = 'Wayne',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        TimeZoneSidKey = 'America/Chicago'
    );
    insert portalAccountOwner1;

    System.runAs(portalAccountOwner1){
        RecordType personAccountRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
            LIMIT 1
        ];

        // Create Person Account
        Account portalAccount1 = new Account(
            FirstName = 'Te',
            LastName = 'Account',
            PersonEmail = 'currrent3@user.com',
            OwnerId = portalAccountOwner1.Id,
            RecordTypeId = personAccountRecordType.Id
        );
        insert portalAccount1;
        

        // Create user associated with Person Account
        Profile portalProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];
        Contact personContact = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :portalAccount1.Id
            LIMIT 1
        ];
        User user1 = new User(
            Username = 'currrent3@user.com',
            ContactId = personContact.Id,
            BI_PSPB_Caregiver__c = false,
            ProfileId = portalProfile.Id,
            Alias = 'tew',
            Email = 'currrent3@user.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Account',
            FirstName = 'Test',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert user1;

        // Create Test Account
        Account testAccountOne = new Account(
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = System.now().millisecond() + 'currrent3@user.com',
            RecordTypeId = personAccountRecordType.Id,
            BI_PSPB_Selected_Patient_ID__c = portalAccount1.Id
        );
        insert testAccountOne;

        // Creating Care program to insert CareProgramEnrollee
        CareProgram carePrgm = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );
        insert carePrgm;
       

        // To create Care Program Enrollee for Assessment
        CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
            Name = 'TestCpa111',
            AccountId = portalAccount1.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCpeOne;
       

        System.runAs(user1) {
            Test.startTest();
            try {
                Map<String, Object> prepopulatedValues = BI_PSPB_TreatmentWidgetCtrl.prepopulatedValues();
                System.assertNotEquals(null, prepopulatedValues, 'The prepopulated values map should not be null.');
                System.assertEquals(null, prepopulatedValues.get(System.Label.BI_PSPB_SelectedCheckBox), 'There should be no selected checkboxes value.');
            } catch (Exception e) {
                System.assertEquals('Script-thrown exception', e.getMessage(), 'Method thrown exception');
            }
            Test.stopTest();
        }
    }
}


    
    @isTest
static void testGetFilteredMetadata() {
    List<BI_PSPB_Notification__mdt> allMetadata = new List<BI_PSPB_Notification__mdt>{
        new BI_PSPB_Notification__mdt(MasterLabel = 'Reminder One', DeveloperName = 'ReminderOne'),
        new BI_PSPB_Notification__mdt(MasterLabel = 'Reminder Two', DeveloperName = 'ReminderTwo'),
        new BI_PSPB_Notification__mdt(MasterLabel = 'Treatment One', DeveloperName = 'TreatmentOne'),
        new BI_PSPB_Notification__mdt(MasterLabel = 'Treatment Two', DeveloperName = 'TreatmentTwo')
    };

    Set<String> developerNames = new Set<String>{'ReminderOne', 'TreatmentOne'};

    Test.startTest();
    try {
        List<BI_PSPB_Notification__mdt> filteredMetadata = BI_PSPB_TreatmentCtrl.getFilteredMetadata(allMetadata, developerNames);
        
        System.assertNotEquals(null, filteredMetadata, 'The filtered metadata should not be null');
        System.assertEquals(2, filteredMetadata.size(), 'The number of filtered metadata records should be 2');

        Set<String> filteredNames = new Set<String>();
        for (BI_PSPB_Notification__mdt metadata : filteredMetadata) {
            filteredNames.add(metadata.DeveloperName);
        }

        System.assert(filteredNames.contains('ReminderOne'), 'Filtered metadata should contain ReminderOne');
        System.assert(filteredNames.contains('TreatmentOne'), 'Filtered metadata should contain TreatmentOne');
        System.assert(!filteredNames.contains('ReminderTwo'), 'Filtered metadata should not contain ReminderTwo');
        System.assert(!filteredNames.contains('TreatmentTwo'), 'Filtered metadata should not contain TreatmentTwo');
        
    } catch (Exception e) {
      
        System.assert(false, 'An unexpected exception occurred: ' + e.getMessage());
    }
    Test.stopTest();
}    

@isTest
static void testGetTasksWithDateOfTreatmentNoReminders() {
        // Ensure that the correct CareProgramEnrollee record is fetched
       // CareProgramEnrollee insertedCPE = [SELECT Id FROM CareProgramEnrollee WHERE Id = :testCPE.Id LIMIT 1];
        try{
            Test.startTest();
            List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentWidgetCtrl.getTasksWithDateOfTreatment();
            System.assertEquals(0, reminders.size(), 'The reminders list should be empty.');
            Test.stopTest();
        } catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
        
    
}


     @isTest
	static void testGetTasksWithDateOfTreatmentInvalidId() {            
		try {
			Test.startTest();
			// Call the method
		   BI_PSPB_TreatmentWidgetCtrl.getTasksWithDateOfTreatment();
			Test.stopTest();
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	
	}
}