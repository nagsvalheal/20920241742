@isTest
public class BI_PSPB_TaskCreationContextCtrlTest {

    @isTest
    static void testConstructor() {
  
        // Mocking ReminderProcessingContext
        BI_PSPB_PastDueNotificationCtrl.ReminderProcessingContext testContext = 
            new BI_PSPB_PastDueNotificationCtrl.ReminderProcessingContext();
        
        // Assuming BI_PSPB_TaskCreationParams has a default or suitable constructor for tests
        Account acc = new Account(Name='Test Enrollee 132');
        insert acc;
        Id testCaregiverId = acc.Id;
        String testPatientName = 'John Doe';
        Integer testAge = 30;

        // Create an instance of BI_PSPB_TaskCreationContextCtrl
        BI_PSPB_TaskCreationContextCtrl taskContextCtrl = new BI_PSPB_TaskCreationContextCtrl(
            testContext,
            null,
            testCaregiverId,
            testPatientName,
            testAge
        );

        // Verify that the constructor correctly initializes the fields
        Assert.areEqual(testContext, taskContextCtrl.context, 'Context should be set correctly.');
        Assert.areEqual(testCaregiverId, taskContextCtrl.caregiverId, 'Caregiver Id should be set correctly.');
        Assert.areEqual(testPatientName, taskContextCtrl.patientName, 'Patient name should be set correctly.');
        Assert.areEqual(testAge, taskContextCtrl.age, 'Age should be set correctly.');
    }
}