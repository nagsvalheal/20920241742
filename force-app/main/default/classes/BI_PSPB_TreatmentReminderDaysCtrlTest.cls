@isTest
/**
* @description This class contains test methods to verify the behaviour of
calculating the treatment reminder days.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TreatmentReminderDaysCtrlTest {
    @isTest
    static void testConstructor() {
        Test.startTest();
        BI_PSPB_TreatmentReminderDaysCtrl ctrl = new BI_PSPB_TreatmentReminderDaysCtrl();
        Test.stopTest();
        Assert.areEqual(1, ctrl.before1Day, 'before1Day should be 1');
        Assert.areEqual(3, ctrl.before3Day, 'before3Day should be 3');
        Assert.areEqual(7, ctrl.before7Day, 'before7Day should be 7');
        Assert.areEqual(10, ctrl.before10Day, 'before10Day should be 10');
        Assert.areEqual(14, ctrl.before14Day, 'before14Day should be 14');
        Assert.areEqual(1, ctrl.pastdue24hrCount, 'pastdue24hrCount should be 24');
        Assert.areEqual(3, ctrl.pastdue72hrCount, 'pastdue72hrCount should be 72');
    }
}