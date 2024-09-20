@isTest
private class BI_PSP_SymptomTrackerConstantTest {
	@isTest
	static void testConstants() {
		// Test error constant
		Assert.areEqual(
			System.Label.BI_PSP_ConsoleError,
			BI_PSP_SymptomTrackerConstant.error,
			'Error constant value does  match expected value.'
		);

		// Test inActiveRecord constant
		Assert.areEqual(
			System.Label.BI_PSP_Inactive,
			BI_PSP_SymptomTrackerConstant.inActiveRecord,
			'InActiveRecord constant value does  match expected value.'
		);

		// Test checkValues constant
		Assert.areEqual(
			System.Label.BI_PSP_CheckValues,
			BI_PSP_SymptomTrackerConstant.checkValues,
			'CheckValues constant value does  match expected value.'
		);

		// Test symptomErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_SymptomTrackerError,
			BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
			'SymptomErrorMsg constant value does  match expected value.'
		);

		// Test gppErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_GppValuesErrorMsg,
			BI_PSP_SymptomTrackerConstant.gppErrorMsg,
			'GppErrorMsg constant value does  match expected value.'
		);

		// Test careProgramErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_SymptomTrackerError,
			BI_PSP_SymptomTrackerConstant.careProgramErrorMsg,
			'CareProgramErrorMsg constant value does  match expected value.'
		);

		// Test carePlanErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_CarePlanErrorMsg,
			BI_PSP_SymptomTrackerConstant.carePlanErrorMsg,
			'CarePlanErrorMsg constant value does  match expected value.'
		);

		// Test patientErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_PatientErrorMsg,
			BI_PSP_SymptomTrackerConstant.patientErrorMsg,
			'PatientErrorMsg constant value does  match expected value.'
		);

		// Test contentErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_ApplicationPhotoMsg,
			BI_PSP_SymptomTrackerConstant.contentErrorMsg,
			'ContentErrorMsg constant value does  match expected value.'
		);

		// Test applicationPhotoMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_ApplicationPhotoMsg,
			BI_PSP_SymptomTrackerConstant.applicationPhotoMsg,
			'ApplicationPhotoMsg constant value does  match expected value.'
		);

		// Test bodyPartsErrorMsg constant
		Assert.areEqual(
			System.Label.BI_PSP_BodyPartsErrorMsg,
			BI_PSP_SymptomTrackerConstant.bodyPartsErrorMsg,
			'BodyPartsErrorMsg constant value does  match expected value.'
		);

		// Test checkUniqueDate constant
		Assert.areEqual(
			System.Label.BI_PSP_CheckUnquieDate,
			BI_PSP_SymptomTrackerConstant.checkUniqueDate,
			'CheckUniqueDate constant value does  match expected value.'
		);

		// Test checkGender constant
		Assert.areEqual(
			System.Label.BI_PSP_Gender,
			BI_PSP_SymptomTrackerConstant.checkGender,
			'CheckGender constant value does  match expected value.'
		);

		// Test symptomRecordType constant
		Assert.areEqual(
			System.Label.BI_PSP_Symptom,
			BI_PSP_SymptomTrackerConstant.symptomRecordType,
			'SymptomRecordType constant value does  match expected value.'
		);

		// Test inActive constant
		Assert.areEqual(
			System.Label.BI_PSP_AcitveRecord,
			BI_PSP_SymptomTrackerConstant.inActive,
			'InActive constant value does  match expected value.'
		);

		// Test activeLable constant
		Assert.areEqual(
			System.Label.BI_PSP_Active,
			BI_PSP_SymptomTrackerConstant.activeLable,
			'ActiveLable constant value does  match expected value.'
		);

		// Test fileName constant
		Assert.areEqual(
			System.Label.BI_PSP_UploadedFilePng,
			BI_PSP_SymptomTrackerConstant.fileName,
			'FileName constant value does  match expected value.'
		);

		// Test fileNamePath constant
		Assert.areEqual(
			System.Label.BI_PSP_UploadedFile,
			BI_PSP_SymptomTrackerConstant.fileNamePath,
			'FileNamePath constant value does  match expected value.'
		);

		// Test symptomTrackerInactive constant
		Assert.areEqual(
			System.Label.BI_PSPB_EnrolleeCaregiverStatusInactive,
			BI_PSP_SymptomTrackerConstant.symptomTrackerInactive,
			'SymptomTrackerInactive constant value does  match expected value.'
		);

		// Test latestRecord constant
		Assert.areEqual(
			System.Label.BI_PSP_LatestRecords,
			BI_PSP_SymptomTrackerConstant.latestRecord,
			'LatestRecord constant value does  match expected value.'
		);

		// Test alleryRecord constant
		Assert.areEqual(
			System.Label.BI_PSP_AllergyDatas,
			BI_PSP_SymptomTrackerConstant.alleryRecord,
			'AlleryRecord constant value does  match expected value.'
		);

		// Test stausChange constant
		Assert.areEqual(
			System.Label.BI_PSP_SymptomUpdateStatus,
			BI_PSP_SymptomTrackerConstant.stausChange,
			'StausChange constant value does  match expected value.'
		);

		// Test LOG_SEVERITY_ERROR constant
		Assert.areEqual(
			'ERROR',
			BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR,
			'LOG_SEVERITY_ERROR constant value does  match expected value.'
		);
	}
}