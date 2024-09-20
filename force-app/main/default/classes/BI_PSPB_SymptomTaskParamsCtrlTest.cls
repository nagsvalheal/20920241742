@isTest
public class BI_PSPB_SymptomTaskParamsCtrlTest {
    
    @isTest
    static void testBuilderPattern() {
        // Arrange
        // Create test data
        List<Id> enrollees = createTestEnrollees(2);
        List<Id> caregiverIds = createTestCaregivers(1);
        String notificationType = 'Symptom Notification';
        String category = 'Treatment';
        String treatmentType = 'Routine Checkup';
        String status = 'Active';
        String userType = 'Patient';
        String subject = 'Symptom Alert';

        // Act
        BI_PSPB_SymptomTaskParamsCtrl params = new BI_PSPB_SymptomTaskParamsCtrl.Builder()
            .setEnrollees(enrollees)
            .setCaregiverIds(caregiverIds)
            .setNotificationType(notificationType)
            .setCategory(category)
            .setTreatmentType(treatmentType)
            .setStatus(status)
            .setUserType(userType)
            .setSubject(subject)
            .build();

        // Assert
        Assert.areEqual(enrollees, params.enrollees, 'Enrollees should match the input list.');
        Assert.areEqual(caregiverIds, params.caregiverIds, 'Caregiver IDs should match the input list.');
        Assert.areEqual(notificationType, params.notificationType, 'Notification type should be set correctly.');
        Assert.areEqual(category, params.category, 'Category should be set correctly.');
        Assert.areEqual(treatmentType, params.treatmentType, 'Treatment type should be set correctly.');
        Assert.areEqual(status, params.status, 'Status should be set correctly.');
        Assert.areEqual(userType, params.userType, 'User type should be set correctly.');
        Assert.areEqual(subject, params.subject, 'Subject should be set correctly.');
    }

    @isTest
    static void testBuilderWithDefaults() {
        // Arrange
        // Create test data with minimal parameters
        List<Id> enrollees = createTestEnrollees(1);
        String notificationType = 'Symptom Notification';
        BI_PSPB_SymptomTaskParamsCtrl params = new BI_PSPB_SymptomTaskParamsCtrl.Builder()
            .setEnrollees(enrollees)
            .setNotificationType(notificationType)
            .build();
            Assert.areEqual(enrollees, params.enrollees, 'Enrollees should match the input list.');
    }

    @isTest
    static void testBuilderHandlesNulls() {
        // Act
        BI_PSPB_SymptomTaskParamsCtrl params = new BI_PSPB_SymptomTaskParamsCtrl.Builder()
            .setEnrollees(null)
            .setCaregiverIds(null)
            .setNotificationType(null)
            .setCategory(null)
            .setTreatmentType(null)
            .setStatus(null)
            .setUserType(null)
            .setSubject(null)
            .build();

        Assert.areEqual(null, params.enrollees, 'Enrollees should be null.');
        Assert.areEqual(null, params.caregiverIds, 'Caregiver IDs should be null.');
        Assert.areEqual(null, params.notificationType, 'Notification type should be null.');
        Assert.areEqual(null, params.category, 'Category should be null.');
        Assert.areEqual(null, params.treatmentType, 'Treatment type should be null.');
        Assert.areEqual(null, params.status, 'Status should be null.');
        Assert.areEqual(null, params.userType, 'User type should be null.');
        Assert.areEqual(null, params.subject, 'Subject should be null.');
    }

    // Helper method to create test enrollees
    private static List<Id> createTestEnrollees(Integer count) {
        List<Id> enrolleeIds = new List<Id>();
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account acc = new Account(Name='Test Enrollee ' + i);
            accountList.add(acc);
            enrolleeIds.add(acc.Id);
        }
        insert accountList;
        return enrolleeIds;
    }

    // Helper method to create test caregivers
    private static List<Id> createTestCaregivers(Integer count) {
        List<Id> caregiverIds = new List<Id>();
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            Contact con = new Contact(LastName='Test Caregiver ' + i);
            contactList.add(con);
            caregiverIds.add(con.Id);
        }
        insert contactList;
        return caregiverIds;
    }
}