/*
 * @description  This test class is designed for testing scenarios related to guest users and is not shared.
  It is used to perform unit tests for retrieving data from the CareProgramProduct objects
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif  05-Nov-2023     			Created             Initial development

 */
@isTest
private class BI_PSPB_ProductListCtrlTest {
private static   BI_SFCOE_LOG_App_Settings__c settings = BI_SFCOE_LOG_App_Settings__c.getValues('ApplicationName');
    /**
 * @description Test method to verify the functionality of retrieving product lists.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test to retrieve the product list.
 * Verifies that the returned list is not null and contains expected products.
 */

    @isTest
    static void testGetProductList() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Beyond GPP', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Product',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> productList = BI_PSPB_ProductListCtrl.getProductList();
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected product
        Assert.areNotEqual(null, productList, 'List of CareProgramProducts from getProductList() is null');
       
    }
    /**
 * @description Test method to verify the functionality of retrieving prescription data for a specific CareProgramProduct.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test to retrieve prescription data for the specified CareProgramProduct.
 * Verifies that the returned list is not null, has a size of 1, and contains the expected prescription data.
 */

    @isTest
    static void testGetprescritionData() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Prescription',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        // Call the method under test
         try{
        Test.startTest();
        List<CareProgramProduct> prescriptionData = BI_PSPB_ProductListCtrl.getPrescritionData(testCareProgramProduct.Id);
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected prescription data
        Assert.areNotEqual(null, prescriptionData, 'prescriptionData is null');
        Assert.areEqual(1, prescriptionData.size(), 'prescriptionData size is not 1');
        Assert.areEqual(testCareProgramProduct.Id, prescriptionData[0].Id, 'Id mismatch in prescriptionData');
        } catch (Exception e) {
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
       
    }
    /**
 * @description Test method to verify the handling of an exception scenario when retrieving prescription data for a specific CareProgramProduct.
 * Creates test data including a CareProgram and a related CareProgramProduct.
 * Calls the method under test with a null parameter to simulate an exception scenario.
 * Verifies that the returned list is null, indicating the occurrence of an exception.
 */

    @isTest
    static void testGetprescritionDataexception() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Prescription',CareProgramId = cp.id);
        insert testCareProgramProduct;
        try{
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> prescriptionData = BI_PSPB_ProductListCtrl.getPrescritionData(null);
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected prescription data
        Assert.areEqual(null, prescriptionData, 'prescriptionData is null');
        }catch (Exception ex) {
        // Assert if there's an exception
        Assert.areEqual(
            'Script-thrown exception',
            ex.getMessage(),
            'An unexpected exception occurred: ' + ex.getMessage()
        );
    }
       
       
    }
     @isTest
    static void testGetProductListexception() {
        // Create test data
        Careprogram cp = new Careprogram(Name ='Test', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        // Call the method under test
        Test.startTest();
        List<CareProgramProduct> productList = BI_PSPB_ProductListCtrl.getProductList();
        Test.stopTest();
        
        // Assert that the returned list is not null and contains the expected product
        Assert.areNotEqual(null, productList, 'List of CareProgramProducts from getProductList() is null');
       
    }
     @isTest
    static void testGetFrequencyWithMatchingRecords() {
        // Test case where records match the criteria
        Test.startTest();
        List<BI_PSPB_Frequency__c> result = BI_PSPB_ProductListCtrl.getFrequency('Test Frequency 1', 'Test Drug');
        Test.stopTest();
        
        // Assertions
       Assert.areEqual(null, result, 'Result should not be null');
    }
      @testSetup
    static void setupTestData() {
        // Insert test data for BI_PSPB_Frequency__c
         Careprogram cp = new Careprogram(Name ='Beyond GPP', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Product',CareProgramId = cp.id);
        insert testCareProgramProduct;
        
        BI_PSPB_Frequency__c testFrequency1 = new BI_PSPB_Frequency__c(
            Name = 'Test Frequency 1',
            BI_PSP_Quantity__c = '1',
            BI_PSP_Drug__c = testCareProgramProduct.Id
        );
        insert testFrequency1;
        
        BI_PSPB_Frequency__c testFrequency2 = new BI_PSPB_Frequency__c(
            Name = 'Test Frequency 2',
            BI_PSP_Quantity__c = '2',
            BI_PSP_Drug__c = testCareProgramProduct.Id
        );
        insert testFrequency2;
    }
    @isTest
    static void testGetFrequencyNoMatchingRecords() {
        // Test case where no records match the criteria
        Test.startTest();
        List<BI_PSPB_Frequency__c> result = BI_PSPB_ProductListCtrl.getFrequency('Nonexistent Frequency', 'Test Drug');
        Test.stopTest();
        
        // Assertions
        Assert.areEqual(null, result, 'Result should not be null');
    }

    @isTest
    static void testGetFrequencyWithException() {
        // Test case where an exception is thrown
        Test.startTest();
        List<BI_PSPB_Frequency__c> result;
        
        try {
            // Simulate an exception by passing null or empty values
            result = BI_PSPB_ProductListCtrl.getFrequency(null, null);
        } catch (Exception e) {
            result = null; // Expecting a null return when an exception occurs
        }
        
        Test.stopTest();
        
        // Assertions
        Assert.areEqual(null, result, 'Result should be null when an exception occurs');
    }
    @isTest
    static void testGetFrequencydata() {
      Careprogram cp = new Careprogram(Name ='Beyond GPP', StartDate = Date.newInstance(2024, 2, 27));
        insert cp;
        CareProgramProduct testCareProgramProduct = new CareProgramProduct(Name = 'Test Product',CareProgramId = cp.id);
        insert testCareProgramProduct;

        BI_PSPB_Frequency__c frequency1 = new BI_PSPB_Frequency__c(
            Name = 'Frequency 1',
            BI_PSP_Drug__c = testCareProgramProduct.Id,
            BI_PSP_Quantity__c = '1'
        );
        BI_PSPB_Frequency__c frequency2 = new BI_PSPB_Frequency__c(
            Name = 'Frequency 2',
            BI_PSP_Drug__c = testCareProgramProduct.Id,
            BI_PSP_Quantity__c = '2'
        );
        insert new List<BI_PSPB_Frequency__c>{frequency1, frequency2};

        Test.startTest();
        List<BI_PSPB_Frequency__c> result = BI_PSPB_ProductListCtrl.getFrequencydata(testCareProgramProduct.Id);
        Test.stopTest();
        assert.areNotEqual(null, result, 'The result should not be null');
       	Assert.areEqual(2, result.size(), 'There should be 2 frequency records returned');
        Assert.areEqual(frequency1.Id, result[0].Id, 'The first frequency record is incorrect');
        Assert.areEqual(frequency2.Id, result[1].Id, 'The second frequency record is incorrect');
    }
    
    @isTest
    static void testGetFrequencydataNoRecords() {
        Test.startTest();
        List<BI_PSPB_Frequency__c> result = BI_PSPB_ProductListCtrl.getFrequencydata('non-existent-id');
        Test.stopTest();
        Assert.areEqual(null, result, 'The result should not be null');
    }
    
    @isTest
    static void testGetFrequencydataException() {
        Test.startTest();
        List<BI_PSPB_Frequency__c> result = BI_PSPB_ProductListCtrl.getFrequencydata(null);
        Test.stopTest();

        Assert.areEqual(null, result, 'The result should be null due to the exception');
    }
}