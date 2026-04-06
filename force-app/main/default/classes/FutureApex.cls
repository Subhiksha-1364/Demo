public class FutureApex {
    
    @Future
    public static void debugStat(String word)
    {
        system.debug(word);
    }
    
    public static void getAccInfo(Id acId)
    {
        logAccInfo(acId);
    }
    
    @future
    public static void logAccInfo(Id acId)
    {
        List<Account> acclist = [Select  Id , Name From Account Where Id =:acId];
        
        system.debug(acclist);
    }
    
    @future
    public static void addNum(Integer a,Integer b)
    {
        Integer total = 0;
        
        for(Integer i = a;i<=b;i++)
        {
            total+=i;
        }
        system.debug(total);
    }
    
}