@RestResource(urlMapping='/ContactAPI/*')
global with sharing class ContactAPI {

    @HttpPost
    global static String createContact(String firstName, String lastName, String email) {
        Contact newContact = new Contact(FirstName=firstName, LastName=lastName, Email=email);
        try {
            insert newContact;
            return 'Contact created with ID: ' + newContact.Id;
        } catch (DmlException e) {
            return 'Error: ' + e.getMessage();
        }
    }
}