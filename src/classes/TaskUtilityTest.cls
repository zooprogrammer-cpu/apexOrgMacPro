@isTest
public class TaskUtilityTest {
    @isTest
    public static void TestHigh() {
        String priority; 
        priority = TaskUtility.getTaskPriority('US'); 
        System.assertEquals('High', priority, 'Priority for US is not returned as High');
    }
    @isTest
    public static void testNull() {
        String priority; 
        priority = TaskUtility.getTaskPriority('USA');
        System.assertEquals(null, priority, 'Priority should have been null');     
    }
    @isTest
    public static void testNormal() {
        String priority; 
        priority = TaskUtility.getTaskPriority('MX');
        System.assertEquals('Normal', priority, 'Priority for other countries have been Normal');     
    }
}