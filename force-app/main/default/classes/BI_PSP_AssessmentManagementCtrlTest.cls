/*
 * @description       This test class provides Insertion for Introduction Assessment and draft Response for Introduction Assessments.
 * History:
 * Version	Author		Date			Detail			Description
 * 1.0		Abinsha  	05-Dec-2023		Created			Initial development.
 * 1.1		Abinsha  	01-Jan-2024		Updated			Updated for caregiver.
 * 1.2		Abinsha 	04-Apr-2024		Updated			test cases added.
 */
@isTest
public class BI_PSP_AssessmentManagementCtrlTest {
    @isTest
    private static void testMulitipleDraftRecordsInsertionNewAssessment() {
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
            Account testAccountFirst = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountFirst;

            String currentUserNameSecond = 'Test User2';
            String currentUserEmailSecond = 'testUserSecondnew@example.com';
            Account testAccountSecond = new Account(
                Lastname = currentUserNameSecond,
                PersonEmail = currentUserEmailSecond,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
            );
            insert testAccountSecond;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            // Set up test data
            CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
                Name = 'testCareProgramEnrolleeTwo',
                AccountId = testAccountSecond.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeTwo;

            Assessment testAssessment = new Assessment(
                Name = 'Test Assessment',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Completed',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
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
                AssessmentQuestionId = questionData.Id,
                IsActive = true
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id
                //CreatedDate = createdDt
            );
            insert testResponse;

            AssessmentQuestion questionDataTwo = new AssessmentQuestion(
                Name = 'test questionname2',
                DeveloperName = 'Valid_Name_1293',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionDataTwo;

            AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
                AssessmentQuestionId = questionDataTwo.id,
                QuestionText = 'What is your gender?',
                Name = 'test data2',
                IsActive = true
            );
            insert questionVersionTwo;

            AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
                ResponseText = 'Female',
                BI_PSP_Category__c = '',
                AssessmentId = testAssessment.id,
                AssessmentQuestionId = questionVersionTwo.id,
                Name = 'test data'
            );
            insert testResponseTwo;

            List<String> responseTexts = new List<String>{
                testResponseTwo.ResponseText,
                testResponse.ResponseText
            };
            List<String> questionIds = new List<String>{ questionVer.Id, questionVersionTwo.Id };
            // Create mock data for the new assessment
            Boolean isItDraftOrSubmit = true;
            Boolean isQsqAfterTwoMonths = false;

            // Mocking method
            System.runAs(testUser) {
                try {
                    Test.startTest();
                    BI_PSP_AssessmentManagementCtrl.mulitipleDraftRecordsInsertion(
                        questionIds,
                        responseTexts,
                        isItDraftOrSubmit,
                        isQsqAfterTwoMonths
                    );
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
            // Verify results
            List<Assessment> assessments = [
                SELECT Id, Name
                FROM Assessment
                WHERE BI_PSP_CareProgramEnrollee__c = :testCareProgramEnrolleeTwo.Id
            ];
            Assert.areEqual(1, assessments.size(), 'An assessment should have been created.');

            Assessment createdAssessment = assessments[0];
            List<AssessmentQuestionResponse> responses = [
                SELECT Id, ResponseText
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :createdAssessment.Id
            ];
            Assert.areEqual(
                questionIds.size(),
                responses.size(),
                'Responses should match the draft questions.'
            );
        }
    }

    @isTest
    private static void testMulitipleDraftRecordsInsertionExistingAssessment() {
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

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';

            Contact con = new Contact(
                LastName = 'testusernew@example.com',
                Email = 'testusernew@example.com'
            );
            insert con;

            //Creating Test User
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
            //Creating Person Account for the User
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            //Creating Care program to insert careProgram Enrollee
            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;
            //To create Care Program Enrollee for Assessment
            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeOne;

            Assessment existingAssessment = new Assessment(
                BI_PSP_CareProgramEnrollee__c = testCpeOne.Id,
                Name = 'Test Category',
                AssessmentStatus = BI_PSP_QuestionnaireConstant.inProgress
            );
            insert existingAssessment;

            //insert assessment question
            AssessmentQuestion questionData = new AssessmentQuestion(
                Name = 'test questionname',
                DeveloperName = 'Valid_Name_123',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionData;

            //insert Assessment question version

            AssessmentQuestionVersion questionVer = new AssessmentQuestionVersion(
                Name = 'test questionname',
                QuestionText = 'Do you often discuss GPP with your friends and family?',
                AssessmentQuestionId = questionData.Id,
                IsActive = true
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = existingAssessment.Id,
                AssessmentQuestionId = questionVer.Id
                //CreatedDate = createdDt
            );
            insert testResponse;

            AssessmentQuestion questionDataTwo = new AssessmentQuestion(
                Name = 'test questionname2',
                DeveloperName = 'Valid_Name_1293',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionDataTwo;

            AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
                AssessmentQuestionId = questionDataTwo.id,
                QuestionText = 'What is your gender?',
                Name = 'test questionname2',
                IsActive = true
            );
            insert questionVersionTwo;

            AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
                ResponseText = 'Female',
                BI_PSP_Category__c = '',
                AssessmentId = existingAssessment.id,
                AssessmentQuestionId = questionVersionTwo.id,
                Name = 'test data'
            );
            insert testResponseTwo;

            List<String> responseTexts = new List<String>{
                testResponseTwo.ResponseText,
                testResponse.ResponseText
            };
            List<String> questionIds = new List<String>{ questionVer.Id, questionVersionTwo.Id };
            Boolean isItDraftOrSubmit = false;
            Boolean isQsqAfterTwoMonths = true;
            System.runAs(testUser) {
                // Mocking method
                Test.startTest();
                BI_PSP_AssessmentManagementCtrl.mulitipleDraftRecordsInsertion(
                    questionIds,
                    responseTexts,
                    isItDraftOrSubmit,
                    isQsqAfterTwoMonths
                );
                Test.stopTest();
            }
            // Verify results
            List<AssessmentQuestionResponse> responses = [
                SELECT Id, ResponseText
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :existingAssessment.Id
            ];
            Assert.areEqual(questionIds.size(), responses.size(), 'Responses should be updated.');
        }
    }


    @isTest
    static void updateExistingResp() {
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

            String currentUserName = 'Test User';
            String currentUserEmail = 'testusernew@example.com';

            Contact con = new Contact(
                LastName = 'testusernew@example.com',
                Email = 'testusernew@example.com'
            );
            insert con;

            //Creating Test User
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
            //Creating Person Account for the User
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

            Account testAccountOne = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountOne;

            //Creating Care program to insert careProgram Enrollee
            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;
            //To create Care Program Enrollee for Assessment
            CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
                Name = 'TestCpa111',
                AccountId = testAccountOne.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpeOne;

            // Create mock data for updating existing assessment
            List<String> draftQuestionIds = new List<String>{ 'a1', 'a2' };
            List<String> draftResponseTexts = new List<String>{
                'Updated Response 1',
                'Updated Response 2'
            };

            System.runAs(testUser) {
                try {
                    Test.startTest();
                    BI_PSP_AssessmentManagementCtrl.mulitipleDraftRecordsInsertion(
                        draftQuestionIds,
                        draftResponseTexts,
                        false,
                        false
                    );
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }
    @isTest
    private static void testForUpdateExistingResponses() {
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
            Account testAccountFirst = new Account(
                Lastname = currentUserName,
                PersonEmail = currentUserEmail,
                RecordTypeId = personAccountRecordTypeId
            );
            insert testAccountFirst;

            String currentUserNameSecond = 'Test User2';
            String currentUserEmailSecond = 'testUserSecondnew@example.com';
            Account testAccountSecond = new Account(
                Lastname = currentUserNameSecond,
                PersonEmail = currentUserEmailSecond,
                RecordTypeId = personAccountRecordTypeId,
                BI_PSPB_Selected_Patient_ID__c = testAccountFirst.Id
            );
            insert testAccountSecond;

            CareProgram carePrgm = new CareProgram(
                Name = 'testcp',
                StartDate = Date.valueOf('2024-02-28')
            );

            insert carePrgm;

            // Set up test data
            CareProgramEnrollee testCareProgramEnrolleeTwo = new CareProgramEnrollee(
                Name = 'testCareProgramEnrolleeTwo',
                AccountId = testAccountSecond.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCareProgramEnrolleeTwo;

            Assessment testAssessment = new Assessment(
                Name = 'Test Assessment',
                OwnerId = testUser.Id,
                AssessmentStatus = 'Completed',
                BI_PSP_DateForCQ__c = 'Jan 2023',
                BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolleeTwo.Id
            );
            insert testAssessment;

            //insert assessment question
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
                AssessmentQuestionId = questionData.Id,
                IsActive = true
            );
            insert questionVer;

            // Create test assessment response data
            AssessmentQuestionResponse testResponse = new AssessmentQuestionResponse(
                Name = 'Test Response',
                ResponseText = 'No',
                BI_PSP_Category__c = 'Social life',
                AssessmentId = testAssessment.Id,
                AssessmentQuestionId = questionVer.Id
                //CreatedDate = createdDt
            );
            insert testResponse;

            AssessmentQuestion questionDataTwo = new AssessmentQuestion(
                Name = 'test questionname2',
                DeveloperName = 'Valid_Name_1293',
                DataType = 'Decimal',
                QuestionCategory = 'Work & Activity Impairment (WPAI)'
            );
            insert questionDataTwo;

            AssessmentQuestionVersion questionVersionTwo = new AssessmentQuestionVersion(
                AssessmentQuestionId = questionDataTwo.id,
                QuestionText = 'What is your gender?',
                Name = 'test data2',
                IsActive = true
            );
            insert questionVersionTwo;

            AssessmentQuestionResponse testResponseTwo = new AssessmentQuestionResponse(
                ResponseText = 'Female',
                BI_PSP_Category__c = '',
                AssessmentId = testAssessment.id,
                AssessmentQuestionId = questionVersionTwo.id,
                Name = 'test data'
            );
            insert testResponseTwo;

            List<String> responseTexts = new List<String>{
                testResponseTwo.ResponseText,
                testResponse.ResponseText
            };
            List<String> questionIds = new List<String>{ questionVer.Id, questionVersionTwo.Id };
            // Create mock data for the new assessment
            Boolean isItDraftOrSubmit = true;
            Boolean isQsqAfterTwoMonths = false;
            String existingAssessmentId = testAssessment.Id;
            // Mocking method
            System.runAs(testUser) {
                Test.startTest();
                BI_PSP_AssessmentManagementCtrl.updateExistingResponses(
                    existingAssessmentId,
                    questionIds,
                    responseTexts,
                    isItDraftOrSubmit,
                    isQsqAfterTwoMonths
                );
                Test.stopTest();
            }
            // Verify results
            List<Assessment> assessments = [
                SELECT Id, Name
                FROM Assessment
                WHERE BI_PSP_CareProgramEnrollee__c = :testCareProgramEnrolleeTwo.Id
            ];
            Assert.areEqual(1, assessments.size(), 'An assessment should have been created.');

            Assessment createdAssessment = assessments[0];
            List<AssessmentQuestionResponse> responses = [
                SELECT Id, ResponseText
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :createdAssessment.Id
            ];
            Assert.areEqual(
                questionIds.size(),
                responses.size(),
                'Responses should match the draft questions.'
            );
        }

    }
}