/**
    @description			This class contains test methods for quering caregiver.
	@author					Niyas
	@Last Modified On   	05/09/2024
	@Last Modified By 		Niyas
*/
@IsTest
public class BI_PSPB_CaregiverProcessorCtrlTest {
	@IsTest
	static void testFetchCaregiverId() {
        CareProgramEnrollee testCareProgramEnrolle;
        BI_PSPB_Enrollee_Caregiver__c caregiver;
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
		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;
		caregiver = new BI_PSPB_Enrollee_Caregiver__c(
				BI_PSPB_Caregiver__c = account.Id,
            	BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            	BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive);
            insert caregiver;
        }
		Test.startTest();
		Id caregiverId = BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(
			testCareProgramEnrolle.Id
		);
		Assert.areEqual( caregiver.BI_PSPB_Caregiver__r.Id , caregiverId , 'Id of the caregiver');
		Test.stopTest();
    }
    @IsTest
	static void testFetchCaregiverIdNoCaregiver() {
        CareProgramEnrollee testCareProgramEnrolle;
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
		testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
            OwnerId = user1.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed'
		);
		insert testCareProgramEnrolle;
        }
		Test.startTest();
        try{
			BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(
			testCareProgramEnrolle.Id
		);
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
	static void testFetchCaregiverIdNull() {
		Test.startTest();
    	 try{
			BI_PSPB_CaregiverProcessorCtrl.fetchCaregiverId(
			null
		);
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
}