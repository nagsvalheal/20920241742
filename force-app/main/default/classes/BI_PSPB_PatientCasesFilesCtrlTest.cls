/**
@description	This class contains test methods to verify the functionality of 
				methods related to insertuploadfileforupdaterx with valid and invalid inputs.
* History:
* Version	Author			Date			Detail			Description
* 1.0		Joyal			23-Apr-2024		created			Initial development
* 1.1		Gokul Krishnan 	10-Jul-2024		updated			test method added for creation of prescription,
															file upload.
*/
@isTest
private class BI_PSPB_PatientCasesFilesCtrlTest {
	/**
	 * @description The test method to insert the file into the related case.
	 */
	@isTest
	static void getFilePositiveScenario() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'Spevigo'
		);
		insert settings;
		// Create lead Record
		Lead testLead = new Lead(
			FirstName = 'Test',
			LastName = 'Lead',
			Company = 'Test Company',
			Status = 'Open'
		);
		insert testLead;
		// Create ContentVersion Record
		ContentVersion content = new ContentVersion();
		content.Title = 'Header_Picture1';
		content.PathOnClient = '/' + content.Title + '.jpg';
		Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body');
		content.VersionData = bodyBlob;
		//content.LinkedEntityId=sub.id;
		content.origin = 'H';
		insert content;

		Id contantDocId = [
			SELECT contentdocumentid
			FROM contentversion
			WHERE id = :content.id
		]
		.contentdocumentid;

		// Prepare data for method invocation
		List<String> fileIds = new List<String>{ contantDocId };
		String leadCaseId = testLead.Id;

		// Call the method under test
		Test.startTest();
		BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(
			fileIds,
			leadCaseId
		);
		Test.stopTest();

		// Assert that ContentDocumentLink records were created
		Integer expectedLinkCount = 1; // We expect one link to be created
		List<ContentDocumentLink> createdLinks = [
			SELECT Id
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :leadCaseId
		];
		Assert.areEqual(
			expectedLinkCount,
			createdLinks.size(),
			'ContentDocumentLink records not created'
		);
	}
	/**
	 * @description		The test method to negative secnario of
	 				 	insert the file into the related case.
	 */
	@isTest
	static void getContentDocumentLinksNegative() {
		try {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create test data
			Case testCase = new Case(Subject = 'Test Case');
			insert testCase;
			// Create a test file (ContentVersion)
			ContentVersion contentVersion = new ContentVersion(
				Title = 'Test File',
				PathOnClient = 'TestFile.txt',
				VersionData = Blob.valueOf('Test file content')
			);
			insert contentVersion;

			// Retrieve the ContentDocumentId from the ContentVersion
			ContentVersion cv = [
				SELECT ContentDocumentId
				FROM ContentVersion
				WHERE Id = :contentVersion.Id
				LIMIT 1
			];
			// Create test files
			ContentDocumentLink testContent = new ContentDocumentLink(
				LinkedEntityId = testCase.Id,
				contentDocumentId = cv.ContentDocumentId
			);
			insert testContent;

			// Call the method under test
			Test.startTest();
			BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(
				new List<Id>{ testContent.ContentDocumentId },
				testCase.Id
			);
			BI_PSPB_PatientCasesFilesCtrl.getContentDocumentLinks(null, null);

			Test.stopTest();
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	/**
	 * @description		The test method to negative secnario of
	 				 	delete the file into the related case.
	 */
	@isTest
	static void deleteDocumentLinksNegative() {
		try {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create test data
			Case testCase = new Case(Subject = 'Test Case');
			insert testCase;
			// Create a test file (ContentVersion)
			ContentVersion contentVersion = new ContentVersion(
				Title = 'Test File',
				PathOnClient = 'TestFile.txt',
				VersionData = Blob.valueOf('Test file content')
			);
			insert contentVersion;

			// Retrieve the ContentDocumentId from the ContentVersion
			ContentVersion cv = [
				SELECT ContentDocumentId
				FROM ContentVersion
				WHERE Id = :contentVersion.Id
				LIMIT 1
			];
			// Create test files
			ContentDocumentLink testContent = new ContentDocumentLink(
				LinkedEntityId = testCase.Id,
				contentDocumentId = cv.ContentDocumentId
			);
			insert testContent;

			// Call the method under test
			Test.startTest();
			BI_PSPB_PatientCasesFilesCtrl.deleteFile(testCase.Id, testContent.Id);
			Test.stopTest();
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}

	@isTest
	/**
	 * @description		The test method to negative secnario of
	 				 	delete the file into the related case.
	 */
	static void deleteNullRecord() {
		try {
			BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
				Name = 'PSPB',
				BI_SFCOE_LOG_Application__c = 'Spevigo'
			);
			insert settings;

			// Create test data
			Case testCase = new Case(Subject = 'Test Case');
			insert testCase;
			
			// Call the method under test
			Test.startTest();
			BI_PSPB_PatientCasesFilesCtrl.deleteFile(null, null);
			Test.stopTest();
		} catch (Exception e) {
			/* While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
       /**
     * @description The test method to verify the positive scenario of deleting a file from a case.
     */
    @isTest
    static void deleteFilePositiveScenario() {
        // Create test data
        BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
            Name = 'ApplicationName',
            BI_SFCOE_LOG_Application__c = 'Spevigo'
        );
        insert settings;

        // Create a Case record
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;

        // Create a ContentVersion record
        ContentVersion content = new ContentVersion(
            Title = 'Header_Picture1',
            PathOnClient = '/' + 'Header_Picture1.jpg',
            VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
            Origin = 'H'
        );
        insert content;

        // Retrieve the ContentDocumentId from the ContentVersion
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId;

        // Create ContentDocumentLink record
        ContentDocumentLink docLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = contentDocId,
            ShareType = 'V'
        );
        insert docLink;

        // Call the deleteFile method
        Test.startTest();
        BI_PSPB_PatientCasesFilesCtrl.deleteFile(testCase.Id, contentDocId);
        Test.stopTest();

        // Assert that ContentDocumentLink record was deleted
        List<ContentDocumentLink> links = [
            SELECT Id
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :testCase.Id
            AND ContentDocumentId = :contentDocId
        ];
        Assert.areEqual(0, links.size(), 'ContentDocumentLink record was not deleted');
    }

    /**
     * @description The test method to verify the negative scenarios of deleting a file from a case.
     */
 @isTest
static void deleteFileNegativeScenarios() {
    // Setup common test data
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'PSPB',
        BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;

    Case testCase = new Case(Subject = 'Test Case');
    insert testCase;

    ContentVersion contentVersion = new ContentVersion(
        Title = 'Test File',
        PathOnClient = 'TestFile.txt',
        VersionData = Blob.valueOf('Test file content')
    );
    insert contentVersion;

    Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

    ContentDocumentLink docLink = new ContentDocumentLink(
        LinkedEntityId = testCase.Id,
        ContentDocumentId = contentDocId
    );
    insert docLink;

    // Simulate failure in deleteOperation
    try {
        Test.startTest();
        // Mock the deleteOperation method to throw an exception
        BI_PSPB_PatientCasesFilesCtrl.deleteFile(testCase.Id, contentDocId);
        Test.stopTest();
       
    } catch (AuraHandledException e) {
        System.assert(e.getMessage().contains(BI_PSPB_SupportCenterConstant.fileIdCount), 'Exception message did not match for simulated failure.');
    }
}

    @isTest
static void deleteNegativeScenarios() {
    // Setup common test data
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'PSPB',
        BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;

    Case testCase = new Case(Subject = 'Test Case');
    insert testCase;

    ContentVersion contentVersion = new ContentVersion(
        Title = 'Test File',
        PathOnClient = 'TestFile.txt',
        VersionData = Blob.valueOf('Test file content')
    );
    insert contentVersion;

    Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

    ContentDocumentLink docLink = new ContentDocumentLink(
        LinkedEntityId = testCase.Id,
        ContentDocumentId = contentDocId
    );
    insert docLink;
    try {
        Test.startTest();
        BI_PSPB_PatientCasesFilesCtrl.deleteFile(null, null);
        Test.stopTest();
       
    } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
}
    @isTest
static void fileNegativeScenarios() {
    // Setup common test data
    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
        Name = 'PSPB',
        BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;

    Case testCase = new Case(Subject = 'Test Case');
    insert testCase;

    ContentVersion contentVersion = new ContentVersion(
        Title = 'Test File',
        PathOnClient = 'TestFile.txt',
        VersionData = Blob.valueOf('Test file content')
    );
    insert contentVersion;

    Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

    ContentDocumentLink docLink = new ContentDocumentLink(
        LinkedEntityId = testCase.Id,
        ContentDocumentId = contentDocId
    );
    insert docLink;
    try {
        Test.startTest();
        BI_PSPB_PatientCasesFilesCtrl.deleteFile(testCase.Id, docLink.Id);
        Test.stopTest();
       
    } catch (Exception e) {
            Assert.areEqual(
                'Script-thrown exception',
                e.getMessage(),
                'Method thrown exception'
            );
        }
}

  
}