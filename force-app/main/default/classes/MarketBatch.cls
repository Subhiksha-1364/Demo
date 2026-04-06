public class MarketBatch implements Database.Batchable<sObject>,DataBase.Stateful  {
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'Select Id,Name,Market__c,Market_Code__c From Store__c Where Market_Code__c != null';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Store__c> scope)
    {
        Set<String> mCodes = new Set<String>();
         List<Market__c> insertList = new List<Market__c>();
        Map<String,Id> marketMap = new Map<String,Id>();
        List<Market__c> marketList = new list<Market__c>();
        
        for(Store__c mkt : scope)
        {
            mCodes.add(mkt.Market_Code__c);
            
           
        }
        marketList = [Select Id,Name from Market__c where Name in: Mcodes];
        
      
        for(Market__c mc : marketList)
        {
            marketMap.put(mc.Name,mc.Id);
        }
        
         for(String mkt : Mcodes)
         {
             if(!marketMap.containsKey(mkt))
             {
                 insertList.add(new Market__c(Name = mkt));
               
             }
           
         }
        
        if(!insertList.isEmpty())
            insert insertList;
        
        for(Market__c ins : insertList)
        {
            MarketMap.put(ins.Name,ins.Id);
        }
        
        system.debug(insertList);
        
        for(Store__c mkt : scope)
        {
            if(MarketMap.containsKey(mkt.Market_Code__c))
            {
                mkt.Market__c = MarketMap.get(mkt.Market_Code__c);
            }
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
        
      /*  system.debug(RecordProcessed);
        system.debug(RecordFailed);
        system.debug(failedRecLink);*/
        
    }
    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob apxJob =[Select Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors
                              From AsyncApexJob Where Id =: bc.getJobId()]; 
        
        String ToAddress = 'subhiksha1364@gmail.com';
        String Subject = 'Summary of Batch records';
        String Body = 'Hi Admin, </br>';
        body+= 'Total Jobs :: '+apxJob.TotalJobItems;
        body+= '<br/> Total Errors :: '+apxJob.NumberOfErrors;
        body+= '<br/> Records Processed :: '+RecordProcessed;
        body+= '<br/> Records Failed :: '+RecordFailed;
        
        for(String ids : failedRecLink)
           body+= '<br/> Records Failed Link  :: '+ids; 
        
        EmailHelper.sendMail(Subject,Body,ToAddress);
                

        
        
    }
    
    
    
}