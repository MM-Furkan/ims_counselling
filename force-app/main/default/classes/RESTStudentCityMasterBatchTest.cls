@isTest
public class RESTStudentCityMasterBatchTest {
    private class Mock implements HttpCalloutMock {
            public HTTPResponse respond(HTTPRequest req) {
                if (req.getEndpoint().endsWith('getstudentcity')) {
                    Boolean b = True;
                    String reCode = '200';
                    String fullJson = 'Here is my String JSON';
                    String sta = 'OK';
                    String Js = '{"studentcity": [{"code": "227","City": "Kolkata"},{"code": "228","City": "Siliguri"}]}';

                    HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setHeader('Authorization', 'Basic eYWdD8n91MMnTYtawCZmWOiqO05/m82qv3/BK7+zagTFUWpfqZJCXkVWqKGGaqB5W2+fqU1C4L+Z3MTdkEYnMXVB0lKa5TOHZ/SNIPm5Un9pRUHwa97FoEMlC5zGjAPN');
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
    
    static testmethod void test() {
        
        // Create test accounts to be updated
        // by the batch job.
        
        List<City__c> accList = new List<City__c>();
        for (Integer i=0;i<200;i++) {
            City__c m = new City__c(Name = '012 ' + i);
            accList.add(m);
        }
        insert accList;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        RESTStudentCityMasterBatch c = new RESTStudentCityMasterBatch();
        Database.executeBatch(c);
        Test.stopTest();
        
    }
}