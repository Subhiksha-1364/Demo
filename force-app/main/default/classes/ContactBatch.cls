public class ContactBatch implements Database.Batchable<sObject>,DataBase.Stateful {
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    
    public iterable<sObject> start(Database.BatchableContext bc)
    {
        // string query = 'Select Id,Description,Phone  From Contact';
        
        // return Database.getQueryLocator(query);
        
        List<Contact> conList = [Select Id,Description,Phone  From Contact];
        
        return conList;
        
    }
    
    public void execute(Database.BatchableContext bc,List<Contact> scope)
    {
        for(Contact con : scope)
        {
            con.Phone = '123456789';
            con.Description = 'Updated by Batch';
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