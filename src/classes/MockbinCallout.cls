/**
 * 
 */

public with sharing class MockbinCallout {
    @InvocableMethod(Label ='Do HttpPost Callout' Callout=true)
    public static List<String> doPost(List<String>inputs) {
        List<String> results = new List<String>();
        for (String input : inputs) {
            results.add(invoke(input));
        }
        return results;

    }

    private static String  invoke(String input) {
        HttpRequest req= new HttpRequest();
        req.setEndpoint('callout:Mockbin' + '/e97ef814cff5493fa785f6e90f7f58ba');
        req.setMethod('POST');
        req.setBody(input);
        req.setHeader('content-type', 'text/plain');
        Http h = new Http();
       HttpResponse res =  h.send(req);
        return res.getBody();

    }
}