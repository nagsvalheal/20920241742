@isTest
/**
* @description This class contains test methods to fetch tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_ActionTaskServiceTest {
	@isTest
	static void testGetTask() {
		Account testAccount = new Account(
			Name = 'Test Account',
			BI_PSP_CommunityUsername__c = 'Test Community Username'
		);
		insert testAccount;
		CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
		insert testCareprogram;
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCareprogram.Id
		);
		insert testEnrollee;
		Task testTask = new Task(
			WhatId = testEnrollee.Id,
			BI_PSP_CommunityUserName__c = 'testUser1',
			Status = BI_PSPB_NotificationConstant.actionTypeUnRead,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
			BI_PSP_ChatterType__c = BI_PSPB_NotificationConstant.createPost,
			BI_PSP_Notification_Type__c = BI_PSPB_NotificationConstant.actionTypeGeneral,
			BI_PSP_CommunityPostStatus__c = BI_PSPB_NotificationConstant.inProgressType
		);
		insert testTask;
		Test.startTest();
		Task resultTask = BI_PSPB_ActionTaskService.getTask(testTask.Id);
		Test.stopTest();
		Assert.areEqual(testTask.Id,resultTask.Id,'The Task Id should match.');
	}
    @isTest
	static void testGetTaskThrowException() {
		Account testAccount = new Account(
			Name = 'Test Account',
			BI_PSP_CommunityUsername__c = 'Test Community Username'
		);
		insert testAccount;
		CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
		insert testCareprogram;
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			AccountId = testAccount.Id,
			Name = 'Test Enrollee',
			CareProgramId = testCareprogram.Id
		);
		insert testEnrollee;
        try{
		Test.startTest();
		Task resultTask = BI_PSPB_ActionTaskService.getTask(testEnrollee.Id);
		Test.stopTest();
		Assert.areNotEqual(testEnrollee.Id,resultTask.Id,'The Task Id should not match.');
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
	}
}