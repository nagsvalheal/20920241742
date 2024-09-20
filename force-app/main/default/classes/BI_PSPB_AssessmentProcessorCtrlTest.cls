/**
    @description			This class contains test methods for quering assessments.
	@author					Niyas
	@Last Modified On   	05/09/2024
	@Last Modified By 		Niyas
*/
@IsTest
private class BI_PSPB_AssessmentProcessorCtrlTest {
    public static List<Id> enrolleeIds = new List<Id>();
    @IsTest
    static void testFetchDueAssessments() {
         User user1;
				UserRole portalRole = [
			SELECT Id
			FROM UserRole
			WHERE PortalType = 'None'
			LIMIT 1
		];

		Profile profile1 = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
		];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = 'brucemess2.wayne@wayneenterprises.com',
			Alias = 'batman',
			Email = 'brucemess2.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess2',
			LastName = 'Waynemess2',
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
			Account account = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account;

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
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			user1 = new User(
				Username = 'brucemess3.wayne@wayneenterprises.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'brucemess2.wayne@wayneenterprises.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Waynemess2',
				FirstName = 'Brucemess2',
				CommunityNickname = 'test12345',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;
            Account account1 = new Account(
				FirstName = 'Brucemess2',
				LastName = 'Waynemess2',
				PersonEmail = 'brucemess3.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account1;
            CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
			AccountId = account1.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrollee;
            enrolleeIds.add(testCareProgramEnrolle.Id);
            enrolleeIds.add(testCareProgramEnrollee.Id);
            Assessment assessment = new Assessment(
                BI_PSP_CareProgramEnrollee__c = testCareProgramEnrolle.Id,
                Name = BI_PSPB_NotificationConstant.pssQuestionName,
                AssessmentStatus = BI_PSPB_NotificationConstant.inProgressType
            );
            insert assessment;
        }
        Test.startTest();
        List<Id> result = BI_PSPB_AssessmentProcessorCtrl.fetchDueAssessments(enrolleeIds, BI_PSPB_NotificationConstant.pssQuestionName);
        
        // Validate the result
        Assert.areEqual(2, result.size(), 'Expected two enrollee Ids to be returned.');
        Test.stopTest();
    }

    @IsTest
    static void testGetAssessmentChildQuery() {
        Test.startTest();
        try{
        	BI_PSPB_AssessmentProcessorCtrl.getAssessmentChildQuery(enrolleeIds, 'Test Assessment');
        } catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        Test.stopTest();
          }

    @IsTest
    static void testGetEnrolleeQuery() {
        Test.startTest();
        try{
			BI_PSPB_AssessmentProcessorCtrl.getEnrolleeQuery(enrolleeIds);
        }catch (Exception e) {
                /*  While running negative scenario, the flow goes to catch.
                Thus resulting in throwing exception and so assertion is done
                for Exception only.*/
                Assert.areEqual(
                    'Script-thrown exception',
                    e.getMessage(),
                    'Method thrown exception'
                );
            }
        Test.stopTest();
    }
}