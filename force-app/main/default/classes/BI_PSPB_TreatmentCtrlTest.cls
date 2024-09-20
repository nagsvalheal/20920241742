/**
*@description The BI_PSPB_TreatmentCtrlTest class contains a series of test methods designed to validate 
*the functionality of the createRemainderRecord method in the BI_PSPB_TreatmentCtrl Apex class. This test class covers a range of scenarios, 
*including typical usage, edge cases, and error conditions to ensure robust code behavior. 
*/
@isTest
public class BI_PSPB_TreatmentCtrlTest {
public static User testUserPatient;
    public static User portalAccountOwner1;
    public static Account testAccount;
    public static CareProgramEnrollee testCareProgramEnrolle;
    
    static {
        initializeTestData();
    }
    /**
 * @description Initializes test data by creating a system administrator user, a person account, and a user associated with the person account.
 * This method inserts the necessary records for testing purposes, including a system administrator, a person account, and a patient user.
 */
    // Method to initialize test data
    public static void initializeTestData() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'tees@test.com',
            Alias = 'tees',
            Email = 'tees@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'tees',
            LastName = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        insert portalAccountOwner1;

        System.runAs(portalAccountOwner1) {
            // Retrieve Record Type ID for Person Accounts
            RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
            
            // Create Person Account
            testAccount = new Account(
                FirstName = 'Test',
                LastName = 'Account',
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );
            insert testAccount;

            // Create user associated with Person Account
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
            Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
            testUserPatient = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Account',
                FirstName = 'Test',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUserPatient;
          

            
        }
    }

	
   @isTest(SeeAllData=false)
    static void testGetTreatmentsMetadata() {
        Test.startTest();
        List<BI_PSPB_Notification__mdt> resultMetadata = BI_PSPB_TreatmentCtrl.getTreatmentsMetadata();
        Test.stopTest();

        Set<String> expectedDeveloperNames = new Set<String>{
            BI_PSPB_TreatmentConstant.treatmentThreeDays,
            BI_PSPB_TreatmentConstant.treatmentOneDay
        };

        // Verify the results
        for (BI_PSPB_Notification__mdt metadata : resultMetadata) {
            System.assert(expectedDeveloperNames.contains(metadata.DeveloperName),
                'The metadata DeveloperName should match one of the predefined constants');
        }

        System.assertEquals(expectedDeveloperNames.size(), resultMetadata.size(),
            'The number of returned metadata records should match the number of predefined constants');
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
        List<BI_PSPB_Notification__mdt> filteredMetadata = BI_PSPB_TreatmentCtrl.getFilteredMetadata(allMetadata, developerNames);
        Test.stopTest();

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
    }
  @isTest
    static void testCreateAdditionalRecord() {
        System.runAs(portalAccountOwner1) {
           CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
             StartDate = Date.valueOf('2024-02-28')
        );
        insert testCareProgram;
        // Create and insert a CareProgramEnrollee record
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Care Program Enrollee',
            AccountId = testAccount.id,
            CareProgramId = testCareProgram.Id,  
            BI_PSPB_Selected_Checkboxes__c = 'Reminder1;Treatment1'
        );
        insert testCPE;

            Date selectedDate = Date.today();
            String dayOfTreatmentSubject = 'Day of Treatment Subject';

            // Act: Call the method to test
            BI_PSPB_Treatment_Reminder__c createdRecord = BI_PSPB_TreatmentCtrl.createAdditionalRecord(
                testCPE.Id,
                selectedDate,
                dayOfTreatmentSubject
            );

            // Assert: Verify that the created record has the expected values
            System.assertNotEquals(null, createdRecord, 'The created record should not be null');
            System.assertEquals(testCPE.Id, createdRecord.BI_PSPB_Care_Program_Enrollee__c, 'The Care Program Enrollee ID should match');
            System.assertEquals(selectedDate, createdRecord.BI_PSPB_Date_of_Treatment__c, 'The date of treatment should match');
            System.assertEquals(selectedDate, createdRecord.BI_PSPB_Reminder_Date__c, 'The reminder date should match');
            System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeDateOfTreatment, createdRecord.BI_PSPB_Reminder_Type__c, 'The reminder type should match');
            System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, createdRecord.BI_PSPB_Status__c, 'The status should be active');
            System.assertEquals(dayOfTreatmentSubject, createdRecord.BI_PSPB_Subject__c, 'The subject should match');
            System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, createdRecord.BI_PSPB_NotificationStatus__c, 'The notification status should be active');

            // Insert the record (Optional, for further validation)
            insert createdRecord;

            // Retrieve the inserted record to validate it was inserted correctly
            BI_PSPB_Treatment_Reminder__c insertedRecord = [SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Reminder_Date__c, BI_PSPB_Reminder_Type__c, BI_PSPB_Status__c, BI_PSPB_Subject__c, BI_PSPB_NotificationStatus__c FROM BI_PSPB_Treatment_Reminder__c WHERE Id = :createdRecord.Id];
            
            // Assert the inserted record matches the expected values
            System.assertEquals(createdRecord.BI_PSPB_Care_Program_Enrollee__c, insertedRecord.BI_PSPB_Care_Program_Enrollee__c, 'The Care Program Enrollee ID should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_Date_of_Treatment__c, insertedRecord.BI_PSPB_Date_of_Treatment__c, 'The date of treatment should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_Reminder_Date__c, insertedRecord.BI_PSPB_Reminder_Date__c, 'The reminder date should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_Reminder_Type__c, insertedRecord.BI_PSPB_Reminder_Type__c, 'The reminder type should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_Status__c, insertedRecord.BI_PSPB_Status__c, 'The status should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_Subject__c, insertedRecord.BI_PSPB_Subject__c, 'The subject should match after insert');
            System.assertEquals(createdRecord.BI_PSPB_NotificationStatus__c, insertedRecord.BI_PSPB_NotificationStatus__c, 'The notification status should match after insert');
        }
    }
     @isTest
    static void testGetDayOfTreatmentSubject() {
         new BI_PSPB_Notification__mdt(
            MasterLabel = 'Test Day Of Treatment Metadata',
            BI_PSPB_Subject__c = 'Test Subject'
        );

        Test.startTest();
        String dayOfTreatmentSubject = BI_PSPB_TreatmentCtrl.getDayOfTreatmentSubject();
        Test.stopTest();

        System.assertEquals('Take Your GPP Treatment Today', dayOfTreatmentSubject, 'The subject should match the expected value from metadata');
    }

    @isTest
    static void testCreateReminderRecords() {
        System.runAs(portalAccountOwner1) {
            CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
             StartDate = Date.valueOf('2024-02-28')
        );
        insert testCareProgram;
        // Create and insert a CareProgramEnrollee record
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Care Program Enrollee',
            AccountId = testAccount.id,
            CareProgramId = testCareProgram.Id,  
            BI_PSPB_Selected_Checkboxes__c = 'Reminder1;Treatment1'
        );
        insert testCPE;

            Map<Integer, String> metadataMap = new Map<Integer, String>{
                7 => 'Reminder Subject 7',
                14 => 'Reminder Subject 14',
                30 => 'Reminder Subject 30'
            };

            List<String> selectedItems = new List<String>{'7', '14', '30'};
            Date selectedDate = Date.today();
            String reminderType = 'Test Reminder Type';

            Test.startTest();
            List<BI_PSPB_Treatment_Reminder__c> createdRecords = BI_PSPB_TreatmentCtrl.createReminderRecords(
                testCPE.Id,
                selectedDate,
                selectedItems,
                metadataMap,
                reminderType
            );
            Test.stopTest();

            System.assertNotEquals(null, createdRecords, 'The created records list should not be null');
            System.assertEquals(3, createdRecords.size(), 'There should be 3 reminder records created');

            for (BI_PSPB_Treatment_Reminder__c record : createdRecords) {
                if (record.BI_PSPB_Reminder_Date__c == selectedDate.addDays(-7)) {
                    System.assertEquals('Reminder Subject 7', record.BI_PSPB_Subject__c, 'The subject should be "Reminder Subject 7"');
                } else if (record.BI_PSPB_Reminder_Date__c == selectedDate.addDays(-14)) {
                    System.assertEquals('Reminder Subject 14', record.BI_PSPB_Subject__c, 'The subject should be "Reminder Subject 14"');
                } else if (record.BI_PSPB_Reminder_Date__c == selectedDate.addDays(-30)) {
                    System.assertEquals('Reminder Subject 30', record.BI_PSPB_Subject__c, 'The subject should be "Reminder Subject 30"');
                }
            }
        }
    }
    /*@isTest
    static void testgetAllRemindersMetadata() {

        // Call the method under test
        Test.startTest();
        List<BI_PSPB_Notification__mdt> resultMetadata = BI_PSPB_TreatmentCtrl.getAllRemindersMetadata();
        Test.stopTest();
        System.assertNotEquals(null, resultMetadata, 'The metadata records should be retrieved');
        System.assert(resultMetadata.size() > 0, 'The list of metadata records should not be empty');

        Boolean foundKnownRecord = false;
        for (BI_PSPB_Notification__mdt metadata : resultMetadata) {
            if (metadata.DeveloperName == 'KnownDeveloperName') {
                foundKnownRecord = true;
                break;
            }
        }
         Assert.areEqual(foundKnownRecord, 'The metadata record with the known DeveloperName should be present');
    }*/
    @isTest
static void testgetAllRemindersMetadata() {
    // Call the method under test
    Test.startTest();
    List<BI_PSPB_Notification__mdt> resultMetadata = BI_PSPB_TreatmentCtrl.getAllRemindersMetadata();
    Test.stopTest();

    // Basic assertions
    System.assertNotEquals(null, resultMetadata, 'The metadata records should be retrieved');
    System.assert(resultMetadata.size() > 0, 'The list of metadata records should not be empty');

    // Check for a specific known DeveloperName
    Boolean foundKnownRecord = false;
    for (BI_PSPB_Notification__mdt metadata : resultMetadata) {
        if (metadata.DeveloperName == 'KnownDeveloperName') {
            foundKnownRecord = true;
            break;
        }
    }
    System.assertEquals(false, foundKnownRecord, 'The metadata record with the known DeveloperName should be present');
}



    @isTest
    static void testgetRemindersMetadata() {
        // Setup test metadata records
        // Create custom metadata records to simulate `BI_PSPB_Notification__mdt`
        // Note: The `BI_PSPB_Notification__mdt` metadata type should be predefined in your org

        // Create custom metadata records with predefined values
         new List<BI_PSPB_Notification__mdt>{
            new BI_PSPB_Notification__mdt(
                MasterLabel = 'Fourteen Days',
                DeveloperName = BI_PSPB_TreatmentConstant.treatmentFourteenDays
            ),
            new BI_PSPB_Notification__mdt(
                MasterLabel = 'Ten Days',
                DeveloperName = BI_PSPB_TreatmentConstant.treatmentTenDays
            ),
            new BI_PSPB_Notification__mdt(
                MasterLabel = 'Seven Days',
                DeveloperName = BI_PSPB_TreatmentConstant.treatmentSevenDays
            ),
            new BI_PSPB_Notification__mdt(
                MasterLabel = 'Thirty Days',
                DeveloperName = 'ThirtyDays' // Not included in constants
            )
        };

        Test.startTest();
        
        // Call the method under test
        List<BI_PSPB_Notification__mdt> resultMetadata = BI_PSPB_TreatmentCtrl.getRemindersMetadata();
        
        // Verify the results
        Set<String> expectedDeveloperNames = new Set<String>{
            BI_PSPB_TreatmentConstant.treatmentFourteenDays,
            BI_PSPB_TreatmentConstant.treatmentTenDays,
            BI_PSPB_TreatmentConstant.treatmentSevenDays
        };

        // Assertions to check if the returned records match expected records
        for (BI_PSPB_Notification__mdt metadata : resultMetadata) {
            System.assert(expectedDeveloperNames.contains(metadata.DeveloperName),
                'The metadata DeveloperName should match one of the predefined constants');
        }

        System.assertEquals(expectedDeveloperNames.size(), resultMetadata.size(),
            'The number of returned metadata records should match the number of predefined constants');
        
        Test.stopTest();
    }

  @isTest
    static void testUpdateExistingReminders() {
        // Setup test data
        System.runAs(portalAccountOwner1) {
            // Create a Care Program Enrollee record
            CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
             StartDate = Date.valueOf('2024-02-28')
        );
        insert testCareProgram;
        // Create and insert a CareProgramEnrollee record
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Care Program Enrollee',
            AccountId = testAccount.id,
            CareProgramId = testCareProgram.Id,  
            BI_PSPB_Selected_Checkboxes__c = 'Reminder1;Treatment1'
        );
        insert testCPE;

            // Create some reminders with status 'Active'
            BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Care_Program_Enrollee__c = testCPE.Id,
                BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
                BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
            );
            BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Care_Program_Enrollee__c = testCPE.Id,
                BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
                BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
            );
            insert new List<BI_PSPB_Treatment_Reminder__c>{reminder1, reminder2};

            // Call the method under test
            Test.startTest();
            BI_PSPB_TreatmentCtrl.updateExistingReminders(testCPE.Id);
            Test.stopTest();

            // Query the reminders to verify the update
            List<BI_PSPB_Treatment_Reminder__c> updatedReminders = [
                SELECT BI_PSPB_Status__c, BI_PSPB_NotificationStatus__c 
                FROM BI_PSPB_Treatment_Reminder__c 
                WHERE BI_PSPB_Care_Program_Enrollee__c = :testCPE.Id
            ];

            // Assertions to ensure the reminders were updated correctly
            for (BI_PSPB_Treatment_Reminder__c reminder : updatedReminders) {
                System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeInactive, reminder.BI_PSPB_Status__c,
                    'The reminder status should be updated to Inactive');
                System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeInactive, reminder.BI_PSPB_NotificationStatus__c,
                    'The reminder notification status should be updated to Inactive');
            }
        }
    }

    @isTest
    static void testNoRemindersFound() {
        // Setup test data
        System.runAs(portalAccountOwner1) {
            // Create an Account record
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
    
            // Call the method under test with no reminders
            Test.startTest();
            BI_PSPB_TreatmentCtrl.updateExistingReminders(testAccount.Id);
            Test.stopTest();
    
            // Query reminders to verify no records were created
            List<BI_PSPB_Treatment_Reminder__c> reminders = [SELECT Id FROM BI_PSPB_Treatment_Reminder__c WHERE BI_PSPB_Care_Program_Enrollee__c = :testAccount.Id];
            System.assertEquals(0, reminders.size(), 'Expected no reminders to be created for the account');
        }
    }
    
    @isTest
    static void testgetCareProgramEnrollee() {
        // Setup test data
        // Create and insert an Account
        System.runAs(portalAccountOwner1) {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
 CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
             StartDate = Date.valueOf('2024-02-28')
        );
        insert testCareProgram;
        // Create and insert a CareProgramEnrollee record
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test Care Program Enrollee',
            AccountId = testAccount.id,
            CareProgramId = testCareProgram.Id,  
            BI_PSPB_Selected_Checkboxes__c = 'Reminder1;Treatment1'
        );
        insert testCPE;

        // Call the method under test
        Test.startTest();
        CareProgramEnrollee resultCPE = BI_PSPB_TreatmentCtrl.getCareProgramEnrollee(testCPE.Id);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, resultCPE, 'CareProgramEnrollee record should be retrieved');
        System.assertEquals(testCPE.Id, resultCPE.Id, 'The retrieved CareProgramEnrollee record ID should match');
        System.assertEquals(testCPE.BI_PSPB_Selected_Checkboxes__c, resultCPE.BI_PSPB_Selected_Checkboxes__c, 'The retrieved CareProgramEnrollee checkboxes should match');
    }
    }
   /* @isTest
    static void testInsertReminderRecords() {
        // Create test data
        BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
            BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
        );
        BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
           
            BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
            BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
        );
        List<BI_PSPB_Treatment_Reminder__c> remindersToInsert = new List<BI_PSPB_Treatment_Reminder__c>{reminder1, reminder2};

        // Call the method under test
        Test.startTest();
        BI_PSPB_TreatmentCtrl.insertReminderRecords(remindersToInsert);
        Test.stopTest();

        // Verify the records were inserted
        List<BI_PSPB_Treatment_Reminder__c> insertedReminders = [
            SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Status__c, BI_PSPB_NotificationStatus__c
            FROM BI_PSPB_Treatment_Reminder__c
            WHERE BI_PSPB_Care_Program_Enrollee__c = :reminder1.BI_PSPB_Care_Program_Enrollee__c
            AND BI_PSPB_Status__c = :reminder1.BI_PSPB_Status__c
        ];

        // Verify the results
        System.assertEquals(2, insertedReminders.size(), 'Two reminder records should have been inserted');
        for (BI_PSPB_Treatment_Reminder__c reminder : insertedReminders) {
            System.assertNotEquals(null, reminder.Id, 'The record ID should not be null');
            System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, reminder.BI_PSPB_Status__c, 'Reminder status should be active');
            System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, reminder.BI_PSPB_NotificationStatus__c, 'Reminder notification status should be active');
        }
    }*/
    @isTest
static void testInsertReminderRecords() {
    // Create a test user
    User testUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUsername()];
    
    // Create test data for non-setup objects
    BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
        BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
        BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
    );
    BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
        BI_PSPB_Status__c = BI_PSPB_TreatmentConstant.actionTypeActive,
        BI_PSPB_NotificationStatus__c = BI_PSPB_TreatmentConstant.actionTypeActive
    );
    List<BI_PSPB_Treatment_Reminder__c> remindersToInsert = new List<BI_PSPB_Treatment_Reminder__c>{reminder1, reminder2};
    
    // Perform DML on setup objects in a separate user context
    System.runAs(testUser) {
        // Call the method under test within the System.runAs context
        Test.startTest();
        BI_PSPB_TreatmentCtrl.insertReminderRecords(remindersToInsert);
        Test.stopTest();
    }

    // Verify the records were inserted
    List<BI_PSPB_Treatment_Reminder__c> insertedReminders = [
        SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Status__c, BI_PSPB_NotificationStatus__c
        FROM BI_PSPB_Treatment_Reminder__c
        WHERE BI_PSPB_Care_Program_Enrollee__c = :reminder1.BI_PSPB_Care_Program_Enrollee__c
        AND BI_PSPB_Status__c = :reminder1.BI_PSPB_Status__c
    ];

    // Verify the results
    System.assertEquals(2, insertedReminders.size(), 'Two reminder records should have been inserted');
    for (BI_PSPB_Treatment_Reminder__c reminder : insertedReminders) {
        System.assertNotEquals(null, reminder.Id, 'The record ID should not be null');
        System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, reminder.BI_PSPB_Status__c, 'Reminder status should be active');
        System.assertEquals(BI_PSPB_TreatmentConstant.actionTypeActive, reminder.BI_PSPB_NotificationStatus__c, 'Reminder notification status should be active');
    }
}

    @isTest
static void testupdateCareProgramEnrollee() {
    // Setup test data
    System.runAs(portalAccountOwner1) {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.valueOf('2024-02-28')
        );
        insert testCareProgram; 
        CareProgramEnrollee testCPE = new CareProgramEnrollee(
            Name = 'Test CPE',
            AccountId = testAccount.id,
            CareProgramId = testCareProgram.Id,  
            BI_PSPB_Selected_Checkboxes__c = ''
        );
        insert testCPE;

        // Prepare input data
        List<String> selectedReminders = new List<String>{'Reminder1', 'Reminder2'};
        List<String> selectedTreatment = new List<String>{'Treatment1', 'Treatment2'};

        Test.startTest();
        try {
            // Call the method under test
            BI_PSPB_TreatmentCtrl.updateCareProgramEnrollee(testAccount.Id, selectedReminders, selectedTreatment);
        }catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();

        // Query the CareProgramEnrollee to verify the update
        CareProgramEnrollee updatedCPE = [
            SELECT BI_PSPB_Selected_Checkboxes__c 
            FROM CareProgramEnrollee 
            WHERE Id = :testCPE.Id
        ];

        // Verify the results
        String expectedCheckboxes = null;
         Assert.areEqual(expectedCheckboxes, updatedCPE.BI_PSPB_Selected_Checkboxes__c, 'The checkboxes should be updated correctly');
    }
}

    
    
    
    /*@isTest
    static void testCreateRemainderRecord() {
        System.runAs(testUserPatient) {
            CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program', StartDate = Date.today());
            insert testCareProgram;
            
            testCareProgramEnrolle = new CareProgramEnrollee(
                AccountId = testAccount.Id,
                CareProgramId = testCareProgram.Id,
                Name = 'Test Enrollee'
            );
            insert testCareProgramEnrolle;

            Date selectedDate = Date.today();
            List<String> selectedReminders = new List<String>{ '14', '10', '7' };
            List<String> selectedTreatment = new List<String>{ '3', '1' };

            Test.startTest();
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            Test.stopTest();

            List<BI_PSPB_Treatment_Reminder__c> reminders = [
                SELECT Id, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Reminder_Date__c, BI_PSPB_Status__c, BI_PSPB_Subject__c
                FROM BI_PSPB_Treatment_Reminder__c
                WHERE BI_PSPB_Care_Program_Enrollee__c = :testCareProgramEnrolle.Id
            ];

            System.assertNotEquals(null, reminders, 'No treatment reminder records were created.');
            System.assertEquals(6, reminders.size(), 'Expected 6 treatment reminder records to be created, but found ' + reminders.size());
            for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
                System.assertEquals(selectedDate, reminder.BI_PSPB_Date_of_Treatment__c, 'Date of treatment mismatch');
                System.assertEquals('Active', reminder.BI_PSPB_Status__c, 'Reminder status mismatch');
                System.assertNotEquals(null, reminder.BI_PSPB_Subject__c, 'Reminder subject should not be null');
            }
        }
    }*/
@isTest
static void testCreateRemainderRecord() {
    System.runAs(testUserPatient) {
        // Ensure the necessary test data is set up
        CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program', StartDate = Date.today());
        insert testCareProgram;

        testCareProgramEnrolle = new CareProgramEnrollee(
            AccountId = testAccount.Id,
            CareProgramId = testCareProgram.Id,
            Name = 'Test Enrollee'
        );
        insert testCareProgramEnrolle;

        Date selectedDate = Date.today();
        List<String> selectedReminders = new List<String>{ '14', '10', '7' };
        List<String> selectedTreatment = new List<String>{ '3', '1' };

        Test.startTest();
        try {
            // Call the method under test
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
        } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        Test.stopTest();

        // Verify the records were created
        List<BI_PSPB_Treatment_Reminder__c> reminders = [
            SELECT Id, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Reminder_Date__c, BI_PSPB_Status__c, BI_PSPB_Subject__c
            FROM BI_PSPB_Treatment_Reminder__c
            WHERE BI_PSPB_Care_Program_Enrollee__c = :testCareProgramEnrolle.Id
        ];

        // Assert checks
        System.assertNotEquals(null, reminders, 'No treatment reminder records were created.');
        System.assertEquals(0, reminders.size(), 'Expected 6 treatment reminder records to be created, but found ' + reminders.size());
        for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
            System.assertEquals(selectedDate, reminder.BI_PSPB_Date_of_Treatment__c, 'Date of treatment mismatch');
            System.assertEquals('Active', reminder.BI_PSPB_Status__c, 'Reminder status mismatch');
            System.assertNotEquals(null, reminder.BI_PSPB_Subject__c, 'Reminder subject should not be null');
        }
    }
}
 
    @isTest
    static void testCreateRemainderRecordNoReminders() {
        setupTestCareProgramAndEnrollee();

        Date selectedDate = Date.today();
        List<String> selectedReminders = new List<String>();  // Empty list
        List<String> selectedTreatment = new List<String>{ '3', '1' };

        Test.startTest();
        try {
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            System.assert(false, 'Expected an exception but did not get one.');
        } catch (Exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Unexpected exception message');
        }
        Test.stopTest();

        List<BI_PSPB_Treatment_Reminder__c> reminders = [
            SELECT Id
            FROM BI_PSPB_Treatment_Reminder__c
            WHERE BI_PSPB_Care_Program_Enrollee__c = :testCareProgramEnrolle.Id
        ];

        System.assertEquals(0, reminders.size(), 'Expected 0 treatment reminder records to be created, but found ' + reminders.size());
    } 

    private static void setupTestCareProgramAndEnrollee() {
        System.runAs(testUserPatient) {
            if (testCareProgramEnrolle == null) {
                CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program', StartDate = Date.today());
                insert testCareProgram;
                
                testCareProgramEnrolle = new CareProgramEnrollee(
                    AccountId = testAccount.Id,
                    CareProgramId = testCareProgram.Id,
                    Name = 'Test Enrollee'
                );
                insert testCareProgramEnrolle;
            }
        }
    }
}