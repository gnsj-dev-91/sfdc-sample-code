public with sharing class PassAccountIdController {
  //Method to get all accounts related to search keyword
  @AuraEnabled
  public static List<Account> accountResults(){
    List<Account> accountList = [SELECT Id,
                                        Name,
                                        Phone,
                                        Industry,
                                        Website
                                        FROM Account
                                        LIMIT 5000];
    return accountList;
  }

  //Method to get all Contacts related to selected account
  @AuraEnabled
  public static List<Contact> getContactsList(Id recordId){
      List<Contact> contactList = [SELECT Id,
                                          FirstName,
                                          LastName,
                                          Name
                                          FROM Contact
                                          WHERE AccountId=: recordId ];
      return contactList;
  }
}
