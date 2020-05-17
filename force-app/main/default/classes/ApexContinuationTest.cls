@isTest
private class ApexContinuationTest {

  // Case 1: Valid HttpRequest using a Continuation
  @isTest
  private static void validHttpRequest() {
    String mockResponseBody = 'success response';

    Test.startTest();
      Continuation con =
        (Continuation) ApexContinuation.startContinuation();

      // Verify that the continuation has the correct number of requests
      Map<String, HttpRequest> requests = con.getRequests();
      System.assertEquals(
        1,
        requests.size(),
        'The number of requests associated to the Continuation is not correct'
      );

      // Create a mock response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(200);
      response.setBody(mockResponseBody);

      // Assign the mock response to the variable created for testing
      // - for keeping the reference to the correct Continuation
      Test.setContinuationResponse(
        ApexContinuation.continuationState,
        response
      );

      String result = (String) ApexContinuation.continuationCallback(
        ApexContinuation.continuationState
      );
    Test.stopTest();

    System.assertEquals(
      mockResponseBody,
      result,
      'Continuation failed: response body not valid'
    );
  }

  // Case 2: Exception caused by a problem with the continuation server
  @isTest
  private static void exceptionContinuation(){
    Test.startTest();
      Continuation con = (Continuation) ApexContinuation.startContinuation();

      // Verify that the continuation has the correct number of requests
      Map<String, HttpRequest> requests = con.getRequests();
      System.assertEquals(
        1,
        requests.size(),
        'The number of requests associated to the continuation is not correct'
      );

      // Create a mock response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(2000);
      Test.setContinuationResponse(
        ApexContinuation.continuationState,
        response
      );

      Boolean execeptionThrow = false;
      try {
        Object result = ApexContinuation.continuationCallback(
          ApexContinuation.continuationState
        );
      } catch (AuraHandledException ex) {
        execeptionThrow = true;
      }
    Test.stopTest();

    System.assert(execeptionThrow, 'Failed to catch continuation exception');
  }

  // Case 3: Exception caused by a bad http response
  @isTest
  private static void exceptionHttp(){
    Test.startTest();
      Continuation con = (Continuation) ApexContinuation.startContinuation();

      // Verify that the continuation has the correct number of requests
      Map<String, HttpRequest> requests = con.getRequests();
      System.assertEquals(
        1,
        requests.size(),
        'The number of requests associated to the continuation is not correct'
      );

      // Create a mock response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(400);
      Test.setContinuationResponse(
        ApexContinuation.continuationState,
        response
      );

      Boolean exceptionThrown = false;
      try {
        Object result = ApexContinuation.continuationCallback(
          ApexContinuation.continuationState
        );
      } catch( AuraHandledException e ) {
        exceptionThrown = true;
      }
      Test.stopTest();

      System.assert(
        exceptionThrown,
        'Failed to catch HTTP request exception'
      );
  }
}
