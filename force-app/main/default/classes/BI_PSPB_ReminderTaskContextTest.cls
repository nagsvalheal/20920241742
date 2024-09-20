@isTest
public class BI_PSPB_ReminderTaskContextTest {


    @isTest
    static void testReminderTaskContextConstructor() {
        // Retrieve the test Treatment Reminder Days configuration and Reminder
         BI_PSPB_TreatmentReminderDaysCtrl daysCount = new BI_PSPB_TreatmentReminderDaysCtrl();
        daysCount.before1Day = 1;
        daysCount.before3Day = 3;
        daysCount.before7Day = 7;
        daysCount.before10Day = 10;
        daysCount.before14Day = 14;

        // Test values for age, caregiverId, daysDifference, and taskIdentifier
        Integer testAge = 30;
        Id testCaregiverId = UserInfo.getUserId();
        Integer testDaysDifference = 7;
        String testTaskIdentifier = 'TestTaskIdentifier';

        // Create an instance of BI_PSPB_ReminderTaskContext
        BI_PSPB_ReminderTaskContext context = new BI_PSPB_ReminderTaskContext(
            null,
            testAge,
            testCaregiverId,
            testDaysDifference,
            daysCount,
            testTaskIdentifier
        );

        // Assertions to verify the constructor assigns values correctly
        System.assertEquals(testAge, context.age, 'The age should be assigned correctly.');
        System.assertEquals(testCaregiverId, context.caregiverId, 'The caregiverId should be assigned correctly.');
        System.assertEquals(testDaysDifference, context.daysDifference, 'The daysDifference should be assigned correctly.');
        System.assertEquals(daysCount.before1Day, context.daysCount.before1Day, 'The daysCount should be assigned correctly.');
        System.assertEquals(testTaskIdentifier, context.taskIdentifier, 'The taskIdentifier should be assigned correctly.');
    }
}