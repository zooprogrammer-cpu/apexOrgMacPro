@IsTest
private class UnitTestingLoveTest {

    //TEST CASES for sum
    // 1. a =3, b =2 --> result 5

    @IsTest
    static void sum_happyPath_returnSum() {
        //GIVEN
        Integer a = 3;
        Integer b = 2;

        //WHEN
        Test.startTest();
        Integer sum = UnitTestingLove.sum(a,b);
        Test.stopTest();

        //THEN
        Assert.areEqual(a + b, sum);

    }
    // 2. a = null , b =2 --> throw exception
    // 3. a = 3, b = null --> throw exception
    @IsTest
    static void sum_aNullException() {
        //GIVEN
        Integer a = null;
        Integer b = 2;

        try {
            //WHEN
            Test.startTest();
            Integer sum = UnitTestingLove.sum(a,b);
            Test.stopTest();
            Assert.fail('Expected exception'); //REMEMBER THIS: make the test fail
        }
        catch (OperationNotPermittedException e) {
            // THEN
            Assert.isTrue(
                    e.getMessage().equalsIgnoreCase('Param is null'),
                    'Exception message does not match: ' + e.getMessage()
            );
        }

    }

    @IsTest
    static void verifyAccountActive_activeAccount_returnsTrue() {
        //GIVEN
        Account acc = new Account(Name='ACME', Active__c = 'Yes');
        acc.Id = '0014x00001MgOPaAAN';// can copy past from the org to mock an Id

        //insert acc; No need to insert
        Contact con = new Contact(FirstName = 'John', LastName = 'Snow');
        con.Account = acc;
        //insert con; No need to insert

        //WHEN
        Test.startTest();
        Boolean returned = UnitTestingLove.verifyAccountIsActive(con);
        Test.stopTest();
        //THEN
        Assert.isTrue(returned, 'Methods does not return true when it should');

    }

    @IsTest
    static void verifyAccountActive_inactiveAccount_returnsFalse() {
        //GIVEN
        Account acc = new Account(Name='KOAA', Active__c = 'No');

        //insert acc;
        Contact con = new Contact(FirstName = 'Barristan', LastName = 'Salvy');
        con.Account = acc;
        //insert con;

        //WHEN
        Test.startTest();
        Boolean returned = UnitTestingLove.verifyAccountIsActive(con);
        Test.stopTest();
        //THEN
        Assert.isFalse(returned, 'Method returns false when it should not');

    }



}