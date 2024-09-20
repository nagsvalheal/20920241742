@isTest
public class BI_PSPB_PastDueTaskSubjectCtrlTest {
    @isTest
	static void testHandleTasks() {
        try {
			Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community2', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccount;
			Account testAccountPatient = new Account(Name = 'Test Account1', BI_PSP_CommunityUsername__c = 'Test Community3', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccountPatient;
			Account testAccountCaregiver = new Account(Name = 'Test Account2', BI_PSP_CommunityUsername__c = 'Test Community4', BI_PSP_Birthdate__c = Date.today().addYears(-25) );
			insert testAccountCaregiver;
			CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
			insert testCareProgram;
			List<CareProgramEnrollee> testEnrollees = new List<CareProgramEnrollee>{
					new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-1)),
					new CareProgramEnrollee(AccountId = testAccountPatient.Id, Name = 'Test Enrollee1', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-3)),
					new CareProgramEnrollee(AccountId = testAccountCaregiver.Id, Name = 'Test Enrollee2', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-5))
			};
			insert testEnrollees;
			List<BI_PSPB_Treatment_Reminder__c> testReminders = new List<BI_PSPB_Treatment_Reminder__c>{
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-1), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-1),BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[1].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-3), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-3),BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
					new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[2].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-5), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-5), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
					BI_PSPB_Reminder_Type__c = 'Date of Treatment')
			};
			insert testReminders;
            List<Task> tasks = new List<Task>{
            new Task(Subject = 'Task 1', WhatId = [SELECT Id FROM BI_PSPB_Treatment_Reminder__c LIMIT 1].Id),
            new Task(Subject = 'Task 2', WhatId = [SELECT Id FROM BI_PSPB_Treatment_Reminder__c LIMIT 1].Id)
        };

        Test.startTest();
        BI_PSPB_PastDueTaskSubjectCtrl.handleTasks(tasks);
        Test.stopTest();

        // Verify that the tasks were inserted
        Assert.areEqual(2, [SELECT COUNT() FROM Task WHERE Subject IN ('Task 1', 'Task 2')],'Count of task is 2');
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
    }
     @isTest
    static void testHandleTasksWithEmptyList() {
        Test.startTest();
        BI_PSPB_PastDueTaskSubjectCtrl.handleTasks(new List<Task>());
        Test.stopTest();

        // Verify that no tasks were inserted
        Assert.areEqual(0, [SELECT COUNT() FROM Task],'Count of task is 0');
    }
@isTest
static void testCreatePatientTaskIfEligible() {
    // Creating test accounts
    Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community2', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccount;
    Account testAccountPatient = new Account(Name = 'Test Account1', BI_PSP_CommunityUsername__c = 'Test Community3', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccountPatient;
    Account testAccountCaregiver = new Account(Name = 'Test Account2', BI_PSP_CommunityUsername__c = 'Test Community4', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccountCaregiver;

    // Creating a Care Program
    CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
    insert testCareProgram;

    // Creating Care Program Enrollees
    List<CareProgramEnrollee> testEnrollees = new List<CareProgramEnrollee>{
        new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-1)),
        new CareProgramEnrollee(AccountId = testAccountPatient.Id, Name = 'Test Enrollee1', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-3)),
        new CareProgramEnrollee(AccountId = testAccountCaregiver.Id, Name = 'Test Enrollee2', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-5))
    };
    insert testEnrollees;

    // Creating Treatment Reminders
    List<BI_PSPB_Treatment_Reminder__c> testReminders = new List<BI_PSPB_Treatment_Reminder__c>{
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(1), BI_PSPB_Date_of_Treatment__c = System.today().addDays(1), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[1].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-3), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-3), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[2].Id, BI_PSPB_Reminder_Date__c = System.today(), BI_PSPB_Date_of_Treatment__c = System.today(), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment')
    };
    insert testReminders;

    // Creating BI_PSPB_TaskCreationParams object with the necessary constructor
    BI_PSPB_TaskCreationParams params = new BI_PSPB_TaskCreationParams(
        [SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Date_of_Treatment__c FROM BI_PSPB_Treatment_Reminder__c LIMIT 1],
        new BI_PSPB_TreatmentReminderDaysCtrl(/* initialize with correct parameters */)
    );

    // Accessing the enrollee ID correctly from the testReminders

   List<Id> enrolleeIds = new List<Id>{testReminders[0].BI_PSPB_Care_Program_Enrollee__c};
       String formattedDate;
			Datetime treatmentDate;
    treatmentDate = testReminders[0].BI_PSPB_Date_of_Treatment__c;
				formattedDate = treatmentDate.format('MM/dd/yyyy');
    // Creating BI_PSPB_TreatmentPatientTaskCtrl object with the correct constructor
    BI_PSPB_TreatmentPatientTaskCtrl patientParams = new BI_PSPB_TreatmentPatientTaskCtrl(
            enrolleeIds,
            enrolleeIds,
            enrolleeIds,
            'Patient',
            null
            );

    // Test execution
    Test.startTest();
    Task task = BI_PSPB_PastDueTaskSubjectCtrl.createPatientTask(Date.today().addDays(-1), params, patientParams);
    BI_PSPB_PastDueTaskSubjectCtrl.createPatientTask(Date.today(), params, patientParams);
    BI_PSPB_PastDueTaskSubjectCtrl.createPatientTask(Date.today().addDays(-3), params, patientParams);
    Test.stopTest();

    // Validate the task creation
    Assert.areEqual('Patient', task.BI_PSPB_Notification_User_Type__c,'Patient is the usertype');
}

@isTest
static void testCreateCaregiverTask() {
    // Creating test accounts
    Account testAccount = new Account(Name = 'Test Account', BI_PSP_CommunityUsername__c = 'Test Community2', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccount;
    Account testAccountPatient = new Account(Name = 'Test Account1', BI_PSP_CommunityUsername__c = 'Test Community3', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccountPatient;
    Account testAccountCaregiver = new Account(Name = 'Test Account2', BI_PSP_CommunityUsername__c = 'Test Community4', BI_PSP_Birthdate__c = Date.today().addYears(-25));
    insert testAccountCaregiver;

    // Creating a Care Program
    CareProgram testCareProgram = new CareProgram(Name = 'Test Enrollee');
    insert testCareProgram;

    // Creating Care Program Enrollees
    List<CareProgramEnrollee> testEnrollees = new List<CareProgramEnrollee>{
        new CareProgramEnrollee(AccountId = testAccount.Id, Name = 'Test Enrollee', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-1)),
        new CareProgramEnrollee(AccountId = testAccountPatient.Id, Name = 'Test Enrollee1', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-3)),
        new CareProgramEnrollee(AccountId = testAccountCaregiver.Id, Name = 'Test Enrollee2', CareProgramId = testCareProgram.Id, BI_PSPB_FirstLoginDate__c = System.today().addDays(-5))
    };
    insert testEnrollees;

    // Creating Treatment Reminders
    List<BI_PSPB_Treatment_Reminder__c> testReminders = new List<BI_PSPB_Treatment_Reminder__c>{
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[0].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(1), BI_PSPB_Date_of_Treatment__c = System.today().addDays(1), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[1].Id, BI_PSPB_Reminder_Date__c = System.today().addDays(-3), BI_PSPB_Date_of_Treatment__c = System.today().addDays(-3), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment'),
        new BI_PSPB_Treatment_Reminder__c(BI_PSPB_Care_Program_Enrollee__c = testEnrollees[2].Id, BI_PSPB_Reminder_Date__c = System.today(), BI_PSPB_Date_of_Treatment__c = System.today(), BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive, BI_PSPB_Reminder_Type__c = 'Date of Treatment')
    };
    insert testReminders;

    // Creating BI_PSPB_TaskCreationParams object with the necessary constructor
    BI_PSPB_TaskCreationParams params = new BI_PSPB_TaskCreationParams(
        [SELECT Id, BI_PSPB_Care_Program_Enrollee__c, BI_PSPB_Date_of_Treatment__c FROM BI_PSPB_Treatment_Reminder__c LIMIT 1],
        new BI_PSPB_TreatmentReminderDaysCtrl(/* initialize with correct parameters */)
    );

    // Accessing the enrollee ID correctly from the testReminders

    List<Id> enrolleeIds = new List<Id>{testReminders[0].BI_PSPB_Care_Program_Enrollee__c};
       String formattedDate;
			Datetime treatmentDate;
    treatmentDate = testReminders[0].BI_PSPB_Date_of_Treatment__c;
				formattedDate = treatmentDate.format('MM/dd/yyyy');
    // Creating BI_PSPB_TreatmentPatientTaskCtrl object with the correct constructor
    BI_PSPB_TreatmentCaregiverTaskCtrl patientParams = new BI_PSPB_TreatmentCaregiverTaskCtrl(
            enrolleeIds,
            enrolleeIds,
            enrolleeIds,
            'Caregiver',
            null
            );

    // Test execution
    Test.startTest();
    Task task = BI_PSPB_PastDueTaskSubjectCtrl.createCaregiverTask(Date.today().addDays(-1), params, 'Niyas', patientParams);
    BI_PSPB_PastDueTaskSubjectCtrl.createCaregiverTask(Date.today(), params, 'Niyas', patientParams);
    BI_PSPB_PastDueTaskSubjectCtrl.createCaregiverTask(Date.today().addDays(-3), params, 'Niyas', patientParams);
    Test.stopTest();

    System.assertEquals('Caregiver', task.BI_PSPB_Notification_User_Type__c,'Caregiver is the usertype');
}

}