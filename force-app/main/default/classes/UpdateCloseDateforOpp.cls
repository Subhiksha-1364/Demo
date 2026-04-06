public class UpdateCloseDateforOpp implements Queueable{
    
    
    String rating;
    
    public UpdateCloseDateforOpp (String varRating)
    {
       this.rating = varRating; 
    }
    
    public void execute(QueueableContext cxt)
    {
        List<Opportunity> opp = [Select Id,StageName From Opportunity Where StageName=:rating];
        
        for(Opportunity op : opp)
        {
            op.CloseDate = system.today();
        }
        
        if(!opp.isEmpty())
            update opp;
    }

}