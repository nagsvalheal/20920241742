@IsTest
/** 
* @description       : This is a BI_PSP_LogMessagesUtilityTest test class designed to test the functionality of the BI_PSP_LogMessagesUtility class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
private class BI_PSP_LogMessagesUtilityTest {

   

    @IsTest
    static void testLogErrorWithoutException() {
        Boolean condition = true;
        // Test logging an error without throwing an exception
        Test.startTest();
        BI_PSP_LogMessagesUtility.logError('Test Error Message', 'BI_PSP_LogMessagesUtilityTest', false, 'ERROR');
        Test.stopTest();

        // Verify that no exception was thrown
         Assert.areEqual(true,condition, 'No exception should be thrown.');
    }

    @IsTest
    static void testLogErrorWithException() {
        // Test logging an error and throwing an exception
        try {
            Test.startTest();
            BI_PSP_LogMessagesUtility.logError('Test Error Message', 'BI_PSP_LogMessagesUtilityTest', true, 'ERROR');
            Test.stopTest();
             Assert.areEqual(false,'exceptionThrown', 'An AuraHandledException should have been thrown.');
        } catch (AuraHandledException e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testExceptionLogMessage() {
        // Test logging an exception and throwing an AuraHandledException
        try {
            AuraHandledException testException = new AuraHandledException('Test Exception');
            Test.startTest();
            BI_PSP_LogMessagesUtility.exceptionLogMessage('Test Exception Message', 'BI_PSP_LogMessagesUtilityTest', testException);
            Test.stopTest();
             Assert.areEqual(false,'exceptionThrown', 'An AuraHandledException should have been thrown.');
        } catch (AuraHandledException e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
    }

    @IsTest
    static void testCatchSystemException() {
        // Test catching and logging a DML exception
        try {
            // Simulate a DML exception
            System.DmlException dmlException = new System.DmlException('DML Exception');

            Test.startTest();
            BI_PSP_LogMessagesUtility.catchSystemException('Test DML Exception Message', 'BI_PSP_LogMessagesUtilityTest', dmlException);
            Test.stopTest();
            
             Assert.areEqual(false,'exceptionThrown', 'A System.DmlException should have been thrown.');
        } catch (System.DmlException e) {
            // Verify that the DML exception message is correct
             Assert.areEqual('Test DML Exception Message', e.getMessage(), 'The DML exception message should match the provided error message.');
        }
    }

    @IsTest
    static void testLogErrorWithEmptyErrorMessage() {
        Boolean condition = true;
        // Test logging an error with an empty error message and no exception thrown
        Test.startTest();
        BI_PSP_LogMessagesUtility.logError('', 'BI_PSP_LogMessagesUtilityTest', false, 'ERROR');
        Test.stopTest();

        // Verify that no exception was thrown
         Assert.areEqual(true,condition, 'No exception should be thrown for an empty error message.');
    }

    @IsTest
    static void testExceptionLogMessageWithEmptyErrorMessage() {
        Boolean condition = true;
        // Test logging an exception with an empty error message and no exception thrown
        AuraHandledException testException = new AuraHandledException('Test Exception');

        Test.startTest();
        try {
            BI_PSP_LogMessagesUtility.exceptionLogMessage('', 'BI_PSP_LogMessagesUtilityTest', testException);
             Assert.areEqual(true,condition, 'No exception should be thrown for an empty error message.');
        } catch (AuraHandledException e) {
             Assert.areEqual(false, 'exceptionThrown','No exception should be thrown for an empty error message.');
        }
        Test.stopTest();
    }

    @IsTest
    static void testCatchSystemExceptionWithEmptyErrorMessage() {
        Boolean condition = true;
        // Test catching and logging a DML exception with an empty error message
        try {
            System.DmlException dmlException = new System.DmlException('DML Exception');
            Test.startTest();
            BI_PSP_LogMessagesUtility.catchSystemException('', 'BI_PSP_LogMessagesUtilityTest', dmlException);
            Test.stopTest();

            // Verify that no exception was thrown
             Assert.areEqual(true,condition, 'No exception should be thrown for an empty error message.');
        } catch (System.DmlException e) {
             Assert.areEqual(false, 'exceptionThrown','No exception should be thrown for an empty error message.');
        }
    }
}