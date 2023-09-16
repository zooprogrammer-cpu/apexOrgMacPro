public with sharing class SalesforceConnect {
    public static void getCasesFromSalesforceOrgB() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'callout:SFDCB/services/apexrest/CasesTest'
        );
        request.setMethod('GET');
        // request.setHeader('Authorization', 'Bearer !AR0AQPIbcA0irnhhPP9u1IlcYLrxeVtBW9iYwcqgbCt0C2ctNLJwyZokk3.tW8Ym8VPYhVFjS5aYw9bvNtEYKSZJ_XwMGmTM');
        HttpResponse response = http.send(request);
        System.debug('response code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200) {
            System.debug('response' + response.getBody());
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for (Object result : results) {
                Map<String, Object> caseProps = (Map<String, Object>) result;
                System.debug('CaseNumber:' + caseProps.get('CaseNumber') 
                            + 'Subject:' + caseProps.get('Subject'));
            }
        }
      }
      public static void createCasesInSalesforceOrgB() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'callout:SFDCB/services/apexrest/CasesTest'
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json; charset=UTF-8');
        request.setBody('{"subject":"Case from Salesforce Org A","status":"New","origin":"Web","priority":"Medium"}');
        HttpResponse response = http.send(request);
        System.debug('response code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200) {
            System.debug('response' + response.getBody());
        }
      }
      // method to send each new created case in Org A to Org B
      @future (callout = true)
      public static void sendCasesToSalesforceOrgB(Id caseId) {
        Case caseToSend = [SELECT Id, Origin, Priority, Subject FROM Case WHERE Id=:caseId];
        Map<String, String> caseMap = new Map<String, String>();
        caseMap.put('subject', caseToSend.Subject);
        caseMap.put('origin', caseToSend.Origin);
        caseMap.put('priority', caseToSend.Priority);
        
        String jsonString = JSON.serialize(caseMap);
        System.debug('jsonString:' + jsonString);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'callout:SFDCB/services/apexrest/CasesTest'
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json; charset=UTF-8');
        request.setBody(jsonString);
        HttpResponse response = http.send(request);
        System.debug('response code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200) {
            System.debug('response' + response.getBody());
        }
      }
}