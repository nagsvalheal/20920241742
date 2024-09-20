/**
 * @description Test class contains test methods to validate the correctness of various constant values and
 * maps used in the BI_PSP_QuestionnaireConstantTest class.
 *
 * History:
 * Version    Author            Date            Detail                Description
 * 1.0        Harish            12-Aug-2024     Created               Initial development
 */

 @isTest
public class BI_PSP_QuestionnaireConstantTest {
    
     @isTest
	 static void testGeneralLabels() {
		 Assert.areEqual(
			 'No care program enrollee found or no assessment records available for the current user',
			 BI_PSP_QuestionnaireConstant.noEnroleeOrAssessment,
			 'Error in getting Text'
		 );
		 Assert.areEqual(
			 'Symptom Tracker record not found',
			 BI_PSP_QuestionnaireConstant.symptomErrorMsg,
			 'Error in getting Text'
		 );
		 Assert.areEqual(
			 'Inactive',
			 BI_PSP_QuestionnaireConstant.symptomStatusInactive,
			 'Error in getting Text'
		 );
		 Assert.areEqual(
			 'Error while retrieving dates for Qualitative Satisfaction Questionnaire',
			 BI_PSP_QuestionnaireConstant.errorForDates,
			 'Error in getting Text'
		 );
	 }

}