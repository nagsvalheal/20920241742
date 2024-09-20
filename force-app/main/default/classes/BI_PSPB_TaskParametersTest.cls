@isTest
/**
* @description This class contains test methods to verify the behaviour of
getting parameters for querying tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskParametersTest {
    @isTest
    static void testTaskParametersConstructor() {
        String subject = 'Test Subject';
        String notificationType = 'Email';
        String category = 'Reminder';
        String treatmentType = 'Type A';
        String status = 'Active';
        BI_PSPB_TaskParameters taskParameters = new BI_PSPB_TaskParameters(
            subject,
            notificationType,
            category,
            treatmentType,
            status
        );
        Assert.areEqual(subject, taskParameters.subject, 'Subject should match');
        Assert.areEqual(notificationType, taskParameters.notificationType, 'Notification Type should match');
        Assert.areEqual(category, taskParameters.category, 'Category should match');
        Assert.areEqual(treatmentType, taskParameters.treatmentType, 'Treatment Type should match');
        Assert.areEqual(status, taskParameters.status, 'Status should match');
    }
}