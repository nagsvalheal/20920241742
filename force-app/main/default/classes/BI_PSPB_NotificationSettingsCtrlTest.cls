@isTest
    public class BI_PSPB_NotificationSettingsCtrlTest {
    @isTest
    static void testAddContactsToSend() {
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
        // Query CareProgramEnrollee to retrieve Account details
        testCareProgramEnrolle = [
            SELECT Id, Account.Name, Account.BI_PSP_Birthdate__c
                FROM CareProgramEnrollee
                WHERE Id = :testCareProgramEnrolle.Id
        ];
        BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
                BI_PSPB_Caregiver__c = account.Id,
                BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
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
        BI_PSPB_NotificationSettingsCtrl.addContactsToSend(
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
    static void testProcessNotifications() {
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
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Email__c = false,
                BI_PSP_SMS__c = true,
                BI_PSP_Patient__c = account.Id
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Email__c = true,
                BI_PSP_SMS__c = false,
                BI_PSP_Patient__c = account.Id
            )
        };

        // Prepare lists for email and SMS IDs
        List<Id> emailList = new List<Id>();
        List<Id> smsList = new List<Id>();

        // Execute the method
        Test.startTest();
        BI_PSPB_NotificationSettingsCtrl.processNotifications(
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
    static void testProcessNotificationsExNull() {
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

        // Test case where notification list is empty
        List<BI_PSP_Notification_Setting__c> emptyNotifications = new List<BI_PSP_Notification_Setting__c>();
        emailList.clear();
        smsList.clear();

        Test.startTest();
        BI_PSPB_NotificationSettingsCtrl.processNotifications(
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
    static void testProcessNotificationsCatch() {
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

        // Test case where a null notification is passed in the list
        List<BI_PSP_Notification_Setting__c> notificationsWithNull = new List<BI_PSP_Notification_Setting__c>{
            null
        };

        emailList.clear();
        smsList.clear();

        Test.startTest();
        BI_PSPB_NotificationSettingsCtrl.processNotifications(
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
    static void testGetAccountToNotificationsMap() {
        // Step 1: Create test data

        Account patientAccount = new Account(
            FirstName = 'Test',
            LastName = 'Patient',
            PersonEmail = 'patient@example.com',
            BI_PSP_Birthdate__c = Date.newInstance(1985, 5, 15)
        );
        insert patientAccount;
        
            CareProgram testCareProgram = new CareProgram(
        Name = 'Test Care Program',
        StartDate = Date.today()
    );
    insert testCareProgram;

    CareProgramEnrollee enrolleeAccount = new CareProgramEnrollee(
        AccountId = patientAccount.Id,
        CareProgramId = testCareProgram.Id,
        BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
        Name = 'TestPatientFeed PatientLastName'
    );
    insert enrolleeAccount;

        // Create the notification settings
        BI_PSP_Notification_Setting__c notificationSetting = new BI_PSP_Notification_Setting__c(
            BI_PSP_Enrollee__c = enrolleeAccount.Id,
            BI_PSP_Patient__c = patientAccount.Id,
            BI_PSP_SMS__c = true,
            BI_PSP_Email__c = true,
            BI_PSP_Notification_Type__c = 'Community'
        );
        insert notificationSetting;

        // Step 2: Create input data for the method
        List<Id> accountRec = new List<Id>{ enrolleeAccount.Id };
        String notificationType = 'Community';

        // Step 3: Call the method
        Map<Id, List<BI_PSP_Notification_Setting__c>> resultMap = BI_PSPB_NotificationSettingsCtrl.getAccountToNotificationsMap(accountRec, notificationType);

        Assert.areEqual(1, resultMap.get(enrolleeAccount.Id).size(), 'The map should contain one notification setting for the enrollee.');
        
        // Assert that the notification setting is correct
        BI_PSP_Notification_Setting__c resultNotification = resultMap.get(enrolleeAccount.Id)[0];
        Assert.areEqual(notificationSetting.Id, resultNotification.Id, 'The notification setting should match the inserted one.');
    }

    @IsTest
    static void testEmptyAccountList() {
        // Test when accountRec is an empty list
        List<Id> emptyAccountRec = new List<Id>();
        String notificationType = 'TestNotificationType';
        try{
            BI_PSPB_NotificationSettingsCtrl.getAccountToNotificationsMap(emptyAccountRec, notificationType);
        } catch (Exception e) {
            /*  When executing the negative scenario, if the flow enters 
        the catch block and throws an exception, assertions 
        are made solely for validating the exception occurrence.*/
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testNoNotificationsFound() {
        // Test when no notifications are found for the given account and type
        Account nonEnrolleeAccount = new Account(
            FirstName = 'Non',
            LastName = 'Enrollee',
            PersonEmail = 'nonenrollee@example.com'
        );
        insert nonEnrolleeAccount;

        List<Id> accountRec = new List<Id>{ nonEnrolleeAccount.Id };
        String notificationType = 'NonExistentNotificationType';
        try{
            BI_PSPB_NotificationSettingsCtrl.getAccountToNotificationsMap(accountRec, notificationType);
    } catch (Exception e) {
		/*  When executing the negative scenario, if the flow enters 
	the catch block and throws an exception, assertions 
	are made solely for validating the exception occurrence.*/
		Assert.areEqual(
			'Script-thrown exception',
			e.getMessage(),
			'Method thrown exception'
		);
}
    }

    @IsTest
    static void testGetNotificationUrl() {
    // Step 1: Set up the custom notificationDetails object
    // You need to instantiate the object using the constructor
    BI_PSPB_SmsAndEmailNotificationCtrl notificationDetails = new BI_PSPB_SmsAndEmailNotificationCtrl(
        'Test Subject',
        'Test Email Subject',
        '/testNotificationPage',
        'Test Notification Type',
        new List<String>{'Name1'}
    );

    // Step 2: Mock the Custom Metadata for Notification URL
    BI_PSPB_Notification__mdt.getInstance(
        BI_PSPB_NotificationConstant.siteUrl
    );

    Test.startTest();

    // Step 3: Call the method to be tested
    String resultUrl = BI_PSPB_NotificationSettingsCtrl.getNotificationUrl(notificationDetails);

    // Step 4: Verify the URL is as expected
    String expectedUrl = 'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded/testNotificationPage';
    Assert.areEqual(expectedUrl, resultUrl, 'The URL returned should match the expected format.');

    Test.stopTest();
    }


    }