@IsTest
public class BI_PSPB_CaregiverNotifyParamsCtrlTest {
    @isTest
    static void testConstructor() {
        // Start test execution
        Test.startTest();

        // Create test Account records (or other relevant sObject types)
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;
		CareProgram testCareProgram = new CareProgram(
				Name = 'Test Enrollee'
			);
			insert testCareProgram;

        // List of Account IDs (representing recordIds)
        List<Id> testRecordIds = new List<Id>();
        for (Account acc : testAccounts) {
            testRecordIds.add(acc.Id);
        }

        // List of Caregiver (User) IDs
        List<Id> testCaregiverIds = new List<Id>();
            testCaregiverIds.add(testCareProgram.Id);
        

        // List of Patient names
        List<String> testPatientNames = new List<String>{'John Doe', 'Jane Smith'};

        // Create an instance of BI_PSPB_CaregiverNotifyParamsCtrl
        BI_PSPB_CaregiverNotifyParamsCtrl paramsCtrl = new BI_PSPB_CaregiverNotifyParamsCtrl(
            testRecordIds,
            testCaregiverIds,
            testPatientNames
        );

        // Assert
        Assert.areEqual(testRecordIds, paramsCtrl.recordId, 'The record IDs should match the input.');
        Assert.areEqual(testCaregiverIds, paramsCtrl.caregiverIds, 'The caregiver IDs should match the input.');

        // Stop test execution
        Test.stopTest();
    }
}