@isTest
public class CustomerTriggerTestClass {
    
    @testSetup
    public static void loadData()
    {
        List<Account> accList = new List<Account>();
        List<User> userList = new List<User>();
        
        for(Integer i=1;i<=210;i++)
        {
            Account ac = new Account (Name = 'Acc'+i);
            accList.add(ac);
        }
        insert accList;
        
        Profile pro = [Select Id from Profile Where Name = 'Standard User' Limit 1];
        
        User u = new User(Firstname = 'Integration',Lastname ='User',Alias ='integ',
                          Email='noreply@example.com',Username='integration@00dgluaf.com',
                          TimeZoneSidKey    = 'Asia/Kolkata',LocaleSidKey = 'en_IN',
                          EmailEncodingKey  = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId =pro.Id);
        
        User u2 = new User(Firstname = 'Subhiksha',Lastname ='S',Alias ='sub',
                           Email='subhiksha1364@gmail.com',Username='subhikshas1364@force.com',
                           TimeZoneSidKey    = 'Asia/Kolkata',LocaleSidKey = 'en_IN',
                           EmailEncodingKey  = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId =pro.Id);
        
        
        userList.add(u);
        userList.add(u2);
        
        insert userList;
        
    }
    
    @isTest
    public static void insertData()
    {
        // List<Customer__c> cList = new List<Customer__c>();
        
        Account acc = [Select Id,Name from Account Limit 1];
        
        User u1 = [Select Name from User Where name = 'Integration User' Limit 1];
        
        Customer__c customer = new Customer__c (Account__c =acc.Id,Account_Manager__c =u1.Id);
        
        insert customer;
        
        Integer Count = [Select Count() From AccountTeamMember Where AccountId =:acc.Id And UserId =:u1.Id];
        
        assert.areEqual(1,count,'Member must be created if customer is added');
        
    }
    
    @isTest
    public static void updateData()
    {
        Account acc = [Select Id,Name from Account Limit 1];
        
        User u1 = [Select Id from User Where name = 'Integration User' Limit 1];
        
        Customer__c customer = new Customer__c (Account__c =acc.Id,Account_Manager__c =u1.Id);
        
        insert customer;
        
        User u2 = [Select Name from User Where name = 'Subhiksha S' Limit 1];
        
        customer.Account_Manager__c = u2.Id;
        
        update customer;
        
        Integer oldMem = [Select Count() From AccountTeamMember Where AccountId =:acc.Id And UserId =:u1.Id];
        Integer newMem = [Select Count() From AccountTeamMember Where AccountId =:acc.Id And UserId =:u2.Id];
        
        assert.areEqual(0,oldMem,'Old Member must be deleted if customer is updated');
        assert.areEqual(1,newMem,'New Member must be created if customer is updated');
        
    }
    
    @isTest
    public static void deleteData()
    {
        Account acc = [Select Id,Name from Account Limit 1];
        
        User u1 = [Select Id from User Where name = 'Integration User' Limit 1];
        Customer__c customer = new Customer__c (Account__c =acc.Id,Account_Manager__c =u1.Id);
        insert customer;
        delete customer;
        Integer Count = [Select Count() From AccountTeamMember Where AccountId =:acc.Id And UserId =:u1.Id];
        
        assert.areEqual(0,count,'Member must be deleted if customer is deleted');
        
    }
    
    @isTest
    public static void undeleteData()
    {
        Account acc = [Select Id,Name from Account Limit 1];
        
        User u1 = [Select Id from User Where name = 'Integration User' Limit 1];
        Customer__c customer = new Customer__c (Account__c =acc.Id,Account_Manager__c =u1.Id);
        insert customer;
        
        Test.startTest();
        delete customer;
        Test.stopTest();
        undelete customer;
        Integer Count = [Select Count() From AccountTeamMember Where AccountId =:acc.Id And UserId =:u1.Id];
        assert.areEqual(1,count,'Member must be undeleted if customer is undeleted');
        
    }
    
    
}