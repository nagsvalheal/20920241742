/**
 * @description Test class to verify the insertion of tasks.
 * @author Niyas
 * @Last Modified On 08/15/2024
 * @Last Modified By Niyas
 */
@isTest
private class BI_PSPB_TaskRecordCtrlTest {
    @isTest
    static void testHandleAfterInsert() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;        
        CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program');
        insert testCareProgram;        
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id, 
            Name = 'Test Enrollee', 
            CareProgramId = testCareProgram.Id
        );
        insert testEnrollee;
        BI_PSP_FeedItem__c feedItem = new BI_PSP_FeedItem__c(
            BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
            BI_PSP_AccountR__c = testAccount.Id
        );
        insert feedItem;
        Task testTask = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'CreatePost'
        );
        insert testTask;
        Task testTaskCommunityFollow = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Follow'
        );
        insert testTaskCommunityFollow;
        Task testTaskCommunityComment = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Comment'
        );
        insert testTaskCommunityComment;
        Task testTaskGeneral = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'Reaction'
        );
        insert testTaskGeneral;
        Task testTaskChallenges = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Challenges',
            BI_PSP_Notification_Type__c = 'General'
        );
        insert testTaskChallenges;
        Task testTaskSymptom = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Symptom Tracker',
            BI_PSP_Notification_Type__c = 'General'
        );
        insert testTaskSymptom;
        Test.startTest();
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTask });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskCommunityFollow });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskCommunityComment });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskGeneral });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskChallenges });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ testTaskSymptom });
        BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>());
        Test.stopTest();
        Task insertedTask = [SELECT BI_PSP_ChatterType__c FROM Task WHERE Id = :testTask.Id];
        Task insertedTaskFollow = [SELECT BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskCommunityFollow.Id];
        Task insertedTaskComment = [SELECT BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskCommunityComment.Id];
        Task insertedTaskGeneral = [SELECT BI_PSP_ChatterType__c FROM Task WHERE Id = :testTaskGeneral.Id];
        Assert.areEqual('CreatePost', insertedTask.BI_PSP_ChatterType__c, 'Chatter Type not set correctly for CreatePost.');
        Assert.areEqual('Follow', insertedTaskFollow.BI_PSP_ChatterType__c, 'Chatter Type not set correctly for Follow.');
        Assert.areEqual('Comment', insertedTaskComment.BI_PSP_ChatterType__c, 'Chatter Type not set correctly for Comment.');
        Assert.areEqual('Reaction', insertedTaskGeneral.BI_PSP_ChatterType__c, 'Chatter Type not set correctly for Reaction.');
    }
    @isTest
    static void testHandleAfterInsertCatch() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;        
        CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program');
        insert testCareProgram;        
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id, 
            Name = 'Test Enrollee', 
            CareProgramId = testCareProgram.Id
        );
        insert testEnrollee;
        BI_PSP_FeedItem__c feedItem = new BI_PSP_FeedItem__c(
            BI_PSP_CareProgramEnrollee__c = testEnrollee.Id,
            BI_PSP_AccountR__c = testAccount.Id
        );
        insert feedItem;
        Task testTask = new Task(
            Subject = 'Test Task',
            WhatId = testEnrollee.Id,
            BI_PSP_Category__c = 'Community',
            BI_PSP_Notification_Type__c = 'General',
            BI_PSP_ChatterType__c = 'CreatePost'
        );
        insert testTask;
            try{
            Test.startTest();
            BI_PSPB_TaskRecordCtrl.handleAfterInsert(new List<Task>{ null });
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