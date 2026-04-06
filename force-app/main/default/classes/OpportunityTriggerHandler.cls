public class OpportunityTriggerHandler {
    
    
    public static   List<Opportunity>  triggerNew;  
    public static   List<Opportunity>  triggerOld; 
    public static   Map<Id,Opportunity>  triggerNewMap;  
    public static   Map<Id,Opportunity>  triggerOldMap;  
       
    
    public  OpportunityTriggerHandler()
    {
        triggerNew = (List<Opportunity>)Trigger.new ;
        triggerOld = (List<Opportunity>)Trigger.old ;
        triggerNewMap = (Map<Id,Opportunity>)Trigger.newMap;
        triggerOldMap = (Map<Id,Opportunity>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
                addOpp(triggerNew);
            }
            When AFTER_UPDATE
            {
                addOpp(triggerNew);
            }
            When AFTER_DELETE
            {
               addOpp(triggerOld);
            }
            When AFTER_UNDELETE
            {
                addOpp(triggerNew);
            }
            
           
        }       
    }
    
    
    public static void  updateAcc (List<Opportunity> oppList)
    {
        Set<Id> accSet = new Set<Id>();
        List<Account>accList = new List<Account>();
        
        for( Opportunity opp : oppList)
        {
           if(opp.AccountId!= null) 
                {
                    accSet.add(opp.AccountId);
                } 
            if(Trigger.isUpdate)
            {
                if(opp.AccountId != TriggerOldMap.get(opp.Id).AccountId)
                {
                    if(opp.AccountId != null)
                        accSet.add(opp.AccountId);
                    if(TriggerOldMap.get(opp.Id).AccountId != null)
                        accSet.add(TriggerOldMap.get(opp.Id).AccountId);
                }
            }
        }
        
       // List<Opportunity> opList = [Select Name,StageName,AccountId From opportunity Where AccountId in:accSet and StageName='ClosedWon'];
        
       // accList = [Select Name,Max_Opportunity_Amount__c,(Select StageName,Amount From Opportunities Where StageName='ClosedWon') 
                  // from Account Where Id in: accSet ];
        
        List<AggregateResult> aggRes = [Select Sum(Amount)amt,AccountId
                                        From Opportunity Where AccountId in:accSet
                                        And Stagename='Closed Won' group by AccountId];
        
        for(AggregateResult ag : aggRes)
        {
            Account a = new Account(Id = (Id)ag.get('AccountId'),Max_Opportunity_Amount__c =(Decimal)ag.get('amt'));
            accList.add(a);  
        }
        
        update accList;
        
 
             
    }
    
    
    public static void addOpp(List<Opportunity> opp)
    {
        Set<Id> ids = new Set<Id>();
        
        for(Opportunity op : opp )
        {
            if(op.AccountId != null)
                ids.add(op.AccountId);
        }
        
        
        List<Account> acc =[Select Name,Max_Opportunity_Amount__c,(Select Id From Opportunities) From Account Where Id in:ids ];
        
        for(Account a : acc)
        {
            a.Max_Opportunity_Amount__c = a.Opportunities.size();
        }
        update acc;
        
        
    }
    

}