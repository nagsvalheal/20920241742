@isTest
/**
* @description This class contains test methods to verify the behaviour of
querying all the insite notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_InsiteTaskQueryCtrlTest {
    @isTest
    static void testFetchTasks() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        Task testTask = new Task(
            WhatId = testEnrollee.Id,
            Subject = 'Test Task',
            Status = 'UnRead',
            BI_PSP_Category__c = 'Challenges'
        );
        insert testTask;
        List<Id> idOfTask =  new List<Id>();
        idOfTask.add(testTask.Id);
        Test.startTest();
        List<Task> resultTasks = BI_PSPB_InsiteTaskQueryCtrl.fetchTasks(idOfTask);
        Test.stopTest();
        Assert.areEqual(1, resultTasks.size(), 'The result list should contain 1 task');
        Task fetchedTask = resultTasks[0];
        Assert.areEqual(testTask.Id, fetchedTask.Id, 'The fetched task ID should match the test task ID');
        Assert.areEqual(testTask.Status, fetchedTask.Status, 'The fetched task status should match the test task status');
        Assert.areEqual(testTask.BI_PSP_Category__c, fetchedTask.BI_PSP_Category__c, 'The fetched task category should match the test task category');
        Assert.areEqual(testTask.BI_PSP_ChatterType__c, fetchedTask.BI_PSP_ChatterType__c, 'The fetched task chatter type should match the test task chatter type');
        Assert.areEqual(testTask.BI_PSP_ChatterFeedId__c, fetchedTask.BI_PSP_ChatterFeedId__c, 'The fetched task chatter feed ID should match the test task chatter feed ID');
    }
    @isTest
    static void testFetchTasksWithNoResults() {
        Test.startTest();
        Task task = new Task(Subject = 'To Be Deleted');
        insert task;
        Id invalidId = task.Id;
        List<Id> idOfTask =  new List<Id>();
        idOfTask.add(invalidId);
        delete task;
        List<Task> resultTasks = BI_PSPB_InsiteTaskQueryCtrl.fetchTasks(idOfTask);
        Test.stopTest();
        Assert.areEqual(0, resultTasks.size(), 'The result list should be empty');
    }
}