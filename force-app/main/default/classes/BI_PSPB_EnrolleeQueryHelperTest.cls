@isTest
/**
* @description This class contains test methods to verify the behaviour of querying enrollee records.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
private class BI_PSPB_EnrolleeQueryHelperTest {
    @isTest
    static void testGetEnrollees() {
        Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community Username', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
        insert testAccount;
        CareProgram testCareprogram = new CareProgram(Name = 'Test Enrollee');
        insert testCareprogram;
        List<CareProgramEnrollee> testEnrollees = new List<CareProgramEnrollee>();
        CareProgramEnrollee enrollee = new CareProgramEnrollee();
        enrollee.AccountId = testAccount.Id;
        enrollee.Name = 'Test Enrollee';
        enrollee.CareProgramId = testCareprogram.Id;
        testEnrollees.add(enrollee);
        insert testEnrollees;
        List<Id> recordIds = new List<Id>{enrollee.Id};
        List<CareProgramEnrollee> resultEnrollees = BI_PSPB_EnrolleeQueryHelper.getEnrollees(recordIds);
        Assert.areEqual(1, resultEnrollees.size(), 'There should be one result.');
        Assert.areEqual(enrollee.Id, resultEnrollees[0].Id, 'The retrieved enrollee should match the inserted one.');
    }
    @isTest
    static void testGetAge() {
        Date birthdate = Date.today().addYears(-25);
        Integer age = BI_PSPB_EnrolleeQueryHelper.getAge(birthdate);
        Assert.areEqual(25, age, 'The age should be calculated correctly.');
        birthdate = Date.today().addYears(1);
        age = BI_PSPB_EnrolleeQueryHelper.getAge(birthdate);
    }
    @isTest
    static void testIsLegalAge() {
        Integer age = 17;
        Boolean isLegal = BI_PSPB_EnrolleeQueryHelper.isLegalAge(null);
        Assert.areEqual(false, isLegal, 'Age 17 should not be considered legal.');
        age = 18;
        isLegal = BI_PSPB_EnrolleeQueryHelper.isLegalAge(age);
        Assert.areEqual(true, isLegal, 'Age 18 should be considered legal.');
        age = 30;
        isLegal = BI_PSPB_EnrolleeQueryHelper.isLegalAge(age);
        Assert.areEqual(true, isLegal, 'Age 30 should be considered legal.');
    }
}