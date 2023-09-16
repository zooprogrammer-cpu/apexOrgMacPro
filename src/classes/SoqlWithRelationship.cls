public with sharing class SoqlWithRelationship {
  public static List<Account> parentWithChildren(
    Integer parentLimit,
    Integer childLimit
  ) {
    List<Account> accounts = [
      SELECT
        Name,
        AccountSource,
        (SELECT Name FROM Previous_Contacts__r LIMIT :childLimit)
      FROM Account
      LIMIT :parentLimit
    ];
    // for (Account nextAcct : accounts) {
    //   System.debug(nextAcct);
    // }
    //iterate through outer loop and any account that has child records,
    //we reference those child records as if they were a list of contacts

    for (Account nextAcct : accounts) {
      System.debug(nextAcct);
      for (Contact nextContact : nextAcct.Previous_Contacts__r) {
        System.debug('Contact Name: ' + nextContact.FirstName); // do whatever processing here
      }
    }

    return accounts;
  }

  // public static List <Account> processAccounts() {
  //   for (Account acc : [SELECT Id, Name FROM Acount]) {
  //       //do something here
  //   }
  // }

  public static List<Author__c> authorName() {
    List<Author__c> authors = [
      SELECT Id, Name, (SELECT Id, Name FROM Books__r)
      FROM Author__c
    ];
    for (Author__c author : authors) {
      System.debug(authors);
      for (Book__c book : author.Books__r) {
        System.debug('Book:'+ book);    
      }
    }
    return authors;
  }

  // public static List<Book__c> bookName() {
  //   List<Author__c> authors = [
  //     SELECT Id, Name, (SELECT Id, Name FROM Books__r)
  //     FROM Author__c
  //   ];
  //   for (Author__c author : authors) {
  //     System.debug(authors);
  //     for (Book__c book : author.Books__r) {
  //       System.debug('Book:'+ book);
  //     }
  //     return book;
  //   }
  //   // return author.Books__r;
  // }
}