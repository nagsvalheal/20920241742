@IsTest
/**
* @description This class contains test methods to verify the behaviour of
creating tasks for all types.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskServiceCtrlTest {    
    @IsTest
    static void testCreateTask() {
        Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
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
        BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(7),
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Status__c = 'Active',
            BI_PSPB_Reminder_Type__c = 'Prescription'
        );
        insert reminder;
        BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(10), 
            BI_PSPB_Reminder_Date__c = Date.today(), 
            BI_PSPB_Status__c = 'Active', 
            BI_PSPB_Reminder_Type__c = 'Prescription'
        );
        insert reminder1;
        BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(10), 
            BI_PSPB_Reminder_Date__c = Date.today(), 
            BI_PSPB_Status__c = 'Active', 
            BI_PSPB_Reminder_Type__c = 'Prescription'
        );
        insert reminder2;
        BI_PSPB_Treatment_Reminder__c reminder3 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(3), 
            BI_PSPB_Reminder_Date__c = Date.today(), 
            BI_PSPB_Status__c = 'Active', 
            BI_PSPB_Reminder_Type__c = 'Treatment'
        );
        insert reminder3;
        BI_PSPB_Treatment_Reminder__c reminder4 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1), 
            BI_PSPB_Reminder_Date__c = Date.today(), 
            BI_PSPB_Status__c = 'Active', 
            BI_PSPB_Reminder_Type__c = 'Treatment'
        );
        insert reminder4;
        String formattedDate;
		Datetime treatmentDate;
        treatmentDate = reminder4.BI_PSPB_Date_of_Treatment__c;
		formattedDate = treatmentDate.format('MM/dd/yyyy');
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before7Day = 7;
        daysCount.before10Day = 10;
        daysCount.before14Day = 14;
        daysCount.before1Day = 1;
        daysCount.before3Day = 3;
        Task createdTask = BI_PSPB_TaskServiceCtrl.createTask(reminder4, 1, daysCount);
        Task createdTask1 = BI_PSPB_TaskServiceCtrl.createTask(reminder, 3, daysCount);
        Task createdTask2 = BI_PSPB_TaskServiceCtrl.createTask(reminder, 10, daysCount);
        Assert.areNotEqual(null, createdTask, 'Task should be created.');
        Assert.areNotEqual(null, createdTask1, 'Task should be created.');
        Assert.areNotEqual(null, createdTask2, 'Task should be created.');
        Assert.areEqual(BI_PSPB_NotificationConstant.oneDayBeforeSubject +
				' ' +
				formattedDate,
                           createdTask.Subject, 'Subject should match the one day before subject.');
        }
    @IsTest
    static void testCreateTaskWithException() {
        BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = null,
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(7), 
            BI_PSPB_Reminder_Date__c = Date.today(), 
            BI_PSPB_Status__c = 'Active', 
            BI_PSPB_Reminder_Type__c = 'Treatment'
        );
        insert reminder;
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before7Day = 7; 
        try{
        Test.startTest();
        BI_PSPB_TaskServiceCtrl.createTask(reminder, 7, daysCount);
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
}