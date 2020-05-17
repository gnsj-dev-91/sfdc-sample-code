// Apex Continuation Impletation Guide
// https://developer.salesforce.com/blogs/2020/05/apex-continuations-implementation-and-testing-in-aura-lwc.html
public with sharing class ApexSimpleContinuationPassingData {
  // Test variable used for holding a reference
  // to the Continuation Request
  @TestVisible
  private static String continuationLabel;

  // Test variable used for holding the value of the
  // Continuation.state attribute
  @TestVisible
  private static String continuationState;

  // Callout endpoint as a named credential URL
  // or, as shown here, as the long-running service URL
  private static final String LONG_RUNNING_SERVICE_URL =
    'https://jsonplaceholder.typicode.com/posts';

  @AuraEnabled(continuation=true cacheable=true)
  public static Object startContinuation(){
    // Create callout request
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(LONG_RUNNING_SERVICE_URL);

    // Create the continuation with a 40s timeout
    Continuation con = new Continuation(40);
    con.ContinuationMethod = 'continuationCallback';

    // Store the reference to the HttpRequest and make it
    // accessible for a test-context
    continuationLabel = con.addHttpRequest(req);

    // Store data to be sent to the callback function
    continuationState = 'Some data here...';
    con.state = continuationState;

    return con;
  }

  // The function that processes the continuation callback
  @AuraEnabled(cacheable=true)
  public static Object continuationCallback(
    List<String> labels,
    Object state
  ){
    HttpResponse response = Continuation.getResponse(labels[0]);
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
