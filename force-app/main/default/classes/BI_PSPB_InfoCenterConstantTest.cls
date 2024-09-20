/**
* @description This test class validates that the custom labels in the BI_PSPB_InfoCenterConstant class 
*              are correctly referenced and match the expected values.
* History:
* Version	Author			Date			Detail				Description
* 1.0		Angelin Irin	31-Jul-2024		Created				Initial development
*/
@isTest
private class BI_PSPB_InfoCenterConstantTest {

    /**
     * @description This method tests the custom labels in BI_PSPB_InfoCenterConstant to ensure they 
     *              match the expected values defined in the Salesforce setup.
     */
    @isTest
    static void testInfoCenterConstantCtrl() {
       
        Assert.areEqual('en_US', BI_PSPB_InfoCenterConstant.usEnglish, 'usEnglish custom label does not match');
        Assert.areEqual('news', BI_PSPB_InfoCenterConstant.cmsNews, 'cmsNews custom label does not match');
        Assert.areEqual('BI_PSPB_Branded', BI_PSPB_InfoCenterConstant.channelName, 'channelName custom label does not match');
        
        Assert.areEqual('Error retrieving cms news data', BI_PSPB_InfoCenterConstant.errorCmsNewsRetrieve, 'errorCmsNewsRetrieve custom label does not match');
        Assert.areEqual('Error in retrieving cms channel Id', BI_PSPB_InfoCenterConstant.errorCmsChannelIdRetrieve, 'errorCmsChannelIdRetrieve custom label does not match');
        Assert.areEqual('Error in retrieving cms news banner image and description', BI_PSPB_InfoCenterConstant.errorCmsNewsImageRetrieve, 'errorCmsNewsImageRetrieve custom label does not match');
        Assert.areEqual('Article parameter should not be null or blank.', BI_PSPB_InfoCenterConstant.articleParameterError, 'articleParameterError custom label does not match');
        
        Assert.areEqual('Insertion Failed', BI_PSPB_InfoCenterConstant.errorInsertLabel,'errorInsertLabel custom label does not match');
        Assert.areEqual('There was an error retrieving the article like or dislike response for the current user.', BI_PSPB_InfoCenterConstant.errorRetrieveLike, 'errorRetrieveLike custom label does not match');
        Assert.areEqual('Like', BI_PSPB_InfoCenterConstant.errorLikeLabel,'errorLikeLabel custom label does not match');
        Assert.areEqual('Dislike', BI_PSPB_InfoCenterConstant.errorDislikeLabel, 'errorDislikeLabel custom label does not match');
        Assert.areEqual('View', BI_PSPB_InfoCenterConstant.viewLabel, 'viewLabel custom label does not match');
    }
}