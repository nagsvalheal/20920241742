@IsTest
/**
* @description This class contains test methods to verify the behaviour of
querying symptom tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_SymptomTrackerQueryTest {
    @TestSetup
    static void setup() {
        Account testAccount = new Account(
            FirstName = 'Test',
            LastName = 'Account',
            PersonEmail = 'testaccount@example.com',
            RecordTypeId = [
                SELECT Id
                FROM RecordType
                WHERE SObjectType = 'Account' AND Name = 'Person Account'
                LIMIT 1
            ]
            .Id
        );
        insert testAccount;
        CareProgram testCareProgram = new CareProgram(
            Name = 'Test Care Program',
            StartDate = Date.today()
        );
        insert testCareProgram;
        CareProgramEnrollee testCareProgramEnrollee = new CareProgramEnrollee(
            AccountId = testAccount.Id,
            CareProgramId = testCareProgram.Id,
            BI_PSP_CommunityUsername__c = 'testuser',
            BI_PSP_AvatarUrl__c = '/some/path',
            Name = 'TestPatientFeed'
        );
        insert testCareProgramEnrollee;
        BI_PSP_Symptom_Tracker__c symptom1 = new BI_PSP_Symptom_Tracker__c(
            BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
            BI_PSP_Are_you_currently_experiencing__c = true,
            BI_PSP_EditEntrydates__c = Date.today(),
            BI_PSP_First_Symptom_Notification_Date__c = Date.today(),
            BI_PSP_Notification_Status__c = true
        );
        BI_PSP_Symptom_Tracker__c symptom2 = new BI_PSP_Symptom_Tracker__c(
            BI_PSP_Care_Program_Enrollee__c = testCareProgramEnrollee.Id,
            BI_PSP_Are_you_currently_experiencing__c = false,
            BI_PSP_EditEntrydates__c = Date.today().addDays(-1),
            BI_PSP_First_Symptom_Notification_Date__c = Date.today()
                .addDays(-1),
            BI_PSP_Notification_Status__c = true
        );
        insert new List<BI_PSP_Symptom_Tracker__c>{ symptom1, symptom2 };
    }
    @IsTest
    static void testFetchSymptomTrackersValidData() {
        CareProgramEnrollee testEnrollee = [
            SELECT Id
            FROM CareProgramEnrollee
            LIMIT 1
        ];
        List<SObject> enrolleeList = new List<SObject>{ testEnrollee };
        List<BI_PSP_Symptom_Tracker__c> result = BI_PSPB_SymptomTrackerQuery.fetchSymptomTrackers(
            enrolleeList
        );
        Assert.areEqual(
            1,result.size(),
            'Only one symptom tracker should be returned.'
        );
        Assert.areEqual(
            testEnrollee.Id,
            result[0].BI_PSP_Care_Program_Enrollee__c,
            'The symptom tracker should belong to the correct enrollee.'
        );
    }
    @IsTest
    static void testFetchSymptomTrackersNoData() {
        List<BI_PSP_Symptom_Tracker__c> result = BI_PSPB_SymptomTrackerQuery.fetchSymptomTrackers(
            new List<SObject>()
        );
        Assert.areEqual(
            0,result.size(),
            'No symptom trackers should be returned for an empty enrollee list.'
        );
    }
    @IsTest
    static void testFetchSymptomTrackersExceptionHandling() {
        List<SObject> enrolleeList = new List<SObject>{ null };
        try {
            Test.startTest();
                BI_PSPB_SymptomTrackerQuery.fetchSymptomTrackers(
                enrolleeList
            );
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
}