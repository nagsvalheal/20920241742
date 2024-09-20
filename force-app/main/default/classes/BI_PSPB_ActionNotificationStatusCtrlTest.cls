@isTest
/**
 * @description This class contains test methods to status updation for the question tasks.
 * @author Niyas
 * @Last Modified On  08/15/2024
 * @Last Modified By   Niyas
 */
private class BI_PSPB_ActionNotificationStatusCtrlTest {
	public static User testUserPatient;
	@isTest
	static void testUpdateActionTreatmentStatus() {
		String actionValue = BI_PSPB_NotificationConstant.actionResponseYes;
		Date reminderDate = Date.today();
		Date treatmentDate = Date.today().addDays(7);
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
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruceaction3.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction3',
			LastName = 'Wayneaction3',
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
				FirstName = 'Bruceaction23',
				LastName = 'Wayneaction3',
				PersonEmail = 'bruceaction3.wayne@wayneenterprises.com',
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
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;
			CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
				AccountId = account.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCareProgramEnrollee;
			BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Reminder_Date__c = reminderDate,
				BI_PSPB_Date_of_Treatment__c = treatmentDate,
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
				BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				BI_PSPB_Status__c = 'Active'
			);
			insert testReminder;
			Task testTask = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
                BI_PSP_Notification_Type__c = 'Action',
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				WhatId = testReminder.id
			);
			insert testTask;
            Task testTask11 = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypePrescription,
                BI_PSP_Notification_Type__c = 'Action',
				WhatId = testReminder.id
			);
			insert testTask11;
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionTreatmentStatus(
				testTask.Id,
				actionValue
			);
			Test.stopTest();

			Task taskAfterUpdation = [
				SELECT Id, Status, BI_PSP_Category__c, WhatId
				FROM Task
				WHERE Id = :testTask.Id
			];
			Assert.areEqual(
				BI_PSPB_NotificationConstant.notificationStatusComplete,
				taskAfterUpdation.Status,
				'Task status should be updated to Complete.'
			);
		}
	}

	@isTest
	static void testUpdateActionDateOfTreatment() {
        Task testTask;
		String actionValue = BI_PSPB_NotificationConstant.actionResponseNo;
		Date reminderDate = Date.today();
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
			Username = System.now().millisecond() + 'actionnoti@test.com',
			Alias = 'batman',
			Email = 'actionnoti@test.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction2',
			LastName = 'Wayneaction2',
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
				FirstName = 'Bruceaction2',
				LastName = 'Wayneaction2',
				PersonEmail = 'actionnoti@test.com',
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
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;
			CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
				AccountId = account.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCareProgramEnrollee;
			BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Reminder_Date__c = reminderDate,
				BI_PSPB_Date_of_Treatment__c = reminderDate,
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
				BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				BI_PSPB_Status__c = 'Active'
			);
			insert testReminder;
			testTask = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask;
            Task testTask11 = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask11;
            Task testTask12 = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask12;
            System.runAs(user1){
                try{
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionDateOfTreatment(
				testTask.Id,
				actionValue
			);
			Test.stopTest();
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
        }
	}

	@isTest
	static void testUpdateActionTreatmentStatusWithBlankInputs() {
		try {
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionTreatmentStatus(
				'',
				''
			);
			Test.stopTest();
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

	@isTest
	static void testupdateActionDateOfTreatmentWithBlankInputs() {
		try {
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionDateOfTreatment(
				'',
				''
			);
			Test.stopTest();
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
	@isTest
	static void testUpdateActionTreatmentStatusWithNull() {
		Date reminderDate = Date.today();
		Date treatmentDate = Date.today().addDays(7);

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
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruceaction1.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction1',
			LastName = 'Waynemessaction1',
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
				FirstName = 'Bruceaction1',
				LastName = 'Wayneaction1',
				PersonEmail = 'bruceaction1.wayne@wayneenterprises.com',
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
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;
			CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
				AccountId = account.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCareProgramEnrollee;
			BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Reminder_Date__c = reminderDate,
				BI_PSPB_Date_of_Treatment__c = treatmentDate,
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
				BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				BI_PSPB_Status__c = 'Active'
			);
			insert testReminder;
			Task testTask = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask;
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionTreatmentStatus(
				testTask.Id,
				BI_PSPB_NotificationConstant.actionResponseNo
			);
			Test.stopTest();
			Task taskAfterUpdation = [
				SELECT Id, Status, BI_PSP_Category__c, WhatId
				FROM Task
				WHERE Id = :testTask.Id
			];
			Assert.areEqual(
				BI_PSPB_NotificationConstant.notificationStatusNotComplete,
				taskAfterUpdation.Status,
				'Task status should be updated to No.'
			);
		}
	}
    	@isTest
	static void testUpdateActionTreatmentWithoutTask() {
		Date reminderDate = Date.today();
		Date treatmentDate = Date.today().addDays(7);

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
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruceaction1.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction1',
			LastName = 'Waynemessaction1',
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
				FirstName = 'Bruceaction1',
				LastName = 'Wayneaction1',
				PersonEmail = 'bruceaction1.wayne@wayneenterprises.com',
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
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;
			CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
				AccountId = account.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCareProgramEnrollee;
			BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Reminder_Date__c = reminderDate,
				BI_PSPB_Date_of_Treatment__c = treatmentDate,
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
				BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				BI_PSPB_Status__c = 'Active'
			);
			insert testReminder;
			Task testTask = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypePrescription,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'	
			);
			insert testTask;
			Test.startTest();
			BI_PSPB_ActionNotificationStatusCtrl.updateActionTreatmentStatus(
				testTask.Id,
				BI_PSPB_NotificationConstant.actionResponseNo
			);
			Test.stopTest();
			Task taskAfterUpdation = [
				SELECT Id, Status, BI_PSP_Category__c, WhatId
				FROM Task
				WHERE Id = :testTask.Id
			];
			Assert.areEqual(
				BI_PSPB_NotificationConstant.notificationStatusNotComplete,
				taskAfterUpdation.Status,
				'Task status should be updated to No.'
			);
		}
	}
    @isTest
	static void testUpdateActionDateOfTreatmentWithYes() {
        Task testTask;
		String actionValue = 'Yes';
		Date reminderDate = Date.today();
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
			Username = System.now().millisecond() + 'actionnoti@test.com',
			Alias = 'batman',
			Email = 'actionnoti@test.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruceaction2',
			LastName = 'Wayneaction2',
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
				FirstName = 'Bruceaction2',
				LastName = 'Wayneaction2',
				PersonEmail = 'actionnoti@test.com',
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
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;
			CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
				AccountId = account.Id,
				Name = 'Test Enrollee',
				CareProgramId = testCareProgram.Id
			);
			insert testCareProgramEnrollee;
			BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Reminder_Date__c = reminderDate,
				BI_PSPB_Date_of_Treatment__c = reminderDate,
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
				BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				BI_PSPB_Status__c = 'Active'
			);
			insert testReminder;
			testTask = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask;
            Task testTask11 = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask11;
            Task testTask12 = new Task(
				Status = BI_PSPB_NotificationConstant.taskStatusAction,
				BI_PSP_Category__c = BI_PSPB_NotificationConstant.dateOfTreatment,
				WhatId = testReminder.id,
                BI_PSP_Notification_Type__c = 'Action',
                BI_PSPB_Treatment_Type__c = 'Day of Treatment'
			);
			insert testTask12;
            System.runAs(user1){
				try{
					Test.startTest();
					BI_PSPB_ActionNotificationStatusCtrl.updateActionDateOfTreatment(
						testTask.Id,
						actionValue
					);
					Test.stopTest();
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
        }
	}
}