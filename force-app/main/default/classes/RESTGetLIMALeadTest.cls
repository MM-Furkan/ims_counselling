@isTest
public class RESTGetLIMALeadTest {
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('getlead')) {
                Boolean b = True;
                String reCode = '200';
                String fullJson = 'Here is my String JSON';
                String sta = 'OK';
                String Js = '{"mtype":"success","StudentAccount": {"FirstName":"TestLead","LastName":"TestLastName"}}';
                
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                //res.setHeader('Authorization', 'Basic eYWdD8n91MMnTYtawCZmWOiqO05/m82qv3/BK7+zagTFUWpfqZJCXkVWqKGGaqB5W2+fqU1C4L+Z3MTdkEYnMXVB0lKa5TOHZ/SNIPm5Un9pRUHwa97FoEMlC5zGjAPN');
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
                
                
            } else if (req.getEndpoint().endsWith('InsertJobcardDetails')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('InsertClientCompany')) {
                
                String sta = 'OK';
                String js = '{"Saved Successfully"}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(js);
                res.setHeader('Content-Type', 'application/json');
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            return null;
        }
    }
    
    public static testMethod void test() {
        
        Lead_Mode__c ldm = new Lead_Mode__c();
        ldm.Name = 'Digital';
        insert ldm;
        String mdId = ldm.Id;
        
        Lead_Source__c ldSource = NEW Lead_Source__c();
        ldSource.Lead_Mode__c = ldm.Id;
        ldSource.Name ='Just Dial';
        insert ldSource;
        String ldsId = ldSource.Id;
        
        Centre__c cen = new Centre__c();
        
        cen.Name = 'Dadar';
        cen.Centre_Code__c = '0129';
        cen.Email_Id__c = 'Test@gmail.com';
        insert cen;
        
        Program__c pgrm = new Program__c();
        
        pgrm.Name = 'CET';
        pgrm.Status__c = 'Active';
        pgrm.Centre__c = cen.id;
        insert pgrm;
        
        Variant__c var = new Variant__c();
        
        var.Name = 'LAW-Intact-2020';
        var.Centre__c = cen.id;
        var.Program__c = pgrm.id;
        var.Mode__c = 'Classroom';
        var.Year__c = '2019';
        insert var;
        
        Account ac = new Account();
        ac.LastName='test';
        ac.PersonEmail = 'raviavhad12@gmail.com';
        ac.PersonMobilePhone = '8655943934';
        ac.Centre__c=cen.Id;
        ac.Total_Enrolled_no__c = 2;
        ac.Total_Closed_Lost_No__c =3;
        ac.Total_Child_Record__c = 1;
        
        //  ac.RecordTypeId = '0122v000000wPRuAAM';
        insert ac;
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', ac.id);
        Test.setMock(HttpCalloutMock.class, new Mock());
        RESTGetLIMALead getLima = new RESTGetLIMALead();
        getLima.RESTGetLIMALeadAction();
        
        Test.stopTest();
    }
    public static testMethod void testMobile() {
        
        Lead_Mode__c ldm = new Lead_Mode__c();
        ldm.Name = 'Digital';
        insert ldm;
        String mdId = ldm.Id;
        
        Lead_Source__c ldSource = NEW Lead_Source__c();
        ldSource.Lead_Mode__c = ldm.Id;
        ldSource.Name ='Just Dial';
        insert ldSource;
        String ldsId = ldSource.Id;
        
        Centre__c cen = new Centre__c();
        
        cen.Name = 'Dadar';
        cen.Centre_Code__c = '0129';
        cen.Email_Id__c = 'Test@gmail.com';
        insert cen;
        
        Program__c pgrm = new Program__c();
        
        pgrm.Name = 'CET';
        pgrm.Status__c = 'Active';
        pgrm.Centre__c = cen.id;
        insert pgrm;
        
        Variant__c var = new Variant__c();
        
        var.Name = 'LAW-Intact-2020';
        var.Centre__c = cen.id;
        var.Program__c = pgrm.id;
        var.Mode__c = 'Classroom';
        var.Year__c = '2019';
        insert var;
        
        Account ac = new Account();
        ac.LastName='test';
        ac.PersonEmail = Null;
        ac.PersonMobilePhone = '8655943934';
        ac.Centre__c=cen.Id;
        ac.Total_Enrolled_no__c = 2;
        ac.Total_Closed_Lost_No__c =3;
        ac.Total_Child_Record__c = 1;
        
        //  ac.RecordTypeId = '0122v000000wPRuAAM';
        insert ac;
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', ac.id);
        Test.setMock(HttpCalloutMock.class, new Mock());
        RESTGetLIMALead getLima = new RESTGetLIMALead();
        getLima.c = False;
        getLima.RESTGetLIMALeadAction();
        
        Test.stopTest();
    }
}