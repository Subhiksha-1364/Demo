public class CaseHandler {
    
    
    public static List<Case> triggerNew ;
    public static List<Case> triggerOld ;
    public static Map<Id,Case> triggerNewMap;
    public static Map<Id,Case> triggerOldMap;
    
    public CaseHandler()
    {
        triggerNew = (List<Case>) trigger.new;
        triggerOld = (List<Case>) trigger.Old;
        triggerOldMap = (Map<Id,Case>) trigger.OldMap;
        triggerNewMap = (Map<Id,Case>) trigger.Newmap;
        
    }
    
    public void handler()
    {
        Switch on Trigger.OperationType
        {
            When BEFORE_UPDATE
            {
                // closeCase(triggerNew);
            }
            When AFTER_UPDATE
            {
                closeCase(triggerNew);
            }
        }
    }
    
    
    public static void closeCase(List<Case> caseList)
    {
        List<Case> newcaseList = new List<Case>();
        set<Id> caseId = new set<Id>();
        
        //   set<Id> processedIds = new set<Id>();
        
        
        for(Case c: caseList)
        {
            if(!CaseHandlerRecurssion.processedIds.contains(c.Id))
            {
                
                if(c.Status =='Closed'&& triggerOldMap.get(c.Id).Status!='Closed')
                {
                    Case updateCase = new Case(Id = c.Id, Closed_Date__c = Date.today());
                    //c.Closed_Date__c = system.today();
                    
                    newcaseList.add(updateCase);
                }
            }
            
            if(!newcaseList.isEmpty())
                update newcaseList;
            
            system.debug('HI');
            
        }
    }
    
    
}