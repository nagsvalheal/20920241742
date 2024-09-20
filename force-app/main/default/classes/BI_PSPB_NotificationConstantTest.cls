@isTest
/**
* @description This class contains test methods to verify all the constants used across notification components.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationConstantTest {
    @isTest
    static void testConstants() {
        String expectedActionTypeGeneral = System.Label.BI_PSPB_General;
        String expectedActionTypeAction = System.Label.BI_PSPB_Action;
        String expectedErrorMsgRecordNotFound = System.Label.BI_PSPB_EnrolleRecNotFound;
        Assert.areEqual(expectedActionTypeGeneral, BI_PSPB_NotificationConstant.actionTypeGeneral, 'actionTypeGeneral should match');
        Assert.areEqual(expectedActionTypeAction, BI_PSPB_NotificationConstant.actionTypeAction, 'actionTypeAction should match');
        Assert.areEqual(expectedErrorMsgRecordNotFound, BI_PSPB_NotificationConstant.errorMsgRecordNotFound, 'errorMsgRecordNotFound should match');
        Assert.areEqual('Day of Treatment', BI_PSPB_NotificationConstant.dayOfTreatment, 'dayOfTreatment should match');
        Assert.areEqual('Treatment Video', BI_PSPB_NotificationConstant.treatmentVideo, 'treatmentVideo should match');
        Assert.areEqual(System.Label.BI_PSPB_Yes, BI_PSPB_NotificationConstant.actionResponseYes, 'actionResponseYes should match');
        Assert.areEqual('Error in passing parameter', BI_PSPB_NotificationConstant.parameterError, 'parameterError should match');
    }
}