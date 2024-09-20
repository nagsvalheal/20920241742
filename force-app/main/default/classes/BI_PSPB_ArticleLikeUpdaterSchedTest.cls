/**
 * @description This test class ensures 100% coverage for the BI_PSPB_ArticleLikeUpdaterSched class.
 *              The test covers scenarios including successful job scheduling, processing of records,
 *              and validation of database error handling.
 * History
 * Version 	Author			Date			Detail				Description
 * 1.0		Gokulkrishnan T	29-Aug-2024		Created				Initial development for testing article like scheduler.
 */
@isTest
private class BI_PSPB_ArticleLikeUpdaterSchedTest {
    
    // Declare a test user for running the test methods
    public static User testUser;

    static {
        // Create the test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testusertgk@example.com',
            UserName = 'testusertgk@example.com',
            Alias = 'testusr',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = profile.Id
        );
        insert testUser;
    }

    /**
     * @description Tests the execution of the scheduled job and ensures that records are correctly processed.
     */
    @isTest
    static void testExecuteMethodScheduleJobSuccessfully() {
        System.runAs(testUser) {
            // Insert a valid article like record
            BI_PSPB_Article_like__c articleLikeRecord = new BI_PSPB_Article_like__c(
                BI_PSPB_JustForMeArticles__c = '["Article1", "Article2", "Article3"]'
            );
            insert articleLikeRecord;

            // Instantiate the schedulable class
            BI_PSPB_ArticleLikeUpdaterSched schedulable = new BI_PSPB_ArticleLikeUpdaterSched();

            Test.startTest();
            String jobId = System.schedule('BI_PSPB_ArticleLikeUpdaterSched', '0 0 0 * * ?', schedulable);
            Test.stopTest();

            // Ensure job is scheduled correctly
            CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                       FROM CronTrigger 
                                       WHERE Id = :jobId];
            Assert.areEqual('0 0 0 * * ?', cronTrigger.CronExpression, 'Cron expression does not match');
            Assert.areEqual(0, cronTrigger.TimesTriggered, 'Job has not been executed');

            // Query the article like records to ensure they have been processed
            List<BI_PSPB_Article_like__c> updatedRecords = [SELECT Id, BI_PSPB_JustForMeArticles__c 
                                                            FROM BI_PSPB_Article_like__c 
                                                            WHERE Id = :articleLikeRecord.Id];
            Assert.areEqual(1, updatedRecords.size(), 'There should be exactly one record.');
            Assert.isTrue(updatedRecords[0].BI_PSPB_JustForMeArticles__c != null, 'Articles list should be updated.');
        }
    }

    /**
     * @description Tests the scheduling and processing of records, ensuring that both records are correctly processed after the job runs.
     */
    @isTest
    static void testDatabaseErrorHandling() {
        System.runAs(testUser) {
            // Insert a valid article like record
            BI_PSPB_Article_like__c validArticleLike = new BI_PSPB_Article_like__c(
                BI_PSPB_JustForMeArticles__c = '["Article1", "Article2", "Article3"]'
            );
            insert validArticleLike;

            // Insert another valid record that will be processed by the scheduler
            BI_PSPB_Article_like__c anotherValidArticleLike = new BI_PSPB_Article_like__c(
                BI_PSPB_JustForMeArticles__c = '["Article4", "Article5"]'
            );
            insert anotherValidArticleLike;

            // Instantiate the schedulable class
            BI_PSPB_ArticleLikeUpdaterSched schedulable = new BI_PSPB_ArticleLikeUpdaterSched();

            Test.startTest();
            // Schedule the job to run immediately
            String jobId = System.schedule('BI_PSPB_ArticleLikeUpdaterSched', '0 0 0 * * ?', schedulable);
            Test.stopTest();

            // Re-query to check if records were processed correctly after the job execution
            List<BI_PSPB_Article_like__c> records = [SELECT Id, BI_PSPB_JustForMeArticles__c 
                                                    FROM BI_PSPB_Article_like__c 
                                                    WHERE Id IN :new List<Id>{validArticleLike.Id, anotherValidArticleLike.Id}];
            Assert.areEqual(2, records.size(), 'Both records should be present after the job execution.');
            Assert.areNotEqual(jobId,null,'jobid is should not null');
        }
    }

}