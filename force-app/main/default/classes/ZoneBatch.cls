public class ZoneBatch implements Database.Batchable<sObject>,DataBase.Stateful {
    
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'Select Id,Name,SW_Zone__c,Zone_Code__c From Store__c Where Zone_Code__c != null';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Store__c> scope)
    {
        Set<String> zCodes = new Set<String>();
        List<Zone__c> insertList = new List<Zone__c>();
        Map<String,Id> zoneMap = new Map<String,Id>();
        List<Zone__c> zoneList = new list<Zone__c>();
        
        for(Store__c zt : scope)
        {
            zCodes.add(zt.Zone_Code__c);
        }
        
        zoneList = [Select Id,Name From Zone__c Where Name in:zCodes];
        
        for(Zone__c zn : zoneList)
            zoneMap.put(zn.Name,zn.Id);
        
        for(String zc : zCodes)
        {
            if(!zoneMap.containsKey(zc))
                insertList.add( new Zone__c(Name = zc));
            
        }
        if(!insertList.isEmpty())
            insert insertList;
        
        system.debug(insertList);
        
        for(Zone__c z : insertList)
        {
            zoneMap.put(z.Name,z.Id);
        }
        
        for(Store__c zt : scope)
        {
            if(zoneMap.containsKey(zt.Zone_Code__c))
            {
                zt.SW_Zone__c = zoneMap.get(zt.Zone_Code__c);
            }
        }
        system.debug(zoneMap);
        
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
    }
    
    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob apxJob =[Select Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors
                              From AsyncApexJob Where Id =: bc.getJobId()]; 
        
        String ToAddress = 'subhiksha1364@gmail.com';
        String Subject = 'Summary of Zone Batch records';
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