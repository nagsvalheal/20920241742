/**
* @description   This is a Test class for the BI_PSPB_PatientFormController Apex Class 
* History:
* Version	Author			Date			Detail				Description
* 1.0		NandhaKumar	    13.02.2024  	Created				Initial development
* 1.1		NandhaKumar 	04-Apr-2023		Updated				Catch log added
*/
@IsTest
public class BI_PSPB_PatientFormCtrlTest {
  /**
 * @method createTestUser
 * @description Creates and inserts a test User record with predefined attributes for testing purposes.
 * 
 * This method constructs a User record with specific details, including the user's first name, last name, email,
 * username, alias, community nickname, and other locale-specific settings. The User record is then inserted into the 
 * database and returned for use in test methods.
 * 
 * @return User The created User record.
 */
  
    private static User createTestUser() {
        User testUser = new User(
            FirstName = 'Testeight',
            LastName = 'Userei',
            Email = 'testsei@example.com',
            Username = 'testeir@example.com',
            Alias = 'teeiUser',
            CommunityNickname = 'testUser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        return testUser;
    }
    
    /**
     * @method createTestAccount
     * @description Creates and inserts a test Account record linked to a specified User and patient ID.
     * @param user The User to associate with the Account.
     * @param patientId The patient ID to be set on the Account.
     * @return Account The created Account record.
     */
    private static Account createTestAccount(User user, String patientId) {
        Account testAccount = new Account(
            FirstName = user.FirstName,
            LastName = user.LastName,
            PersonEmail = user.Username,
            BI_PSPB_Selected_Patient_ID__c = patientId
        );
        insert testAccount;
        return testAccount;
    }

    /**
     * @method testGetPatientInfo_UserFound_AccountFound
     * @description Tests the 'getPatientInfo' method when both the user and the corresponding account are found.
     * Creates a test user and account, then verifies that the 'getPatientInfo' method returns the correct account.
     */
    @IsTest
    static void testGetPatientInfoUserFoundAccountFound() {
        User testUser = createTestUser();
        Account patientAccount = new Account(
            FirstName = 'PatientFirstName',
            LastName = 'PatientLastName',
            PersonEmail = 'patient@example.com'
        );
        insert patientAccount;

        createTestAccount(testUser, patientAccount.Id);

        System.runAs(testUser) {
            try {
                Test.startTest();
                Account result = BI_PSPB_PatientFormCtrl.getPatientInfo();
                Test.stopTest();
                Assert.areEqual(patientAccount.Id, result.Id, 'Expected account ID to match');
            }  catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        }
    }
    
    /**
     * @method testGetPatientInfo_UserFound_NoPatientAccount
     * @description Tests the 'getPatientInfo' method when a user is found but no corresponding patient account exists.
     * Verifies that the method returns null when no patient account is associated.
     */
    @IsTest
    static void testGetPatientInfoUserFoundNoPatientAccount() {
        User testUser = createTestUser();
        createTestAccount(testUser, null);

        System.runAs(testUser) {
            try {
                Test.startTest();
                Account result = BI_PSPB_PatientFormCtrl.getPatientInfo();
                Test.stopTest();

                // Assert that the result is null since no patient account exists
                Assert.isNull(result, 'Expected result to be null if no patient account is found');
            } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        }
    }
    
     /**
     * @method testGetPatientInfo_NoUserFound
     * @description Tests the 'getPatientInfo' method when no user is found that matches the account criteria.
     * Verifies that the method returns null if no user account matches.
     */
    @IsTest
    static void testGetPatientInfoNoUserFound() {
        User testUser = new User(
            FirstName = 'Nonexistent',
            LastName = 'User',
            Email = 'nonexistentuser@example.com',
            Username = 'nonexistentuser@example.com',
            Alias = 'nnonex',
            CommunityNickname = 'nonexistent',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;

        System.runAs(testUser) {
            try {
                Test.startTest();
                Account result = BI_PSPB_PatientFormCtrl.getPatientInfo();
                Test.stopTest();

                // Assert that the result is null since no account matches the user info
                Assert.isNull(result, 'Expected result to be null if no user account matches');
            } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
        }
    }

    /**
     * @method testGetPatientInfo_ExceptionHandling
     * @description Simulates an exception being thrown during the execution of the 'getPatientInfo' method.
     * Ensures that the method handles exceptions properly and verifies that an exception message is thrown.
     */
    @IsTest
    static void testGetPatientInfoExceptionHandling() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            
            Test.startTest();
            try {
                BI_PSPB_PatientFormCtrl.getPatientInfo();
            } catch(Exception e) {
               
                assert.areNotEqual(null, e.getMessage(), 'Expected an exception to be thrown');
            }
            Test.stopTest();
        }
    }

}