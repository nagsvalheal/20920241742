@isTest
public class BI_PSPB_QuestionAssessmentServiceTest {
	@isTest
	static void testGetEnrolleeRecIdToAssessmentNamesMap() {
		Account testAccount = new Account(
			Name = 'Test Account',
			BI_PSP_CommunityUsername__c = 'Test Community Username'
		);
		insert testAccount;
		CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program');
		insert testCareProgram;
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCareProgram.Id
		);
		insert testEnrollee;
		Assessment assessment1 = new Assessment(
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			Name = BI_PSPB_NotificationConstant.dlqiQuestionName,
			AssessmentRating = BI_PSPB_NotificationConstant.assessmentRating,
			AssessmentStatus = 'Completed'
		);
		Assessment assessment2 = new Assessment(
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			Name = BI_PSPB_NotificationConstant.pssQuestionName,
			AssessmentRating = BI_PSPB_NotificationConstant.assessmentRating,
			AssessmentStatus = 'Completed'
		);
		insert new List<Assessment>{ assessment1, assessment2 };
		Test.startTest();
		Map<Id, Map<String, String>> resultMap = BI_PSPB_QuestionAssessmentService.getEnrolleeRecIdToAssessmentNamesMap(
			testEnrollee.Id
		);
		Test.stopTest();
		Assert.areNotEqual(
			null,
			resultMap,
			'The result map should not be null'
		);
		Assert.areEqual(
			1,
			resultMap.size(),
			'The result map should contain 1 enrollee record'
		);

		Map<String, String> assessmentNames = resultMap.get(testEnrollee.Id);
		Assert.areNotEqual(
			null,
			assessmentNames,
			'The assessment names map should not be null'
		);
		Assert.areEqual(
			2,
			assessmentNames.size(),
			'The assessment names map should contain 2 entries'
		);

		Assert.areEqual(
			BI_PSPB_NotificationConstant.dlqiQuestionName,
			assessmentNames.get(
				BI_PSPB_NotificationConstant.dlqiQuestionName
			),
			'The assessment name for dlqi should be included'
		);
		Assert.areEqual(
			BI_PSPB_NotificationConstant.pssQuestionName,
			assessmentNames.get(
				BI_PSPB_NotificationConstant.pssQuestionName
			),
			'The assessment name for pss should be included'
		);
	}

	@isTest
	static void testGetEnrolleeRecIdToAssessmentNamesMapWithNoResults() {
		try{
		Test.startTest();
		BI_PSPB_QuestionAssessmentService.getEnrolleeRecIdToAssessmentNamesMap(
			'InvalidId'
		);
		Test.stopTest();
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
					Thus resulting in throwing exception and so assertion is done
					for Exception only.*/
			Assert.areEqual(
			'Script-thrown exception',
			e.getMessage(),
			'Method thrown exception'
			);
		}
	}

	@isTest
	static void testExceptionHandling() {
		Test.startTest();
		try {
			BI_PSPB_QuestionAssessmentService.getEnrolleeRecIdToAssessmentNamesMap(
				''
			);
		} catch (Exception e) {
            /*  While running negative scenario, the flow goes to catch.
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