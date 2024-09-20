@isTest
public class BI_PSPB_OutlookReminderCalendarCtrlTest {
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
	static void testGenerateOutlookCalendarURL() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		Date eventDate = Date.today();
		String outlookCalendarURL = BI_PSPB_OutlookReminderCalendarCtrl.generateOutlookCalendarURL(
			eventDate
		);

		// Get the expected encoded values
		 EncodingUtil.urlEncode(
			'Today you are scheduled with the treatment',
			'UTF-8'
		);
		String expectedBody = EncodingUtil.urlEncode(
			'Description for the treatment',
			'UTF-8'
		);

		// Updated assertions based on the expected URL format
		System.assert(
			outlookCalendarURL.contains(
				'https://outlook.live.com/calendar/0/deeplink/compose?'
			),
			'Unexpected Outlook Calendar URL format: ' + outlookCalendarURL
		);
		
		System.assert(
			outlookCalendarURL.contains('body=' + expectedBody),
			'Unexpected body in Outlook Calendar URL: ' + outlookCalendarURL
		);
		System.assert(
			outlookCalendarURL.contains('startdt='),
			'Start date not present in Outlook Calendar URL: ' +
			outlookCalendarURL
		);
		// Add more assertions as needed
	}
	@isTest
	static void testCatchOutlookCalendarURL() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			BI_PSPB_OutlookReminderCalendarCtrl.generateOutlookCalendarURL(null);
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