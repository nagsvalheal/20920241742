@isTest
/**
* @description This class contains test methods to verify the behaviour of
expiring the tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationExpiredDaysCtrlTest {
    @isTest
    static void testNotificationExpiredDays() {
        Test.startTest();
        Integer expectedOneDay = 1;
        Integer expectedSevenDays = 7;
        Integer expectedTwentyEightDays = 28;
        Integer expectedThirtyDays = 30;
        Integer oneDayCount = BI_PSPB_NotificationExpiredDaysCtrl.oneCount();
        Integer sevenDayCount = BI_PSPB_NotificationExpiredDaysCtrl.sevenCount();
        Integer twentyEightDayCount = BI_PSPB_NotificationExpiredDaysCtrl.twentyEightCount();
        Integer thirtyDayCount = BI_PSPB_NotificationExpiredDaysCtrl.thirtyCount();
        Assert.areEqual(expectedOneDay, oneDayCount, 'One day count should be 1.');
        Assert.areEqual(expectedSevenDays, sevenDayCount, 'Seven day count should be 7.');
        Assert.areEqual(expectedTwentyEightDays, twentyEightDayCount, 'Twenty-eight day count should be 28.');
        Assert.areEqual(expectedThirtyDays, thirtyDayCount, 'Thirty day count should be 30.');
        Test.stopTest();
    }
}