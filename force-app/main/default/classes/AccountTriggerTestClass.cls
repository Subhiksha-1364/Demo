@isTest
public class AccountTriggerTestClass {
    
    @TestSetup
    public static void  loadData()
    {
        List<Account> accList = new List<Account>();
        
        for(Integer i=1;i<=210;i++)
        {
            Account acc = new Account (Name = 'Account'+i);
            accList.add(acc);
        }
        
        insert accList;
    }
    @isTest
    public static void deletePermit()
    {
        account ac = [Select Name From Account Limit 1 ];
        
        Profile pro = [Select Id from Profile Where Name = 'System Administrator' Limit 1];
        
         User u2 = new User(Firstname = 'Subhiksha',Lastname ='S',Alias ='sub',
                           Email='subhiksha1364@gmail.com',Username='subhikshas1364@force.com',
                           TimeZoneSidKey    = 'Asia/Kolkata',LocaleSidKey = 'en_IN',
                           EmailEncodingKey  = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId =pro.Id);
        
        
        Test.startTest();
        
        system.runAs(u2)
        {
            Boolean isBlocked = false;
            
            try
            {
                delete ac;
            }
            catch(exception e)
            {
                isBlocked = true;
            }
        }
    }

}