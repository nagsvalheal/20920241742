@IsTest
/**
* @description This class contains test methods to verify the behaviour of
displaying insite notifications.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_MessageCenterCtrlTest {
	@IsTest
	static void testGetGeneralNotifyRecords() {
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

		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
            OwnerId = user1.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
		Task generalTask = new Task(
			Subject = 'General Notification',
			Status = BI_PSPB_NotificationConstant.actionTypeUnRead,
			WhatId = testCareProgramEnrolle.Id,
			BI_PSP_Notification_Type__c = BI_PSPB_NotificationConstant.actionTypeGeneral
		);
		insert generalTask;
        }
        System.runAs(user1) {
            try{
				Test.startTest();
					BI_PSPB_MessageCenterCtrl.getGeneralNotifyRecords();
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

	@IsTest
	static void testGetActionNotifyRecords() {
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
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'brucemess1.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess1',
			LastName = 'Waynemess1',
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
				FirstName = 'Waynemess1',
				LastName = 'Brucemess1',
				PersonEmail = 'brucemess1.wayne@wayneenterprises.com',
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
				Username = 'brucemess1.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'brucemess1.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Brucemess1',
				FirstName = 'Waynemess1',
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
		Task actionTask = new Task(
			Subject = 'Action Notification',
			Status = BI_PSPB_NotificationConstant.actionTypeNotificatonTypeAction,
			WhatId = testCareProgramEnrolle.Id,
			BI_PSP_Notification_Type__c = BI_PSPB_NotificationConstant.actionTypeAction
		);
		insert actionTask;
        }
        System.runAs(user1) {
            try{
				Test.startTest();
					BI_PSPB_MessageCenterCtrl.getActionNotifyRecords();
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

	@IsTest
	static void testGetHistoryNotifyRecords() {
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
		Task historyTask = new Task(
			Subject = 'History Notification',
			Status = BI_PSPB_NotificationConstant.notificationStatusComplete,
			WhatId = testCareProgramEnrolle.Id,
			BI_PSP_Notification_Type__c = 'General'
		);
		insert historyTask;
        } 
        System.runAs(user1) {
            try{
			Test.startTest();
				BI_PSPB_MessageCenterCtrl.getHistoryNotifyRecords();
			Test.stopTest();
		}  catch (Exception e) {
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
    @IsTest
	static void testGetHistoryNotifyRecordsWithException() {
        try{
			Test.startTest();
			BI_PSPB_MessageCenterCtrl.getHistoryNotifyRecords();
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
     @IsTest
	static void testGetGeneralNotifyRecordsWithException() {
        try{
			Test.startTest();
			BI_PSPB_MessageCenterCtrl.getGeneralNotifyRecords();
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
      @IsTest
	static void testGetActionNotifyRecordsWithException() {
        try{
			Test.startTest();
			BI_PSPB_MessageCenterCtrl.getActionNotifyRecords();
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