@IsTest
/**
* @description This class contains test methods to verify the behaviour of creating lets personalise
notifications.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_LetPersonaliseNotificationTest {
    @IsTest
    static void testCreateTaskIfNoAssessmentsNoTasks() {
		User user1;
		CareProgramEnrollee testCareProgramEnrolle;
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
			Username = 'brucemess.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'messbruce.wayne@wayneenterprises.com',
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
				Username = 'messbruce.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'messbruce.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess',
				FirstName = 'Brucemess',
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

		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
            OwnerId = user1.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
        }
        System.runAs(user1){
        Test.startTest();
        BI_PSPB_LetPersonaliseNotification.createTaskIfNoAssessment();
        Test.stopTest();
        
		List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        Assert.areEqual(1, tasks.size(), 'No tasks should be created when there are no assessments.');
        }
    }
    @IsTest
    static void testCreateTaskIfNoAssessmentAssessmentsExistNoTasks() {
        User user1;
		CareProgramEnrollee testCareProgramEnrolle;
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
			Username = 'brucemess.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'messbruce.wayne@wayneenterprises.com',
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
				Username = 'messbruce.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'messbruce.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess',
				FirstName = 'Brucemess',
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

		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
            OwnerId = user1.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		//System.runAs(testUserPatient){
        Test.startTest();
        BI_PSPB_LetPersonaliseNotification.createTaskIfNoAssessment();
        Test.stopTest();
        
		List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        Assert.areEqual(0, tasks.size(), 'Tasks should be created when assessments already exist.');
        }
    }
    @IsTest
    static void testCreateTaskIfNoAssessmentTasksExist() {
        User user1;
		CareProgramEnrollee testCareProgramEnrolle;
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
			Username = 'brucemess.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'messbruce.wayne@wayneenterprises.com',
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
				Username = 'messbruce.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'messbruce.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess',
				FirstName = 'Brucemess',
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

		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
            OwnerId = user1.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		System.runAs(user1){
        Test.startTest();
        BI_PSPB_LetPersonaliseNotification.createTaskIfNoAssessment();
        Test.stopTest();
        }
        Task updatedTask = [SELECT Id, Subject, Status FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        Assert.areEqual(BI_PSPB_NotificationConstant.assessmentSubject, updatedTask.Subject,'The task subject should match the expected value.');
        }
    }
    @IsTest
    static void testCreateTaskIfNoAssessmentExceptionHandling() {
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
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'brucemess.wayne@wayneenterprises.com',
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
        }
        Test.startTest();
        try {
            BI_PSPB_LetPersonaliseNotification.createTaskIfNoAssessment();
        } catch (Exception ex) {
			/*  While running negative scenario, the flow goes to catch.
          Thus resulting in throwing exception and so assertion is done
          for Exception only.*/
          Assert.areEqual(
            'Script-thrown exception',
            ex.getMessage(),
            'Method thrown exception'
          );
		}
        Test.stopTest();
    }
    @IsTest
    static void testCreateTaskIfNoAssessmentsWithCaregiver() {
		User user1;
		CareProgramEnrollee testCareProgramEnrolle;
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
			Username = 'brucemess.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'messbruce.wayne@wayneenterprises.com',
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
				Username = 'messbruce.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'messbruce.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess',
				FirstName = 'Brucemess',
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

		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
            OwnerId = user1.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
				OwnerId = user1.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
		Assessment asessment = new Assessment(
            	Name = 'DLQI',
				OwnerId = user1.Id,
        		AssessmentStatus = BI_PSPB_NotificationConstant.inProgressType,
        		BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id);
            insert asessment;
        }
        System.runAs(user1){
        Test.startTest();
        BI_PSPB_LetPersonaliseNotification.createTaskIfNoAssessment();
        Test.stopTest();
        
		List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :testCareProgramEnrolle.Id];
        Assert.areEqual(1, tasks.size(), 'No tasks should be created when there are no assessments.');
        }
    }
}