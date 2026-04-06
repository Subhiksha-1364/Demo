public class TaskTriggerHandler {
    
    public static   List<Task>  triggerNew;  
    public static   List<Task>  triggerOld; 
    public static   Map<Id,Task>  triggerNewMap;  
    public static   Map<Id,Task>  triggerOldMap;  
       
    
    public  TaskTriggerHandler()
    {
        triggerNew = (List<Task>)Trigger.new ;
        triggerOld = (List<Task>)Trigger.old ;
        triggerNewMap = (Map<Id,Task>)Trigger.newMap;
        triggerOldMap = (Map<Id,Task>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
                taskCount(triggerNew);
            }
            When AFTER_UPDATE
            {
                taskCount(triggerNew);
            }
            When AFTER_DELETE
            {
                taskCount(triggerOld );
            }
            When AFTER_UNDELETE
            {
                taskCount(triggerNew);
            }
        }       
    }
    
    
    public static  void taskCount(List<Task> taskList)
    {
        Set<Id> projectId = new Set<Id>();
        
        for(Task tsk : taskList)
        {
            if(tsk.WhatId!=null && tsk.WhatId.getSObjectType() == Project__c.SObjectType)
            {
                projectId.add(tsk.WhatId);
            }
        }
        
        if(!projectId.isEmpty())
        {
            List<AggregateResult> aggRes = [ SELECT COUNT(Id) totalTasks, WhatId
                                            FROM Task
                                            WHERE WhatId IN :projectId
                                            GROUP BY WhatId ];
            
            
            List<Project__c> projectList = new List<Project__c>();
            
            for(AggregateResult ar : aggRes)
            {
                projectList.add(new Project__c(
                    Id = (Id) ar.get('WhatId'),
                    Total_Tasks__c = (Decimal) ar.get('totalTasks')
                ));
            }
            
            if(!projectList.isEmpty())
                update projectList;            
        }              
    }  
}