@isTest
/**
* @description This class contains test methods to verify the behaviour
of querying all questionnaires tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_QuestionTaskServiceTest {
	@isTest
	static void testGetTasksToUpdate() {
		Account testAccount = new Account(
			Name = 'Test Account',
			BI_PSP_CommunityUsername__c = 'Test Community Username'
		);
		insert testAccount;
		CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
		insert testCareProgram;
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCareProgram.Id
		);
		insert testEnrollee;
		Assessment newAssessment = new Assessment(
			Name = BI_PSPB_NotificationConstant.dlqiQuestionName,
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			AssessmentStatus = 'In Progress',
			AssessmentRating = 'High'
		);
		insert newAssessment;
		Assessment newAssessment2 = new Assessment(
			Name = BI_PSPB_NotificationConstant.pssQuestionName,
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			AssessmentStatus = 'In Progress',
			AssessmentRating = 'High'
		);
		insert newAssessment2;
		Assessment newAssessment3 = new Assessment(
			Name = BI_PSPB_NotificationConstant.wpaiQuestionName,
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			AssessmentStatus = 'In Progress',
			AssessmentRating = 'High'
		);
		insert newAssessment3;
		Assessment newAssessment4 = new Assessment(
			Name = BI_PSPB_NotificationConstant.qsqQuestionName,
			BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
			AssessmentStatus = 'In Progress',
			AssessmentRating = 'High'
		);
		insert newAssessment4;
		Task task1 = new Task(
			WhatId = testEnrollee.Id,
			Status = BI_PSPB_NotificationConstant.taskStatusAction,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.dlqi
		);

		Task task2 = new Task(
			WhatId = testEnrollee.Id,
			Status = BI_PSPB_NotificationConstant.taskStatusAction,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.pss
		);

		Task task3 = new Task(
			WhatId = testEnrollee.Id,
			Status = BI_PSPB_NotificationConstant.taskStatusAction,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.wpai
		);

		Task task4 = new Task(
			WhatId = testEnrollee.Id,
			Status = BI_PSPB_NotificationConstant.taskStatusAction,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.qsq
		);
		insert task1;
		insert task2;
		insert task3;
		insert task4;
		Map<Id, Map<String, String>> enrolleeRecIdToAssessmentNamesMap = new Map<Id, Map<String, String>>();
		Map<String, String> assessmentNames1 = new Map<String, String>{
			BI_PSPB_NotificationConstant.dlqiQuestionName => BI_PSPB_NotificationConstant.pssQuestionName
		};
		enrolleeRecIdToAssessmentNamesMap.put(task1.WhatId, assessmentNames1);
		Map<String, String> assessmentNames2 = new Map<String, String>{
			BI_PSPB_NotificationConstant.pssQuestionName => BI_PSPB_NotificationConstant.pssQuestionName
		};
		enrolleeRecIdToAssessmentNamesMap.put(task2.WhatId, assessmentNames2);
		Map<String, String> assessmentNames3 = new Map<String, String>{
			BI_PSPB_NotificationConstant.wpaiQuestionName => BI_PSPB_NotificationConstant.pssQuestionName
		};
		enrolleeRecIdToAssessmentNamesMap.put(task3.WhatId, assessmentNames3);
		Map<String, String> assessmentNames4 = new Map<String, String>{
			BI_PSPB_NotificationConstant.qsqQuestionName => BI_PSPB_NotificationConstant.pssQuestionName
		};
		enrolleeRecIdToAssessmentNamesMap.put(task4.WhatId, assessmentNames4);
		Test.startTest();
		List<Task> tasksToUpdate = BI_PSPB_QuestionTaskService.getTasksToUpdate(
			enrolleeRecIdToAssessmentNamesMap
		);
		Test.stopTest();
		Assert.areEqual(1, tasksToUpdate.size(), 'There should be 1 task to update');
	}
}