@isTest
private class ApexSimpleContinuationPassingDataTest {
    // Case 1: Valid HttpRequest using a continuation
    @isTest
    private static void validRequest(){
      String mockReponseBody = 'TestBodyResponse';

      Test.startTest();
      Continuation con =
        (Continuation) ApexSimpleContinuationPassingData.startContinuation();
      Test.stopTest();

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
      response.setBody(mockReponseBody);

      Test.setContinuationResponse(
        ApexSimpleContinuationPassingData.continuationLabel,
        response
      );

      List<String> labels = new List<String>{
        ApexSimpleContinuationPassingData.continuationLabel
      };

      String result =
        (String) ApexSimpleContinuationPassingData.continuationCallback(
          labels,
          ApexSimpleContinuationPassingData.continuationState
        );

      System.assertEquals(
        true,
        result.contains(mockReponseBody),
        'Continuation failed: response body not valid');
    }

    // Case 2: Exception caused by a problem with the continuation
    @isTest
    private static void exceptionContinuation(){
      Continuation con
        = (Continuation) ApexSimpleContinuationPassingData.startContinuation();

      // Verify that the continuation has the correct number of requests
      Map<String, HttpRequest> requests = con.getRequests();
      System.assertEquals(
        1,
        requests.size(),
        'The number of requests associated to the Continuation is not correct'
      );

      // Create a mock response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(2000);
      Test.setContinuationResponse(
        ApexSimpleContinuationPassingData.continuationLabel,
        response
      );

      List<String> labels =
        new List<String>{ApexSimpleContinuationPassingData.continuationLabel};

      Boolean exceptionThrown = false;
      try {
        String result =
          (String) ApexSimpleContinuationPassingData.continuationCallback(
            labels,
            ApexSimpleContinuationPassingData.continuationState
          );
      } catch (AuraHandledException ex) {
        exceptionThrown = true;
      }

      System.assertEquals(
        true,
        exceptionThrown,
        'Failed to catch Continuation Exception'
      );
    }

    // Case 3: Exception caused by a bad HTTP request
    @isTest
    private static void exceptionHTTP(){
      Continuation con
        = (Continuation) ApexSimpleContinuationPassingData.startContinuation();

      // Verify that the continuation has the correct number of requests
      Map<String, HttpRequest> requests = con.getRequests();
      System.assertEquals(
        1,
        requests.size(),
        'The number of requests associated to the Continuation is not correct'
      );

      // Create a mock response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(400);
      Test.setContinuationResponse(
        ApexSimpleContinuationPassingData.continuationLabel,
        response
      );

      List<String> labels
        = new List<String>{ApexSimpleContinuationPassingData.continuationLabel};

        Boolean exceptionThrown = false;
        try {
          String result =
            (String) ApexSimpleContinuationPassingData.continuationCallback(
              labels,
              ApexSimpleContinuationPassingData.continuationState
            );
        } catch (AuraHandledException ex) {
          exceptionThrown = true;
        }

        System.assertEquals(
          true,
          exceptionThrown,
          'Failed to catch Http Request Exception'
        );
    }
}
