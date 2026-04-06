trigger CustomerTrigger on Customer__c (after insert,after update,before delete,after undelete) {
    
    new CustomerTriggerHandler();
    
   CustomerTriggerHandler.doHandler();

}