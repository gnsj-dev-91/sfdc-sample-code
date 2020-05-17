// Apex Continuation Impletation Guide
// https://developer.salesforce.com/blogs/2020/05/apex-continuations-implementation-and-testing-in-aura-lwc.html
public with sharing class ApexContinuation {
  // Test variable used holding the value of the Continuation.state.
  // Because the property is static
  // there can be only request in the method.
  @TestVisible
  private static String continuationState;

  // Callout endpoint as a named credential URL
  // or, as shown here, as the long-running service URL
  private static final String LONG_RUNNING_SERVICE_URL =
    'https://jsonplaceholder.typicode.com/posts';

  // The function that fires the continuation
  @AuraEnabled(continuation=true cacheable=true)
  public static Object startContinuation(){
    // Create the callout request
    HttpRequest request = new HttpRequest();
    request.setMethod('GET');
    request.setEndpoint(LONG_RUNNING_SERVICE_URL);

    // Create the continuation with a 40s timeout
    Continuation continuation = new Continuation(40);
    continuation.ContinuationMethod = 'continuationCallback';

    // Store the HttpRequest and make it accessible
    continuationState = continuation.addHttpRequest(request);
    continuation.state = continuationState;

    return continuation;
  }

  // The function that processes the continuation callback
  @AuraEnabled(cacheable=true)
  public static Object continuationCallback(Object state) {
    // Get the response
    HttpResponse response = Continuation.getResponse((String) state);

    Integer statusCode = response.getStatusCode();
    if (statusCode == 200) {
      return response.getBody();
    } else if(statusCode >= 2000) {
      // Handle continutation-specific error codes
      // See <a href="https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm">https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm</a>
      throw new AuraHandledException('Continuation Error: ' + statusCode + ' - ' + response.getBody());
    } else {
      // Handle standard HTTP request errors
      throw new AuraHandledException('HTTP Request Error: ' + statusCode + ' - ' + response.getBody());
    }
  }

}
