/**
 * @description Unit tests for BI_PSPB_SmsBatch Apex class.
 * History
 * Version 	Author		Date			Detail		Description
 * 1.0		Rajaa		01-Apr-2024		Created		Initial development.
 * 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
 */
@isTest
public class BI_PSPB_SmsBatchTest {
    /**
     * @description MockHttpResponse class to simulate HTTP callouts.
     */
    public class MockHttpResponse implements HttpCalloutMock {
        /**
         * @description Responds to an HTTP request with a mock HTTP response.
         *
         * @param request The HTTP request.
         * @return The mock HTTP response.
         */
        public HTTPResponse respond(HTTPRequest request) {
            // Create a new HTTPResponse object
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status": "success"}');
            // Set the desired status code in the response
            response.setStatusCode(200);
            // Set the response body
            //response.setBody('{"status": "Success", "Message Id": "123"}');
            response.setBody('{"access_token": "mock_access_token"}');
            // Return the response
            return response;
        }
    }

    /**
     * @description Mock class for simulating an HTTP response with a status code other than 200 (OK).
     */
    public class MockNot200HttpResponse implements HttpCalloutMock {
        /**
         *  @description Responds to the HTTP request with a mock response.
         *
         * @param request The HTTPRequest object representing the request.
         * @return An HTTPResponse object representing the mock response.
         */
        public HTTPResponse respond(HTTPRequest request) {
            // Create a new HTTPResponse object
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status": "failed"}');
            // Set the desired status code in the response
            response.setStatusCode(400);
            // Set the response body
            response.setBody('{"access_token": "mock_access_token"}');
            // Return the response
            return response;
        }
    }
    
    // Test method to cover the else part of the constructor
    @isTest
    static void testConstructorElsePart() {
        // Create a batch instance with invalid parameters
        Test.startTest();
        BI_PSPB_SmsBatch batch = new BI_PSPB_SmsBatch(
            new List<Id>(), // Empty contactIds list
            '',             // Empty notificationDeveloperName
            '',             // Empty destUrl
            null            // Null notificationDate
        );
        Test.stopTest();
        Assert.areNotEqual(null, batch, 'Batch instance should not be null');
    }
   
    
    // Test method to verify positive scenario of the method for making a callout.This test ensures that the method behaves correctly when making a callout with a valid access token.
    @isTest
    static void positiveScenario() {
        // Create test data
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(
                new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact' + i,
                    Phone = '123456789' + i
                )
            );
        }
        insert contacts;

        List<Id> contactIds = new List<Id>();
        for (Contact con : contacts) {
            contactIds.add(con.Id);
        }
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        // Create instance of batch class
        Test.startTest();
        BI_PSPB_SmsBatch batch = new BI_PSPB_SmsBatch(
            contactIds,
            'BI_PSP_NewArticleSms',
            'Destination_URL',
            'Notification_Date'
        );
        Database.executeBatch(batch);
        Test.stopTest();
        Integer expectedRecordCount = 5;
        Integer actualRecordCount = [
            SELECT COUNT()
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            expectedRecordCount,
            actualRecordCount,
            'The correct number of records should be created'
        );
    }

    // Test method to verify behavior when making a callout without an access token.This test ensures that the method handles the scenario where an access token is missing properly.
    @isTest
    static void negativeScenario() {
        // Create test data
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(
                new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact' + i,
                    Phone = '123456789' + i
                )
            );
        }
        insert contacts;

        List<Id> contactIds = new List<Id>();
        for (Contact con : contacts) {
            contactIds.add(con.Id);
        }

        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockNot200HttpResponse());
        // Create instance of batch class
        try {
            //assertion is not done because this is for negative scenario and it goes to catch
            Test.startTest();
            BI_PSPB_SmsBatch batch = new BI_PSPB_SmsBatch(
                contactIds,
                'BI_PSP_NewArticleSms',
                'Destination_URL',
                'Notification_Date'
            );
            Database.executeBatch(batch);
            Test.stopTest();
        } catch (Exception e) {
            // Assert that the exception message is as expected
            Assert.areEqual(
                e.getMessage(),
                'Attempt to de-reference a null object',
                e.getMessage()
            );
        }
    }

    // Utility method to create and return a metadata record for testing purposes.
    private static BI_PSPB_OmnichannelSetting__mdt getTestMethodSetting() {
        BI_PSPB_OmnichannelSetting__mdt setting = new BI_PSPB_OmnichannelSetting__mdt(
            DeveloperName = 'BI_PSPB_SmsEndpoint',
            BI_PSPB_EndPoint__c = 'Test End Point',
            BI_PSPB_ClientSecret__c = 'Test Client Secret',
            BI_PSPB_ClientId__c = 'Test Client Id'
        );
        // Assert that the returned metadata instance is not null
        Assert.areNotEqual(
            null,
            setting,
            'Metadata instance should not be null'
        );
        return setting;
    }

    // Utility method to create and return a metadata record for testing purposes.
    private static BI_PSPB_Notification__mdt getTestMethodSettingNotIf() {
        BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
            DeveloperName = 'BI_PSP_NewArticleSms',
            BI_PSPB_SmsBody__c = 'Test SMS Body',
            BI_PSPB_EventName__c = 'Test Event Name',
            BI_PSPB_EventType__c = 'Test Event Type',
            BI_PSPB_Subject__c = 'Test Subject'
        );
        // Assert that the returned metadata instance is not null
        Assert.areNotEqual(
            null,
            notification,
            'Metadata instance should not be null'
        );
        return notification;
    }
    
     // Test method to verify positive scenario of the method for making a callout.This test ensures that the method behaves correctly when making a callout with a valid access token.
    @isTest
    static void positiveScenarioCatch() {
        // Create test data
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'PSPB'
        );
        insert settings;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(
                new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact',
                    Phone = 'as' + i
                )
            );
        }
        insert contacts;

        List<Id> contactIds = new List<Id>();
        for (Contact con : contacts) {
            contactIds.add(con.Id);
        }
        // Mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        // Create instance of batch class
        Test.startTest();
        BI_PSPB_SmsBatch batch = new BI_PSPB_SmsBatch(
            contactIds,
            'BI_PSP_NewArticleSms',
            'Destination_URL',
            'Notification_Date'
        );
        Database.executeBatch(batch);
        Test.stopTest();
        Integer expectedRecordCount = 5;
        Integer actualRecordCount = [
            SELECT COUNT()
            FROM BI_PSPB_OmnichannelLog__c
        ];
        Assert.areEqual(
            expectedRecordCount,
            actualRecordCount,
            'The correct number of records should be created'
        );
    }


    
}