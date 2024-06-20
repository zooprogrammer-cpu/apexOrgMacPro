@RestResource(UrlMapping='/Account/contacts/*')
global class ExploreRestAccountController {
    //https://instance.salesforce.com/services/apexrest/Account/contacts/001xxxxx

    // When a callout is made to the endpoint above, if the method is GET, invoke this method
    @HttpGet
    global static Account doGet() {
        // In order to get the Id that the request is going to have from external platform,
        // let's use RestContext class. req is the actual request sent by nodeJs or PHP.
        // We are trying to grab the request. It will have headers, content type and everything else.
        RestRequest req = RestContext.request;
        System.debug('req.params: ' + req.params);
        System.debug('req.requestURI: ' + req.requestURI);
        System.debug('req.resourcePath: ' + req.resourcePath);
        // get the accId send in the request.
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        return [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id =: accId];
    }

    // When a callout is made to the endpoint above, if the method is POST, invoke this method
    @HttpPost
    global static void doPost(RequestWrapper requestPayload) {
        /*
        insert requestPayload.accountRecord;
        insert requestPayload.contactRecords;

        return requestPayload.accountRecord;
         */
        RestResponse res = RestContext.response;
        Account a = requestPayload.accountRecord;
        insert a;
        Contact[] c = requestPayload.contactRecords;
        insert c;

        if ( a!=null && c!= null) {
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(a));
        }
        else {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Something went wrong');

        }

    }

    // Wrapper class for complex parameters from third party
    global class RequestWrapper {
        Account accountRecord;
        Contact[] contactRecords;
    }

    @HttpDelete
    global static void toDelete() {
        RestRequest req = RestContext.request;
        String recordId =  req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        delete [SELECT Id FROM Account WHERE Id =: recordId];
        // Send response saying record got deleted. Can enhance this by actually checking if it got deleted.
        // No need to return anything since we are using RestResponse
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(recordId + ' got deleted');

    }

}
