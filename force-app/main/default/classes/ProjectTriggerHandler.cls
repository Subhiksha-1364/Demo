public class ProjectTriggerHandler {
    
    
    
    public static   List<Project__c>  triggerNew;  
    public static   List<Project__c>  triggerOld; 
    public static   Map<Id,Project__c>  triggerNewMap;  
    public static   Map<Id,Project__c>  triggerOldMap;  
    
    
    public  ProjectTriggerHandler()
    {
        triggerNew = (List<Project__c>)Trigger.new ;
        triggerOld = (List<Project__c>)Trigger.old ;
        triggerNewMap = (Map<Id,Project__c>)Trigger.newMap;
        triggerOldMap = (Map<Id,Project__c>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
                activeProject(triggerNew);
            }
            When AFTER_UPDATE
            {
                activeProject(triggerNew);
            } 
            When AFTER_DELETE
            {
                activeProject(triggerOld);
            } 
            When AFTER_UNDELETE
            {
                activeProject(triggerNew);
            } 
        }       
    }
    
    
    public static void activeProject(List<Project__c> projList)
    {
        if (!checkRecursion.isRecursion) 
        {
            
            checkRecursion.isRecursion = true;
            List<Opportunity> ActiveoppList = new list<Opportunity>();
            Set<Id> oppId = new Set<Id>();
            Set<Id> ActiveOppId = new Set<Id>();
           
            
            for(Project__c pro : projList)
            {
                if(pro.Opportunity__c != null)
                    oppId.add(pro.Opportunity__c);
            }
            
            List<AggregateResult> aggRes = [Select Count(Id) activePro , Opportunity__c 
                                            From Project__c
                                            Where Status__c='Active'
                                            And Opportunity__c in:oppId
                                            Group By Opportunity__c];
            
            
            
            
            for(AggregateResult ar : aggRes)
            {
                ActiveOppId.add((Id)ar.get('Opportunity__c'));
           
            }
            
            for(Id opp : oppId)
            {
                Opportunity oppty = new opportunity(Id = opp,Active_Project__c =ActiveOppId.contains(opp));
                
                ActiveoppList.add(oppty);
            }
            
            if(!ActiveoppList.isEmpty())
                update ActiveoppList;
            

            
        }        
    }
}