public class SoqlExample {
  // Hard coded SOQL Where Query
  public static List<Account> accountsByRevenueHardCoded() {
    List<Account> accounts = [
      SELECT Id
      FROM Account
      WHERE AnnualRevenue >= 10000
    ];
    System.debug(accounts);
    return accounts;
  }
  //Dynamic SOQL  with bind variable Where query
  public static List<Account> accountsByRevenue(Integer minRevenue) {
    List<Account> accounts = [
      SELECT Id
      FROM Account
      WHERE AnnualRevenue >= :minRevenue
    ];
    System.debug(accounts);
    return accounts;
  }
  // Anonymous to call accountsByRevenue method
  // SoqlExample.accountsByRevenue(5000);

  // another dynamic Database.query at runtime with bind variable
  public static List<Account> accountsByRevenueDynamic(Integer minRevenue) {
    List<Account> accounts;
    String query =
      'SELECT Id ' +
      ' FROM Account ' +
      ' WHERE AnnualRevenue >= :minRevenue';
    accounts = Database.query(query);
    System.debug(accounts);
    return accounts;
  }

  //bind varaibles as a list - get a list of contacts related to a list of accounts
  public static List<Contact> contactsFromAccounts(List<Account> accounts) {
    List<Contact> contacts = [
      SELECT Id
      FROM Contact
      WHERE AccountId IN :accounts
    ];
    System.debug(contacts);
    return contacts;
  }

  //query with parent references - just like in formulas
  public static List<Contact> childWithParents(Integer rowLimit) {
    List<Contact> contacts = [
      SELECT Name, Contact.Account.Name, CreatedBy.Name
      FROM Contact
      LIMIT :rowLimit
    ];
    return contacts;
  }

  // parent reference with bind variable
  public static List<Account> parentRecordReference(
    Account childAccount
  ) {
    List<Account> accounts = [
      SELECT Name
      FROM Account
      WHERE Id = :childAccount.Id
    ];
    return accounts;
  }

  //problematic dynamic query -cannot use dynamic query with parent reference dot notation
  public static List<Account> parentRecordReferenceDynamic(Account childAccount) {
    List<Account> accounts;
    String childAccountId = childAccount.Id;
    String query =
      'SELECT Name ' +
      ' FROM Account ' +
      ' WHERE Id = :childAccountId';
    accounts = Database.query(query);
    System.debug(accounts);
    return accounts;
  }

  //anonymous apex to run above
  // List<Account> children = [SELECT Id FROM Account WHERE ParentId != null];
  // System.debug(children);
  // if (!children.isEmpty()) {
  // //List<Account> result = SoqlExample.parentRecordReference(children[0]); //this works
  // List<Account> result = SoqlExample.parentRecordReferenceDynamic(children[0]); // this does not work since the method uses dynamic query with dot notation
  // System.debug('Result: ' + result);
  // }
}