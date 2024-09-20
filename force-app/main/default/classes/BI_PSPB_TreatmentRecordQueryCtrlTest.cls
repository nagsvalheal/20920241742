@IsTest
/**
* @description This class contains test methods to verify the behaviour of
querying treatment records.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TreatmentRecordQueryCtrlTest {
	@TestSetup
	static void setup() {
		 Account account = new Account(
			FirstName = 'TestPatientFeed',
			LastName = 'PatientLastName',
			PersonEmail = 'testpatientfeed@gmail.com',
			RecordTypeId = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
			]
			.Id,
			Phone = '123456'
		);
		insert account;
		CareProgram testCareProgram = new CareProgram(
			Name = 'Test Care Program',
			StartDate = Date.today()
		);
		insert testCareProgram;
		CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
			CareProgramId = testCareProgram.Id,
			BI_PSP_CommunityUsername__c = 'patient',
			AccountId = account.Id,
			BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
			Name = 'TestPatientFeed PatientLastName'
		);
		insert testCareProgramEnrolle;
			BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
				BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
				BI_PSPB_Reminder_Type__c = 'Date of Treatment',
				BI_PSPB_Date_of_Treatment__c = Date.today(),
				BI_PSPB_Status__c = BI_PSPB_NotificationConstant.actionTypeActive
			);
		insert reminder;
	}
	@IsTest
	static void testGetTreatmentRecordsValidData() {
			Set<Date> targetDates = new Set<Date>{Date.today()};
			Map<Date, List<BI_PSPB_Treatment_Reminder__c>> result = BI_PSPB_TreatmentRecordQueryCtrl.getTreatmentRecords(targetDates);
			Assert.areEqual(1, result.size(), 'The map should contain dates');
			Assert.areEqual(1, result.get(Date.today()).size(), 'There should be 1 reminder for today\'s date');
	}
	@IsTest
	static void testGetTreatmentRecordsNoMatchingData() {
		try{
			Set<Date> targetDates = new Set<Date>{Date.today().addYears(1)};
			BI_PSPB_TreatmentRecordQueryCtrl.getTreatmentRecords(targetDates);
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
	@IsTest
	static void testGetTreatmentRecordsNullTargetDates() {
		try{
			BI_PSPB_TreatmentRecordQueryCtrl.getTreatmentRecords(null);
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