// https://github.com/afawcett/force-brf
@isTest
private class InvoiceGenerationJobTest {

  @isTest
  private static void ordersAreExecutedSuccessfully() {
    // Given
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    List<Order> testOrders = createSampleOrders(99, testAccount.Id);
    insert testOrders;

    // When
    Test.startTest();
      InvoiceGenerationJob.run();
    Test.stopTest();

    // Then (check if all orders now have an invoice)
    System.assertEquals(99, [SELECT Id FROM Order WHERE Invoiced__c = true].size());
    System.assertEquals(99, [SELECT Id FROM Invoice__c].size());
  }

  private static List<Order> createSampleOrders(Integer numOrders, Id accountId){
    List<Order> orders = new List<Order>();
    for(Integer orderIdx = 0; orderIdx < numOrders; orderIdx++) {
        Order order = new Order();
        order.Name = 'Ref:'+orderIdx;
        order.Status = 'Draft';
        order.EffectiveDate = System.today();
        order.AccountId = accountId;
        orders.add(order);
    }
    return orders;
  }

}
