@IsTest
/** 
* @description       : This is a BI_PSPB_EnrollmentConstantTest test class designed to test the functionality of the BI_PSPB_EnrollmentConstant class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentConstantTest {
    @IsTest
    static void testGetLabel() {
        // Test retrieving a valid label
        String expectedLabel = System.Label.BI_PSP_ErrorSeverity;
        String actualLabel = BI_PSPB_EnrollmentConstant.getLabel('LOG_SEVERITY_ERROR');
        Assert.areEqual(expectedLabel, actualLabel, 'The label for LOG_SEVERITY_ERROR should match the expected value.');

        // Test retrieving another valid label
        expectedLabel = System.Label.BI_PSPB_PatientQualified;
        actualLabel = BI_PSPB_EnrollmentConstant.getLabel('PATIENT_QUALIFIED_STATUS');
        Assert.areEqual(expectedLabel, actualLabel, 'The label for PATIENT_QUALIFIED_STATUS should match the expected value.');

        // Test retrieving a non-existing label
        actualLabel = BI_PSPB_EnrollmentConstant.getLabel('NON_EXISTENT_KEY');
        Assert.areEqual(null, actualLabel, 'The label for a non-existent key should be null.');

        // Test retrieving another valid label
        expectedLabel = System.Label.BI_PSPB_ErrorGettingAccount;
        actualLabel = BI_PSPB_EnrollmentConstant.getLabel('ERROR_GETTING_CONTACT');
        Assert.areEqual(expectedLabel, actualLabel, 'The label for ERROR_GETTING_CONTACT should match the expected value.');
    }
}