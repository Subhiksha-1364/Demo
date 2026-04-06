public class OppLineItemHandler {
    
    public static   List<OpportunityLineItem>  triggerNew;  
    public static   List<OpportunityLineItem>  triggerOld; 
    public static   Map<Id,OpportunityLineItem>  triggerNewMap;  
    public static   Map<Id,OpportunityLineItem>  triggerOldMap;   
    
    public  OppLineItemHandler()
    {
        triggerNew = (List<OpportunityLineItem>)Trigger.new ;
        triggerOld = (List<OpportunityLineItem>)Trigger.old ;
        triggerNewMap = (Map<Id,OpportunityLineItem>)Trigger.newMap;
        triggerOldMap = (Map<Id,OpportunityLineItem>)Trigger.oldMap;
        
    }
    
    public static void doHandler()
    {
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
                addCode(TriggerNew);
            }
            When AFTER_UPDATE
            {
               // addCode(TriggerNew);
            }
            
            When AFTER_DELETE
            {
                
                addCode(triggerOld);
            }
            When AFTER_UNDELETE
            {
                //addCode(triggerOld);
            }
        }
    }  
    
    
    
    public static void addCode(List<OpportunityLineItem>opLineList)
    {
        
        Map<Id,set<String>> opptyMap = new  Map<Id,set<String>>();
        List<Opportunity> opptyList = new List<Opportunity>();
        
        set<Id> oppId = new set<Id>();
        //
        
        for(OpportunityLineItem opp : opLineList)
        {
            if(opp.OpportunityId!= null)
            {
                oppId.add(opp.OpportunityId);
            }
        }
        List<OpportunityLineItem> opLine = [Select OpportunityId,ProductCode From OpportunityLineItem Where OpportunityId in: oppId];
        
        
        for(OpportunityLineItem opp : opLine)
        {
            if(!String.isBlank(opp.ProductCode) && opp.OpportunityId != null)
                {
                    if(!opptyMap.containsKey(opp.OpportunityId))
                    {
                        opptyMap.put(opp.OpportunityId, new Set<String>());
                    }
                    
                    opptyMap.get(opp.OpportunityId).add(opp.ProductCode);
                    
                }
 
        }
        
        
        for(Id opLi	 : opptyMap.keySet())
        {
            Opportunity oppty = new Opportunity(Id = opLi,Opp_LineItem_ProdCode__c =String.join(new List<String>(opptyMap.get(opLi)),','));  
            opptyList.add(oppty);
        }
        
        if(!opptyList.isEmpty())
            update opptyList;
        
        
    }
    
    
}