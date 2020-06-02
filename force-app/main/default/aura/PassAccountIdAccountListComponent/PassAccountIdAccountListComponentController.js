({
  doInit : function(component, event, helper) {
    helper.queryAccountFieldsMethod(component);
  },

  handleClick : function(component, event, helper){
    var accountId = event.getSource().get('v.name'); console.log(accountId);
    component.set('v.checkButtonId', accountId);

    var evt = $A.get("e.c:PassAccountIdEvent");
    evt.setParams({ "Pass_AccountId": accountId});
    evt.fire();
  }
})
