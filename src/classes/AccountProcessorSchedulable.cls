/**
 * 
 */

public with sharing class AccountProcessorSchedulable implements Schedulable {
    public void execute(SchedulableContext context) {
        AccountProcessor.processInactiveAccounts();
    }
}