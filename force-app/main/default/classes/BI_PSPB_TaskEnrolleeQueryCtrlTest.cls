@isTest
/**
* @description This class contains test methods to verify the behaviour of
querying tasks with enrollee.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskEnrolleeQueryCtrlTest {
    @isTest
    static void testFetchEnrolleeRecords() {
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
        List<Id> recordIds = new List<Id>{ testEnrollee.Id };
        Test.startTest();
        List<CareProgramEnrollee> results = BI_PSPB_TaskEnrolleeQueryCtrl.fetchEnrolleeRecords(recordIds);
        Test.stopTest();
        Assert.areEqual(1, results.size(), 'Expected 1 enrollee record');
        Assert.areEqual(testEnrollee.Id, results[0].Id, 'The returned enrollee record should match the test data');
    }
}