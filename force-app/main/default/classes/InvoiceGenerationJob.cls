/**
 * Job to generate invoices to given orders
 **/
public class InvoiceGenerationJob implements Database.Batchable<SObject> {
  public List<Order> start(Database.BatchableContext ctx) {
    return [SELECT Id FROM Order
            WHERE EffectiveDate = THIS_WEEK
            AND Invoiced__c != true
            ORDER by Name];
  }

  public void execute(Database.BatchableContext ctx, List<SObject> scope) {
    List<Invoice__c> invoices = new List<Invoice__c>();
    // Re-queries the records is a best practice
    // in order to avoid reading stale records provided within the scope parameter,
    // important for long running jobs.
    List<Order> orders = [SELECT  Id,
                                  TotalAmount,
                                  Invoiced__c,
                                  EffectiveDate,
                                  Name
                          FROM Order
                          WHERE Id IN :scope
                          AND Invoiced__c != true];
    for(Order order : orders) {
        produceSomeExceptions(order.Name, order.EffectiveDate);
        Invoice__c invoice = new Invoice__c();
        invoice.DueDate__c = System.today().addDays(30);
        invoice.Paid__c = false;
        invoice.Order__c = order.Id;
        invoice.Amount__c = order.TotalAmount;
        invoices.add(invoice);
        order.Invoiced__c = true;
    }
    insert invoices;
    update orders;
  }

  public void finish(Database.BatchableContext ctx) { }

  /*public void handleErrors(brf_BatchableError error) {
      // Update the effected orders with the error for further review
      List<String> orderIds = error.JobScope.split(',');
      List<Order> orders = [select Id from Order where Id in :orderIds];
      for(Order order : orders) {
          order.InvoiceGenerationError__c = error.Id;
      }
      update orders;
  }*/

  // Produce some exceptions, some catchable, some not...
  private void produceSomeExceptions(String orderName, Date orderDate) {
    if(orderDate != System.today()){
      return;
    }

    switch on orderName {
      when 'Ref:100' {
        // Standard exception
        throw new InvoiceGenerationException('Order Ref:100 is invalid.');
      }
      when 'Ref:300' {
        // Divide by zero!
        Integer newAmount = 20 / 0;
      }
      when 'Ref:500' {
        // Limits exception
        for(Integer idx=0; idx<201; idx++) {
          Order order = [SELECT Id FROM Order LIMIT 1];
        }
      }
    }
  }

  /**
   * InvoiceGenerationJob.run();
   **/
  public static Id run() {
    // Chunk size of 200 forces
    return Database.executeBatch(new InvoiceGenerationJob(), 200);
  }

  public class InvoiceGenerationException extends Exception {}
}
