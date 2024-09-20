@isTest
/**
* @description This class contains test methods to verify the behaviour
of sending email and sms notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_SmsAndEmailNotificationCtrlTest {
    @isTest
    static void testConstructor() {
        String testSubject = 'Test Subject';
        String testEmailSubject = 'Test Email Subject';
        String testUrlPage = 'Test URL Page';
        String testNotificationType = 'Test Notification Type';
        List<String> testFollowName = new List<String>{'User1', 'User2'};
        BI_PSPB_SmsAndEmailNotificationCtrl notificationCtrl = new BI_PSPB_SmsAndEmailNotificationCtrl(
            testSubject, 
            testEmailSubject, 
            testUrlPage, 
            testNotificationType, 
            testFollowName
        );
        Assert.areEqual(testSubject, notificationCtrl.subject,'Subject of the task');
        Assert.areEqual(testEmailSubject, notificationCtrl.emailSubject,'Subject of the email notification');
        Assert.areEqual(testUrlPage, notificationCtrl.urlPage,'URL of the page to be navigated');
        Assert.areEqual(testNotificationType, notificationCtrl.notificationType,'Type of notification');
        Assert.areEqual(testFollowName, notificationCtrl.followName,'Username of the user');
    }
}