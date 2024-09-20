@isTest
public class BI_PSP_UserEmailSyncSchedTest {

    @testSetup
    static void setupTestData() {
        // Create test profiles
        Profile patientProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create test Users with mismatched Username and Email for Patient Profile
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username =  'test2@now.com',
            Alias = 'batman',
            Email = 'now.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Bruce',
            LastName = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );

        insert portalAccountOwner1;

        System.runAs(portalAccountOwner1) {
            // Retrieve the Record Type ID for Person Accounts
            RecordType personAccountRecordType = [
                SELECT Id
                FROM RecordType
                WHERE SObjectType = 'Account' AND Name = 'Person Account'
                LIMIT 1
            ];

            // Create Person Account
            Account portalAccount1 = new Account(
                FirstName = 'Test',
                LastName = 'Account',
                PersonEmail = 'currrent@user.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );

            insert portalAccount1;

            // Create user associated with Person Account
            Contact personContact = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :portalAccount1.Id
                LIMIT 1
            ];

            User user1 = new User(
                Username = System.now().millisecond() + 'now@user.com',
                ContactId = personContact.Id,
                ProfileId = patientProfile.Id,
                Alias = 'Cuse',
                Email = 'now@user.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Account',
                FirstName = 'Test',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );

            insert user1;
        }

        // Create test Users with matched Username and Email for Standard Profile (should not be updated)
        User testUserStandard = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            Email = 'sameemail@test.com',
            Username = 'now@test.com',
            Alias = 'tstd',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );

        insert testUserStandard;
    }

    @isTest
    static void testSchedulerExecution() {
        // Test method to verify the execution of the scheduler
        Test.startTest();
        
        String cronExpression = '0 0 12 * * ?';  // Schedule to run at 12 PM daily
        BI_PSP_UserEmailSyncSched scheduler = new BI_PSP_UserEmailSyncSched();
        
        // Schedule the job and capture the Job ID
        String jobId = System.schedule('Test User Email Username Sync Job', cronExpression, scheduler);
        
        Test.stopTest();
    
        // Assert that the job was scheduled successfully
        CronTrigger ct = [SELECT Id, CronExpression, State, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId LIMIT 1];
        
        Assert.areEqual(cronExpression, ct.CronExpression, 'The cron expression should match.');
        Assert.areEqual('WAITING', ct.State, 'The job should be in WAITING state.');
        Assert.areEqual(0, ct.TimesTriggered, 'The job should not have been triggered yet.');
        
    }
    

    @isTest
    static void testUpdateMismatchedUsernames() {
        // Verify that mismatched usernames and emails are correctly identified and updated

        // Call the future method asynchronously
        Test.startTest();
        BI_PSP_UserEmailSyncSched.updateMismatchedUsernames();
        Test.stopTest();

        // Fetch the updated users
        User updatedPatientUser = [SELECT Id, Username, Email FROM User WHERE Username = 'test2@now.com' LIMIT 1];
        User standardUser = [SELECT Id, Username, Email FROM User WHERE Username = 'now@test.com' LIMIT 1];

        // Assertions to verify updates
        assert.areNotEqual(updatedPatientUser.Email, updatedPatientUser.Username, 'The Email should be updated to match the Username for the patient user.');
        Assert.areEqual('sameemail@test.com', standardUser.Email, 'The Email should not be changed for the standard user.');
    }

   
}