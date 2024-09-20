@isTest
public class BI_PSPB_TreatmentTaskCreateCtrlTest {
    @isTest
    static void testCreatePatientTask() {
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
        // Retrieve test data
        BI_PSPB_Treatment_Reminder__c reminder = [SELECT Id, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Care_Program_Enrollee__r.AccountId
                                                  FROM BI_PSPB_Treatment_Reminder__c LIMIT 1];

        // Define a mock of the days configuration
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 1;
        daysCount.before3Day = 3;
        daysCount.before7Day = 7;
        daysCount.before10Day = 10;
        daysCount.before14Day = 14;

        // Test for 1 day before treatment date
        Task patientTask = BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 1, daysCount, 'Patient');
        BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 3, daysCount, 'Patient');
        BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 7, daysCount, 'Patient');
        BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 10, daysCount, 'Patient');
        BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 14, daysCount, 'Patient');
        Assert.areEqual('Patient', patientTask.BI_PSPB_Notification_User_Type__c,'Type of user is patient');
        Assert.areEqual(reminder.Id, patientTask.WhatId,'WhatId should be the reminder Id');

        // Test for an invalid days difference
        Task invalidTask = BI_PSPB_TreatmentTaskCreateCtrl.createPatientTask(reminder, 5, daysCount, 'Patient');
        Assert.areEqual(null, invalidTask,'Id is invalid so it is null');
    }

    @isTest
    static void testCreateCaregiverTask() {
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
        // Retrieve test data
        BI_PSPB_Treatment_Reminder__c reminder = [SELECT Id, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Care_Program_Enrollee__r.Account.Name
                                                  FROM BI_PSPB_Treatment_Reminder__c LIMIT 1];

        // Define a mock of the days configuration
        BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 1;
        daysCount.before3Day = 3;
        daysCount.before7Day = 7;
        daysCount.before10Day = 10;
        daysCount.before14Day = 14;

        // Test for 1 day before treatment date
        Task caregiverTask = BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 1, daysCount, 'Caregiver');
        BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 3, daysCount, 'Caregiver');
        BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 7, daysCount, 'Caregiver');
        BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 10, daysCount, 'Caregiver');
        BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 14, daysCount, 'Caregiver');
        Assert.areEqual('Caregiver', caregiverTask.BI_PSPB_Notification_User_Type__c,'Type of user is caregiver');
        Assert.areEqual(reminder.Id, caregiverTask.WhatId,'Id of the reminder should match WhatId');

        // Test for an invalid days difference
        Task invalidTask = BI_PSPB_TreatmentTaskCreateCtrl.createCaregiverTask(reminder, 5, daysCount, 'Caregiver');
        Assert.areEqual(null, invalidTask,'No valid tasks');
    }
}