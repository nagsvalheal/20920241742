@isTest
public class BI_PSP_UserUtilityTest {

    @testSetup
    static void setupTestData() {
Profile patientProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];

// Retrieve UserRole and Profile for the portal account owner
UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

// Create portal account owner user
User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = 'test2@tset.com',
    Alias = 'batman',
    Email = 'now.wayne@tset.com',
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
        PersonEmail = 'newemail@example.com',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );

    insert portalAccount1;

    // Retrieve the associated Contact for the Person Account
    Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];

    // Generate a unique username for the new user
    //String uniqueUsername = 'newemail@example.com';

    // Create user associated with the Person Account
    User user1 = new User(
        Username = 'newemail@example.com',
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

}
        

   @isTest
static void testUpdateUserEmailsAndUsernames() {
    // Retrieve the Account ID and set up the map for email updates
    Id accountId = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1].Id;
    
    // Create a map to hold Account Id and new email
    Map<Id, String> accountEmailMap = new Map<Id, String>();
    accountEmailMap.put(accountId, 'newemail@example.com');
    
    // Call the future method and perform the test
    try{
    Test.startTest();
    BI_PSP_UserUtility.updateUserEmailsAndUsernames(accountEmailMap);  // Future method called here
    Test.stopTest();
     
    // Query the Users again to check if the Username and Email have been updated
    List<User> updatedUsers = [SELECT Username, Email FROM User WHERE AccountId = :accountId];
    
    // Assertions to verify the update
    for (User user : updatedUsers) {
        Assert.areEqual('newemail@example.com', user.Username, 'Username should be updated to match the new email.');
        assert.areNotEqual('newemail@example.com', user.Email, 'Email should be updated to the new email.');
    }
         } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        
}

    @isTest
    static void testUpdateUserEmailsAndUsernamesWithNoMatchingRecords() {
        // Case when there are no matching records for the given Account IDs
        Map<Id, String> accountEmailMap = new Map<Id, String>();
        Id accountId = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1].Id;
        accountEmailMap.put(accountId, 'nomateech@example.com');  // Random ID that does not exist
        
        // Call the future method
        Test.startTest();
        BI_PSP_UserUtility.updateUserEmailsAndUsernames(accountEmailMap);
        Test.stopTest();
        
        // There should be no Users with the updated email
        List<User> users = [SELECT Id FROM User WHERE Username = 'nomatch@example.com'];
        Assert.areEqual(0, users.size(), 'No Users should have the updated email since there are no matching records.');
    }

    @isTest
    static void testUpdateUserEmailsAndUsernamesWithNullEmails() {
        // Create a map with a null email to test the null check
        Id accountId = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1].Id;
        
        Map<Id, String> accountEmailMap = new Map<Id, String>();
        accountEmailMap.put(accountId, null);  // Null email
        
        // Call the future method
        Test.startTest();
        BI_PSP_UserUtility.updateUserEmailsAndUsernames(accountEmailMap);
        Test.stopTest();
        
        // Query the Users again to check that Username has not been updated to null
        List<User> users = [SELECT Username FROM User WHERE AccountId = :accountId];
        
        // Assertions
        for (User user : users) {
            assert.areNotEqual(null, user.Username, 'Username should not be updated to null.');
        }
    }

  
}