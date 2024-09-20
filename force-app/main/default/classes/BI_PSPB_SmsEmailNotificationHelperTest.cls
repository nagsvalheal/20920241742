@isTest
/**
* @description This class contains test methods to verify the behaviour of
triggering email and sms notification with the respective url and names.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_SmsEmailNotificationHelperTest {
  @isTest
    static void testGetNotificationDetails() {
        Test.startTest();
        List<String> communityUserName = new List<String>{'User1', 'User2'};
        String notificationTypes = BI_PSPB_NotificationConstant.generalSymptomTracker;
        BI_PSPB_SmsAndEmailNotificationCtrl result = BI_PSPB_SmsEmailNotificationHelper.getNotificationDetails(notificationTypes, communityUserName, null);
        Assert.areNotEqual(null, result,'Result should not be null');
        Assert.areEqual(BI_PSPB_NotificationConstant.generalSymptomSms, result.subject, 'Subject should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.generalSymptomEmail, result.emailSubject, 'Email subject should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.urlSymptomTracker, result.urlPage, 'URL page should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeSymptomTracker, result.notificationType, 'Notification type should match');
        Assert.areEqual(communityUserName, result.followName, 'Username should match');
        Test.stopTest();
    }
     @isTest
    static void testGetNotificationCaregiverDetails() {
        Test.startTest();
        List<String> communityUserName = new List<String>{'User1', 'User2'};
        List<String> patientName = new List<String>{'patientName1'};
        String notificationTypes = BI_PSPB_NotificationConstant.generalSymptomTracker;
        BI_PSPB_SmsAndEmailNotificationCtrl result = BI_PSPB_SmsEmailNotificationHelper.getCaregiverNotificationDetails(notificationTypes, communityUserName, null, patientName);
        Assert.areNotEqual(null, result,'Result should not be null');
        /*Assert.areEqual(BI_PSPB_NotificationConstant.generalSymptomSms, result.subject, 'Subject should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.generalSymptomEmail, result.emailSubject, 'Email subject should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.urlSymptomTracker, result.urlPage, 'URL page should match');
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeSymptomTracker, result.notificationType, 'Notification type should match');
        Assert.areEqual(communityUserName, result.followName, 'Username should match');*/
        Test.stopTest();
    }
    @isTest
    static void testAddContactsToSend() {
    Contact contactForPatient = new Contact(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        Email = 'testpatientfeed@gmail.com'
    );
    insert contactForPatient;
    List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee>();
    List<Id> emailList = new List<Id>();
    List<Id> smsList = new List<Id>();
    emailList.add(contactForPatient.Id);
    smsList.add(contactForPatient.Id);
    Account account = new Account(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        PersonEmail = 'testpatientfeed@gmail.com',
        BI_PSP_Birthdate__c = Date.today().addYears(-25),
        HealthCloudGA__PrimaryContact__c = contactForPatient.Id,
        RecordTypeId = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
        ].Id,
        Phone = '123456'
    );
    insert account;
    account = [
        SELECT Id, BI_PSP_Birthdate__c, PersonContactId
        FROM Account
        WHERE Id = :account.Id
    ];
    CareProgram testCareProgram = new CareProgram(
        Name = 'Test Care Program',
        StartDate = Date.today()
    );
    insert testCareProgram;
    CareProgramEnrollee enrollee = new CareProgramEnrollee(
        AccountId = account.Id,
        CareProgramId = testCareProgram.Id,
        BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
        Name = 'TestPatientFeed PatientLastName'
    );
    insert enrollee;
    enrollee = [
        SELECT Id, Account.BI_PSP_Birthdate__c, Account.PersonContactId
        FROM CareProgramEnrollee
        WHERE Id = :enrollee.Id
    ];
    enrollees.add(enrollee);
        BI_PSP_Notification_Setting__c notificationSetting = new BI_PSP_Notification_Setting__c(
        BI_PSP_Email__c = true,
        BI_PSP_SMS__c = true,
        BI_PSP_Enrollee__c = enrollee.id
    );
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>{
        enrollee.id => new List<BI_PSP_Notification_Setting__c>{notificationSetting}
    };
    Test.startTest();
    BI_PSPB_SmsEmailNotificationHelper.addContactsToSend(accountToNotificationsMap, enrollees, emailList, smsList);
    Test.stopTest();
    Assert.areNotEqual(null, enrollee.Account.PersonContactId, 'PersonContactId should not be null');
	}
    @isTest
    static void testGetNotificationUrl() {
        Test.startTest();
        BI_PSPB_SmsAndEmailNotificationCtrl notificationDetails = new BI_PSPB_SmsAndEmailNotificationCtrl(
            'Test Subject',
            'Test Email Subject',
            'TestPage',
            'Test Notification Type',
            new List<String>{'User1', 'User2'}
        );
        String result = BI_PSPB_SmsEmailNotificationHelper.getNotificationUrl(notificationDetails);
        Test.stopTest();
        BI_PSPB_Notification__mdt filteredNotifications = BI_PSPB_Notification__mdt.getInstance(
		BI_PSPB_NotificationConstant.siteUrl
        );
        String bDestUrl = filteredNotifications.BI_PSPB_BrandedUrl__c + 'TestPage';
        Assert.areEqual(bDestUrl, result, 'The result URL should match the expected page URL');
    }
    @isTest
    static void testThrowException() {
    Contact contactForPatient = new Contact(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        Email = 'testpatientfeed@gmail.com'
    );
    insert contactForPatient;
    List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee>();
    List<Id> emailList = new List<Id>();
    List<Id> smsList = new List<Id>();
    emailList.add(contactForPatient.Id);
    smsList.add(contactForPatient.Id);
    Account account = new Account(
        FirstName = 'TestPatientFeed',
        LastName = 'PatientLastName',
        PersonEmail = 'testpatientfeed@gmail.com',
        BI_PSP_Birthdate__c = Date.today().addYears(-25),
        HealthCloudGA__PrimaryContact__c = contactForPatient.Id,
        RecordTypeId = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
        ].Id,
        Phone = '123456'
    );
    insert account;
    account = [
        SELECT Id, BI_PSP_Birthdate__c, PersonContactId
        FROM Account
        WHERE Id = :account.Id
    ];
    CareProgram testCareProgram = new CareProgram(
        Name = 'Test Care Program',
        StartDate = Date.today()
    );
    insert testCareProgram;
    CareProgramEnrollee enrollee = new CareProgramEnrollee(
        AccountId = account.Id,
        CareProgramId = testCareProgram.Id,
        BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
        Name = 'TestPatientFeed PatientLastName'
    );
    insert enrollee;
    enrollee = [
        SELECT Id, Account.BI_PSP_Birthdate__c, Account.PersonContactId
        FROM CareProgramEnrollee
        WHERE Id = :enrollee.Id
    ];
    enrollees.add(enrollee);
    Map<Id, List<BI_PSP_Notification_Setting__c>> accountToNotificationsMap = new Map<Id, List<BI_PSP_Notification_Setting__c>>{};
    Test.startTest();
    try{
        BI_PSPB_SmsEmailNotificationHelper.addContactsToSend(accountToNotificationsMap, enrollees, emailList, smsList);
    } catch (Exception e) {
        Assert.areEqual(
            'Script-thrown exception',
            e.getMessage(),
            'Method thrown exception'
        );
    }
    Test.stopTest();
    }
}