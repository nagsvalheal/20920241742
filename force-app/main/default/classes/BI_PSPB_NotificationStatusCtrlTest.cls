@IsTest
/**
* @description This class contains test methods to verify the behaviour of updating 
status of the tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationStatusCtrlTest {
	@IsTest
	static void testMarkTaskReadInvalidId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskRead(
				'InvalidTaskId'
			);
		} catch (Exception e) {
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

	@IsTest
	static void testMarkTaskCompletedValidId() {
        Task historyTask;
        User user1;
				UserRole portalRole = [
			SELECT Id
			FROM UserRole
			WHERE PortalType = 'None'
			LIMIT 1
		];

		Profile profile1 = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
		];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = 'brucemess2.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess2.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess2',
			LastName = 'Waynemess2',
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
			Account account = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account;

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
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			user1 = new User(
				Username = 'brucemess3.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'brucemess2.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess2',
				FirstName = 'Brucemess2',
				CommunityNickname = 'test12345',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;
		historyTask = new Task(
			Subject = 'History Notification',
			Status = 'Action Required',
			WhatId = testCareProgramEnrolle.Id,
            BI_PSP_Category__c = 'Treatment',
			BI_PSP_Notification_Type__c = 'General',
            BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		insert historyTask;
            Task historyTask1 = new Task(
			Subject = historyTask.Subject,
			Status = historyTask.Status,
			WhatId = historyTask.WhatId,
			BI_PSP_Notification_Type__c = historyTask.BI_PSP_Notification_Type__c,
			BI_PSP_Category__c = historyTask.BI_PSP_Category__c,
                BI_PSPB_Treatment_Type__c = historyTask.BI_PSPB_Treatment_Type__c
		);
		insert historyTask1;
        } 
        try{
			BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
			historyTask.Id
		);
		} catch (Exception e) {
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

	@IsTest
	static void testMarkTaskCompletedInvalidId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
				'InvalidTaskId'
			);
		} catch (Exception e) {
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
	@IsTest
	static void testMarkTaskReadNullId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskRead(
				''
			);
		} catch (Exception e) {
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

	@IsTest
	static void testMarkTaskCompletedNullId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
				null
			);
		} catch (Exception e) {
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
@IsTest
static void testUpdateTaskStatusSetting(){
    User user1;
    UserRole portalRole = [
        SELECT Id
        FROM UserRole
        WHERE PortalType = 'None'
        LIMIT 1
    ];

    Profile profile1 = [
        SELECT Id
        FROM Profile
        WHERE Name = 'System Administrator'
    ];

    User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = 'admadminCare.wayne@wayneenterprises.com',
        Alias = 'batman',
        Email = 'admadminCare.wayne@wayneenterprises.com',
        EmailEncodingKey = 'UTF-8',
        FirstName = 'Brucemess22',
        LastName = 'Waynemess22',
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
        Date birthDate = Date.newInstance(2001, 9, 4);
        Account accountStatus = new Account(
            FirstName = 'bun21',
            LastName = 'Way21',
            PersonEmail = 'brucemedddCare1.wayne@wayneenterprises.com',
            BI_PSP_Birthdate__c = birthDate,
            RecordTypeId = personAccountRecordType.Id
        );

        insert accountStatus;

        // Create user associated with Person Account
        Profile portalProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'BI_PSP_Patient Profile'
            LIMIT 1
        ];

        Contact personContactStatus = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :accountStatus.Id
            LIMIT 1
        ];

        // Check if the user already exists for the Contact
        List<User> existingUsers = [
            SELECT Id, Username
            FROM User
            WHERE ContactId = :personContactStatus.Id
        ];

        if (existingUsers.isEmpty()) {
            // No user exists for the contact, create a new one
            user1 = new User(
                Username = 'brucemedddCare.wayne@wayneenterprises.com',
                ContactId = personContactStatus.Id,
                ProfileId = portalProfile.Id,
                Alias = 'sttt123',
                Email = 'brucemedddCare.wayne@wayneenterprises.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Way1',
                FirstName = 'bun1',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );

            insert user1;
        } else {
            // Use the existing user
            user1 = existingUsers[0];
        }

        CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.today()
        );
        insert testCareProgram;

        CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
            AccountId = accountStatus.Id,
            CareProgramId = testCareProgram.Id,
            BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
            Name = 'TestPatientFeed'
        );
        insert testCareProgramEnrolle;

        Task historyTask = new Task(
            Subject = 'History Notification',
            Status = 'Action Required',
            WhatId = testCareProgramEnrolle.Id,
            BI_PSP_Category__c = 'Treatment',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSPB_Treatment_Type__c = 'Past Due Date'
        );
        insert historyTask;
    }

    System.runAs(user1){   
        try {
            BI_PSPB_NotificationStatusCtrl.updateTaskStatusSetting('Patient');
        } catch (Exception e) {
            // Asserting the expected exception
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }
}

    @IsTest
    static void testMarkTaskRead(){

			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Date birthDate = Date.newInstance(2000, 9, 4);
			Account accountStatus = new Account(
				FirstName = 'bun',
				LastName = 'Way',
                BI_PSP_Birthdate__c = birthDate,
				PersonEmail = 'notificationunique567@gmail.com',
				RecordTypeId = personAccountRecordType.Id
			);

			insert accountStatus;

		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = accountStatus.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;
		Task historyTask = new Task(
			Subject = 'History Notification',
			Status = 'Action Required',
			WhatId = testCareProgramEnrolle.Id,
            BI_PSP_Category__c = 'Treatment',
			BI_PSP_Notification_Type__c = 'General',
            BI_PSPB_Treatment_Type__c = 'Past Due Date'
		);
		insert historyTask;
        try{
            BI_PSPB_NotificationStatusCtrl.markTaskRead(historyTask.Id);
        } catch (Exception e) {
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

    @IsTest
    static void testUpdateTasksStatusNoTasks() {
        // Test the scenario where no tasks are passed in
        List<Task> emptyTaskList = new List<Task>();

        Test.startTest();
        BI_PSPB_NotificationStatusCtrl.updateTasksStatus(emptyTaskList);
        Test.stopTest();

        // Verify no DML operations should be performed with an empty list
        Assert.areEqual(0, Limits.getDmlStatements(), 'No DML should be performed with an empty task list');
    }
}