@IsTest
public class BI_PSPB_TreatmentNotificationCtrlTest {
    @IsTest
    static void testProcessReminders() {
                Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
            BI_PSP_Birthdate__c = Date.today(),
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
        BI_PSPB_Treatment_Reminder__c testReminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Date_of_Treatment__c = Date.today(),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = BI_PSPB_NotificationConstant.actionTypeTreatment
        );
        insert testReminder;
        Test.startTest();
            BI_PSPB_TreatmentNotificationCtrl.processReminders();
        Test.stopTest();    
        List<BI_PSPB_Treatment_Reminder__c> reminders = [
            SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Reminder_Date__c, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Status__c, BI_PSPB_Reminder_Type__c
            FROM BI_PSPB_Treatment_Reminder__c
            WHERE Id = :testReminder.Id
        ];
        BI_PSPB_Treatment_Reminder__c processedReminder = reminders[0]; 
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeActive, processedReminder.BI_PSPB_Status__c, 'The reminder status should be active.');
        Assert.areEqual(BI_PSPB_NotificationConstant.actionTypeTreatment, processedReminder.BI_PSPB_Reminder_Type__c, 'The reminder type should be treatment.');  
    }
    @IsTest
    static void testProcessRemindersNoReminders() {
        delete [SELECT Id FROM BI_PSPB_Treatment_Reminder__c];
        Test.startTest();
        try{
            BI_PSPB_TreatmentNotificationCtrl.processReminders();
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
        Test.stopTest();
	}
}