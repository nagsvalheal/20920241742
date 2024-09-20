@isTest
public class BI_PSPB_GoogleCalendarCtrlTest {
	private static BI_PSPB_Notification__mdt getTestMethodSetting2() {
		BI_PSPB_Notification__mdt notificationSetting2 = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_SmsBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
		return notificationSetting2;
	}
	@isTest
	static void generateGoogleCalendarURLtest() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		Date eventDate = Date.today();
		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		//TestUser for Patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;

		System.runAs(testUser) {
			Test.startTest();
			String result = BI_PSPB_GoogleCalendarCtrl.generateGoogleCalendarURL(
				eventDate
			);
			Assert.arenotequal(result, null, 'URL link generated');
			Test.stopTest();
		}
	}

	@isTest
	static void generateGoogleCalendarURLcatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		//User profile
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User'
			LIMIT 1
		];
		//TestUser for Patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = false,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = standardUserProfile.Id,
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			System.runAs(testUser) {
				Test.startTest();
				BI_PSPB_GoogleCalendarCtrl.generateGoogleCalendarURL(null);
				Test.stopTest();
			}
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	
	
}