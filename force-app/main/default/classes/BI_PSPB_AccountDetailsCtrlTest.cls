/**
 * @description   This Apex test class verifies the functionality of the `BI_PSPB_AccountDetailsCtrl` class 
 *                 by testing the `getAccDetails` method. It covers both positive and negative scenarios to ensure
 *                 correct behavior of the method under various conditions.
 * History:
 * Version    Author        Date            Detail                Description
 * 1.0        NandhaKumar   06.12.2023       Created               Initial development
 * 
 * @isTest
 * This class contains test methods to validate the behavior of the `BI_PSPB_AccountDetailsCtrl` class.
 */
@isTest
public class BI_PSPB_AccountDetailsCtrlTest {
 /**
     * @description
     * Test method to verify the behavior of the `getAccDetails` method in the `BI_PSPB_AccountDetailsCtrl` class.
     * This method tests the following scenarios:
     * 1. When a valid user and corresponding account are created, the `getAccDetails` method should return the correct account details.
     * 2. When a non-existent user is tested, the `getAccDetails` method should return null.
     * 
     * The method performs the following steps:
     * 1. Creates and inserts a test user with required fields.
     * 2. Creates and inserts a test account linked to the test user.
     * 3. Executes the `getAccDetails` method in the context of the test user and verifies that the returned account matches the inserted account.
     * 4. Creates and inserts another test user (non-existent in context of the first user).
     * 5. Executes the `getAccDetails` method in the context of the new test user and verifies that null is returned.
     * 6. Handles any exceptions thrown by the method and asserts the expected exception message.
     *
     * @isTest
     * This is a test method, which means it does not count against governor limits and is used solely for unit testing.
     * 
     * @see BI_PSPB_AccountDetailsCtrl
     */
    @isTest
    static void getAccDetails() {
        // Create a test user
        User testUser = new User(
            FirstName = 'testuserone',
            LastName = 'lnameuser',
            Email = 'testlnameuser@example.com',
            Username = 'testlnameuser@example.com',
            Alias = 'tuserd',
            CommunityNickname = 'testuser',
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        // Create a test account
        Account testAccount = new Account(
            FirstName = testUser.FirstName,
            LastName = testuser.LastName,
            PersonEmail = testUser.Email
            // Add any other required fields
        );
        insert testAccount;
        System.runAs(testUser) {
            try{
            Test.startTest();
            
           
            Account resultAccount = BI_PSPB_AccountDetailsCtrl.getAccDetails();
            Assert.areEqual(testAccount.Id, resultAccount.Id, 'Retrieved account should match the test account');
            
            User testUser2 = new User(
                FirstName = 'nonexistent',
                LastName = 'user',
                Email = 'nonexistent@example.com',
                Username = 'nonexistent@example.com',
                Alias = 'nonex',
                CommunityNickname = 'nonexistentuser',
                ProfileId = UserInfo.getProfileId(),
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles'
            );
            insert testUser2;
            System.runAs(testUser2) {
                Account resultAccountNull = BI_PSPB_AccountDetailsCtrl.getAccDetails();
                Assert.areEqual(null, resultAccountNull, 'Expected null as user does not exist');
            }
            
            
            Test.stopTest();
                 }catch(Exception e){
		Assert.areEqual('Script-thrown exception',e.getMessage(),
		'Method thrown exception');
        }
        }
       
    }
}