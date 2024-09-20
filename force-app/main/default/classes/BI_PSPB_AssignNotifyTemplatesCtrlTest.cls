@isTest
public class BI_PSPB_AssignNotifyTemplatesCtrlTest {
    @isTest
    static void testAssignPatientTemplates() {
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
			Username = 'brucemess22.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess22.wayne@wayneenterprises.com',
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
			Account account = new Account(
				FirstName = 'Brucemess33',
				LastName = 'Waynemess33',
				PersonEmail = 'brucemess33.wayne@wayneenterprises.com',
                //BI_PSP_Birthdate__c = Date.today().addYears(-25),
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
				Username = 'brucemess44.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'brucemess44.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess44',
				FirstName = 'Brucemess44',
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
                BI_PSP_Birthdate__c = Date.today().addYears(-25),
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
            List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrollee.Id,
                BI_PSP_Patient__c = account1.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrollee.Id,
                BI_PSP_Patient__c = account1.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrollee.Id,
                BI_PSP_Patient__c = account1.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
             new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrollee.Id,
                BI_PSP_Patient__c = account1.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrollee.Id,
                BI_PSP_Patient__c = account1.Id,
                BI_PSP_SMS__c = false,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;

        List<Id> recordIds = new List<Id>{ testCareProgramEnrollee.Id };
        List<String> communityUserNames = new List<String>{ 'Test User' };
        Test.startTest();
        try{
            // Call the method under test
            BI_PSPB_AssignNotificationTemplatesCtrl.assignPatientTemplates(
                recordIds,
                BI_PSPB_NotificationConstant.generalComment,
                null,
                '',
                communityUserNames
            );
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
        Test.stopTest();
    }
    }
    @isTest
    static void testAssignCaregiverTemplates() {
        Account account = new Account(
			FirstName = 'TestPatientFeed2',
			LastName = 'PatientLastName2',
            BI_PSP_Birthdate__c = Date.today(),
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
        Account testCaregiverdata = new Account(
    Name = 'Caregiver Business Account', // Business accounts require a Name field
    Phone = '123-456-7890',
    BI_PSPB_Preferred_Communication_Method__c = 'Email',
            BI_PSPB_User_Type__c = 'Caregiver'
);
insert testCaregiverdata;

// Create a dummy Contact related to the business Account
Contact testCaregiverContact = new Contact(
    FirstName = 'John2',
    LastName = 'Doe2',
    Email = 'johndoe2@example.com',
    AccountId = testCaregiverdata.Id, // Use business account Id
    Phone = '123-456-7890'
);
insert testCaregiverContact;
        Contact testContact = new Contact(
            FirstName = 'Jane2',
            LastName = 'Doe2',
            Email = 'janedoe2@example.com'
        );
        insert testContact;
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
         BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Patient__c = account.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id,
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver1 = new BI_PSPB_Enrollee_Caregiver__c(
            Id = testEnrolleeCaregiver.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id
        );
        update testEnrolleeCaregiver1;
        testEnrolleeCaregiver = [
        SELECT Id, BI_PSPB_Caregiver__c, BI_PSPB_Care_Program_Enrollee__c
        FROM BI_PSPB_Enrollee_Caregiver__c
        WHERE Id = :testEnrolleeCaregiver.Id
    ];
        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSPB_Caregiver__c = testEnrolleeCaregiver.BI_PSPB_Caregiver__c,
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
                BI_PSP_SMS__c = false,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;
        List<Id> recordIds = new List<Id>{ testCareProgramEnrolle.Id };
        List<Id> caregiverIds = new List<Id>{ testEnrolleeCaregiver.id };
        List<String> communityUserNames = new List<String>{ 'Test User' };
        Test.startTest();
        try{
            BI_PSPB_CaregiverNotifyParamsCtrl params = new BI_PSPB_CaregiverNotifyParamsCtrl(
                    recordIds,
                    caregiverIds,
                    communityUserNames
                );
            // Call the method under test
            BI_PSPB_AssignNotificationTemplatesCtrl.assignCaregiverTemplates(
                params,
                BI_PSPB_NotificationConstant.generalComment,
                '',
                communityUserNames
            );
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
        Test.stopTest();
    }
        @isTest
    static void testAddAssignCaregiverTemplates() {
    Contact contactForPatient = new Contact(
        FirstName = 'TestPatientFeed2',
        LastName = 'PatientLastName2',
        Email = 'testpatientfeed2@gmail.com'
    );
    insert contactForPatient;
        Account account = new Account(
			FirstName = 'TestPatientFeed2',
			LastName = 'PatientLastName2',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
        HealthCloudGA__PrimaryContact__c = contactForPatient.Id,
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
         Account testCaregiverdata = new Account(
            FirstName = 'John2',
            LastName = 'Doe2',
            PersonEmail = 'johndoe2@example.com',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
            Phone = '123-456-7890',
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
             BI_PSPB_User_Type__c = 'Caregiver',
            BI_PSPB_Relationship_to_Patient__c = 'parent'
        );
        insert testCaregiverdata;
        Contact testContact = new Contact(
            FirstName = 'Jane2',
            LastName = 'Doe2',
            Email = 'janedoe2@example.com'
        );
        insert testContact;
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
         BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Patient__c = account.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id,
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;
        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
             new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_SMS__c = false,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;
        List<Id> recordIds = new List<Id>{ testCareProgramEnrolle.Id };
        List<String> communityUserNames = new List<String>{ 'Test User' };
        Test.startTest();
        try{
            // Call the method under test
            BI_PSPB_AssignNotificationTemplatesCtrl.assignAddCaregiverTemplates(
                recordIds,
                BI_PSPB_NotificationConstant.generalComment,
                recordIds,
                '',
                communityUserNames
            );
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
        Test.stopTest();
    }
}