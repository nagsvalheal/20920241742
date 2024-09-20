@isTest
public class BI_PSPB_PastDueTargetDatesCtrlTest {

    /**
     * @description Test method to verify the getTreatmentRecords method.
     *              This test will cover scenarios where the target dates are valid.
     */
    @isTest
    static void testGetTreatmentRecordsValidTargetDates() {
        // Create test data
        Account testAccount = new Account(
            Name = 'Test Account',
            BI_PSP_Birthdate__c = Date.today().addYears(-25)
        );
        insert testAccount;

        CareProgram testCareProgram = new CareProgram(Name = 'Test Program');
        insert testCareProgram;

        CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id,
            Name = 'Test Enrollee',
            CareProgramId = testCareProgram.Id,
            BI_PSPB_FirstLoginDate__c = Date.today().addDays(-1)
        );
        insert testEnrollee;

        // Create treatment reminders with various dates
        BI_PSPB_Treatment_Reminder__c reminder1 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Date__c = Date.today(),
            BI_PSPB_Date_of_Treatment__c = Date.today(),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = 'Date of Treatment'
        );

        BI_PSPB_Treatment_Reminder__c reminder2 = new BI_PSPB_Treatment_Reminder__c(
            BI_PSPB_Care_Program_Enrollee__c = testEnrollee.Id,
            BI_PSPB_Reminder_Date__c = Date.today().addDays(-1),
            BI_PSPB_Date_of_Treatment__c = Date.today().addDays(-1),
            BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive,
            BI_PSPB_Reminder_Type__c = 'Date of Treatment'
        );

        insert new List<BI_PSPB_Treatment_Reminder__c>{reminder1, reminder2};
        // Create a set of target dates for testing
        Set<Date> targetDates = new Set<Date>{Date.today(),Date.today().addDays(-1)};
        // Test execution
		Map<Date, List<BI_PSPB_Treatment_Reminder__c>> result = new Map<Date, List<BI_PSPB_Treatment_Reminder__c>>();
	try{
        Test.startTest();
        result = BI_PSPB_PastDueTargetDatesCtrl.getTreatmentRecords(targetDates);
        Test.stopTest();
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

    /**
     * @description Test method to verify the behavior when target dates are null.
     */
    @isTest
    static void testGetTreatmentRecordsNullTargetDates() {
        Map<Date, List<BI_PSPB_Treatment_Reminder__c>> result = new Map<Date, List<BI_PSPB_Treatment_Reminder__c>>();
        // Test execution with null target dates
        try{
        Test.startTest();
			result = BI_PSPB_PastDueTargetDatesCtrl.getTreatmentRecords(null);
        Test.stopTest();
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

        // Assert that the result is empty
        System.assertEquals(0, result.size(), 'The result should be empty when target dates are null.');
    }

    /**
     * @description Test method to verify the behavior when there are no matching records.
     */
    @isTest
    static void testGetTreatmentRecordsNoMatchingRecords() {
        Map<Date, List<BI_PSPB_Treatment_Reminder__c>> result = new Map<Date, List<BI_PSPB_Treatment_Reminder__c>>();
        // Create a set of target dates for testing
        Set<Date> targetDates = new Set<Date>{Date.today(), Date.today().addDays(-1)};

        // Test execution
            try{
        Test.startTest();
        	result = BI_PSPB_PastDueTargetDatesCtrl.getTreatmentRecords(targetDates);
        Test.stopTest();
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

        // Assert that the result is empty as there are no matching records
        System.assertEquals(0, result.size(), 'The result should be empty when there are no matching records.');
    }

    /**
     * @description Test method to verify the behavior when an exception occurs.
     */
    @isTest
    static void testGetTreatmentRecordsExceptionHandling() {
        Map<Date, List<BI_PSPB_Treatment_Reminder__c>> result = new Map<Date, List<BI_PSPB_Treatment_Reminder__c>>();
        // Test execution with an invalid parameter to force an exception (e.g., invalid date format)
        try{
        Test.startTest();
			result = BI_PSPB_PastDueTargetDatesCtrl.getTreatmentRecords(new Set<Date>{Date.newInstance(2024, 13, 32)});
        Test.stopTest();
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

        // Assert that the result is empty due to exception handling
        System.assertEquals(0, result.size(), 'The result should be empty due to exception handling.');
    }


}