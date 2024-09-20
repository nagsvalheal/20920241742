@isTest
public class BI_PSPB_EmailStatusBatchSchedTest {
	//Mock class for simulating an HTTP response with a status code of 200.
	private class MockHttpResponse implements HttpCalloutMock {
		/**
		 * @description Responds to an HTTP request with a mock HTTP response.
		 * @param req The HTTP request.
		 * @return The mock HTTP response.
		 */
		public HTTPResponse respond(HTTPRequest req) {
			// Create a new HTTPResponse object
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			String responseBody = '{"status": "success", "access_token": "mock_access_token"}';
			res.setBody(responseBody);
			res.setStatusCode(200);
			return res;
		}
	}

	/**
	 * @description Mock class for simulating an HTTP response with a status code other than 200.
	 */
	public class MockNot200HttpResponse implements HttpCalloutMock {
		/**
		 * @description Responds to an HTTP request with a mock HTTP response.
		 *
		 * @param req The HTTP request.
		 * @return The mock HTTP response.
		 */
		public HTTPResponse respond(HTTPRequest req) {
			// Create a new HTTPResponse object
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"status": "failed"}');
			// Set the desired status code in the response
			res.setStatusCode(400);
			// Set the response body
			res.setBody('{"access_token": "mock_access_token"}');
			// Return the response
			return res;
		}
	}
	// Test method to verify positive scenario of the method for making a callout.This test ensures that the method behaves correctly when making a callout with a valid access token.
	@isTest
	static void testPositiveScenario() {
		// Create mock BI_SFCOE_LOG_App_Settings__c record
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
			BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
			BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
			BI_PSPB_Status__c = 'queued',
			BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
		);
		insert omni11;

		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		Test.startTest();
		// Start the batch job
		BI_PSPB_EmailStatusBatchSched batchJob = new BI_PSPB_EmailStatusBatchSched();
		Database.executeBatch(batchJob);
		Test.stopTest();
		Integer expectedRecordCount = 1;
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
	static void testNegativeScenario() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
			BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
			BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
			BI_PSPB_Status__c = 'queued',
			BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
		);
		insert omni11;

		Test.setMock(HttpCalloutMock.class, new MockNot200HttpResponse());
		try {
			Test.startTest();
			// Start the batch job
			BI_PSPB_EmailStatusBatchSched batchJob = new BI_PSPB_EmailStatusBatchSched();
			Database.executeBatch(batchJob);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	// Test method to verify behavior when making a callout with incorrect status.This test ensures that the method handles the scenario where an access token is missing properly.

	@isTest
	static void testnegScenariocatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;

		BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
			BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQw',
			BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPT',
			BI_PSPB_Status__c = 'Yes',
			BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
		);
		insert omni11;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		try {
			Test.startTest();
			// Start the batch job
			BI_PSPB_EmailStatusBatchSched batchJob = new BI_PSPB_EmailStatusBatchSched();
			Database.executeBatch(batchJob);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	// Test method to verify behavior when passing logIds list as empty list.This test ensures that the method handles the scenario where an access token is missing properly.

	@isTest
	static void testupdateEmailLogsreturncatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String emailBodyrespose = 'success';
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        List<Id> logIds=new List<Id>();
		Test.startTest();
		try {
			BI_PSPB_EmailStatusBatchSched.updateEmailLogs(logIds, emailBodyrespose);

			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

    // Test method to verify behavior when passing BI_PSPB_OmnichannelLog__c as null.This test ensures that the method handles the scenario where an access token is missing properly.

	@isTest
	static void testupdateEmailLogsreturncatchnull() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;

		String emailBodyrespose = 'success';
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
		Test.startTest();
		try {
			BI_PSPB_EmailStatusBatchSched.updateEmailLogs(null, emailBodyrespose);

			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	// Test method to verify behavior when passing emailBodyrespose as null.This test ensures that the method handles the scenario where an access token is missing properly.

	@isTest
	static void testupdateEmailLogscatch() {
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Id> emailLogIds = new List<Id>();
		BI_PSPB_OmnichannelLog__c omni11 = new BI_PSPB_OmnichannelLog__c(
			BI_PSPB_EmailMessageId__c = '4ANanCrLTNC_nUhzcH0xQx',
			BI_PSPB_GetAccessTokenResponse__c = 'ylt4ybqI5g2rDm1pIoi7ji6myAJxzVxvVlAQg0FAadFXQsLSjeEXPu',
			BI_PSPB_Status__c = BI_PSPB_NotificationConstant.queued,
			BI_PSPB_Body__c = '<Username> just shared a new post! Check it out View Post'
		);
		insert omni11;

		emailLogIds.add(omni11.Id);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		Test.startTest();
		try {
			BI_PSPB_EmailStatusBatchSched.updateEmailLogs(
				new List<Id>{ omni11.Id },
				null
			);

			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}

	// Utility method to create and return a metadata record for testing purposes.

	@isTest
	private static BI_PSPB_GetMethodOmnichannel__mdt getmeta() {
		BI_PSPB_GetMethodOmnichannel__mdt metaa = new BI_PSPB_GetMethodOmnichannel__mdt(
			DeveloperName = 'BI_PSPB_EmailGetmethod',
			BI_PSPB_EndPoint__c = 'Test End Point',
			BI_PSPB_Country__c = 'Test',
			BI_PSPB_omnichannelentapi__c = 'test api'
		);
		// Assert that the returned metadata instance is not null
		Assert.areNotEqual(null, metaa, 'Metadata instance should not be null');
		return metaa;
	}

	//This test method ensures that the scheduled batch job executes successfully within the test context

	@isTest
	static void testExecute() {
		Test.startTest();

		// Schedule the batch job
		String jobId = System.schedule(
			'Test Batch Job',
			'0 0 0 * * ?',
			new BI_PSPB_EmailStatusBatchSched()
		);

		// Ensure that the batch job is scheduled
		Assert.areNotEqual(null, jobId, 'batch job is scheduled');

		Test.stopTest();
	}
}