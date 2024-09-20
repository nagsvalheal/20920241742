@IsTest
/** 
* @description       : This is a BI_PSP_CommonQueryUtilityTest test class designed to test the functionality of the BI_PSP_CommonQueryUtility class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
private class BI_PSP_CommonQueryUtilityTest {

    @TestSetup
    static void setupTestData() {
        // Create test data to use in the tests
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a custom record type for Account
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BI_PSPB_Practice' LIMIT 1].Id;
      

        // Create another Account with the custom record type
        Account accountWithRecordType = new Account(
            Name = 'Account with Record Type',
            RecordTypeId = recordTypeId
        );
        insert accountWithRecordType;
    }

    @IsTest
    static void testExecuteQuery() {
        // Test execution of a simple SOQL query
        String fields = 'Id, Name';
        String conditions = 'Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeQuery('Account', fields, conditions, true);
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }

    @IsTest
    static void testExecuteComplexQuery() {
        // Test execution of a more complex query
        String queryString = 'SELECT Id, Name FROM Account WHERE Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeComplexQuery(queryString, true);
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }

    @IsTest
    static void testGetCount() {
        // Test counting records
        String query = 'SELECT COUNT() FROM Account WHERE Name = \'Test Account\'';
        
        Integer count = BI_PSP_CommonQueryUtility.getCount(query, true);
        
        Assert.areEqual(1, count, 'Expected count to be 1');
    }

    @IsTest
    static void testRetrieveRecordTypeId() {
        // Test retrieval of Record Type Id
        String sObjectType = 'Account';
        String developerName = 'BI_PSPB_Practice';
        
        Id recordTypeId = BI_PSP_CommonQueryUtility.retrieveRecordTypeId(sObjectType, developerName);
        
        Assert.areNotEqual(null, recordTypeId, 'Record Type Id should not be null');
    }

    @IsTest
    static void testInvalidSObjectType() {
        // Test handling of invalid SObject type
        try {
            BI_PSP_CommonQueryUtility.retrieveRecordTypeId('InvalidObject', 'recordTypeId');
           Assert.areEqual(false, 'Expected an exception for invalid SObject type',null);
        } catch (IllegalArgumentException e) {
            Assert.areEqual('Invalid SObject type: InvalidObject', e.getMessage(), 'Expected exception message for invalid SObject type');
        }
    }

    @IsTest
    static void testInvalidRecordType() {
        // Test handling of invalid Record Type
        try {
            BI_PSP_CommonQueryUtility.retrieveRecordTypeId('Account', 'InvalidRecordType');
            Assert.areEqual(false, 'Expected an exception for invalid Record Type',null);
        } catch (IllegalArgumentException e) {
            Assert.areEqual('Record Type not found: InvalidRecordType', e.getMessage(), 'Expected exception message for invalid Record Type');
        }
    }
    
      @IsTest
    static void testExecuteQueryWithOutOrderBy() {
        // Test execution of a simple SOQL query
        String fields = 'Id, Name';
        String conditions = 'Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeQueryWithOrderBy('Account', fields, conditions, true,'');
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }
      @IsTest
    static void testExecuteQueryWithOrderBy() {
        // Test execution of a simple SOQL query
        String fields = 'Id, Name';
        String conditions = 'Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeQueryWithOrderBy('Account', fields, conditions, true,'Name ASC');
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }
     @IsTest
    static void testExecuteComplexQueryWithOrderByPositive() {
        // Test execution of a more complex query
        String queryString = 'SELECT Id, Name FROM Account WHERE Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeComplexQueryWithOrderBy(queryString, true ,'Name ASC');
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }
       @IsTest
    static void testExecuteComplexQueryWithOrderByNegative() {
        // Test execution of a more complex query
        String queryString = 'SELECT Id, Name FROM Account WHERE Name = \'Test Account\'';
        
        List<SObject> result = BI_PSP_CommonQueryUtility.executeComplexQueryWithOrderBy(queryString, true ,'');
        
        Assert.areEqual(1, result.size(), 'Expected one Account record to be returned');
        Assert.areEqual('Test Account', ((Account)result[0]).Name, 'The returned Account name should match');
    }
}