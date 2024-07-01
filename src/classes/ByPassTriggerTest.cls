@IsTest
private class ByPassTriggerTest {
    @IsTest
    static void testbypass() {
        Map<String, Custom_Switch__mdt > allbypassdata = Custom_Switch__mdt.getAll();
        String triggerName = 'Test Trigger Name';
        String currentUserName = 'User A';
        BypassTrigger.bypass(triggerName, currentUserName);

    }
}