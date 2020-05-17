public with sharing class ApexMultipleContinuation {
    // Test variable used for holding the values
    // of the Continuation.state requests
    @TestVisible
    private static String continuationLabel1;
    @TestVisible
    private static String continuationLabel2;

    // Callout endpoint as a named credential URL
    // or, as shown here, as the long-running service URL
    private static final String LONG_RUNNING_SERVICE_URL =
      'https://jsonplaceholder.typicode.com/posts';

    // The function to be called to fire the continuation
    @AuraEnabled(continuation=true cacheable=true)
    public static Object startContinuation(){
      // Create the callout request
      HttpRequest req1 = new HttpRequest();
      req1.setMethod('GET');
      req1.setEndpoint(LONG_RUNNING_SERVICE_URL);

      HttpRequest req2 = new HttpRequest();
      req2.setMethod('GET');
      req2.setEndpoint(LONG_RUNNING_SERVICE_URL);

      // Create the continuation with a 40s timeout
      Continuation con = new Continuation(40);
      con.ContinuationMethod = 'continuationCallback';

      // Store the references to the requests
      // and make them accessible for a test-context
      continuationLabel1 = con.addHttpRequest(req1);
      continuationLabel2 = con.addHttpRequest(req2);

      return con;
    }

    // The function that will process the callback of the continuation
    @AuraEnabled(cacheable=true)
    public static Object continuationCallback(
      List<String> labels,
      Object state
    ){
      // Get the response of the first HttpRequest
      HttpResponse response1 = Continuation.getResponse(labels[0]);
      Integer statusCode1 = response1.getStatusCode();
      // TODO: handle the different status codes for statusCode1

      // Get the response of the second HttpRequest
      HttpResponse response2 = Continuation.getResponse(labels[01]);
      Integer statusCode2 = response2.getStatusCode();
      // TODO: handle the different status codes for statusCode1

      return new List<String>{
        response1.getBody(),
        response2.getBody()
      };
    }
}
