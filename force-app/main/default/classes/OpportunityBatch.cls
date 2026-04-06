public class OpportunityBatch implements Database.Batchable<sObject>,DataBase.Stateful {
    
      
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'Select Id, CloseDate,Follow_Up__c From Opportunity Where CloseDate =THIS_MONTH';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc,List<Opportunity> scope)
    {
        for(Opportunity opp : scope)
        {
            opp.Follow_Up__c = true;
        }
        
        List<DataBase.SaveResult>Result = DataBase.update (scope,false);
        
        for(DataBase.SaveResult res : Result)
        {
            if(res.isSuccess())
            {
                RecordProcessed +=1;
            }
            else
            {
                RecordFailed+=1;
                failedRecLink.add(url.getOrgDomainUrl().toExternalForm()+'/'+res.getId()); 
            }
            
        }
        
        system.debug(RecordProcessed);
        system.debug(RecordFailed);
        system.debug(failedRecLink);
        
    }
    
    public void finish(Database.BatchableContext bc)
    {
        List<AsyncApexJob> apxJob =[Select Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors
                                    From AsyncApexJob Where Id =: bc.getJobId()]; 
        
        system.debug(apxJob);
    }
    
    
    
    
    


}