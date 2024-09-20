/*
*********************************************************
Apex Class Name    :BI_PSP_CompletedQuestionnaireCtrlTest
Created Date       : March 10, 2024
@description       : This Apex Test Class for Retrieving Questionnaire Records those status is in Completed
                  	and expired
@author            : Abinsha
Last Modification  : Harish
*********************************************************
*/

@isTest
public class BI_PSP_CompletedQuestionnaireCtrlTest {
    public static string careProgramEnrolleeOne;
    public static String pss = 'Psoriasis Symptom Scale (PSS)';
    public static String wapiCategory = 'Work & Activity Impairment (WPAI)';
    public static String dlqiCategory = 'Dermatology Life Quality Index (DLQI)';
    public static String qualiCategory = 'Qualitative satisfaction questionnaire';
    public static String inProgress = 'In Progress';

    @isTest
    //To get the Completed Questionnaire Response by Category
    static void getCompletedQuestionaresTest() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        String targetDate = 'Jan 2023';
        String currentUserName = 'Test User';
        String currentUserEmail = 'testusernew@example.com';

        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account testAccountOne = new Account(
            Lastname = currentUserName,
            PersonEmail = currentUserEmail,
            RecordTypeId = personAccountRecordTypeId
        );
        insert testAccountOne;

        String currentUserNameTwo = 'Test User2';
        String currentUserEmaiTwo = 'testuser2new@example.com';
        Account testAccountTwo = new Account(
            Lastname = currentUserNameTwo,
            PersonEmail = currentUserEmaiTwo,
            RecordTypeId = personAccountRecordTypeId,
            BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
        );
        insert testAccountTwo;

        CareProgram carePrgm = new CareProgram(
            Name = 'testcp',
            StartDate = Date.valueOf('2024-02-28')
        );

        insert carePrgm;

        CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
            Name = 'TestCpa222',
            AccountId = testAccountOne.Id,
            CareProgramId = carePrgm.Id
        );
        insert testCpeTwo;
        Datetime createdDt = DateTime.newInstance(
            Date.newInstance(2023, 1, 6),
            Time.newInstance(12, 23, 0, 0)
        );
        Assessment testAssessment = new Assessment(
            Name = 'Qualitative satisfaction questionnaire',
            AssessmentStatus = 'Expired',
            BI_PSP_DateForCQ__c = 'Jan 2023',
            ExpirationDateTime = createdDt,
            BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
        );
        insert testAssessment;

        //insert assessment question
        AssessmentQuestion questionData = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Qualitative satisfaction questionnaire'
        );
        insert questionData;

        //insert Assessment question version

        AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questionData.Id
        );
        insert questionVer;

        // Create test assessment response data
        AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
            Name = 'Test Response',
            ResponseText = 'No',
            BI_PSP_Category__c = 'Social life',
            AssessmentId = testAssessment.Id,
            AssessmentQuestionId = questionVer.Id,
            //CreatedDate = createdDt,
            BI_PSP_QsqAfterWeeks__c = 'pageTwo'
        );
        insert testResponse;

        String categoryName = 'Dermatology Life Quality Index (DLQI)';
        try {
            //assertion is not done because this is for negative scenario and it goes to catch
            Test.startTest();
            BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(targetDate, categoryName);
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
        }
    }

    @isTest
    //To get the all Completed Questionnaire Response for category negative Senario
    static void getCompletedQuestionaresNullTest() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
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
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );

            insert portalAccount1;

            // Create user associated with Person Account
            Profile portalProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];
            Contact personContact = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :portalAccount1.Id
                LIMIT 1
            ];
            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = false,
                Username = 'testusernew@example.com',
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;

            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            String currentUserNameTwo = 'Test User2';
            String currentUserEmaiTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmaiTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeTwo;
            Datetime createdDt = DateTime.newInstance(
                Date.newInstance(2023, 1, 6),
                Time.newInstance(12, 23, 0, 0)
            );
            Assessment testAssessment = new Assessment(
                Name = 'Qualitative satisfaction questionnaire',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Expired',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                ExpirationDateTime = createdDt,
                BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Qualitative satisfaction questionnaire'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id,
                //CreatedDate = createdDt,
                BI_PSP_QsqAfterWeeks__c = 'pageTwo'
            );
            insert testResponse;

            try {
                //assertion is not done because this is for negative scenario and it goes to catch
                Test.startTest();
                BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(null, null);
                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }

    @isTest
    //To get the All Completed Questionnaire Response for caregiver
    static void getCompltdTestCaregiver() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
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
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );

            insert portalAccount1;

            // Create user associated with Person Account
            Profile portalProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];
            Contact personContact = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :portalAccount1.Id
                LIMIT 1
            ];
            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            String targetDate = 'Jan 2023';
            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = false,
                Username = 'testusernew@example.com',
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;

            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            String currentUserNameTwo = 'Test User2';
            String currentUserEmaiTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmaiTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeTwo;
            Datetime createdDt = DateTime.newInstance(
                Date.newInstance(2023, 1, 6),
                Time.newInstance(12, 23, 0, 0)
            );
            Assessment testAssessment = new Assessment(
                Name = 'Qualitative satisfaction questionnaire',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Expired',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                ExpirationDateTime = createdDt,
                BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Qualitative satisfaction questionnaire'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id,
                //CreatedDate = createdDt,
                BI_PSP_QsqAfterWeeks__c = 'pageTwo'
            );
            insert testResponse;

            String categoryName = 'Dermatology Life Quality Index (DLQI)';
            try {
                //assertion is not done because this is for negative scenario and it goes to catch
                System.runAs(testUser) {
                    Test.startTest();
                    BI_PSP_CompletedQuestionnaireCtrl.getCompletedQuestionares(
                        targetDate,
                        categoryName
                    );
                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }

    @isTest
    //To get current date for completed Questionnaire for patient
    static void forCurrentDateTestNoncaregvr() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
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
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );

            insert portalAccount1;

            // Create user associated with Person Account
            Profile portalProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];
            Contact personContact = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :portalAccount1.Id
                LIMIT 1
            ];
            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = false,
                Username = 'testusernew@example.com',
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;

            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            String currentUserNameTwo = 'Test User2';
            String currentUserEmaiTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmaiTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeTwo;
            Datetime createdDt = DateTime.newInstance(
                Date.newInstance(2023, 1, 6),
                Time.newInstance(12, 23, 0, 0)
            );
            Assessment testAssessment = new Assessment(
                Name = 'Qualitative satisfaction questionnaire',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Expired',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                ExpirationDateTime = createdDt,
                BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Qualitative satisfaction questionnaire'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id,
                //CreatedDate = createdDt,
                BI_PSP_QsqAfterWeeks__c = 'pageTwo'
            );
            insert testResponse;

            String categoryName = 'Dermatology Life Quality Index (DLQI)';
            try {
                //assertion is not done because this is for negative scenario and it goes to catch
                System.runAs(testUser) {
                    Test.startTest();
                    BI_PSP_CompletedQuestionnaireCtrl.getQstnrcurrentcompleteddate(categoryName);
                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }

    @isTest
    //To cover negative Senario for current completed date
    static void forCurrentDateTestNull() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
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
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );

            insert portalAccount1;

            // Create user associated with Person Account
            Profile portalProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'BI_PSP_Patient Profile'
                LIMIT 1
            ];
            Contact personContact = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :portalAccount1.Id
                LIMIT 1
            ];
            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = false,
                Username = 'testusernew@example.com',
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;

            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            String currentUserNameTwo = 'Test User2';
            String currentUserEmaiTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmaiTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeTwo;
            Datetime createdDt = DateTime.newInstance(
                Date.newInstance(2023, 1, 6),
                Time.newInstance(12, 23, 0, 0)
            );
            Assessment testAssessment = new Assessment(
                Name = 'Qualitative satisfaction questionnaire',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Expired',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                ExpirationDateTime = createdDt,
                BI_PSP_CareProgramEnrollee__c = testCpeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Qualitative satisfaction questionnaire'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id,
                //CreatedDate = createdDt,
                BI_PSP_QsqAfterWeeks__c = 'pageTwo'
            );
            insert testResponse;

            try {
                //assertion is not done because this is for negative scenario and it goes to catch
                System.runAs(testUser) {
                    Test.startTest();
                    BI_PSP_CompletedQuestionnaireCtrl.getQstnrcurrentcompleteddate(null);
                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }
}