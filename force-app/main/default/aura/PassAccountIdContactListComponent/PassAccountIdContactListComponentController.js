({
    getAccountIdFromApplicationEvent : function(component, event, helper) {
      var accountId = event.getParam("Pass_AccountId");
      console.log('received: ' + accountId);
      helper.accountContactMethod(component,accountId);
    }
})
