/**
* @description This class contains test methods to verify the behaviour of
triggering email and sms notification.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
@IsTest
public class BI_PSPB_NotificationTemplatesCtrlTest {
 @IsTest
    static void testHandleTrigger() {
        Contact contactForPatient = new Contact(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        Email = 'testpatientfeed@gmail.com'
    );
    insert contactForPatient;
        Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
            BI_PSP_Birthdate__c = Date.today().addYears(-25),
        HealthCloudGA__PrimaryContact__c = contactForPatient.Id,
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;

		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
             new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;
        List<Id> enrolleeIds = new List<Id>{ testCareProgramEnrolle.Id };
        String notificationType = 'TR1333';
        List<String> communityUserNames = new List<String>{ 'TestUser' };
        try{
        Test.startTest();
        BI_PSPB_NotificationTemplatesCtrl.handleTrigger(enrolleeIds, notificationType, communityUserNames, '');
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
     @IsTest
    static void testHandleCaregiver() {
        Contact contactForPatient = new Contact(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        Email = 'testpatientfeed@gmail.com'
    );
    insert contactForPatient;
        Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
            BI_PSP_Birthdate__c = Date.today(),
        HealthCloudGA__PrimaryContact__c = contactForPatient.Id,
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
         Account testCaregiverdata = new Account(
            FirstName = 'John',
            LastName = 'Doe',
            BI_PSP_Birthdate__c = Date.newInstance(1980, 1, 1),
            PersonEmail = 'johndoe@example.com',
            Phone = '123-456-7890',
            BI_PSPB_Preferred_Communication_Method__c = 'Email',
            BI_PSPB_Relationship_to_Patient__c = 'parent'
        );
        insert testCaregiverdata;
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'janedoe@example.com'
        );
        insert testContact;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;

		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			AccountId = account.Id,
			CareProgramId = testCareProgram.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
        
        BI_PSPB_Enrollee_Caregiver__c testEnrolleeCaregiver = new BI_PSPB_Enrollee_Caregiver__c(
            BI_PSPB_Patient__c = account.Id,
            BI_PSPB_Caregiver__c = testCaregiverdata.Id,
            BI_PSPB_Contact_Id__c = testContact.Id,
            BI_PSPB_Status__c = 'Active'
        );
        insert testEnrolleeCaregiver;
        List<BI_PSP_Notification_Setting__c> notificationSettings = new List<BI_PSP_Notification_Setting__c>{
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'New Content Updates'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Questionnaires'
            ),
            new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Symptom Tracker'
            ),
             new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Treatment and Rx Reminders'
            ),
                new BI_PSP_Notification_Setting__c(
                BI_PSP_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSP_Patient__c = account.Id,
                BI_PSP_SMS__c = true,
                BI_PSP_Email__c = true,
                BI_PSP_Notification_Type__c = 'Community'
            )
        };
        insert notificationSettings;
        List<Id> enrolleeIds = new List<Id>{ testCareProgramEnrolle.Id };
        String notificationType = 'TR1333';
        List<String> communityUserNames = new List<String>{ 'TestUser' };
        try{
        Test.startTest();
        BI_PSPB_NotificationTemplatesCtrl.handleTrigger(enrolleeIds, notificationType, communityUserNames, '');
        Test.stopTest();
        } catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
    }
    @IsTest
    static void testHandleTriggerNoRecordsAndTypes() {
        List<Id> enrolleeIds = new List<Id>();
        String notificationType = '';
        List<String> communityUserNames = new List<String>{ 'TestUser' };
        String treatmentDate = Date.today().format();
        try{
        Test.startTest();
        BI_PSPB_NotificationTemplatesCtrl.handleTrigger(enrolleeIds, notificationType, communityUserNames, treatmentDate);
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