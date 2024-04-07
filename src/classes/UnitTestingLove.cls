public with sharing class UnitTestingLove {
    public static Integer sum(Integer a, Integer b) {
        if (a == null || b == null) {
            throw new OperationNotPermittedException('Param is null');
        }

        return a + b;
    }

    public static Boolean verifyAccountIsActive(Contact ctc) {
        if (ctc.Account.Active__c == 'Yes') {
            return true;
        }
        return false;
    }

}