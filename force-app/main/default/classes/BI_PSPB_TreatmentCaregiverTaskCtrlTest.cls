@isTest
public class BI_PSPB_TreatmentCaregiverTaskCtrlTest {

    @isTest
    static void testConstructorInitialization() {
        // Create test data dynamically
        List<Id> enrolleeRecIds = createTestEnrollees(2);
        List<Id> enrolleePastOne = createTestEnrollees(1);
        List<Id> enrolleePastThree = createTestEnrollees(2);
        String userType = 'Caregiver';
        Id caregiverId = createTestCaregiver();

        // Initialize the class with test data
        BI_PSPB_TreatmentCaregiverTaskCtrl taskCtrl = new BI_PSPB_TreatmentCaregiverTaskCtrl(
            enrolleeRecIds,
            enrolleePastOne,
            enrolleePastThree,
            userType,
            caregiverId
        );

        // Verify that the object is initialized with the correct values
        Assert.areEqual(enrolleeRecIds, taskCtrl.enrolleeRecIds, 'The enrolleeRecIds should be initialized correctly.');
        Assert.areEqual(enrolleePastOne, taskCtrl.enrolleePastOne, 'The enrolleePastOne should be initialized correctly.');
        Assert.areEqual(enrolleePastThree, taskCtrl.enrolleePastThree, 'The enrolleePastThree should be initialized correctly.');
        Assert.areEqual(userType, taskCtrl.userType, 'The userType should be initialized correctly.');
        Assert.areEqual(caregiverId, taskCtrl.caregiverId, 'The caregiverId should be initialized correctly.');
    }

    // Helper method to create test enrollees
    private static List<Id> createTestEnrollees(Integer count) {
        List<Id> enrolleeIds = new List<Id>();
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account acc = new Account(Name='Test Enrollee ' + i);
            accountList.add(acc);
        }
        insert accountList;
        for (Account acc : accountList) {
            enrolleeIds.add(acc.Id);
        }
        return enrolleeIds;
    }

    // Helper method to create a test caregiver
    private static Id createTestCaregiver() {
        Contact caregiver = new Contact(LastName='Test Caregiver');
        insert caregiver;
        return caregiver.Id;
    }
}