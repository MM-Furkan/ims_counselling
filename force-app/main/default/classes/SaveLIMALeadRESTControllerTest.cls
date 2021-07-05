@isTest
public class SaveLIMALeadRESTControllerTest {
    
    
    private class Mock implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
            response.setStatusCode(200);
            return response; 
        }
    }
    
    
    static testmethod void test() {
        
        Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        
        List<Program__c> progList = new List<Program__c>();
        Program__c p = new Program__c();
        p.Program_Code__c = '1111';
        progList.add(p);
        
        insert progList;
        
        Centre__c c = new Centre__c();
        c.Name = 'Mumbai';
        c.Centre_Code__c = '2111';
        
        insert c;
        
        Variant__C var = new Variant__c();
        var.Program__c = progList[0].Id;
        var.Centre__c = c.Id;
        
        insert var;
        
        Account acc = new Account();
        // acc.Name = 'Test ';
        acc.LastName = 'Test';
        acc.Variant__c=var.id;
        acc.PersonMobilePhone = '8467775437';
        acc.PersonEmail = 'Test@gmail.com';
        acc.RecordTypeId = objectRecordTypeId;
        
        insert acc;
        
        Program_Admitted__c ProAddmi = new Program_Admitted__c();    
        ProAddmi.Student_Account__c = acc.id;
        ProAddmi.Program__c = p.Id;
        ProAddmi.Centre__c = c.id; 
        ProAddmi.Variant__c = var.Id;
        insert ProAddmi;
        
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock()); 
        
        SaveLIMALeadRESTController s = new SaveLIMALeadRESTController();
        
        
        PageReference pageRef = Page.SaveLimaLeadAPIPage;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',acc.id);
        s.entryAction();
        s.Cancel();
        Test.stopTest();
    }
}