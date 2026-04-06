public class CustomerTriggerHandler {
    
    public static   List<Customer__c>  triggerNew;  
    public static   List<Customer__c>  triggerOld; 
    public static   Map<Id,Customer__c>  triggerNewMap;  
    public static   Map<Id,Customer__c>  triggerOldMap;   
    
    public  CustomerTriggerHandler()
    {
        triggerNew = (List<Customer__c>)Trigger.new ;
        triggerOld = (List<Customer__c>)Trigger.old ;
        triggerNewMap = (Map<Id,Customer__c>)Trigger.newMap;
        triggerOldMap = (Map<Id,Customer__c>)Trigger.oldMap;
        
    }
    
    public static void doHandler()
    {
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
                addUserToTeam(TriggerNew);
            }
            When AFTER_UPDATE
            {
                updateUserToTeam(TriggerNew);
            }
            When BEFORE_DELETE
            {
                deleteMember();
            }
            When AFTER_UNDELETE
            {
                UndeleteMember();
            }
        }
    }
    
    public static void addUserToTeam(List<Customer__c>customList)
    {
        List<AccountTeamMember> accMember =  new List<AccountTeamMember>();
        
        for(Customer__c custom : customList)
        {
            if(custom.Account__c!= null && custom.Account_Manager__c!= null )
            {
                AccountTeamMember newAcMember = new AccountTeamMember(AccountId = custom.Account__c,UserId=custom.Account_Manager__c);
                accMember.add(newAcmember);
            }
            
        }
        
        if (!accMember.isEmpty())
            insert accMember;
        
    }
    
    public static void updateUserToTeam(List<Customer__c>customList)
    {
        List<AccountTeamMember> deleteAccMember =  new List<AccountTeamMember>();
        List<AccountTeamMember> InsertAccMember =  new List<AccountTeamMember>();
        
        set<Id> accId = new Set<Id>();
        set<Id> UserId = new Set<Id>();
        
        for(Customer__c custom : customList)
        {    
            if(triggerOldMap.get(custom.Id)!=null && triggerOldMap.get(custom.Id).Account_Manager__c!=custom.Account_Manager__c)
            {
                accId.add(triggerOldMap.get(custom.Id).Account__c);	
                UserId.add(triggerOldMap.get(custom.Id).Account_Manager__c);
            }
            
            
            if(custom.Account_Manager__c!=null && triggerOldMap.get(custom.Id).Account_Manager__c!=custom.Account_Manager__c  )
            {
                AccountTeamMember insAcMember = new AccountTeamMember(AccountId = custom.Account__c,UserId=custom.Account_Manager__c);
                InsertAccMember.add(insAcMember);
            }
        }
        
        List<AccountTeamMember> updateAcMember = [Select Id 
                                                  from AccountTeamMember
                                                  Where UserId in:UserId
                                                  And AccountId in:accId];
        
        deleteAccMember.addAll(updateAcMember);
        
        delete deleteAccMember;
        insert InsertAccMember;
    }
    
    
    public static void deleteMember()
    {
        set<Id> accId = new Set<Id>();
        set<Id> UserId = new Set<Id>();
        
        for(Customer__c c : TriggerOld)
        {
            if (c.Account__c != null && c.Account_Manager__c != null)
            {
                accId.add(c.Account__c);	
                UserId.add(c.Account_Manager__c);
            }
        }
        
        
        if (!accId.isEmpty() && !userId.isEmpty())
        {
            delete [Select Id From AccountTeamMember Where AccountId in: accId And UserId in: UserId];
        }
    }
    
    public static void UndeleteMember()
    {
        List<AccountTeamMember> restoreList = new List<AccountTeamMember>();
        
        for(Customer__c c : TriggerNew)
        {
            if (c.Account__c != null && c.Account_Manager__c != null) 
            {
                AccountTeamMember accMember = new AccountTeamMember (AccountId = c.Account__c, UserId=c.Account_Manager__c);
                
                restoreList.add(accMember);
            }
            
        }
        
        if (!restoreList.isEmpty())
            insert restoreList;
    }
    
}