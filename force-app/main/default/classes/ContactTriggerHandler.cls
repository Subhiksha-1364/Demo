public class ContactTriggerHandler {
    
    public static   List<Contact>  triggerNew;  
    public static   List<Contact>  triggerOld; 
    public static   Map<Id,Contact>  triggerNewMap;  
    public static   Map<Id,Contact>  triggerOldMap;  
    
    
    public  ContactTriggerHandler()
    {
        triggerNew = (List<Contact>)Trigger.new ;
        triggerOld = (List<Contact>)Trigger.old ;
        triggerNewMap = (Map<Id,Contact>)Trigger.newMap;
        triggerOldMap = (Map<Id,Contact>)Trigger.oldMap;
        
    }
    
    public static void handlerCase()
    {        
        Switch on Trigger.OperationType
        {
            When AFTER_INSERT
            {
               // ConRelationship(triggerNew);
            }
            
            When AFTER_UPDATE
            {
              //  updateUserName();
                rollup(triggerNew);
            }
            When BEFORE_DELETE
            {
                deleteChild(triggerOld);
            }
            When AFTER_UNDELETE
            {
               undeletechild(triggerNew);
            }
            
        }       
    }
    
    
    
    public static void deleteChild(List<Contact>conList)
    {
        try
        {
            set<Id> cId = new Set<Id>();
            
            for(Contact c : conList)
            {
                cId.add(c.Id);
            }
            
            List<Contact_Relationship__c> crList = [Select Name From Contact_Relationship__c Where Contact__c in : cId];
            
            delete crList;
        }
        catch(exception e)
        {
            system.debug(e.getMessage());
        }
    }
    
    public static void undeletechild(List<Contact> conList)
    {
        try
        {
            set<Id> cIds = new Set<Id>();
            for(Contact c : conList)
            {
                cIds.add(c.Id);  
            }
            List<Contact_Relationship__c> crLists = [Select Name
                                                     From Contact_Relationship__c
                                                     Where Contact__c in : cIds
                                                     And isDeleted = true
                                                     ALL ROWS];
            undelete crLists;
        }
        catch(exception e)
        {
            system.debug(e.getMessage());
        }
        
        
    }
    
    public static void rollup(List<Contact> conList)
    {
        try
        {
            Set<Id> Ids = new Set<Id>();
            for(Contact c : conList)
            {
                Ids.add(c.Id); 
            }
            List<Contact> cntList = [Select Id,(Select Id From Contact_Relationships__r)
                                     From Contact
                                     Where Id in: Ids];
            for(Contact c : cntList)
            {
                c.Description = string.valueOf(c.Contact_Relationships__r.size());
            }
            update cntList;
            
        }
        catch(exception e)
        {
            system.debug(e.getMessage());
        }
    }
    
    
    
    
    // insert ConRelationship
    
    public static void ConRelationship(List<Contact> conList)
    {
        List<Contact_Relationship__c> conRelList = new List<Contact_Relationship__c>();
        
        
        set <Id> conId = new set<Id>();
        
        for(Contact con : conList)
        {
            if(con.Contact_Relationship__c == true)
            {                
                conId.add(con.Id); 
            }
        }
        
        
        for(Id con : conId)
        {
            system.debug(TriggerNewMap.get(con));
            
            system.debug(con);
            
            Contact_Relationship__c conRel = new Contact_Relationship__c(Name = TriggerNewMap.get(con).LastName +' Relation ',Contact__c=con);
            
            conRelList.add(conRel);
        }
        try
        {
            if(!conRelList.isEmpty()) 
                insert conRelList;
        }
        catch(exception e)
        {
            system.debug(e);
        }
        
        
    }
    
    // Update Conrelationship
    
    public static void updateUserName()
    {
        List<Contact_Relationship__c> UpdateconRelList = new List<Contact_Relationship__c>();
        List<Contact_Relationship__c> NewConRelList = new List<Contact_Relationship__c>();
        List<Contact_Relationship__c> DeleteconRelList = new List<Contact_Relationship__c>();
        
        set <Id> conId = new set<Id>();
        Set<Id> newId = new Set<Id>();
        Set<Id> ownerId = new Set<Id>();
        
        for(Contact con : TriggerNew)
        { 
            if((con.Contact_Relationship__c== true &&  TriggerOldMap.get(con.Id).Contact_Relationship__c == false))
                
            {
                conId.add(con.Id);
                ownerId.add(con.OwnerId);
                
            }
            if(con.Contact_Relationship__c == true && con.OwnerId != TriggerOldMap.get(con.Id).OwnerId)
            {
                conId.add(con.Id);
                ownerId.add(con.OwnerId);
            }
            
            if(con.Contact_Relationship__c ==false && TriggerOldMap.get(con.Id).Contact_Relationship__c == true)
            {
                conId.add(con.Id);
                
            }
            
        }
        List<Contact_Relationship__c> RelList = [Select Id,Contact__c from Contact_Relationship__c Where Contact__c in:conId ];
        
        for(Contact_Relationship__c cr : RelList )
        {
            newId.add(cr.Contact__c);
        }
        
        Map<Id,User> userName = new map<Id,User>( [Select Id,Name from User Where Id in:ownerId]);
        
        for(Contact_Relationship__c RelCon : RelList)
        {
            Contact con = TriggerNewMap.get(RelCon.Contact__c);
            
            if((TriggerNewMap.get(RelCon.Contact__c).Contact_Relationship__c ==true && TriggerOldMap.get(RelCon.Contact__c).Contact_Relationship__c == false))
            {
                Contact_Relationship__c conRelate = new Contact_Relationship__c(Name=TriggerNewMap.get(RelCon.Contact__c).LastName +' Relation ' ,Contact__c=RelCon.Contact__c);
                
                NewConRelList.add(conRelate);
            } 
            
            if(TriggerNewMap.get(RelCon.Contact__c).OwnerId != TriggerOldMap.get(RelCon.Contact__c).OwnerId)
            {
                Contact_Relationship__c conRelate = new Contact_Relationship__c(Id = RelCon.Id,Name=userName.get(con.OwnerId).Name,Contact__c=RelCon.Contact__c);
                
                UpdateconRelList.add(conRelate);
            }
            
            if((TriggerNewMap.get(RelCon.Contact__c).Contact_Relationship__c ==false && TriggerOldMap.get(RelCon.Contact__c).Contact_Relationship__c == true))
            {
                DeleteconRelList.add(RelCon);
            }
            
        } 
        
        if(!NewConRelList.isEmpty()) 
            insert NewConRelList;
        
        if(!UpdateconRelList.isEmpty()) 
            update UpdateconRelList;
        
        if (!DeleteconRelList.isEmpty())
            delete DeleteconRelList;
        
    }
    
    public static void delConAndChild(List<Contact>conList)
    {
        Set<Id> conIds = new Set<Id>();
        List<Contact_Relationship__c> deleteChildList = new List<Contact_Relationship__c>();
        
        for(Contact con : conList)
        {
            conIds.add(con.Id);
        }
        
        List<Contact_Relationship__c> RelList = [Select Id,Contact__c from Contact_Relationship__c Where Contact__c in:conIds ];
        
        for(Contact_Relationship__c child : RelList)
        {
            deleteChildList.add(child);
        }
        
        if (!deleteChildList.isEmpty())
            delete deleteChildList;
        
    }
    
    
    public static void undeleteParentChild(List<Contact>conList)
    {
        Set<Id> conIds = new Set<Id>();
        //List<Contact_Relationship__c> RestoreChildList = new List<Contact_Relationship__c>();
        
        for(Contact con : conList)
        {
            conIds.add(con.Id);
        }
        
        List<Contact_Relationship__c> RestoreChildList = [Select Id,Contact__c 
                                                          from Contact_Relationship__c 
                                                          Where Contact__c in:conIds 
                                                          And isDeleted = true
                                                          All Rows ];
        
        
        try
        {
            if (!RestoreChildList.isEmpty())
                undelete RestoreChildList;      
        }
        catch(exception e)
        {
            system.debug(e);
        }
        
        
    }
    
}