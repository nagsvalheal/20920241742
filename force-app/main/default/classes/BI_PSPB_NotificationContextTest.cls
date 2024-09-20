@isTest
/**
* @description This class contains test methods to verify the behaviour of updating tasks with subject,
category,notificationType,chatterType,communityUserName and recordId.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_NotificationContextTest {
    @isTest
    static void testNotificationContextConstructor() {
        String category = 'Category1';
        String notificationType = 'NotificationType1';
        String chatterType = 'ChatterType1';
        List<String> communityUserName = new List<String>{'user1', 'user2'};
        List<Id> recordId = new List<Id>{UserInfo.getUserId()};
        BI_PSPB_NotificationContext notificationContext = new BI_PSPB_NotificationContext(
            category, 
            notificationType, 
            chatterType, 
            communityUserName, 
            recordId
        );
        Assert.areEqual(category, notificationContext.category, 'Category should be initialized correctly.');
        Assert.areEqual(notificationType, notificationContext.notificationType, 'Notification Type should be initialized correctly.');
        Assert.areEqual(chatterType, notificationContext.chatterType, 'Chatter Type should be initialized correctly.');
        Assert.areEqual(communityUserName, notificationContext.communityUserName, 'Community UserName list should be initialized correctly.');
        Assert.areEqual(recordId, notificationContext.recordId, 'Record Id list should be initialized correctly.');
    }
}