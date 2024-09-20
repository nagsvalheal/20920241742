/*
 * @description   This is a Test class for the BI_PSPB_ProfileManagerConstant Apex Class 
 * History:
 * Version    Author        Date        Detail           Description
 * 1.0        NandhaKumar   14-Aug-2024  Created          Initial development
 */
@isTest
public class BI_PSPB_ProfileManagerConstantTest {
     /**
     * @method testProfileManagerConstCtrl
     * @description Tests various constants and labels in the BI_PSPB_ProfileManagerConstant class. 
     * This method asserts that all constants are properly initialized and not empty.
     * It ensures that the labels and settings used in the controller are correctly set.
     */
    @isTest
    static void testProfileManagerConstCtrl() {
        
        Test.startTest();
        
        
        String appName = BI_PSPB_ProfileManagerConstant.applicationName;
        String recordNotFound = BI_PSPB_ProfileManagerConstant.recordCannotFound;
        String recordCannotUpdate = BI_PSPB_ProfileManagerConstant.recordCannotUpdate;
        String activeStatus = BI_PSPB_ProfileManagerConstant.active;
        String inactiveStatus = BI_PSPB_ProfileManagerConstant.inActive;
        String userName = BI_PSPB_ProfileManagerConstant.userName;
        String userEmail = BI_PSPB_ProfileManagerConstant.userEmail;
        String logSeverityError = BI_PSPB_ProfileManagerConstant.LOG_SEVERITY_ERROR;
        String caseRecordType = BI_PSPB_ProfileManagerConstant.caseRecordType;
        String deletionReq = BI_PSPB_ProfileManagerConstant.deletionReq;
        String highPriority = BI_PSPB_ProfileManagerConstant.high;
        String insertError = BI_PSPB_ProfileManagerConstant.insertError;
        String accountMessage = BI_PSPB_ProfileManagerConstant.accountMessage;
        String caseDelete = BI_PSPB_ProfileManagerConstant.caseDelete;
        String accessReq = BI_PSPB_ProfileManagerConstant.accessReq;
        String mediumPriority = BI_PSPB_ProfileManagerConstant.medium;
        String caseAccess = BI_PSPB_ProfileManagerConstant.caseAccess;
        String email = BI_PSPB_ProfileManagerConstant.email;
        String errorForThrow = BI_PSPB_ProfileManagerConstant.errorForThrow;
        String errorForAccount = BI_PSPB_ProfileManagerConstant.errorForAccount;
        String errorForUpdate = BI_PSPB_ProfileManagerConstant.errorForUpdate;
        String errorUpdateCpe = BI_PSPB_ProfileManagerConstant.errorUpdateCpe;
        String errorGettingEcg = BI_PSPB_ProfileManagerConstant.errorGettingEcg;

        // Assert that the settings are retrieved and that the applicationName is set correctly
        if (BI_PSPB_ProfileManagerConstant.settings != null) {
            assert.areNotEqual('', appName, 'Application name should be initialized from settings.');
        }

        // Assert that the labels are not null
        assert.areNotEqual('', recordNotFound, 'Label for Record Not Found should be initialized.');
        assert.areNotEqual('', recordCannotUpdate, 'Label for Record Cannot Update should be initialized.');
        assert.areNotEqual('', activeStatus, 'Label for active status should be initialized.');
        assert.areNotEqual('', inactiveStatus, 'Label for inactive status should be initialized.');
        assert.areNotEqual('', logSeverityError, 'Label for log severity error should be initialized.');
        assert.areNotEqual('', caseRecordType, 'Label for case record type should be initialized.');
        assert.areNotEqual('', deletionReq, 'Label for deletion request should be initialized.');
        assert.areNotEqual('', highPriority, 'Label for high priority should be initialized.');
        assert.areNotEqual('', insertError, 'Label for insert error should be initialized.');
       assert.areNotEqual('', accountMessage, 'Label for account message should be initialized.');
        assert.areNotEqual('', caseDelete, 'Label for case delete should be initialized.');
        assert.areNotEqual('', accessReq, 'Label for access request should be initialized.');
        assert.areNotEqual('', mediumPriority, 'Label for medium priority should be initialized.');
        assert.areNotEqual('', caseAccess, 'Label for case access should be initialized.');
        assert.areNotEqual('', errorForThrow, 'Label for error for throw should be initialized.');
        assert.areNotEqual('', errorForAccount, 'Label for error for account should be initialized.');
        assert.areNotEqual('', errorForUpdate, 'Label for error for update should be initialized.');
        assert.areNotEqual('', errorUpdateCpe, 'Label for error update CPE should be initialized.');
        assert.areNotEqual('', errorGettingEcg, 'Label for error getting ECG should be initialized.');

        // Assert that the user information is initialized
        assert.areNotEqual('', userName, 'User name should be initialized.');
        assert.areNotEqual('', userEmail, 'User email should be initialized.');
        assert.areNotEqual('', email, 'Email should be initialized.');
        
        Test.stopTest();
    }
}