public class AccountTriggerHandler {
    
    
   /* public static   List<Account>  triggerNew;  
    public static   List<Account>  triggerOld; 
    public static   Map<Id,Account>  triggerNewMap;  
    public static   Map<Id,Account>  triggerOldMap;   
    
    public  AccountTriggerHandler()
    {
        triggerNew = (List<Account>)Trigger.new ;
        triggerOld = (List<Account>)Trigger.old ;
        triggerNewMap = (Map<Id,Account>)Trigger.newMap;
        triggerOldMap = (Map<Id,Account>)Trigger.oldMap;
        
    }
    
    public static void doHandler()
    {
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
               createCon(TriggerNew);
            }
            When AFTER_UPDATE
            {
               createCon(TriggerNew);
            }
            
            When BEFORE_DELETE
            {
              //  avoidDel(triggerOld);
            }
        }
    }   
    
    public static void avoidDel(List<Account> accList)
    {
        User current = [Select Profile.Name 
                        From User
                        Where Id =: UserInfo.getUserId() 
                        Limit 1];       
        
        for(Account acc : accList)
        {
            if(current.Profile.Name == 'System Administrator')
            {
                acc.addError(Label.Admin_del_error);
            }
            
        }        
        
    }
    
    public static void createCon(List<Account> accList)
    {
        if (!checkRecursion.isRecursion) {
            
            checkRecursion.isRecursion = true;
            
            List<Contact> conToAdd = new List<Contact>();
            List<Contact> conToDel = new List<Contact>();
            Set<Id> accIds = new Set<Id>();
            
            for (Account acc : accList)
            {
                
                accIds.add(acc.Id);
                
            }
            
            List<AggregateResult> aggRes = [
                SELECT AccountId accId, COUNT(Id) conCount
                FROM Contact
                WHERE AccountId IN :accIds
                GROUP BY AccountId
            ];
            
            for (Account acc : accList) {
                
                Integer newVal = 0;
                Integer oldVal = 0;
                
                if (acc.NumberofLocations__c != null && acc.NumberofLocations__c > 0)
                {
                    newVal = Integer.valueOf(acc.NumberofLocations__c);
                }
                
                
                for (AggregateResult ar : aggRes) {
                    if ((Id) ar.get('accId') == acc.Id) {
                        oldVal = (Integer) ar.get('conCount');
                        break;
                    }
                }
                
                
                if (newVal > oldVal) {
                    Integer diff = newVal - oldVal;
                    for (Integer i = 1; i <= diff; i++) {
                        conToAdd.add(new Contact(
                            LastName = acc.Name + ' Contact '+ i,
                            AccountId = acc.Id
                        ));
                    }
                }
                
                
                if (newVal < oldVal) 
                {
                    Integer diff = oldVal - newVal;
                    
                    List<Contact> cons = [
                                           SELECT Id
                                           FROM Contact
                                            WHERE AccountId = :acc.Id
                                           LIMIT :diff
                    ];
                    conToDel.addAll(cons);
                }
            }
            
            insert conToAdd;
            delete conToDel;
        }*/
    }