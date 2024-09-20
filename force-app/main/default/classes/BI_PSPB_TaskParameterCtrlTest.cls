@isTest
public class BI_PSPB_TaskParameterCtrlTest {

    @isTest
    static void testConstructorWithValidInputs() {
        // Arrange
        String testSubject = 'Task Subject';
        String testNotificationType = 'Email';
        String testCategory = 'Reminder';
        String testTreatmentType = 'Treatment A';
        String testStatus = 'Open';

        BI_PSPB_TaskParameterCtrl taskParams = new BI_PSPB_TaskParameterCtrl(
            testSubject, 
            testNotificationType, 
            testCategory, 
            testTreatmentType, 
            testStatus
        );

        Assert.areEqual(testSubject, taskParams.subject,'Subject of Task');
        Assert.areEqual(testNotificationType, taskParams.notificationType,'Type of task');
        Assert.areEqual(testCategory, taskParams.category,'Category of task');
        Assert.areEqual(testTreatmentType, taskParams.treatmentType,'Treatment Type of task');
        Assert.areEqual(testStatus, taskParams.status,'Status of task');
    }

    @isTest
    static void testConstructorWithNullSubject() {
        String testSubject = null;
        String testNotificationType = 'Email';
        String testCategory = 'Reminder';
        String testTreatmentType = 'Treatment A';
        String testStatus = 'Open';

        Test.startTest();
        try {
            new BI_PSPB_TaskParameterCtrl(
                testSubject, 
                testNotificationType, 
                testCategory, 
                testTreatmentType, 
                testStatus
            );
        } catch (Exception e) {
            /**  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
        }
        Test.stopTest();
    }
    /**
    * @description Test method to log for null subject.
    */
    @isTest
    static void testLogErrorCalledForNullSubject() {
        String testSubject = null;
        String testNotificationType = 'Email';
        String testCategory = 'Reminder';
        String testTreatmentType = 'Treatment A';
        String testStatus = 'Open';
        Test.startTest();
            try {
                new BI_PSPB_TaskParameterCtrl(testSubject, testNotificationType, testCategory, testTreatmentType, testStatus);
            } catch (Exception e) {
                /**  While running negative scenario, the flow goes to catch.
                    Thus resulting in throwing exception and so assertion is done
                    for Exception only.*/
                Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Method thrown exception'
                );
            }
        Test.stopTest();
    }
}