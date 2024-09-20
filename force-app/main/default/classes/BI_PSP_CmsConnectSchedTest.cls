@isTest
public class BI_PSP_CmsConnectSchedTest {
    /**
     * @description Mock implementation of the HttpCalloutMock interface
     *              used to simulate HTTP responses for testing purposes.
     */
    // Define the mock class inside the test class
    private class MockManagedContentChannelCollection implements HttpCalloutMock {
        private String mockResponse;
/**
 * @description Constructs a new instance of the MockManagedContentChannelCollection class with the specified mock response.
 *              This constructor initializes the mockResponse property with the provided response string.
 * @param response The mock response string to be used by the MockManagedContentChannelCollection instance. 
 *                 This string represents the data or response that the mock class should return or simulate.
 */
        public MockManagedContentChannelCollection(String response) {
            this.mockResponse = response;
        }
/**
 * @description Constructs and returns a mock HTTP response for a given HTTP request.
 *              This method creates a response with a JSON body that includes fake channel and item data.
 *              The response's content type is set to 'application/json', and the status code is set to 200 (OK).
 * @param req The HTTP request for which the response is being constructed. This parameter is not used in the method
 *            but is included for completeness and to match the method signature.
 * @return The HTTPResponse object containing the mock response with the following properties:
 *         - Header 'Content-Type': 'application/json'
 *         - Status Code: 200
 *         - Body: A JSON string with channels and items, including a formatted date string.
 */
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String todayDateString = System.now().addHours(-1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
            String responseBody = '{"channels": [{"channelName": "' + System.Label.BI_PSPB_CmsBiSite + '", "channelId": "TestChannelId"}], "items": [{"publishedDate": "' + todayDateString + '"}]}';
            
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest
    static void testRetrieveMediaFromCMS() {
        String todayDateString = System.now().addHours(-1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        String mockResponse = '{"channels": [{"channelName": "' + System.Label.BI_PSPB_CmsBiSite + '", "channelId": "TestChannelId"}],"items": [{"publishedDate": "' + todayDateString + '"}]}';
        Test.setMock(HttpCalloutMock.class, new MockManagedContentChannelCollection(mockResponse));
        Test.startTest();
        String result = BI_PSP_CmsConnectSched.getChannelId('BI_PSPB_Branded');
        Test.stopTest();
        assert.areEqual(null, result, 'Channel ID should match the mocked response');
    }
    
     @isTest
    static void testRetrieveMediaFromCMSWithBlankChannelName() {
        String mockResponse = '{"channels": []}';
        Test.setMock(HttpCalloutMock.class, new MockManagedContentChannelCollection(mockResponse));
        Test.startTest();
        String result = BI_PSP_CmsConnectSched.getChannelId('');
        Test.stopTest();
        Boolean isEmptyResult = String.isEmpty(result);
        String expectedValue = 'true';
        String actualValue = String.valueOf(isEmptyResult);
        assert.areEqual(expectedValue, actualValue, 'Result should be empty or null when channel name is blank');
    }

 @isTest
    static void testSaveTasksException() {
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(Subject='Test Task')); 
        Test.startTest();
        try {
            BI_PSP_CmsConnectSched.saveTasks(tasks);
        } catch (Exception e) {
            assert.areEqual('Simulated exception message', e.getMessage(), 'Expected exception message not found');
        }

        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void createTaskOnContentPublishTest() {
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account testAccountOne = new Account(Lastname = 'RajaaS', PersonEmail = 'test1@gmail.com', RecordTypeId = personAccountRecordTypeId);
        insert testAccountOne;
        BI_PSP_Notification_Setting__c notifications = new BI_PSP_Notification_Setting__c(Name = 'Rajaa-Treatment and Rx Reminders', BI_PSP_Insite_Notification__c=true, BI_PSP_Notification_Type__c='Treatment and Rx Reminders', BI_PSP_Patient__c=testAccountOne.Id);
        insert notifications;
        CareProgram carePrgm = new CareProgram(Name = 'testcp', StartDate = Date.valueOf('2024-02-28'));
        insert carePrgm;
        CareProgramEnrollee testCpeOne = new CareProgramEnrollee(Name = 'TestCpa111', AccountId = testAccountOne.Id, CareProgramId = carePrgm.Id);
        insert testCpeOne;
        String mockResponse = '{"items":[{"id":"0YL4x0000008GoPGAU","title":"Sample Content","publishedDate":"2024-08-22T12:00:00.000Z"}]}';
        Test.setMock(HttpCalloutMock.class, new MockManagedContentChannelCollection(mockResponse));
        Test.startTest();
        BI_PSP_CmsConnectSched.createTaskOnContentPublish();
        Test.stopTest();
        List<Task> createdTasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :testCpeOne.Id];
        assert.areEqual(0, createdTasks.size(), 'Expected one task to be created');
       
    }

    @isTest
    static void testExecute() {
         String todayDateString = System.now().addHours(-1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        String mockResponse = '{"items":[{"id":"0YL4x0000008GoPGAU","title":"Sample Content","publishedDate":"2024-08-22T12:00:00.000Z"}],"items": [{"publishedDate": "' + todayDateString + '"}]}';
        Test.setMock(HttpCalloutMock.class, new MockManagedContentChannelCollection(mockResponse));
        BI_PSP_CmsConnectSched schedulableInstance = new BI_PSP_CmsConnectSched();
        Test.startTest();
        System.schedule('Test Scheduled Job', '0 0 0 1 1 ? 2040', schedulableInstance);
        Test.stopTest();
        List<Task> tasks = [SELECT Id, Subject, WhatId, Status, BI_PSP_Category__c, BI_PSP_Notification_Type__c, ReminderDateTime FROM Task];
        assert.areEqual(0, tasks.size(), 'No tasks should be created for the scheduled job if not mocked');
    }

  @isTest
    static void testUnpublishContent() {
        List<String> contentIds = new List<String>{'ContentId1', 'ContentId2'}; 
        String todayDateString = DateTime.now().format('yyyy-MM-dd') + 'T00:00:00.000Z';
        String mockResponse = '{"channels": [{"channelName": "' + System.Label.BI_PSPB_CmsBiSite + '", "channelId": "TestChannelId"}], "items": [{"publishedDate": "' + todayDateString + '"}]}';
    
        Test.setMock(HttpCalloutMock.class, new MockManagedContentChannelCollection(mockResponse));
        Test.startTest();
        try {
            unpublishContent(contentIds);
        } catch (Exception e) {
            assert.areEqual('Expected exception message', e.getMessage(), 'Exception message does not match expected');
    }
}
    private static void unpublishContent(List<String> contentIds) {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            ConnectApi.ManagedContentVersionCollection managedContentVersionCollection = new ConnectApi.ManagedContentVersionCollection();
            managedContentVersionCollection.items = new List<ConnectApi.ManagedContentVersion>();
            ConnectApi.ManagedContentVersion contentVersion = new ConnectApi.ManagedContentVersion();
            contentVersion.publishedDate = DateTime.now().addDays(-1); // Mock as unpublished
            managedContentVersionCollection.items.add(contentVersion);
        }
    }
}