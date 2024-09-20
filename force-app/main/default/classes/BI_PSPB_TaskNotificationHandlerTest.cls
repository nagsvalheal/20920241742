@isTest
/**
* @description This class contains test methods to verify the behaviour of
creating task notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskNotificationHandlerTest {
    @isTest
    static void testHandleNotificationsForGeneralCommunity() {
        try{
        Account testAccount = new Account(Name = 'Test Account Notify', BI_PSP_CommunityUsername__c = 'Test Community Notify');
        insert testAccount;
        CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
        insert testCareProgram;
        List<CareProgramEnrollee> enrolleeRecords = new List<CareProgramEnrollee>{
            new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee Notify', CareProgramId = testCareProgram.Id)
        };
        insert enrolleeRecords;
		Task testTask = new Task(
			Status = BI_PSPB_NotificationConstant.actionTypeGeneral,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity,
			WhatId = enrolleeRecords[0].id
		);
		insert testTask;            
            Task testTask2 = new Task(
			Status = BI_PSPB_NotificationConstant.actionTypeGeneral,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeChallenges,
			WhatId = enrolleeRecords[0].id
		);
		insert testTask2;
        String category = BI_PSPB_NotificationConstant.actionTypeGeneralCommunity;
        String notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
        String chatterType = BI_PSPB_NotificationConstant.comment;
        List<String> communityUserName = new List<String>{ 'User1' };
        List<Id> recordId = new List<Id>{ enrolleeRecords[0].Id };
        Test.startTest();
        BI_PSPB_NotificationContext notificationContext = new BI_PSPB_NotificationContext(
            category, 
            notificationType,
            chatterType, 
            communityUserName, 
            recordId
        );
        BI_PSPB_TaskNotificationHandler.handleNotifications(enrolleeRecords, notificationContext);
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
    @isTest
    static void testHandleNotificationsForGeneralChallenges() {
        try{
        Account testAccount = new Account(Name = 'Test Account Notify', BI_PSP_CommunityUsername__c = 'Test Community Notify');
        insert testAccount;
        CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
        insert testCareProgram;
        List<CareProgramEnrollee> enrolleeRecords = new List<CareProgramEnrollee>{
            new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee Notify', CareProgramId = testCareProgram.Id)
        };
        insert enrolleeRecords;
		Task testTask = new Task(
			Status = BI_PSPB_NotificationConstant.actionTypeGeneral,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeChallenges,
			WhatId = enrolleeRecords[0].id
		);
		insert testTask;
        String category = BI_PSPB_NotificationConstant.actionTypeChallenges;
        String notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
        String chatterType = '';
        List<String> communityUserName = new List<String>{ '' };
        List<Id> recordId = new List<Id>{ enrolleeRecords[0].Id };
        Test.startTest();
        BI_PSPB_NotificationContext notificationContext = new BI_PSPB_NotificationContext(
            category, 
            notificationType,
            chatterType, 
            communityUserName, 
            recordId
        );
        BI_PSPB_TaskNotificationHandler.handleNotifications(enrolleeRecords, notificationContext);
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
    @isTest
    static void testHandleNotificationsForGeneralSymptom() {
        try{
        Account testAccount = new Account(Name = 'Test Account Notify', BI_PSP_CommunityUsername__c = 'Test Community Notify');
        insert testAccount;
        CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
        insert testCareProgram;
        List<CareProgramEnrollee> enrolleeRecords = new List<CareProgramEnrollee>{
            new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee Notify', CareProgramId = testCareProgram.Id)
        };
        insert enrolleeRecords;
		Task testTask = new Task(
			Status = BI_PSPB_NotificationConstant.actionTypeGeneral,
			BI_PSP_Category__c = BI_PSPB_NotificationConstant.actionTypeSymptomTracker,
			WhatId = enrolleeRecords[0].id
		);
		insert testTask;
        String category = BI_PSPB_NotificationConstant.actionTypeSymptomTracker;
        String notificationType = BI_PSPB_NotificationConstant.actionTypeGeneral;
        String chatterType = '';
        List<String> communityUserName = new List<String>{ '' };
        List<Id> recordId = new List<Id>{ enrolleeRecords[0].Id };
        Test.startTest();
        BI_PSPB_NotificationContext notificationContext = new BI_PSPB_NotificationContext(
            category, 
            notificationType,
            chatterType, 
            communityUserName, 
            recordId
        );
        BI_PSPB_TaskNotificationHandler.handleNotifications(enrolleeRecords, notificationContext);
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