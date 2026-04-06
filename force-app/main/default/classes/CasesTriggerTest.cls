@isTest
public class CasesTriggerTest {
    
    @testSetup
    public static void loaddata()
    {
        
        List<Case> casesList = new List<case>();
        
        Case C1 = new Case (Origin = 'Web', Status ='New');
        
        casesList.add(C1);
        
        insert casesList;
        
    }

}