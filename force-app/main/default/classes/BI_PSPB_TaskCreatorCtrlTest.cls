@isTest
public class BI_PSPB_TaskCreatorCtrlTest {
    // Test method for creating patient tasks
    @isTest
    static void testCreatePatientTasks() {
        List<Id> enrolleeIds = new List<Id>();
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
			Username = 'taskcreator@wayneenterprises.com',
			Alias = 'batman',
			Email = 'taskcreator@wayneenterprises.com',
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
				PersonEmail = 'taskcreatorpatient@wayneenterprises.com',
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
				Username = 'taskcreatorpatient@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'taskcreatorpatient@wayneenterprises.com',
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
            Account account1 = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account1;
            CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
			AccountId = account1.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrollee;
            enrolleeIds.add(testCareProgramEnrolle.Id);
            enrolleeIds.add(testCareProgramEnrollee.Id);
        
        // Create an instance of BI_PSPB_TaskParameterCtrl using the required parameters
        BI_PSPB_TaskParameterCtrl params = new BI_PSPB_TaskParameterCtrl(
            'Test Patient Task', // subject
            'Reminder', // notificationType
            'My Questionnaires', // category
            'TreatmentType1', // treatmentType
            'Open' // status
        );
        
        String userType = 'Patient';
        Id caregiverId = null; // For patient tasks, this can be null
        
        // Call the method under test
        Test.startTest();
        List<Task> createdTasks = BI_PSPB_TaskCreatorCtrl.createPatientTasks(enrolleeIds, params, userType, caregiverId);
        Test.stopTest();
        
        // Assert the tasks are created correctly
        Assert.areEqual(2, createdTasks.size(), 'Two tasks should be created for the enrollees.');
        for (Task task : createdTasks) {
            Assert.areEqual('Test Patient Task', task.Subject, 'Subject should match.');
            Assert.areEqual('Reminder', task.BI_PSP_Notification_Type__c, 'Notification type should match.');
            Assert.areEqual('Patient', task.BI_PSPB_Notification_User_Type__c, 'User type should be Patient.');
            Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeQuestionnaires, task.BI_PSP_Category__c, 'Category should match.');
            Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction, task.Status, 'Status should match.');
        }
        }
    }
    
    // Test method for creating caregiver tasks
    @isTest
    static void testCreateCaregiverTasks() {
         User user1;
        List<Id> enrolleeIds = new List<Id>();
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
            Account account1 = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account1;
            CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
			AccountId = account1.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrollee;
            enrolleeIds.add(testCareProgramEnrolle.Id);
            enrolleeIds.add(testCareProgramEnrollee.Id);
        
        // Create an instance of BI_PSPB_TaskParameterCtrl using the required parameters
        BI_PSPB_TaskParameterCtrl params = new BI_PSPB_TaskParameterCtrl(
            'Test Caregiver Task', // subject
            'Alert', // notificationType
            'My Questionnaires', // category
            'TreatmentType2', // treatmentType
            'Open' // status
        );
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
        
        String userType = 'Caregiver';
        Id caregiverId = caregiver.Id; // Optional ID, not used in the method
        
        // Call the method under test
        Test.startTest();
        List<Task> createdTasks = BI_PSPB_TaskCreatorCtrl.createCaregiverTasks(enrolleeIds, params, userType, caregiverId);
        Test.stopTest();
        
        // Assert the tasks are created correctly
        Assert.areEqual(2, createdTasks.size(), 'Two tasks should be created for the caregivers.');
        for (Task task : createdTasks) {
            Assert.areEqual('Test Caregiver Task', task.Subject, 'Subject should match.');
            Assert.areEqual('Alert', task.BI_PSP_Notification_Type__c, 'Notification type should match.');
            Assert.areEqual('Caregiver', task.BI_PSPB_Notification_User_Type__c, 'User type should be Caregiver.');
            Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeQuestionnaires, task.BI_PSP_Category__c, 'Category should match.');
            Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction, task.Status, 'Status should match.');
        }
        }
    }
    
    @isTest
    static void testCreateCaregiverTasksException() {
        User user1;
        String userType;
		Id caregiverId;
        BI_PSPB_TaskParameterCtrl params;
        List<Id> enrolleeIds = new List<Id>();
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
            Account account1 = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account1;
            CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
			AccountId = account1.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrollee;
            enrolleeIds.add(testCareProgramEnrolle.Id);
            enrolleeIds.add(testCareProgramEnrollee.Id);
        
        // Create an instance of BI_PSPB_TaskParameterCtrl using the required parameters
        params = new BI_PSPB_TaskParameterCtrl(
            'Test Caregiver Task', // subject
            'Alert', // notificationType
            'Questionnaires', // category
            'TreatmentType2', // treatmentType
            'Open' // status
        );
		BI_PSPB_Enrollee_Caregiver__c caregiver = new BI_PSPB_Enrollee_Caregiver__c(

            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
        
        userType = 'Caregiver';
        caregiverId = caregiver.Id; // Optional ID, not used in the method
        }
            try{
                Test.startTest();
                	BI_PSPB_TaskCreatorCtrl.createCaregiverTasks(enrolleeIds, params, userType, caregiverId);
                Test.stopTest();
            } catch (Exception e) {
			/**  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
    }