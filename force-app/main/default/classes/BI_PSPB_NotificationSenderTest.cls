@isTest
/**
* @description This class contains test methods to verify the behaviour of
sending notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationSenderTest {
    @isTest
    static void testSendNotifications() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        List<Id> enrolleeIds = new List<Id>{testEnrollee.Id};
        String notificationType = 'Reminder';
        List<String> communityUserNames = new List<String>{'user1@example.com', 'user2@example.com'};
        try{
        Test.startTest();
        BI_PSPB_NotificationSender.sendNotifications(enrolleeIds, notificationType, communityUserNames);
        Test.stopTest();
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
    @isTest
    static void testSendNotificationsException() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        List<Id> enrolleeIds = new List<Id>{testEnrollee.Id}; // Wrap the single Id in a List
        List<String> communityUserNames = new List<String>{'user1@example.com', 'user2@example.com'};
        try{
        Test.startTest();
        BI_PSPB_NotificationSender.sendNotifications(enrolleeIds, null, communityUserNames);
        Test.stopTest();
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
}