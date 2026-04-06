public class CaseBatch implements Schedulable{
    
    public void execute(SchedulableContext bc)
    {
       List<Case> cList = [Select Priority,Escalation_Date__c,
                           Is_Escaleted__c,Escalation_breached__c From Case
                          Where Is_Escaleted__c = false And status != 'Closed'
                          And CreatedDate <=: Date.today().addDays(-3)];
        
        for(Case c : cList)
        {
            c.Escalation_breached__c = true ;
        }
        
        update cList;
    }
    
   
}