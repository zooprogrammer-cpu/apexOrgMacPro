public with sharing class BasicApexScenarios {
  public static void subsidy() {
    Integer requiredYearsworked = 10;
    Integer yearsWorked = 0;
    final Decimal minAmount = 50000;
    final Decimal maxAmount = 80000;
    Decimal salary = 90000;
    Double rate;
    Decimal subsidy;
    if (salary <= minAmount) {
      rate = 7.5 / 100;
    } else if (salary >= minAmount && salary <= maxAmount) {
      rate = 5 / 100;
    } else
      rate = 2.5 / 100;
    subsidy = salary * rate;
    System.debug(subsidy);
  }

  public static void colorSwitch() {
    String color = 'purple';
    Decimal price = 0;
    System.debug('Baloon color is:' + color);
    System.debug('Price before switch: ' + price);

    switch on color {
      when 'gold dust', 'silver dust', 'sun burst' {
        price = 1.0;
      }
      when 'red', 'blue' {
        price = 0.75;
      }
      when else {
        price = 0.50;
      }
    }
    System.debug('The price after switch: ' + price);
  }

  public static void unknownSObject() {
    List<sObject> records = new List<sObject>();
    records.add([SELECT Id, Name FROM Account LIMIT 1]);
    records.add([SELECT Id, Name, Department FROM Contact LIMIT 1]);
    records.add([SELECT Id, Name, Description FROM Lead LIMIT 1]);
    System.debug('The SObject List Records are: ' + records);
    for (sObject record : records) {
      switch on record {
        when Account a {
          a.Type = 'External';
        }
        when Contact c {
          c.Department = 'Temporary';
        }
        when Lead l {
          l.Description = 'Auto';
        }
      }
    }
    if (!records.isEmpty()) {
      System.debug('Records after control flow: ' + records);
      update records;
    }
  }

  public static void governorLimits() {
    List<Opportunity> results = [SELECT Name, Description FROM Opportunity];
    System.debug('Batch of Opportunities: ' + results.size());

    for (Opportunity result : results) {
      if (String.isBlank(result.Description)) {
        result.Description = 'updated';
      }
    }

    System.debug('Current number of DML statements in this transaction: ' + Limits.getDmlStatements());
    System.debug('Total no of statements per transaction: ' + Limits.getLimitDmlStatements());
    if (Limits.getDmlStatements() < Limits.getLimitDmlStatements()) {
        update results;     
    } else{
      System.debug('Total no of statements per transaction is greater than: ' + Limits.getLimitDmlStatements());
    }
  }
  

  public static void testBranch() {
    System.debug('Testing this branch');  
  }
}