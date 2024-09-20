@isTest
public class BI_PSPB_CmsConstantTest {
  /**
	  * @description Tests the initialization and correctness of general labels.
	  */
@isTest
	 static void testGeneralLabels() {
		 Assert.areEqual(
			 'UnRead',
			 BI_PSPB_CmsConstant.actionTypeUnRead,
			 'Error in Updation'
		 );
		
	 }
}