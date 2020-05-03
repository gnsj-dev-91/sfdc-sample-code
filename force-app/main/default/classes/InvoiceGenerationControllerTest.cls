@isTest
private class InvoiceGenerationControllerTest {

  // our logic in inside the job class
  // this VF controller only calls the job execution
  @isTest
  private static void clickRunJobTest() {
    PageReference pageRef = Page.runinvoicegeneration;
    Test.setCurrentPage(pageRef);

    List<Order> orders = [SELECT Id FROM Order];

    ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(orders);
    InvoiceGenerationController controller = new InvoiceGenerationController(standardSetController);
    controller.runJob();
  }

}
