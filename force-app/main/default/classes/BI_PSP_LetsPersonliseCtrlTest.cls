/**
 * @description       :Apex test class for testing the functionality of the BI_PSP_LetsPersonliseCtrl class.
                       This test class covers various scenarios related to the BI_PSP_LetsPersonliseCtrl class, including:
                       Insertion of multiple draft records for assessment responses,
                       Updating existing assessments with new responses,
                       Deleting selected assessment responses for both caregivers and non-caregivers.
                       The tests simulate different user contexts and assess the behavior of the BI_PSP_LetsPersonliseCtrl class accordingly.
 
 * @author            : Abinsha Basheer
 * @group             : 
 * @last modified on  : 05-02-2024
 * @last modified by  :  Abinsha Basheer
 */
@isTest
public class BI_PSP_LetsPersonliseCtrlTest {
    /**
    * @description This method inserts multiple draft records for assessment question responses. It takes a list of question IDs
    * and a list of corresponding response texts, along with an assessment ID. For each question ID and response text
    * pair, it creates a draft record for the assessment question response associated with the provided assessment ID.
    */
    @isTest
    static void testCaregiverData() {
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
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'ApplicationName',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;
            try {
                // String targetDate = 'Jan 2023';
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

                CareProgramEnrollee testCpaTwo = new CareProgramEnrollee(
                    Name = 'TestCpa222',
                    AccountId = testAccountTwo.Id,
                    CareProgramId = carePrgm.Id
                );
                insert testCpaTwo;
                String[] emptyIdsOfRes = new List<String>{};
                System.runAs(testUserTwo) {
                    Test.startTest();
                    BI_PSP_LetsPersonliseCtrl.draftRespoDeletion(emptyIdsOfRes);
                    Test.stopTest();
                }
            } catch (Exception e) {
                // Assert that the exception message is as expected
                Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
            }
        }
    }

    //@Description Test Method for checking the deletion of unselected response from Introduction questionnaire.
    @isTest
    static void methodForDelSelcResCareGver() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2qq@test.com',
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
            // Create a test user

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
            CareProgramEnrollee testCpaTwo = new CareProgramEnrollee(
                Name = 'TestCpa222',
                AccountId = testAccountTwo.Id,
                CareProgramId = carePrgm.Id
            );
            insert testCpaTwo;

            Assessment testAssessment = new Assessment(
                Name = 'Test Assessment',
                OwnerId = testUserTwo.Id,
                AssessmentStatus = 'Completed',
                BI_PSP_DateForCQ__c = 'Jan 2023'
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
                AssessmentQuestionId = questionData.Id
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
                QuestionCategory = 'Introduction'
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
            List<String> idsOfRes = new List<String>{ testResponseTwo.Id };
            System.runAs(testUserTwo) {
                try {
                    Test.startTest();
                    BI_PSP_LetsPersonliseCtrl.draftRespoDeletion(idsOfRes);
                    Test.stopTest();
                } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
            List<AssessmentQuestionResponse> draftRecords = [
                SELECT Id
                FROM AssessmentQuestionResponse
                WHERE AssessmentId = :testAssessment.Id
            ];
            Integer expectedDraftRecordCount = 2; // Assuming 2 draft records were created
            Assert.areEqual(
                expectedDraftRecordCount,
                draftRecords.size(),
                'Expected characters after first two'
            ); // Succeeds
        }
    }
	//Testing with responses to delete.
    @isTest
    static void testGetEnrolleeRecordsAsCaregiver() {
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
            List<String> draftResponseTexts = new List<String>{
                'Updated Response 1',
                'Updated Response 2'
            };

            System.runAs(testUser) {
                try {
                Test.startTest();
                BI_PSP_LetsPersonliseCtrl.draftRespoDeletion(draftResponseTexts);
                Test.stopTest();

                // Assertions to verify expected behavior
                List<Assessment> assessments = [
                    SELECT Id, Name
                    FROM Assessment
                    WHERE BI_PSP_CareProgramEnrollee__c = :testCpeOne.Id
                ];
                Assert.areEqual(
                    0,
                    assessments.size(),
                    'Expected no assessments to exist after draft response deletion.'
                );

                List<CareProgramEnrollee> enrollees = [
                    SELECT Id
                    FROM CareProgramEnrollee
                    WHERE AccountId = :testAccountOne.Id
                ];
                Assert.areEqual(
                    1,
                    enrollees.size(),
                    'Expected one Care Program Enrollee associated with the account.'
                );
                      } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }
    //Testing with No response to delete.
     @isTest
    static void testAssessmentDeleteNegative() {
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
            // Create mock data for updating existing assessment
            List<String> draftResponseTexts = null;
            System.runAs(testUser) {
                  try {
                Test.startTest();
                BI_PSP_LetsPersonliseCtrl.draftRespoDeletion(draftResponseTexts);
                Test.stopTest();

                // Assertions to verify expected behavior
                List<Assessment> assessments = [
                    SELECT Id, Name
                    FROM Assessment
                    WHERE BI_PSP_CareProgramEnrollee__c = :testCpeOne.Id
                ];
                Assert.areEqual(
                    0,
                    assessments.size(),
                    'Expected no assessments to exist after draft response deletion.'
                );

                List<CareProgramEnrollee> enrollees = [
                    SELECT Id
                    FROM CareProgramEnrollee
                    WHERE AccountId = :testAccountOne.Id
                ];
                Assert.areEqual(
                    1,
                    enrollees.size(),
                    'Expected one Care Program Enrollee associated with the account.'
                );
                        } catch (Exception e) {
                    // Assert that the exception message is as expected
                    Assert.areEqual(e.getMessage(), 'Script-thrown exception', e.getMessage());
                }
            }
        }
    }
}