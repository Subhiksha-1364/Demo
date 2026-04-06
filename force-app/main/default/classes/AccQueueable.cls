public class AccQueueable implements Queueable {
    
    String industry;
    
    public AccQueueable(String ind)
    {
        this.industry = ind;
    }
    
    public void execute(QueueableContext cxt)
    {
        List<Account> accList = [Select Id,Industry,Description From Account Where Industry =:industry];
        
        for(Account acc: accList)
        {
            acc.Description = Label.Desc;
        }
        
        if(!accList.isEmpty())
            update accList;
    }
    
    

}