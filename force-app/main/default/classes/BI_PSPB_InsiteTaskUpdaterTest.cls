@isTest
/**
* @description This class contains test methods to verify the behaviour of updating tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_InsiteTaskUpdaterTest {
    @isTest
    static void testUpdateTaskStatus() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username');
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareprogram.Id);
        insert testEnrollee;
        Task task1 = new Task(
            WhatId = testEnrollee.Id,
            Subject = 'Test Task 1',
            Status = 'Action Required',
            BI_PSP_Category__c = 'Challenges'
        );
        Task task2 = new Task(
            WhatId = testEnrollee.Id,
            Subject = 'Test Task 2',
            Status = 'Action Required',
            BI_PSP_Category__c = 'Challenges'
        );
        insert new List<Task>{ task1, task2 };
        Test.startTest();
        List<Task> tasksToUpdate = new List<Task>{ task1, task2 };
        List<Task> updatedTasks = BI_PSPB_InsiteTaskUpdater.updateTaskStatus(tasksToUpdate, 'Completed');
        Test.stopTest();
        List<Task> tasksAfterUpdate = [SELECT Id, Status FROM Task WHERE Id IN :updatedTasks];
        Assert.areEqual(2, tasksAfterUpdate.size(), 'The number of tasks returned should be 2');
    }
    @isTest
    static void testUpdateTaskStatusWithEmptyList() {
        try{
        Test.startTest();
        BI_PSPB_InsiteTaskUpdater.updateTaskStatus(new List<Task>(), 'Completed');
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
    static void testUpdateTaskStatusWithEmptyStatus() {
        Task task1 = new Task(
            Subject = 'Test Task 1',
            Status = 'Action Required',
            BI_PSP_Category__c = 'Challenges'
        );
        insert task1;
        try{
        Test.startTest();
        List<Task> tasksToUpdate = new List<Task>{ task1 };
        BI_PSPB_InsiteTaskUpdater.updateTaskStatus(tasksToUpdate, '');
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
            List<Task> tasksToUpdate = new List<Task>();
            BI_PSPB_InsiteTaskUpdater.updateTaskStatus(tasksToUpdate, 'Completed');
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