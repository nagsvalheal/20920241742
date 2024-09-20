@isTest
public class BI_PSPB_QuestionsDaysCountQueryCtrlTest {
    @isTest
    static void testFetchDlqiCount() {
        Test.startTest();
        Integer dlqiCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchDlqiCount();
        Test.stopTest();
        Assert.areEqual(0, dlqiCount, 'The DLQI count should be 0.');
    }
    @isTest
    static void testFetchPssCount() {
        Test.startTest();
        Integer pssCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchPssCount();
        Test.stopTest();
        Assert.areEqual(0, pssCount, 'The PSS count should be 0.');
    }
    @isTest
    static void testFetchWpaiCount() {
        Test.startTest();
        Integer wpaiCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchWpaiCount();
        Test.stopTest();
        Assert.areEqual(0, wpaiCount, 'The WPAI count should be 0.');
    }
    @isTest
    static void testFetchQsqCount() {
        Test.startTest();   
        Integer qsqCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchQsqCount();
        Test.stopTest();
        Assert.areEqual(0, qsqCount, 'The QSQ count should be 0.');
    }
    @isTest
    static void testFetchQsqTwoCount() {
        Test.startTest();
        Integer qsqTwoCount = BI_PSPB_QuestionsDaysCountQueryCtrl.fetchQsqTwoCount();
        Test.stopTest();
        Assert.areEqual(2, qsqTwoCount, 'The QSQ Two count should be 0.');
    }
}