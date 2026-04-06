@isTest
public class OppLineItemHandlerTestClass {
    
    @TestSetup
    public static void loadData()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
        
        Id standardPBId = Test.getStandardPricebookId();
        
        
        Pricebook2 pb = new Pricebook2(Name ='Sample PB',isActive=True);
        
        insert pb;
        
        Product2 prod = new Product2(Name ='Sample Product',ProductCode='SP01',isActive=true);
        
        insert prod;
        Product2 prod2 = new Product2(Name ='Sample Product',ProductCode='SP02',isActive=true);
        
        insert prod2;
        
        PricebookEntry StdpbEntry = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod.Id,UnitPrice=500,isActive=true,UseStandardPrice=false);
        
        insert StdpbEntry;
        
        PricebookEntry StdpbEntry2 = new PricebookEntry(Pricebook2Id=standardPBId,Product2Id=prod2.Id,UnitPrice=500,isActive=true,UseStandardPrice=false);
        
        insert StdpbEntry2;
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id=pb.Id,Product2Id=prod.Id,UnitPrice=500,isActive=true,UseStandardPrice=false);
        
        insert pbEntry;
        PricebookEntry pbEntry2 = new PricebookEntry(Pricebook2Id=pb.Id,Product2Id=prod2.Id,UnitPrice=500,isActive=true,UseStandardPrice=false);
        
        insert pbEntry2;
        
        for(Integer i=1;i<210;i++)
        {
            Opportunity oppty = new Opportunity (Name='Opportunity'+i,StageName='Prospecting',CloseDate=Date.today().addDays(30),Pricebook2Id=pb.Id); 
            oppList.add(oppty);
        }
        insert oppList;
        
        for(opportunity opp:oppList)
        {
            OpportunityLineItem opLine = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId=pbEntry.Id,Quantity =50,UnitPrice=100);
            oppLineItem.add(opLine);
            
            OpportunityLineItem opLine2 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId=pbEntry2.Id,Quantity =50,UnitPrice=100);
            oppLineItem.add(opLine2);
        }
        
        Test.startTest();
        insert oppLineItem;
        Test.stopTest();
        
    }
    
    @isTest
    public static void insertdata()
    {
        List<Opportunity> opps = [SELECT Opp_LineItem_ProdCode__c FROM Opportunity];
        
        for(Opportunity op :opps)
            assert.areEqual('SP01,SP02',op.Opp_LineItem_ProdCode__c,'Product not inserted');
    }
    
    @isTest
    public static void deleteData()
    {
        
        
        Opportunity opp = [Select Opp_LineItem_ProdCode__c, Id from opportunity limit 1];
        
        List<OpportunityLineItem> oli = [Select Id from OpportunityLineItem Where OpportunityId =:opp.Id Limit 1  ];
        
        Test.startTest();
        delete oli;
        Test.stopTest();
        
        Integer oliCount = [SELECT COUNT()
                            FROM OpportunityLineItem
                            WHERE OpportunityId = :opp.Id];
        
        assert.areEqual(1,oliCount,'Error');
        
    }
    
    
    
}