@isTest
public class ContactTriggerTestClass {
    
    @testSetup
    public static void loadData()
    {
        List<Contact> conList = new list<Contact>();
        
        for(Integer i=1;i<=210;i++)
        {
            Contact con = new Contact (LastName='Con'+i);
            
            conList.add(con);
        }
        
        insert conList;
        
        Contact con = [Select id,LastName from Contact limit 1];
        
       // Contact_Relationship__c cRel = new Contact_Relationship__c(Contact__c = con.Id);
        
       // insert crel;
    }
    
    @isTest
    public static void insertData()
    {
        //Contact con = [Select id,LastName,Contact_Relationship__c from Contact limit 1];
        
        Contact con = new Contact (LastName='Con 1',Contact_Relationship__c = true);
        
        insert con;
        
        Integer count = [Select count() from Contact_Relationship__c Where Contact__c =:con.Id];
        
        assert.areEqual(1,count,'Contact relation should be created if the checkbox is true');
    }
    
    @isTest
    public static void updatedata()
    {
       Contact con = new Contact (LastName='Con 1',Contact_Relationship__c = false);
        
        insert con;
        
        Test.startTest();
        
        con.Contact_Relationship__c = true;
        
        update con;
        
        Integer count = [Select count() from Contact_Relationship__c Where Contact__c =:con.Id];
        
        
        
        assert.areEqual(1,count,'Contact relation should be created if the checkbox is true');
        
        
        Profile pro = [Select Id from Profile Where Name = 'Standard User' Limit 1];
        
        User u2 = new User(Firstname = 'Subhiksha',Lastname ='S',Alias ='sub',
                           Email='subhiksha1364@gmail.com',Username='subhikshas1364@force.com',
                           TimeZoneSidKey    = 'Asia/Kolkata',LocaleSidKey = 'en_IN',
                           EmailEncodingKey  = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId =pro.Id);
        
        insert u2;
        
        con.OwnerId = u2.Id;
        
        update con;
        
        Contact_Relationship__c cRel =[ Select Contact__c,Name From Contact_Relationship__c where Contact__c =: con.Id Limit 1 ];
        
        assert.areEqual('Subhiksha S',cRel.Name,'Relation name should be updated with the contact owner');
        
        
        con.Contact_Relationship__c = false;
        
        update con;
        
        Integer counts = [Select count() from Contact_Relationship__c Where Contact__c =:con.Id];
        
        assert.areEqual(0,counts,'Contact relation should be deleted if the checkbox is false');
        
        con.Contact_Relationship__c = true;
        
        update con;
        
        Integer count2 = [Select count() from Contact_Relationship__c Where Contact__c =:con.Id];
       
        assert.areEqual(1,count2,'Contact relation should be deleted if the checkbox is false');
        
        
        Test.stopTest();
        
    }
    
}