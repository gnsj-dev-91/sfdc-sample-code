@isTest
private class PassAccountIdControllerTest {
  @TestSetup
  static void makeData(){
    Account acc = new Account();
    acc.Name = 'Test Account';
    insert acc;

    Contact con = new Contact();
    con.FirstName = 'Test';
    con.LastName = 'Contact';
    con.AccountId = acc.Id;
    insert con;
  }

  @isTest
  private static void verifyAccountTest(){
    Test.startTest();
      List<Account> result = PassAccountIdController.accountResults();
    Test.stopTest();

    System.assertEquals(
      1,
      result.size(),
      'There are no accounts'
    );
  }

  @isTest
  private static void verifyContactTest(){
    Account acc = [SELECT Id FROM Account LIMIT 1];

    Test.startTest();
      List<Contact> result = PassAccountIdController.getContactsList(acc.Id);
    Test.stopTest();

    System.assertEquals(
      1,
      result.size(),
      'There are no contacts'
    );
  }

}
