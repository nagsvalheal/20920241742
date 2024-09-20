@isTest
public class BI_PSPB_CaregiverOnboardingCtrlTest {    
    @isTest
	static void testCreateCaregiverRecord() {
		Account testAccount = new Account(
			FirstName = 'TestFirst',
			LastName = 'TestLast',
			BI_PSP_Birthdate__c = Date.today(),
			PersonEmail = 'test@example.com'
		);
		insert testAccount;
		CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
		insert testCP;
		// Create a new CareProgramEnrollee record for testing
		CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
			Name = 'testenrolee',
			AccountId = testAccount.id,
			CareProgramId = testCP.Id
		);
		insert testEnrollee;

		// Create test data
		BI_PSPB_CaregiverOnboardingCtrl.DataWrapper testData = new BI_PSPB_CaregiverOnboardingCtrl.DataWrapper();
		testData.firstName = 'John';
		testData.lastName = 'Doe';
		testData.relation = 'Parent';
		testData.email = 'john.doe@example.com';
		testData.dob = '1990-01-01';
		testData.phone = '1234567890';
		testData.caregiverId = testEnrollee.Id; // Use the testEnrollee's Id

		Test.startTest();
		// Call the method to be tested
		Id caregiverId = BI_PSPB_CaregiverOnboardingCtrl.createCaregiverRecord(
			testData
		);
		Test.stopTest();

		// Verify that the BI_PSPB_Enrollee_Caregiver__c record is created
		BI_PSPB_Enrollee_Caregiver__c createdCaregiverRelation = [
			SELECT
				Id,
				Name,
				BI_PSPB_Care_Program_Enrollee__c,
				BI_PSPB_Patient__c,
				BI_PSPB_Contact_Id__c
			FROM BI_PSPB_Enrollee_Caregiver__c
			WHERE BI_PSPB_Contact_Id__c = :caregiverId
		];

		// Assert that the BI_PSPB_Enrollee_Caregiver__c record has been created with the correct values
		Assert.areEqual(
			'John',
			createdCaregiverRelation.Name,
			'Name should match'
		);
		Assert.areEqual(
			testEnrollee.Id,
			createdCaregiverRelation.BI_PSPB_Care_Program_Enrollee__c,
			'Careprogram Id should match'
		);
		// Add more assertions as needed
	}

    
    @isTest
	static void catchcreateCaregiverRecord() {
		//user with patient
		User testUser = new User(
			Email = 'testusernew@example.com',
			BI_PSPB_Caregiver__c = true,
			Username = 'testusernew@example.com',
			FirstName = 'Test',
			LastName = 'User',
			Alias = 'tesn',
			TimeZoneSidKey = 'America/New_York',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = UserInfo.getProfileId(),
			LanguageLocaleKey = 'en_US'
		);
		insert testUser;
		Contact con = new Contact(
			FirstName = 'TestFirstName',
			LastName = 'TestLastName',
			Phone = '1234567890',
			BI_PSP_Birthdate__c = Date.newInstance(1990, 1, 1),
			Email = 'test@example.com',
			BI_PSPB_Relationship_To_Patient__c = 'Friend'
		);
		insert con;
		BI_PSPB_CaregiverOnboardingCtrl.DataWrapper wrapper = new BI_PSPB_CaregiverOnboardingCtrl.DataWrapper();
		System.runAs(testUser) {
			try {
				Test.startTest();
				BI_PSPB_CaregiverOnboardingCtrl.createCaregiverRecord(wrapper);
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
    
    @isTest
    static void testCreateCaregiverRecords() {
        try{
        Test.startTest();
        Id caregiverId = BI_PSPB_CaregiverOnboardingCtrl.createCaregiverRecord(null);
        Test.stopTest();

        System.assertEquals(null, caregiverId, 'Method should return null if wrapper is null');
        }catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    
      @isTest
    static void testCreateCaregiverRecordsWrapper() {
        // Prepare DataWrapper with a non-existing CareProgramEnrollee Id
        BI_PSPB_CaregiverOnboardingCtrl.DataWrapper wrapper = new BI_PSPB_CaregiverOnboardingCtrl.DataWrapper();
        wrapper.firstName = 'Jane';
        wrapper.lastName = 'Doe';
        wrapper.email = 'jane.doe@example.com';
        wrapper.phone = '123-456-7890';
        wrapper.dob = '1980-01-01';
        wrapper.relation = 'Spouse';
        wrapper.caregiverId = 'nonExistentId'; // Use a non-existing Id
        try{
        Test.startTest();
        // Call the method to be tested
        Id caregiverId = BI_PSPB_CaregiverOnboardingCtrl.createCaregiverRecord(wrapper);
        Test.stopTest();
	 	System.assertEquals(null, caregiverId, 'Caregiver Id should be null if no enrollee is found');
        } catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
        
    }

}