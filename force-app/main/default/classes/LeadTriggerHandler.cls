public class LeadTriggerHandler {
    
    public static   List<Lead>  triggerNew;  
    public static   List<Lead>  triggerOld; 
    public static   Map<Id,Lead>  triggerNewMap;  
    public static   Map<Id,Lead>  triggerOldMap;  
       
    
    public  LeadTriggerHandler()
    {
        triggerNew = (List<Lead>)Trigger.new ;
        triggerOld = (List<Lead>)Trigger.old ;
        triggerNewMap = (Map<Id,Lead>)Trigger.newMap;
        triggerOldMap = (Map<Id,Lead>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When AFTER_DELETE
            {
                updatedeleted(triggerold);
            }
           
        }       
    }
    
    
      
       public static void updatedeleted(List<Lead> leadlist)
        {
            
            List<Deleted_Leads__c> deletedList = new List<Deleted_Leads__c>();
            for( Lead leads : leadlist)
            {
                Deleted_Leads__c delLeads = new Deleted_Leads__c(Lead_Name__c = leads.Name);
                deletedList.add(delLeads);
            }
            
            if(!deletedList.isEmpty())
                insert deletedList;
        }

}