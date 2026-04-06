public class CasetriggerHandler {
    
    
    public static   List<Case>  triggerNew;  
    public static   List<Case>  triggerOld; 
    public static   Map<Id,Case>  triggerNewMap;  
    public static   Map<Id,Case>  triggerOldMap;  
       
    
    public  CaseTriggerHandler()
    {
        triggerNew = (List<Case>)Trigger.new ;
        triggerOld = (List<Case>)Trigger.old ;
        triggerNewMap = (Map<Id,Case>)Trigger.newMap;
        triggerOldMap = (Map<Id,Case>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When BEFORE_INSERT
            {
                caseTrigger(triggerNew);
            }
            When AFTER_INSERT
            {
               // caseTrigger(triggerNew);
            }
            When BEFORE_UPDATE
            {
               caseTrigger(triggerNew);
            }
            
            
            
        }       
    }
    
    
    public static void caseTrigger(List<Case> caseList)
    {
        //Set<Id> caseId = new Set<Id>();
        List<Case> cases = new list<Case>();
       // Set<Id> caseId2 = new Set<Id>();
        
        for(Case c : caseList)
        {
            if(c.Origin =='Email' && c.Type == 'Other')
                c.Priority = 'High';
               // caseId.add(c.Id);
            
            if(Trigger.isUpdate)
            {
                if(TriggerOldMap.get(c.Id).Status !='Escalated' && c.Status == 'Escalated')
                {
                    c.Is_Escaleted__c =true;
                    c.Escalation_Date__c = system.today();
                }
                if(TriggerOldMap.get(c.Id).Status =='Escalated' && c.Status != 'Escalated')
                {
                    c.Is_Escaleted__c =false;
                    c.Escalation_Date__c =null;
                }
                
                
                    //caseId2.add(c.Id);
            }
            
            
        }
           
    }
        
       /* List<Case> cList = [Select Priority,Escalation_Date__c,Is_Escaleted__c,Escalation_breached__c
                            From Case Where Id in:caseId];
        
        for(Case c : cList)
        {
            c.Priority = 'High';
        }
        update cList;*/
        
        
        
     
    
    
   /* public static void WriteMessage(List<Case> caselist)
    {
            for(Case cases : caselist)
            {
                if(TriggerOldmap.get(cases.Id).Status!= Cases.Status)
                {
                    system.debug('Status has been changed');
                }
                
            }
        
    }*/

}