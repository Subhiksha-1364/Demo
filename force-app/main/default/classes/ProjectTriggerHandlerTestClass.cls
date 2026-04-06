@isTest
public class ProjectTriggerHandlerTestClass {
    
    @testSetup
    public static void loadData()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0;i<=210;i++)
        {
           Opportunity opp = new Opportunity(Name ='Test Data'+i,StageName='Prospecting',CloseDate = Date.today().addDays(30)); 
            oppList.add(opp);
        }
        
        
        insert oppList;
    
    }
    
    @isTest
    public static void doTestInsert()
    {
        List<Project__c> projList = new List<Project__c>();
        Opportunity opp =[Select Id,Active_Project__c
                          From Opportunity 
                          Limit 1 ];
        Project__c ActivePro = new Project__c(Name = 'Project 1 ',Opportunity__c=opp.Id,Status__c ='Active');
        Project__c InactiveProj = new Project__c(Name = 'Project 2 ',Opportunity__c=opp.Id,Status__c ='Inactive');
        
       
        projList.add(ActivePro);
        projList.add(InactiveProj);
        
        insert projList;
        Opportunity oppty =[Select Id,Active_Project__c
                          From Opportunity 
                          Limit 1 ];
        
       Assert.areEqual(true,oppty.Active_Project__c,'The checkbox should  be marked if there is atleast one active projects'); 
        
    }
    
    @isTest
     public static void doTestUpdate()
     {
         checkRecursion.isRecursion = false;
        Opportunity oppList =[Select Id,Active_Project__c 
                           From Opportunity 
                           Limit 1 ];
                            
         
        Project__c pro = new Project__c (Name = 'Project 3 ',Opportunity__c=oppList.Id,Status__c ='Active');
         
      
         
         insert pro;
         
         
         checkRecursion.isRecursion = false;
         
         pro.Status__c='Inactive';
         
         Test.startTest();
         update pro;
         Test.stopTest();
         
         
         
         Opportunity opp =[Select Id,Active_Project__c 
                           From Opportunity 
                           Where Id =:pro.Opportunity__c 
                            ];
         
         Assert.areEqual(false,opp.Active_Project__c,'The checkbox should not be marked if there is no active projects');
         
     }
    

}