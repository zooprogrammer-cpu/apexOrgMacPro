@RestResource(urlMapping='/FieldCase/*')
global with sharing class RESTCaseController {

    @HttpPost
    global static String createNewCase(List<String> companyName, String caseType) {

        return 'This is a test for '+companyName[0]+companyName[1]+caseType;
    }
}