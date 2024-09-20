@IsTest
/**
* @description This class contains test methods to verify the behaviour oquerying the tasks for community.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_CommunityTaskQueryCtrlTest {
    @TestSetup
    static void setup() {
		Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;        
        Task testTask = new Task(
            WhatId = testCareProgramEnrolle.Id,
            Subject = 'Test Community Post',
            BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
            BI_PSP_ChatterType__c = BI_PSPB_NotificationConstant.createPost,
            Status = BI_PSPB_NotificationConstant.actionTypeUnRead,
            BI_PSP_CommunityPostStatus__c = BI_PSPB_NotificationConstant.inProgressType,
            BI_PSP_CommunityUserName__c = 'TestUsername'
        );
        insert testTask;
        Task nonMatchingTask = new Task(
            WhatId = testCareProgramEnrolle.Id,
            Subject = 'Non-matching Community Post',
            BI_PSP_Category__c = 'Prescription',
            BI_PSP_ChatterType__c = 'Follow',
            Status = 'Completed',
            BI_PSP_CommunityPostStatus__c = 'Completed',
            BI_PSP_CommunityUserName__c = 'TestUsername'
        );
        insert nonMatchingTask;
    }
    @IsTest
    static void testFetchPendingCommunityPosts() {
        Test.startTest();
        List<Task> pendingCommunityPosts = BI_PSPB_CommunityTaskQueryCtrl.fetchPendingCommunityPosts();
        Test.stopTest();
        Assert.areEqual(1, pendingCommunityPosts.size(), 'The result should contain 1 task.');
        Task resultTask = pendingCommunityPosts[0];
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeGeneralCommunity, resultTask.BI_PSP_Category__c, 'Category should match the expected value.');
        Assert.areEqual(BI_PSPB_NotificationConstant.createPost, resultTask.BI_PSP_ChatterType__c, 'ChatterType should match the expected value.');
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeUnRead, resultTask.Status, 'Status should match the expected value.');
        Assert.areEqual(BI_PSPB_NotificationConstant.inProgressType, resultTask.BI_PSP_CommunityPostStatus__c, 'CommunityPostStatus should match the expected value.');
        }    
    @IsTest
    static void testFetchPendingCommunityPostsNoMatches() {
        delete [SELECT Id FROM Task];        
        Test.startTest();
        List<Task> pendingCommunityPosts = BI_PSPB_CommunityTaskQueryCtrl.fetchPendingCommunityPosts();
        Test.stopTest();
        Assert.areEqual(0, pendingCommunityPosts.size(), 'The result should be an empty list.');
    }
}