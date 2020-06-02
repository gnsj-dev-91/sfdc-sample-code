({
  queryAccountFieldsMethod : function(component) {
    // Call class's method 'accountResults' to get accounts
    var action = component.get("c.accountResults");

    action.setCallback(this,function(response){
      var state = response.getState();
      if(state === "SUCCESS"){
        // Set the value in Account datatable
        component.set("v.accountList", response.getReturnValue());
      } else {
        console.error("Failed with state: " + state);
      }
    });

    $A.enqueueAction(action);
  }
})
