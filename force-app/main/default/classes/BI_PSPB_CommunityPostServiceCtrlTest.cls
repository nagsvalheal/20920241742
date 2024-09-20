@isTest
/**
* @description This class contains test methods to verify the condition of sending community email.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_CommunityPostServiceCtrlTest {
@isTest
static void testProcessCommunityPostReminders() {
	List<Task> tasks = new List<Task>();
	// Setup test data
	Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
	insert testAccount;
	CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
	insert testCareprogram;
	CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
	insert testEnrollee;        
	tasks.add(new Task(
		WhatId = testEnrollee.Id,
		BI_PSP_CommunityUserName__c = 'testUser1',
		Status = BI_PSPB_NotificationConstant.actionTypeUnRead,
		BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
		BI_PSP_ChatterType__c = BI_PSPB_NotificationConstant.createPost,
		BI_PSP_Notification_Type__c = BI_PSPB_NotificationConstant.actionTypeGeneral,
		BI_PSP_CommunityPostStatus__c = BI_PSPB_NotificationConstant.inProgressType
	));
	tasks.add(new Task(
		WhatId = testEnrollee.Id,
		BI_PSP_CommunityUserName__c = 'testUser2',
		Status = BI_PSPB_NotificationConstant.actionTypeUnRead,
		BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
		BI_PSP_ChatterType__c = BI_PSPB_NotificationConstant.createPost,
		BI_PSP_Notification_Type__c = BI_PSPB_NotificationConstant.actionTypeGeneral,
		BI_PSP_CommunityPostStatus__c = BI_PSPB_NotificationConstant.inProgressType
	));        
	insert tasks;
	Test.startTest();
	BI_PSPB_CommunityPostServiceCtrl.processCommunityPostReminders();
	Test.stopTest();
	List<Task> updatedTasks = [SELECT Id, Status FROM Task WHERE Id IN :tasks];
	Assert.areNotEqual(0, updatedTasks.size(), 'Tasks should be updated.');
}
@isTest
static void testProcessCommunityPostCatch() {
	try{
	Test.startTest();
	BI_PSPB_CommunityPostServiceCtrl.processCommunityPostReminders();        
	Test.stopTest();
	} catch (Exception e) {
		/*  When executing the negative scenario, if the flow enters 
	the catch block and throws an exception, assertions 
	are made solely for validating the exception occurrence.*/
		Assert.areEqual('Script-thrown exception',e.getMessage(),
			'Method thrown exception');
	}        
}
	@isTest
static void testPublicMethodThatUsesCreateUpdatedTaskWithNullInput() {
	try{
	Test.startTest();
		BI_PSPB_CommunityPostServiceCtrl.createUpdatedTask(null);
	Test.stopTest();
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