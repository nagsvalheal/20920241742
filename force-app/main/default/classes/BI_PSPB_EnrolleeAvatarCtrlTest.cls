@isTest
private class BI_PSPB_EnrolleeAvatarCtrlTest {

    @isTest
    static void testUpdateEnrolleeAvatar() {
        // Prepare test data
         CareProgram cpvalue = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today() 
        );
        insert cpvalue;
         // Create test Account
        Account account = new Account(Name = 'Test Account');
        insert account;

        CareProgramEnrollee testEnrollee = new CareProgramEnrollee();
        testEnrollee.Name = 'Test Enrollee';
        testEnrollee.AccountId =account.id;
        testEnrollee.CareProgramId = cpvalue.Id;
        insert testEnrollee;

        // Define test avatar URL
        String testAvatarUrl = 'http://example.com/avatar.jpg';

        // Call the method
        Test.startTest();
        BI_PSPB_EnrolleeAvatarCtrl.updateEnrolleeAvatar(testEnrollee.Id, testAvatarUrl);
        Test.stopTest();

        // Verify the update
        CareProgramEnrollee updatedEnrollee = [SELECT Id, BI_PSP_AvatarUrl__c, BI_PSP_Loginattempt__c, BI_PSPB_FirstLoginDate__c 
                                               FROM CareProgramEnrollee 
                                               WHERE Id = :testEnrollee.Id];
        
        Assert.areEqual(testAvatarUrl, updatedEnrollee.BI_PSP_AvatarUrl__c, 'Avatar URL should be updated');
        assert.areNotEqual(0, updatedEnrollee.BI_PSP_Loginattempt__c, 'Login attempt should be set');
        assert.areNotEqual(null, updatedEnrollee.BI_PSPB_FirstLoginDate__c, 'First login date should be set');
    }

     @isTest
    static void testUpdateEnrolleeAvatarWithNullValues() {
        // Call the method with null values
           try {
        Test.startTest();
        BI_PSPB_EnrolleeAvatarCtrl.updateEnrolleeAvatar('', '');
        Test.stopTest();
               } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }

    }
   
}