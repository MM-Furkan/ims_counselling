@isTest
public class RESTGetVarientClassTest {
private class Mock implements HttpCalloutMock {
            public HTTPResponse respond(HTTPRequest req) {
                if (req.getEndpoint().endsWith('getproduct')) {
                    Boolean b = True;
                    String reCode = '200';
                    String fullJson = 'Here is my String JSON';
                    String sta = 'OK';
                    String Js = '{"product": [{"code": "1234","Product": "Academic Support"}]}';

                    HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setHeader('Authorization', 'Basic eYWdD8n91MMnTYtawCZmWOiqO05/m82qv3/BK7+zagTFUWpfqZJCXkVWqKGGaqB5W2+fqU1C4L+Z3MTdkEYnMXVB0lKa5TOHZ/SNIPm5Un9pRUHwa97FoEMlC5zGjAPN');
                    res.setBody(Js);
                    res.setStatusCode(200);
                    res.setStatus(sta);
                    return res;


                } else if (req.getEndpoint().endsWith('getproduct')) {
                    HTTPResponse res = new HTTPResponse();
                    String js = '{"Program": [{"Code": "1234","Program": "Academic Support"}]}';
                    res.setBody(js);
                    res.setStatusCode(200);
                    return res;
                } else if (req.getEndpoint().endsWith('getvariant')) {

                    String sta = 'OK';
                    String js = '{"variant": [{ "CentreCode": "250","ProductCode": "1193","ModeCode": "57","ModeName": "Classroom","VariantCode": "2552","Variant": "MBA CATapult 2019"}]}';
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

    static testmethod void test() {
        
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
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        RESTGetVarientClass s = new RESTGetVarientClass();
		Database.executeBatch(s,5);
       
        
        Test.stopTest();
    }
}