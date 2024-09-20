@isTest
public class BI_PSPB_TreatmentConstantTest {
    /**
	  * @description Tests the initialization and correctness of general labels.
	  */
@isTest
	 static void testGeneralLabels() {
		 Assert.areEqual(
			 'Unable to update record',
			 BI_PSPB_TreatmentConstant.errorDml,
			 'Error in Updation'
		 );
		
	 }
}