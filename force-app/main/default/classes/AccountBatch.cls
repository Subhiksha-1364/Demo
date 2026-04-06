public class AccountBatch implements Database.Batchable<sObject>,DataBase.Stateful {
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        //string query = 'Select Id, Industry,Rating From Account Where Industry =null';
          string query = 'Select Id, Industry,AnnualRevenue From Account  Where Industry !=null';

        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc,List<Account> scope)
    {
        Set<string> indlist = new Set<String>();
        
        for(Account acc : scope)
        {
            // acc.Industry = 'Chemicals';
            // acc.Rating = 'Hot';
            
            indList.add(acc.Industry);
            
        }
        
        List<AggregateResult> arlist = [Select Sum(AnnualRevenue)ar,Industry From Account Where Industry in:indList Group By Industry];
        
        for(AggregateResult agres : arList)
        {
            system.debug(agres.get('ar'));
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