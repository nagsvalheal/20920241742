@isTest
/** 
* @description       : This is a BI_PSPB_EnrollmentWrapperTest test class designed to test the functionality of the BI_PSPB_EnrollmentWrapper class,
* History:
* Version  Author      Date            Detail          Description
* 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrollmentWrapperTest {

    @isTest
    static void testDataWrapper() {
        // Create an instance of the DataWrapper class
        BI_PSPB_EnrollmentWrapper.DataWrapper dataWrapper = new BI_PSPB_EnrollmentWrapper.DataWrapper();
        
        // Set values to the fields
        dataWrapper.firstName = 'John';
        dataWrapper.lastName = 'Doe';
        dataWrapper.email = 'john.doe@example.com';
        dataWrapper.phone = '1234567890';
        dataWrapper.city = 'San Francisco';
        dataWrapper.street = '123 Main St';
        dataWrapper.country = 'US';
        dataWrapper.state = 'CA';
        dataWrapper.code = '94105';
        dataWrapper.sex = 'Male';
        dataWrapper.dob = '1980-01-01';
        dataWrapper.relation = 'Brother';
        dataWrapper.caregiverId = '123456789012345678';
        dataWrapper.prefferedMethodOfCom = 'Email';

        BI_PSPB_EnrollmentWrapper.HcpWrapper hcpWrapper = new BI_PSPB_EnrollmentWrapper.HcpWrapper();
        hcpWrapper.practice = 'General Practice';
        hcpWrapper.type = 'Type A';
        hcpWrapper.lisence = 'AB123456';
        hcpWrapper.drug = 'TestDrug';
        hcpWrapper.unit = 'mg';
        hcpWrapper.frequency = 2;
        hcpWrapper.addressLine = 'Line 1';
        // Validate the values
        Assert.areEqual('John', dataWrapper.firstName, 'First name should be John');
        Assert.areEqual('Doe', dataWrapper.lastName, 'Last name should be Doe');
        Assert.areEqual('john.doe@example.com', dataWrapper.email, 'Email should be john.doe@example.com');
        Assert.areEqual('1234567890', dataWrapper.phone, 'Phone number should be 1234567890');
        Assert.areEqual('General Practice', hcpWrapper.practice, 'Practice should be General Practice');
        Assert.areEqual('Type A', hcpWrapper.type, 'Type should be Type A');
        Assert.areEqual('AB123456', hcpWrapper.lisence, 'License number should be AB123456');
        Assert.areEqual('San Francisco', dataWrapper.city, 'City should be San Francisco');
        Assert.areEqual('123 Main St', dataWrapper.street, 'Street should be 123 Main St');
        Assert.areEqual('US', dataWrapper.country, 'Country should be US');
        Assert.areEqual('CA', dataWrapper.state, 'State should be CA');
        Assert.areEqual('94105', dataWrapper.code, 'Postal code should be 94105');
        Assert.areEqual('Male', dataWrapper.sex, 'Sex should be Male');
        Assert.areEqual('1980-01-01', dataWrapper.dob, 'Date of birth should be 1980-01-01');
        Assert.areEqual('Brother', dataWrapper.relation, 'Relation should be Brother');
        Assert.areEqual('TestDrug', hcpWrapper.drug, 'Drug should be TestDrug');
        Assert.areEqual('mg', hcpWrapper.unit, 'Unit should be mg');
        Assert.areEqual(2, hcpWrapper.frequency, 'Frequency should be 2');
        Assert.areEqual('123456789012345678', dataWrapper.caregiverId, 'Caregiver ID should be 123456789012345678');
        Assert.areEqual('Email', dataWrapper.prefferedMethodOfCom, 'Preferred method of communication should be Email');
        Assert.areEqual('Line 1', hcpWrapper.addressLine, 'Address line should be Line 1');
    }
}