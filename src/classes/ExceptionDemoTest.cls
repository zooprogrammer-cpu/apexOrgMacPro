@IsTest
private class ExceptionDemoTest {
    @IsTest
    static void testBehavior() {
        //GIVEN
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Amount = 2000;
        testOpp1.Name = 'Test Oppo 1';
        testOpp1.StageName = 'Prospecting';
        testOpp1.CloseDate = Date.today().addDays(14);
        oppsToInsert.add(testOpp1);

        Opportunity testOpp2 = new Opportunity();
        testOpp2.Amount = 500;
        testOpp2.Name = 'Test Oppo 2';
        testOpp2.StageName = 'Prospecting';
        testOpp2.CloseDate = Date.today().addDays(14);
        oppsToInsert.add(testOpp2);
        System.debug('oppsToInsert: ' + oppsToInsert);

        insert oppsToInsert;
        //WHEN
        try {
            Test.startTest();
            ExceptionDemo.updateOpp();
            Test.stopTest();
        } catch (Exception e) {
            // THEN
            Assert.isTrue(
                    e.getMessage().equalsIgnoreCase('no won opportunities'),
                    'Exception message does not match: ' + e.getMessage()
            );
        }

    }
}