trigger CasesTrigger on Case (before insert,before update,after update) {
    
    //new CaseHandler();
    
    new CaseHandler().handler();
    
    
    
    

}