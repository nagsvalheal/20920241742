@isTest
public class BI_PSPB_TreatmentPatientTaskCtrlTest {
    @isTest
    static void testConstructorInitialization() {
        // Create test Account records to simulate enrollee records
        Id recordType = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND Name = 'Person Account'
        ].Id;
        List<Account> enrolleeAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            enrolleeAccounts.add(new Account(
                FirstName = 'TestEnrollee' + i,
                LastName = 'PatientLastName' + i,
                PersonEmail = 'testenrollee' + i + '@example.com',
                BI_PSP_Birthdate__c = Date.today(),
                RecordTypeId = recordType,
                Phone = '123456789' + i
            ));
        }
        insert enrolleeAccounts;

        // Create test CareProgram record
        CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.today()
        );
        insert testCareProgram;

        // Create CareProgramEnrollees associated with the Accounts
        List<CareProgramEnrollee> careProgramEnrollees = new List<CareProgramEnrollee>();
        for (Integer i = 0; i < enrolleeAccounts.size(); i++) {
            careProgramEnrollees.add(new CareProgramEnrollee(
                AccountId = enrolleeAccounts[i].Id,
                CareProgramId = testCareProgram.Id,
                BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
                Name = enrolleeAccounts[i].FirstName + ' ' + enrolleeAccounts[i].LastName
            ));
        }
        insert careProgramEnrollees;

        // Create test Caregiver record
        Contact testCaregiver = new Contact(
            LastName = 'TestCaregiver',
            Email = 'testcaregiver@example.com'
        );
        insert testCaregiver;

        // Get the IDs of the inserted records
        List<Id> enrolleeRecIds = new List<Id>{ careProgramEnrollees[0].Id, careProgramEnrollees[1].Id };
        List<Id> enrolleePastOne = new List<Id>{ careProgramEnrollees[2].Id };
        List<Id> enrolleePastThree = new List<Id>{ careProgramEnrollees[3].Id, careProgramEnrollees[4].Id };
        String userType = 'Patient';
        Id caregiverId = testCaregiver.Id;

        // Act
        // Initialize the class with test data
        BI_PSPB_TreatmentPatientTaskCtrl taskCtrl = new BI_PSPB_TreatmentPatientTaskCtrl(
            enrolleeRecIds,
            enrolleePastOne,
            enrolleePastThree,
            userType,
            caregiverId
        );

        // Assert
        // Verify that the object is initialized with the correct values
        Assert.areEqual(enrolleeRecIds, taskCtrl.enrolleeRecIds, 'The enrolleeRecIds should be initialized correctly.');
        Assert.areEqual(enrolleePastOne, taskCtrl.enrolleePastOne, 'The enrolleePastOne should be initialized correctly.');
        Assert.areEqual(enrolleePastThree, taskCtrl.enrolleePastThree, 'The enrolleePastThree should be initialized correctly.');
        Assert.areEqual(userType, taskCtrl.userType, 'The userType should be initialized correctly.');
        Assert.areEqual(caregiverId, taskCtrl.caregiverId, 'The caregiverId should be initialized correctly.');
    }
}