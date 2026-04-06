public class LeadBatch implements Database.Batchable<sObject>,DataBase.Stateful {
    
    
    Integer RecordProcessed=0;
    Integer RecordFailed =0;
    list<String> failedRecLink = new List<String>();
    
    Id ceoId = '005gL00000DjzO1QAJ';
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'Select Id,LastActivityDate,Days_Since_Last_Activity__c,OwnerId From Lead Where Days_Since_Last_Activity__c>5';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Lead> scope)
    {
        Set<Id>idList =  new Set<Id>();
        
        for(Lead ld : scope)
        {
            idList.add(ld.OwnerId);
        }
        
        Map<Id,User> users = new Map<Id,User>([Select Id,ManagerId from User Where id in:idList]);
        
        for(Lead ld : scope)
        {
            User u = users.get(ld.OwnerId);
            
            if(u.ManagerId!= null)
            {
                ld.OwnerId= u.ManagerId;
            }
            else
            {
                ld.OwnerId = ceoId;
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
        
        system.debug(RecordProcessed);
        system.debug(RecordFailed);
        system.debug(failedRecLink);
        
    }
    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob apxJob =[Select Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors
                              From AsyncApexJob Where Id =: bc.getJobId()]; 
        
        String ToAddress = 'subhiksha1364@gmail.com';
        String Subject = 'Summary of Lead batch records';
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