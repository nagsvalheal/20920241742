/**
@description	This class contains test methods to verify the functionality of 
				methods related to Update Notification and retrieve the Notification records
@author					Adhish
@Last Modified On   	04/23/2024
@Last Modified By 		Adhish
*/
@isTest
private class BI_PSP_NotificationCtrlTest {
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testUpdateFieldInObject() {
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
			Username = System.now().millisecond() + 'noti@user.com',
			Alias = 'notify',
			Email = 'notifi@gmail.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'damon',
			LastName = 'salvatore',
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
				FirstName = 'damon',
				LastName = 'salvatore',
				PersonEmail = 'notifi@gmail.com',
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
				Username = System.now().millisecond() + 'notifi2345@gmail.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'noti45',
				Email = 'notifi9876@gmail.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'NotifyAccount',
				FirstName = 'userNotify',
				CommunityNickname = 'test12345',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		//Create Notification record
		BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
			BI_PSP_Patient__c = account.Id,
			BI_PSP_Notification_Type__c = 'Challenges'
		);
		insert testNotification;

		// Create wrapper object
		BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper();
		wrapper.emailValue = false;
		wrapper.smsValue = false;
		wrapper.insiteValue = true;
		wrapper.phoneValue = false;
		wrapper.typeValue = 'Challenges';

		Test.startTest();
		//System.runAs(testUser) {
            try{
			// Test positive scenario
			BI_PSP_NotificationCtrl.updateFieldInObject(
				account.Id,
				wrapper
			);
		}
            catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        
		// Query to assert the updates
		List<BI_PSP_Notification_Setting__c> updatedNotifications = [
			SELECT
				BI_PSP_Email__c,
				BI_PSP_SMS__c,
				BI_PSP_Insite_Notification__c,
				BI_PSP_Phone__c
			FROM BI_PSP_Notification_Setting__c
			WHERE BI_PSP_Patient__c = :account.Id
		];

		Assert.areEqual(
			true,
			updatedNotifications.size() > 0,
			'Size of updatedNotification'
		);
		Assert.areEqual(
			true,
			updatedNotifications[0].BI_PSP_Email__c,
			'Value of Email'
		);
		Assert.areEqual(
			false,
			updatedNotifications[0].BI_PSP_SMS__c,
			'Value of Sms'
		);
		Assert.areEqual(
			true,
			updatedNotifications[0].BI_PSP_Insite_Notification__c,
			'Value of Insite'
		);
		Assert.areEqual(
			false,
			updatedNotifications[0].BI_PSP_Phone__c,
			'Value of Phone'
		);
        }
		Test.stopTest();
            
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the Negative Scenario functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testUpdateFieldInObjectNegative() {
		try {
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
			Email = 'brucemessu.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemessu',
			LastName = 'Waynemessu',
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
				FirstName = 'Brucemessu',
				LastName = 'Waynemessu',
				PersonEmail = 'brucemessu.wayne@wayneenterprises.com',
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

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create wrapper object
			BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper();
			wrapper.emailValue = false;
			wrapper.smsValue = false;
			wrapper.insiteValue = true;
			wrapper.phoneValue = false;
			wrapper.typeValue = 'Challenges';

			Test.startTest();
			//System.runAs(testUser) {
				// Test positive scenario
				BI_PSP_NotificationCtrl.updateFieldInObject(
					account.Id,
					wrapper
				);
				// Query to assert the updates
			//}
			// Query to assert the updates
			Test.stopTest();
        }
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
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the Negative Scenario functionality of 
					methods related to Update Notification
	*/
	@isTest
	static void testNegativeUpdateFieldInObject() {
		try {
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
			Email = 'brucemessa.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemessa',
			LastName = 'Waynemessa',
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
				FirstName = 'Brucemessa',
				LastName = 'Waynemessa',
				PersonEmail = 'brucemessa.wayne@wayneenterprises.com',
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

			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;
			//Create Notification record
			BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
				BI_PSP_Patient__c = account.Id,
				BI_PSP_Notification_Type__c = 'Challenges'
			);
			insert testNotification;

			// Create wrapper object
			BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper();
			wrapper.emailValue = false;
			wrapper.smsValue = false;
			wrapper.insiteValue = true;
			wrapper.phoneValue = false;
			wrapper.typeValue = 'Challenges';

			Test.startTest();
			// Test negative scenario - no account ID provided

			//System.runAs(testUser) {
				BI_PSP_NotificationCtrl.updateFieldInObject(null, wrapper);
			//}

			Test.stopTest();
        }
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
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description 	This class contains test methods to verify the functionality of 
					methods related to retrieve the specific notification type records
	*/
	
	@isTest
	static void testRetrieveNotifications() {
		// Create test data
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
			Alias = 'batwoman',
			Email = 'brucemen1.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemen1',
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
				FirstName = 'Brucemen1',
				LastName = 'Waynemess1',
				PersonEmail = 'brucemen1.wayne@wayneenterprises.com',
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

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'PSPB',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		BI_PSP_Notification_Setting__c testNotification = new BI_PSP_Notification_Setting__c(
			BI_PSP_Patient__c = account.Id,
			BI_PSP_Notification_Type__c = 'Challenges'
		);
		insert testNotification;

		Test.startTest();
		// Test positive scenario
		//System.runAs(testUser) {
            try{
			List<BI_PSP_Notification_Setting__c> notify = BI_PSP_NotificationCtrl.retrieveNotifications(
				account.Id,
				'Challenges'
			);
			Assert.areEqual(1, notify.size(), 'List Of Notification');
        }
        catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
		}
		// Test negative scenario - no account ID provided
		Boolean isExceptionThrown = false;
		try {
			System.runAs(portalAccountOwner1) {
				BI_PSP_NotificationCtrl.retrieveNotifications(
					null,
					'Challenges'
				);
			}
		} catch (AuraHandledException ex) {
			isExceptionThrown = true;
		}
		Assert.areEqual(true, isExceptionThrown, 'Exception Thrown');

		Test.stopTest();
	}
	/**
	* The assertions ensure that the method behaves as expected under 
	different user contexts and error conditions.
	* @description	 This class contains test methods to verify the functionality of 
					methods related to negative scenerio for retrieve notification
	*/
	@isTest
    static void testupdateNotificationSettings() {
        // Create test data
        List<BI_PSP_Notification_Setting__c> notifyList = new List<BI_PSP_Notification_Setting__c>();
        
        for (Integer i = 0; i < 5; i++) {
            BI_PSP_Notification_Setting__c notification = new BI_PSP_Notification_Setting__c(
                Name = 'Test Notification ', BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            );
            notifyList.add(notification);
        }
        
        // Insert test data into the database
        insert notifyList;
        
        // Create a wrapper instance with test values
        BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper wrapper = new BI_PSP_NotificationCtrl.BI_PSPB_notificationSettingParaWrapper();
        wrapper.emailValue = false;
        wrapper.smsValue = true;
        wrapper.insiteValue = true;
        wrapper.phoneValue = true;
        
        // Call the method to test
        Test.startTest();
        BI_PSP_NotificationCtrl.updateNotificationSettings(notifyList, wrapper);
        Test.stopTest();
        
        // Verify the results
        List<BI_PSP_Notification_Setting__c> updatedNotifications = [SELECT BI_PSP_Email__c, BI_PSP_SMS__c, BI_PSP_Insite_Notification__c,BI_PSP_Notification_Type__c, BI_PSP_Phone__c FROM BI_PSP_Notification_Setting__c WHERE Id IN :notifyList];
        
        for (BI_PSP_Notification_Setting__c notification : updatedNotifications) {
            System.assertEquals(true, notification.BI_PSP_Insite_Notification__c, 'Insite Notification value did not match');
        }
    }

	@isTest
	static void testRetrieveNotificationsNegativeScenarioNoMatchingType() {
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
			Alias = 'mass',
			Email = 'mass@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'mass',
			LastName = 'hero',
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
				FirstName = 'Brucemess4',
				LastName = 'Waynemess4',
				PersonEmail = 'brucemess4.wayne@wayneenterprises.com',
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

		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		Test.startTest();
		// Test positive scenario

		// Test negative scenario - no matching notification type provided
		Boolean isExceptionThrown = false;
		try {
				List<BI_PSP_Notification_Setting__c> notify = BI_PSP_NotificationCtrl.retrieveNotifications(
					account.Id,
					'Challenges'
				);
				Assert.areEqual(0, notify.size(), 'List Of Notification');
		} catch (AuraHandledException ex) {
			/*  While running negative scenario, the flow goes to catch.
                Thus resulting in throwing exception and so assertion is done
                for Exception only.*/
			isExceptionThrown = true;
			Assert.areEqual(true, isExceptionThrown, 'Exception Thrown');
		}
        }

		Test.stopTest();
	}
}