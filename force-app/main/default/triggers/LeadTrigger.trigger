trigger LeadTrigger on Lead (before insert,before update,after insert) {
    
    
     new LeadTriggerHandler();
    
   LeadTriggerHandler.handlerCase();
  
}