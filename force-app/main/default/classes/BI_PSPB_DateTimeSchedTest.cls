/*@description -- This test class ensures scheduled daily generation and insertion of dates for CRM Analytics, covering nullable field insertion, job scheduling accuracy, bulk record handling, and database error validation.
* History
* Version 	Author		Date			Detail		Description
* 1.0		Rajaa		01-Apr-2024		Created		Initial development.
* 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
*/
@isTest
public class BI_PSPB_DateTimeSchedTest {
    public static User testUser;
    public static Contact contactForPatient;

    static {
        // Create the test user
        Profile patientProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole testUserRole = [SELECT Id FROM UserRole WHERE Name = 'CEO' LIMIT 1];
        testUser = new User(
            FirstName = 'Test',
            LastName = 'Account',
            Email = 'testuser12@example.com',
            UserName = 'testuser12@example.com',
            BI_PSPB_Caregiver__c = false,
            Alias = 'tuser1',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = patientProfile.Id,
            UserRoleId = testUserRole.Id // Assign the role to the test user
        );

        insert testUser;

        // Perform contact DML separately from user DML
        System.runAs(testUser) {
            // Contact for patient user
            contactForPatient = new Contact(
                FirstName = testUser.FirstName,
                LastName = testUser.LastName,
                Email = testUser.Email
            );
            insert contactForPatient;
        }
    }

    @isTest
    static void testExecuteMethodScheduleJobSuccessfully() {
        System.runAs(testUser) {
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            Date currentDate = Date.valueOf('2024-02-28');
            BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c(
                Name = String.valueOf(currentDate),
                BI_PSPB_Date__c = currentDate
            );
            insert newObj;

            BI_PSPB_DateTimeSched schedulable = new BI_PSPB_DateTimeSched();

            Test.startTest();
            String jobId = System.schedule('BI_PSPB_DateTimeSched', '0 0 0 * * ?', schedulable);
            Test.stopTest();

            // Ensure job is scheduled
            CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                        FROM CronTrigger 
                                        WHERE Id = :jobId];
            Assert.areEqual('0 0 0 * * ?', cronTrigger.CronExpression, 'Cron expression does not match');
            Assert.areEqual(0, cronTrigger.TimesTriggered, 'Job has not been executed');
        }
    }

    @isTest
    static void forCatch() {
        System.runAs(testUser) {
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            List<BI_PSPB_DateTimeMention__c> recordsToInsert = new List<BI_PSPB_DateTimeMention__c>();
            Integer numberOfRecords = 200; // Change this value to insert the desired number of records
            for (Integer i = 0; i < numberOfRecords; i++) {
                Date currentDate = Date.valueOf('2024-02-28').addDays(i);
                BI_PSPB_DateTimeMention__c newObj = new BI_PSPB_DateTimeMention__c(
                    Name = String.valueOf(currentDate),
                    BI_PSPB_Date__c = currentDate
                );
                recordsToInsert.add(newObj);
            }
            insert recordsToInsert;

            BI_PSPB_DateTimeSched schedulable = new BI_PSPB_DateTimeSched();
            Test.startTest();
            String jobId = System.schedule('BI_PSPB_DateTimeSched', '0 0 0 * * ?', schedulable);
            Test.stopTest();

            CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                        FROM CronTrigger 
                                        WHERE Id = :jobId];
            Assert.areEqual('0 0 0 * * ?', cronTrigger.CronExpression, 'Cron expression does not match');
            Assert.areEqual(0, cronTrigger.TimesTriggered, 'Job has not been executed');
        }
    }

   @isTest
static void testDatabaseErrorHandling() {
    System.runAs(testUser) {
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'Test Settings',
            BI_SFCOE_LOG_Application__c = 'Test App'
        );
        insert settings;

        List<BI_PSPB_DateTimeMention__c> recordsToInsert = new List<BI_PSPB_DateTimeMention__c>();
        for (Integer i = 0; i < 5; i++) {
            recordsToInsert.add(new BI_PSPB_DateTimeMention__c(
                Name = 'DuplicateName', // Adjust data to trigger a known validation rule or unique constraint
                BI_PSPB_Date__c = Date.today()
            ));
        }
        
        Test.startTest();
        try {
            // Attempt to insert duplicate names or other constraints that should fail
            insert recordsToInsert;
        } catch (DmlException e) {
            // Check that the exception was thrown due to the correct reason
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') || e.getMessage().contains('DUPLICATE_VALUE'), 
                'Unexpected exception message: ' + e.getMessage());
        }
        Test.stopTest();
    }
}

}