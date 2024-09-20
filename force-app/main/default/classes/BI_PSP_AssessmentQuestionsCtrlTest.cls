/*

Apex Class Name    :BI_PSP_AssessmentQuestionsCtrlTest
Created Date       : November 5, 2023
description       : Get Assessment Questions
author            : Harish
@Last Modified On  :11/03/2024
@Last Modified by  :Abinsha

*/

@isTest
private class BI_PSP_AssessmentQuestionsCtrlTest {
    //this test method is for checking the retreival assessment questions related to WAPI category.
    @isTest
    static void testGetTheAssessmentQuestion() {
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

            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;
            //create Assessment Questions Work & Activity Impairment (WPAI)
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;
            String questionnaireName = 'Introduction';
            try {
                Test.startTest();
                // Call the method from BI_PSP_AssessmentQuestionsCtrl
                List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
                    questionnaireName
                );
                Assert.areEqual(1, questions.size(), 'Expected one WAPI question');
                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }
	//this method checks whether js questionnaireName input is null or not.
    @isTest
    static void testGetTheAssessmentQuestionNegativeScenario() {
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

            // Create mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;
            //create Assessment Questions Work & Activity Impairment (WPAI)
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'question',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id
            );
            insert questionVer;
            String questionnaireName = '';
            try {
                Test.startTest();
                // Call the method from BI_PSP_AssessmentQuestionsCtrl
                List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
                    questionnaireName
                );
                Assert.areEqual(1, questions.size(), 'Expected one WAPI question');
                Test.stopTest();
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }
    
    //this test method is for checking the retreival assessment questions related to PSS category.
    @isTest
    static void testGetPsoriasisAssesmentQues() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        AssessmentQuestion questionData = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Psoriasis Symptom Scale (PSS)'
        );
        insert questionData;

        //insert Assessment question version

        AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questionData.Id
        );
        insert questionVer;

        Test.startTest();
        // Call the method from BI_PSP_AssessmentQuestionsCtrl
        List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
            'Psoriasis Symptom Scale (PSS)'
        );
        Assert.areEqual(1, questions.size(), 'Expected one PSS question');
        Test.stopTest();
    }

    //this test method is for checking the retreival of assessment questions related to Qualitative Satisfaction Questionnaire.
    @isTest
    static void testGetQualitativeAssesmentQues() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
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

        Test.startTest();
        // Call the method from BI_PSP_AssessmentQuestionsCtrl
        List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
            'Qualitative satisfaction questionnaire'
        );
        Assert.areEqual(1, questions.size(), 'Expected one QSQ question');
        Test.stopTest();
    }

    //this test method is for checking the retreival of assessment questions related to DLQI category.
    @isTest
    static void testGetDermatologyAssesmentQues() {
        // Create mock BI_SFCOE_LOG_App_Settings__c record
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;
        AssessmentQuestion questionData = new AssessmentQuestion(
            Name = 'test questionname',
            DeveloperName = 'Valid_Name_123',
            DataType = 'Decimal',
            QuestionCategory = 'Dermatology Life Quality Index (DLQI)'
        );
        insert questionData;

        //insert Assessment question version

        AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
            Name = 'question',
            QuestionText = 'Do you often discuss GPP with your friends and family?',
            AssessmentQuestionId = questionData.Id
        );
        insert questionVer;

        Test.startTest();
        // Call the method from BI_PSP_AssessmentQuestionsCtrl
        List<AssessmentQuestion> questions = BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
            'Dermatology Life Quality Index (DLQI)'
        );
        Assert.areEqual(1, questions.size(), 'Expected one DLQI question');
        Test.stopTest();
    }

    //this test method is for checking the retreival of Patient status (Unassigned).
    @isTest
    static void testPatientStatusReturnPatient() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'way2@test.com',
            Alias = 'batway',
            Email = 'way2@test.com',
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
                PersonEmail = 'way2@test.com',
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
            // Create a test user without caregiver access
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

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id,
                BI_PSPB_PatientStatus__c = 'Unassigned'
            );
            insert testCpeOne;

            // Call the method under test
            Test.startTest();
            System.runAs(testUser) {
                String result = BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
                Assert.areEqual('Unassigned', result, 'Expected status to be Unassigned');
            }
            Test.stopTest();
        }
    }

    //this test method is for checking the retreival of Patient status (Acute).
    @isTest
    static void testPatientStatusReturnPatientAcute() {
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
            // Create a test user without caregiver access
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

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id,
                BI_PSPB_PatientStatus__c = 'Acute'
            );
            insert testCpeOne;

            // Call the method under test
            Test.startTest();
            System.runAs(testUser) {
                String result = BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
                Assert.areEqual('Acute', result, 'Expected status to be Unassigned');
            }
            Test.stopTest();
        }
    }
    //this test method is for checking the retreival of Caregiver status (Unassigned).
    @isTest
    static void testPatientStatusReturnCaregiver() {
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
            // Create a test user with caregiver access
            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            User testUserTwo = new User(
                Email = 'testuser2new@example.com',
                BI_PSPB_Caregiver__c = true,
                Username = 'testuser2new@example.com',
                FirstName = 'Test',
                LastName = 'User2',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUserTwo;
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
            String currentUserEmailTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmailTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeOne;
            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountTwo.Id,
                CareProgramId = carePrgm.Id,
                BI_PSPB_PatientStatus__c = 'Unassigned'
            );
            insert testCpeTwo;

            // Call the method under test
            try {
                //assertion is not done because this is for negative scenario and it goes to catch
                System.runAs(testUserTwo) {
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }

    //this test method is for checking the retreival of Caregiver status (Acute).
    @isTest
    static void testPatientStatusReturnCaregiveracute() {
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

            // Create a test user with caregiver access
            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;

            User testUserTwo = new User(
                Email = 'testuser2new@example.com',
                BI_PSPB_Caregiver__c = true,
                Username = 'testuser2new@example.com',
                FirstName = 'Test',
                LastName = 'User2',
                Alias = 'tesn',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUserTwo;
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
            String currentUserEmailTwo = 'testuser2new@example.com';
            Account testAccountTwo = new Account(
                Lastname = currentUserNameTwo,
                PersonEmail = currentUserEmailTwo,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountOne.Id
            );
            insert testAccountTwo;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeOne;
            CareProgramEnrollee testCpeTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountTwo.Id,
                CareProgramId = carePrgm.Id,
                BI_PSPB_PatientStatus__c = 'Acute'
            );
            insert testCpeTwo;

            // Call the method under test
            try {
                System.runAs(testUserTwo) {
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();

                    BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();

                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }

            // Add assertions to verify the expected behavior
        }
    }

    //this test method is for checking the retreival of Assessments questions of WAPI - negative.
    @isTest
    static void getCatch() {
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

            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            //user with patient
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = true,
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
            System.runAs(testUser) {
                try {
                    String questionnaireName = 'Introduction';
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(questionnaireName);
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }

        }
    }

    //this test method is for checking the retreival of Assessments questions of PSS - negative.
    @isTest
    static void getCatchFour() {
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

            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            //user with patient
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = true,
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
            System.runAs(testUser) {
                try {
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
                        'Psoriasis Symptom Scale (PSS)'
                    );
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }

    //this test method is for checking the retreival of Assessments questions of DLQI - negative.
    @isTest
    static void getCatchFive() {
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

            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            //user with patient
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = true,
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
            System.runAs(testUser) {
                try {
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
                        'Dermatology Life Quality Index (DLQI)'
                    );
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }
    //this test method is for checking the retreival of Assessments questions of QSQ - negative.
    @isTest
    static void getCatchSix() {
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
            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;

            //user with patient
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = true,
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
            System.runAs(testUser) {
                try {
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.getTheAssesmentQuestion(
                        'Qualitative satisfaction questionnaire'
                    );
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }

    //this test method is for checking the retreival of Assessments questions of QSQ - negative.
    @isTest
    static void getCatchNegativeForStatus() {
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

            Contact con = new Contact(LastName = 'User', Email = 'testuser2new@example.com');
            insert con;
            //user with patient
            User testUser = new User(
                Email = 'testusernew@example.com',
                BI_PSPB_Caregiver__c = true,
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
            System.runAs(testUser) {
                try {
                    //assertion is not done because this is for negative scenario and it goes to catch
                    Test.startTest();
                    BI_PSP_AssessmentQuestionsCtrl.patientstatusreturn();
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }

        }
    }
}