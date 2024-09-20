@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentPrescriptionTest test class designed to test the functionality of the BI_PSPB_EnrollmentPrescription class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentPrescriptionTest {
    
    @isTest
    
    static void testPrescriptionCreate() {
        
        // Set up test data
        BI_PSPB_EnrollmentWrapper.HcpWrapper prescriptionData = new BI_PSPB_EnrollmentWrapper.HcpWrapper();
        prescriptionData.drug = 'TestDrug';
        prescriptionData.frequency = 2;
        prescriptionData.unit = 'Per day';
        prescriptionData.quantity = 10;
        prescriptionData.refill = 2;
     BI_PSPB_EnrollmentWrapper.DataWrapper data = new BI_PSPB_EnrollmentWrapper.DataWrapper();
         Data.dob = '2024-07-20';
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;
       // Create a CareProgram record for the test drug
		CareProgram cpvalue = new CareProgram(
			Name = 'Test CP',
			StartDate = Date.today() // Adjust the start date as needed
			// Add any other required fields for your CareProgram record
		);
		insert cpvalue;
        // Create a test CareProgramProduct
        CareProgramProduct testDrug = new CareProgramProduct(
            Name = 'TestDrug',
            CareProgramId =cpvalue.id
        );
        insert testDrug;

        // Run the method
        Test.startTest();
        try{
        Id prescriptionId = BI_PSPB_EnrollmentPrescription.prescriptionCreate(prescriptionData,Data,testLead.Id);
        Test.stopTest();

        // Validate the results
        BI_PSPB_Lead_Prescription__c createdPrescription = [SELECT Id, BI_PSPB_Dosage__c, BI_PSPB_Quantity__c, BI_PSPB_Frequency__c, BI_PSPB_of_Refills__c, BI_PSPB_Frequency_Unit__c, BI_PSPB_Drug__c, BI_PSPB_Lead__c FROM BI_PSPB_Lead_Prescription__c WHERE Id = :prescriptionId];
        Assert.areEqual(10, createdPrescription.BI_PSPB_Quantity__c,'null');
        Assert.areEqual(2, createdPrescription.BI_PSPB_Frequency__c,'null');
        Assert.areEqual(2, createdPrescription.BI_PSPB_of_Refills__c,'null');
        Assert.areEqual('Per day', createdPrescription.BI_PSPB_Frequency_Unit__c,'null');
        Assert.areEqual(testDrug.Id, createdPrescription.BI_PSPB_Drug__c,'null');
        Assert.areEqual(testLead.Id, createdPrescription.BI_PSPB_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }
@isTest
    static void testPrescriptionCreateException() {
        // Set up test data
        BI_PSPB_EnrollmentWrapper.HcpWrapper prescriptionData = new BI_PSPB_EnrollmentWrapper.HcpWrapper();
        prescriptionData.drug = 'TestDrug';
        prescriptionData.frequency = 2;
        prescriptionData.unit = 'day';


        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;
       // Create a CareProgram record for the test drug
		CareProgram cpvalue = new CareProgram(
			Name = 'Test CP',
			StartDate = Date.today() // Adjust the start date as needed
			
		);
		insert cpvalue;
        // Create a test CareProgramProduct
        CareProgramProduct testDrug = new CareProgramProduct(
            Name = 'TestDrug',
            CareProgramId =cpvalue.id
        );
        insert testDrug;

        // Run the method
        Test.startTest();
        try{
        Id prescriptionId = BI_PSPB_EnrollmentPrescription.prescriptionCreate(prescriptionData,null,testLead.Id);
        Test.stopTest();

        // Validate the results
        BI_PSPB_Lead_Prescription__c createdPrescription = [SELECT Id, BI_PSPB_Dosage__c, BI_PSPB_Quantity__c, BI_PSPB_Frequency__c, BI_PSPB_of_Refills__c, BI_PSPB_Drug_Code__c, BI_PSPB_Unit__c, BI_PSPB_Prescribed_Date__c, BI_PSPB_Frequency_Unit__c, BI_PSPB_Drug__c, BI_PSPB_Lead__c FROM BI_PSPB_Lead_Prescription__c WHERE Id = :prescriptionId];
        Assert.areEqual(10, createdPrescription.BI_PSPB_Quantity__c,'null');
        Assert.areEqual(2, createdPrescription.BI_PSPB_Frequency__c,'null');
        Assert.areEqual(2, createdPrescription.BI_PSPB_of_Refills__c,'null');
        Assert.areEqual(Date.valueOf('2024-07-20'), createdPrescription.BI_PSPB_Prescribed_Date__c,'null');
        Assert.areEqual('day', createdPrescription.BI_PSPB_Frequency_Unit__c,'null');
        Assert.areEqual(testDrug.Id, createdPrescription.BI_PSPB_Drug__c,'null');
        Assert.areEqual(testLead.Id, createdPrescription.BI_PSPB_Lead__c,'null');
     } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        }

    @isTest
    static void testPrescriptionCreateWithNullData() {

        // Run the method and validate that an error is logged
        Test.startTest();
        try {
            BI_PSPB_EnrollmentPrescription.prescriptionCreate(null,null,'');
            Assert.areEqual(false, 'Expected exception was not thrown',null);
        } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        Test.stopTest();
    }

    @isTest
    static void testPrescriptionCreateWithMissingData() {
        // Set up test data with missing required fields
        BI_PSPB_EnrollmentWrapper.HcpWrapper prescriptionData = new BI_PSPB_EnrollmentWrapper.HcpWrapper();
        prescriptionData.drug = 'TestDrug';
        prescriptionData.frequency = 2;
        prescriptionData.unit = 'Days';


        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test.lead@example.com'
        );
        insert testLead;

        // Run the method and validate that an error is logged
        Test.startTest();
        try{
            BI_PSPB_EnrollmentPrescription.prescriptionCreate(prescriptionData,null, testLead.Id);
           Assert.areEqual(false, 'Expected exception was not thrown',null);
          } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
        Test.stopTest();
    }
}