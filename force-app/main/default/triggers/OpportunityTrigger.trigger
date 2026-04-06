trigger OpportunityTrigger on Opportunity (before insert,before update,after update,after insert,after delete,after undelete) {
    
   new OpportunityTriggerHandler();
    
  OpportunityTriggerHandler.handlerCase();
    
    /* Switch on Trigger.OperationType
    {
        when BEFORE_INSERT
        {
            for(Opportunity opp : Trigger.new)
            {
                if(opp.Amount>1000000 && opp.Description==null)
                {
                    opp.Description.addError(Label.Opportunity_desc_error);
                }
                if(opp.AccountId==Null)
                {
                    opp.addError(Label.Opp_acc_error);
                }
                opp.StageName = 'Closed Won';
            }
        }
        when BEFORE_UPDATE
        {
            for(Opportunity opp : Trigger.new)
            {
                if(opp.Amount>1000000 && opp.Description==null)
                {
                    opp.Description.addError(Label.Opportunity_desc_error);
                }
                if(opp.AccountId==Null)
                {
                    opp.addError(Label.Opp_acc_error);
                }
                
                if(Trigger.OldMap.get(opp.Id).Amount!=null &&  opp.Amount!=null && Trigger.OldMap.get(opp.Id).Amount > opp.Amount)
                {
                    opp.Amount.addError(Label.Opp_Amt_Error);
                }
                
                if(Trigger.OldMap.get(opp.Id).CloseDate>opp.CloseDate)
                {
                    opp.CloseDate.addError(Label.Opp_Closedate_Error);
                }
            }
            
            
        }
        
        When AFTER_UPDATE
        {
            updateOppAmt(Trigger.New);
            Set<Id> oppIds = new Set<Id>();
            for(Opportunity opp : Trigger.new)
                oppIds.add(opp.Id);            
            
            List<OpportunityLineItem> product =[Select Id,Quantity,OpportunityId From OpportunityLineItem Where OpportunityId =: Trigger.new ];
            for(OpportunityLineItem opp : product)
            {
                opp.Quantity = Trigger.NewMap.get(opp.OpportunityId).Quantity__c;
            }
            
            update product; 
        }
        
        When AFTER_INSERT
        {
            updateOppAmt(Trigger.new);
            
            Set<Account> accSet = new Set<Account>();
            List<Account>accList = new List<Account>();
            List<Task> tasklist = new List <Task>();
            for( Opportunity opp : Trigger.new)
            {
                if(opp.Amount>=1000000)
                {
                    system.debug(Label.Opp_msg);
                }                
                
                task t = new Task( Subject = 'Follow up the opportunity created',
                                  ActivityDate = System.today().addDays(3), 
                                  Status = 'Not Started',
                                  WhatId= opp.Id,
                                  OwnerId = opp.OwnerId);
                
                taskList.add(t);
                
                if(opp.AccountId!= null) 
                {
                    Account acc = new Account(Id = opp.AccountId,Last_Opportunity_Amount__c= opp.Amount ); 
                    accSet.add(acc);
                }               
            }
            
            if(!taskList.isEmpty())
                insert taskList;
            
            if(!accSet.isEmpty())
            {
                accList.addAll(accSet);
                update accList;
            }
            
            
        }
        
        When AFTER_DELETE
        {
            updateOppAmt(Trigger.Old);
            List<Opportunity_Deletion_Log__c> deletedList = new List<Opportunity_Deletion_Log__c>();
            for( Opportunity opp : Trigger.old)
            {
                Opportunity_Deletion_Log__c oppDelLog = new Opportunity_Deletion_Log__c(Opportunity_Name__c = opp.Name);
                deletedList.add(oppDelLog);
            }
            
            if(!deletedList.isEmpty())
                insert deletedList;
        }
        
        When AFTER_UNDELETE
        {
            updateOppAmt(Trigger.new);
        }
    }
   
    public static void updateOppAmt(List<Opportunity> oppList)
    {
        List<Account> accList = new List<Account>();
        List<Account> accountList = new List<Account>();
        Set<Id> accId = new Set<Id>();
        Set<Id> accountId = new Set<Id>();
        
        for(Opportunity opp : oppList)
        {
            if(Trigger.isUpdate)
            {
                if(Trigger.OldMap.get(opp.Id).Amount!=opp.Amount && opp.AccountId!=null  )
                {
                    accId.add(opp.AccountId);                    
                }
                if( Trigger.OldMap.get(opp.Id).StageName!= opp.StageName && opp.AccountId!=null)
                {
                    accountId.add(opp.AccountId);                    
                }
            }
            else
            {
                if(opp.AccountId!=null)
                {
                    accId.add(opp.AccountId);
                    accountId.add(opp.AccountId);   
                }                
            }           
        }
        
        if(accId.size()>0 )
        { 
            List<AggregateResult> aggRes = [Select Max(Amount)oppAmt,AccountId 
                                            From Opportunity
                                            Where Amount!=null And AccountId in:accId
                                            Group By AccountId];
            
            
            for(AggregateResult ar : aggRes)
            {
                Account acc = new Account(Id =(Id) ar.get('AccountId'),Max_Opportunity_Amount__c =(Decimal) ar.get('oppAmt'));
                
                accList.add(acc);       
            }
            
            
        }
        
        if(accountId.size()>0)
        {
            List<AggregateResult> aggResult = [Select Count(Id)oppStage,AccountId 
                                               From Opportunity
                                               Where StageName!= 'Closed Won' and StageName!= 'Closed Lost' And AccountId in:accountId
                                               Group By AccountId];
            
            for(AggregateResult ar : aggResult)
            {
                Account acc = new Account(Id =(Id) ar.get('AccountId'),No_of_Active_Opportunities__c =(Integer) ar.get('oppStage'));
                
                accountList.add(acc);       
            }        
            
      }
        
         if(!accountList.isEmpty() && !accList.isEmpty())
            {
                 List<Account> accListToUpdateAll = new List<Account>();
                 accListToUpdateAll.addAll(accountList);
                 accListToUpdateAll.addAll(accList);
            }
        
        
        
    }*/
   
   
}