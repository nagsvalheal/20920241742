@IsTest
/**
* @description This class contains test methods to verify that notification
setting is enabled.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_SettingCaregiverCtrlTest {
            @isTest
    static void testAddContactsToSendCaregiver() {
 RecordType personAccountRecordType = [
        SELECT Id
        FROM RecordType
        WHERE SObjectType = 'Account' AND Name = 'Person Account'
        LIMIT 1
    ];

    // Create Person Account
    Account account = new Account(
        FirstName = 'setting',
        LastName = 'Patient',
        PersonEmail = 'DlqiPatient@gmail.com',
        BI_PSP_Birthdate__c = Date.newInstance(2000, 9, 4),
        RecordTypeId = personAccountRecordType.Id
    );
    insert account;

    // Create Caregiver Account
    Account testCaregiverdata = new Account(
        FirstName = 'John1',
        LastName = 'Doe1',
        BI_PSP_Birthdate__c = Date.newInstance(1980, 1, 1),
        PersonEmail = 'johndoe1@example.com',
        Phone = '123-456-7890',
        BI_PSPB_Preferred_Communication_Method__c = 'Email',
        BI_PSPB_User_type__c = 'Caregiver',
        BI_PSPB_Relationship_to_Patient__c = 'parent'
    );
    insert testCaregiverdata;
    
    CareProgram testCareProgram = new CareProgram(
        Name = 'Test Care Program',
        StartDate = Date.today()
    );
    insert testCareProgram;

    CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
        AccountId = account.Id,
        CareProgramId = testCareProgram.Id,
        BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
        Name = 'TestPatientFeed PatientLastName'
    );
    insert testCareProgramEnrolle;

    // Create the Enrollee_Caregiver record
    BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
        BI_PSPB_Caregiver__c = testCaregiverdata.Id,  // Caregiver account ID
        BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
        BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive
    );

    // Insert the Enrollee_Caregiver record
    insert caregiver;
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver1 = new BI_PSPB_Enrollee_Caregiver__c(
            Id = caregiver.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id
        );
        update testEnrolleeCaregiver1;

    // Query again to ensure value is stored in the database
    caregiver = [
        SELECT Id, BI_PSPB_Caregiver__c, BI_PSPB_Care_Program_Enrollee__c
        FROM BI_PSPB_Enrollee_Caregiver__c
        WHERE Id = :caregiver.Id
    ];

        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testCaregiverdata.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testCaregiverdata.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testCaregiverdata.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
             new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testCaregiverdata.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testCaregiverdata.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;
// Prepare account to notifications map
        Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>();
        accountToNotificationsMap.put(testCareProgramEnrolle.Id, notificationSettings);

        // Prepare lists for email and SMS IDs
        List<Id> emailList = new List<Id>();
        List<Id> smsList = new List<Id>();

        // Prepare enrollee list
        List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee> { testCareProgramEnrolle };

        // Mocking BI_PSPB_EnrolleeQueryHelper methods
            try{
        Test.startTest();
        // Call the method under test
        BI_PSPB_SettingCaregiverCtrl.addContactsToSendCaregiver(
            accountToNotificationsMap,
            enrollees,
            emailList,
            smsList
        );
                Test.stopTest(); 
            }catch (Exception e) {
            /*  While running negative scenario, the flow goes to catch.
                    Thus resulting in throwing exception and so assertion is done
                    for Exception only.*/
            Assert.areEqual(
            'Script-thrown exception',
            e.getMessage(),
            'Method thrown exception'
            );
        }
    }
        @isTest
    static void testCaregiverProcessNotifications() {
        // Create test data for the test case

        // Create an Account as a Person Account
        RecordType personAccountRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
            LIMIT 1
        ];

        Account account = new Account(
            FirstName = 'Test',
            LastName = 'Patient',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            RecordTypeId = personAccountRecordType.Id
        );
        insert account;

        CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.today()
        );
        insert testCareProgram;
         CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
            AccountId = account.Id,
            CareProgramId = testCareProgram.Id,
            BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
            Name = 'TestPatientFeed PatientLastName'
        );
        insert testCareProgramEnrolle;

        // Create Notification Settings with email and SMS enabled
        List<BI_PSP_Notification_Setting__c> notifications = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Notification_Type__c = 'Questionnaires',
                BI_PSP_Email__c = true,
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Notification_Type__c = 'Symptom Tracker',
                BI_PSP_Email__c = false,
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Notification_Type__c = 'Community',
                BI_PSP_Email__c = true,
                BI_PSP_SMS__c = false,
                BI_PSP_Patient__c = account.Id
            )
        };
        insert notifications;

        // Prepare lists for email and SMS IDs
        List<Id> emailList = new List<Id>();
        List<Id> smsList = new List<Id>();

        // Execute the method
        Test.startTest();
        BI_PSPB_SettingCaregiverCtrl.processCaregiverNotifications(
            notifications,
            account.Id,
            emailList,
            smsList
        );
        Test.stopTest();

        // Assertions to validate email and SMS lists
        Assert.areEqual(2, emailList.size(), 'Email list should contain 2 IDs');
        Assert.areEqual(2, smsList.size(), 'SMS list should contain 2 IDs');
    }
     @isTest
    static void testCaregiverProcessNotificationsExNull() {
        // Create test data for the test case

        // Create an Account as a Person Account
        RecordType personAccountRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
            LIMIT 1
        ];

        Account account = new Account(
            FirstName = 'Test',
            LastName = 'Patient',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            RecordTypeId = personAccountRecordType.Id
        );
        insert account;

        // Create Notification Settings with email and SMS enabled
        List<BI_PSP_Notification_Setting__c> notifications = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires',
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Email__c = false,
                BI_PSP_Notification_Type__c = 'Symptom Tracker',
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community',
                BI_PSP_SMS__c = false,
                BI_PSP_Patient__c = account.Id
            )
        };
        insert notifications;
        // Prepare lists for email and SMS IDs
        List<Id> emailList = new List<Id>();
        List<Id> smsList = new List<Id>();

        // Test case where notification list is empty
        List<BI_PSP_Notification_Setting__c> emptyNotifications = new List<BI_PSP_Notification_Setting__c>();
        emailList.clear();
        smsList.clear();

        Test.startTest();
        BI_PSPB_SettingCaregiverCtrl.processCaregiverNotifications(
            emptyNotifications,
            account.Id,
            emailList,
            smsList
        );
        Test.stopTest();

        // Ensure no emails or SMSs are processed for empty notifications
        Assert.areEqual(0, emailList.size(), 'Email list should be empty');
        Assert.areEqual(0, smsList.size(), 'SMS list should be empty');
    }
    @isTest
    static void testCaregiverProcessNotificationsCatch() {
        // Create test data for the test case

        // Create an Account as a Person Account
        RecordType personAccountRecordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
            LIMIT 1
        ];

        Account account = new Account(
            FirstName = 'Test',
            LastName = 'Patient',
            BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
            RecordTypeId = personAccountRecordType.Id
        );
        insert account;

        // Create Notification Settings with email and SMS enabled
        List<BI_PSP_Notification_Setting__c> notifications = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Notification_Type__c = 'Questionnaires',
                BI_PSP_Email__c = true,
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Notification_Type__c = 'Symptom Tracker',
                BI_PSP_Email__c = false,
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Notification_Type__c = 'Community',
                BI_PSP_Email__c = true,
                BI_PSP_SMS__c = false,
                BI_PSP_Patient__c = account.Id
            )
        };
        insert notifications;
        // Prepare lists for email and SMS IDs
        List<Id> emailList = new List<Id>();
        List<Id> smsList = new List<Id>();

        // Test case where a null notification is passed in the list
        List<BI_PSP_Notification_Setting__c> notificationsWithNull = new List<BI_PSP_Notification_Setting__c>{
            null
        };

        emailList.clear();
        smsList.clear();

        Test.startTest();
        BI_PSPB_SettingCaregiverCtrl.processCaregiverNotifications(
            notificationsWithNull,
            account.Id,
            emailList,
            smsList
        );
        Test.stopTest();

        // Ensure no emails or SMSs are processed for null notifications
        Assert.areEqual(0, emailList.size(), 'Email list should be empty');
        Assert.areEqual(0, smsList.size(), 'SMS list should be empty');
    }
     @IsTest
    static void testGetCaregiverToNotificationsMap() {
        // Step 1: Create test data
        Account caregiverAccount = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            PersonEmail = 'john.doe@example.com',
            BI_PSPB_User_Type__c = 'Caregiver'
        );
        insert caregiverAccount;

        // Create a second caregiver for variety
        Account anotherCaregiverAccount = new Account(
            FirstName = 'Jane',
            LastName = 'Smith',
            PersonEmail = 'jane.smith@example.com',
            BI_PSPB_User_Type__c = 'Caregiver'
        );
        insert anotherCaregiverAccount;

        // Create a notification setting for these caregivers
        BI_PSP_Notification_Setting__c notificationSetting = new BI_PSP_Notification_Setting__c(
            BI_PSPB_Caregiver__c = caregiverAccount.Id,
            BI_PSP_Notification_Type__c = 'Community',
            BI_PSP_SMS__c = true,
            BI_PSP_Email__c = false
        );
        insert notificationSetting;

        // Create another notification setting for the second caregiver
        BI_PSP_Notification_Setting__c anotherNotificationSetting = new BI_PSP_Notification_Setting__c(
            BI_PSPB_Caregiver__c = anotherCaregiverAccount.Id,
            BI_PSP_Notification_Type__c = 'Community',
            BI_PSP_SMS__c = false,
            BI_PSP_Email__c = true
        );
        insert anotherNotificationSetting;

        // Step 2: Create input data for the method
        List<Id> caregiverRec = new List<Id>{ caregiverAccount.Id, anotherCaregiverAccount.Id };
        String notificationType = 'Community';

        // Step 3: Call the method
        Map<Id, List<BI_PSP_Notification_Setting__c>> resultMap = BI_PSPB_SettingCaregiverCtrl.getCaregiverToNotificationsMap(caregiverRec, notificationType);

        // Assert the number of notification settings for each caregiver
        Assert.areEqual(1, resultMap.get(caregiverAccount.Id).size(), 'The map should contain one notification setting for the first caregiver.');
        Assert.areEqual(1, resultMap.get(anotherCaregiverAccount.Id).size(), 'The map should contain one notification setting for the second caregiver.');

        // Assert that the notification settings are correct
        BI_PSP_Notification_Setting__c resultNotification = resultMap.get(caregiverAccount.Id)[0];
        Assert.areEqual(notificationSetting.Id, resultNotification.Id, 'The notification setting should match the inserted one.');

        resultNotification = resultMap.get(anotherCaregiverAccount.Id)[0];
        Assert.areEqual(anotherNotificationSetting.Id, resultNotification.Id, 'The notification setting should match the inserted one.');
    }
    @IsTest
    static void testNoNotificationsFoundnnn() {
        // Test when no notifications are found for the given caregiver and type
        Account nonCaregiverAccount = new Account(
            FirstName = 'Non',
            LastName = 'Caregiver',
            PersonEmail = 'noncaregiver@example.com'
        );
        insert nonCaregiverAccount;

        List<Id> caregiverRec = new List<Id>{ nonCaregiverAccount.Id };
        String notificationType = 'NonExistentNotificationType';

        Map<Id, List<BI_PSP_Notification_Setting__c>> resultMap = BI_PSPB_SettingCaregiverCtrl.getCaregiverToNotificationsMap(caregiverRec, notificationType);

        System.assert(resultMap.isEmpty(), 'The result map should be empty when no notifications are found.');
    }
}