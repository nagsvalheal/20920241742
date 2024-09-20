@isTest
private class BI_PSPB_PrescriptionConstantTest {

    // This method tests the retrieval of label values
    @isTest static void testLabelValues() {

        // Assert that the labels are correctly assigned
        System.assertEquals(System.Label.BI_PSPB_ShareType, 'V', 'Share Type label is incorrect');
        System.assertEquals(System.Label.BI_PSPB_InsertError, 'Insertion Failed', 'Error For Insert label is incorrect');
        System.assertEquals(System.Label.BI_PSPB_PrescriptionRecordType, 'BI_PSPB_Update_Prescription', 'Record Type Name label is incorrect');
        System.assertEquals(System.Label.BI_PSPB_ErrorForCase, 'Prescriptions not found', 'Error For Case label is incorrect');
    }

    // This method tests the retrieval of the record type ID
    @isTest static void testRecordTypeId() {
        // Mock the return value for the retrieveRecordTypeId method
        Id expectedRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BI_PSPB_Update_Prescription').getRecordTypeId();

        // Access the recordTypeId from the constant controller
        Id actualRecordTypeId = BI_PSPB_PrescriptionConstant.recordTypeId;

        // Assert that the record type ID is correctly assigned
        System.assertEquals(expectedRecordTypeId, actualRecordTypeId, 'Record Type ID is incorrect');
    }
}