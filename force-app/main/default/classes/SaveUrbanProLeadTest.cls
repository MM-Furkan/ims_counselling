@isTest
    public class SaveUrbanProLeadTest {

        private class Mock implements HttpCalloutMock {
            public HTTPResponse respond(HTTPRequest req) {
                if (req.getEndpoint().endsWith('login')) {
                    Boolean b = True;
                    String reCode = '200';
                    String fullJson = 'Here is my String JSON';
                    String sta = 'OK';
                    String Js = '{"key":"token", "value":"f7779b26c4bd793"}';

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

        public static testMethod void test() {

            Lead_Mode__c ldm = new Lead_Mode__c();
            ldm.Name = 'Digital';
            insert ldm;
            String mdId = ldm.Id;
            
            Lead_Source__c ldSource = NEW Lead_Source__c();
            ldSource.Lead_Mode__c = ldm.Id;
            ldSource.Name ='UrbanPro';
            insert ldSource;
            String ldsId = ldSource.Id;
            
            String js='{\"UrbanProLead\": [{ \"LeadStatus\": \"New\", \"Owner\": \"Roy\", \"Salutation\": \"Mr.\",\"Website\": \"www.gmail.com\", \"FirstName\": \"Jam\", \"Company\": \"Sam Pvt Ltd\", \"MiddleName\": \"Papa\",      \"Industry\": \"\",      \"LastName\": \"Billings\",      \"NoOfEmployees\": \"23\",      \"Suffix\": \"ss\",      \"LeadSource\": \"Master\",      \"Title\": \"Master\",      \"Email\": \"raviavhad12@gmail.com\",      \"Phone\": \"1234567890\",      \"Mobile\": \"9876543210\",      \"Street\": \"Dy Road\",      \"City\": \"Pune\",      \"State\": \"Maharashtra\",      \"PostalCode\": \"020206565\",      \"Country\": \"India\"    },    {      \"LeadStatus\": \"New\",      \"Owner\": \"Roy\",      \"Salutation\": \"Mr.\",      \"Website\": \"www.gmail.com\",      \"FirstName\": \"Pam\",      \"Company\": \"Sam Pvt Ltd\",      \"MiddleName\": \"Papa\",      \"Industry\": \"\",      \"LastName\": \"Billings\",      \"NoOfEmployees\": \"23\",      \"Suffix\": \"ss\",      \"LeadSource\": \"Master\",      \"Title\": \"Master\",      \"Email\": \"raviavhad12@gmail.com\",      \"Phone\": \"1234567890\",      \"Mobile\": \"9876543210\",      \"Street\": \"Dy Road\",      \"City\": \"Pune\",      \"State\": \"Maharashtra\",      \"PostalCode\": \"020206565\",      \"Country\": \"India\"    }  ]}';
            
            
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/saveUrbanProLead'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(js);
            RestContext.request = req;
            RestContext.response = res;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Mock());
            SaveUrbanProLead.doPost();

            Test.stopTest();
        }

    }