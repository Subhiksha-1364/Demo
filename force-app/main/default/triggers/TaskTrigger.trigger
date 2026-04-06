trigger TaskTrigger on Task (after insert, After update,After delete,After undelete) {
    
   new TaskTriggerHandler();
    
   TaskTriggerHandler.handlerCase();
   
    
    
}