({
  accountContactMethod : function(component, accountId) {
    var action = component.get("c.getContactsList");
    action.setParams({
        "recordId" : accountId
    });

    action.setCallback(this,function(response){
      var state  = response.getState();
      if(state == "SUCCESS"){
          // Set the value in Contact List
          component.set("v.contactList", response.getReturnValue());
          if(response.getReturnValue().length == 0){
              alert('There are no contacts');
          }
      }else{
          console.error("Failed with state: " + state);
      }
    });
    $A.enqueueAction(action);
  }
})
