@isTest
public class SendStudentWithProgREST_TEST {
    
    public static testmethod void test(){
        
        Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        Set<ID> progIDs = new Set<ID>(); 
        /*  List<Program_Admitted__c> pi=[SELECT Id, Name,Student_Account__c,Program__r.Name,Program__r.Program_Code__c,
Centre__r.Name,Centre__r.Centre_Code__c,Variant__r.Name,Variant__r.Variant_Code__c FROM Program_Admitted__c ];


For(Program_Admitted__c p :pi){
if(p.Program_Admitted__c == false){
progIDs.add(p.Id);
}

}
If(progIDs.size()>0){

Test.startTest();
SendStudentWithProgREST.apiCallout(progIDs);
Test.stopTest(); */
        // List<Program__c> progList = new List<Program__c>();
        Program__c p1 = new Program__c();
        p1.Program_Code__c = '1111';
        insert p1;
        // progList.add(p1);
        
        // insert progList;
        
        Centre__c c = new Centre__c();
        c.Name = 'Mumbai';
        c.Centre_Code__c = '2111';
        
        insert c;
        
        Variant__C var = new Variant__c();
        var.Program__c = p1.Id;
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
        
        
        
        
        Program_Admitted__c padm = new Program_Admitted__c();
        //  padm.Name = 'Test';
        padm.Student_Account__c = acc.id;
        padm.Centre__c = c.id;
        padm.Variant__c = var.id;
        padm.Program__c = p1.id;
        padm.Program_Admitted__c = False;
        insert padm;
        
        
        
        String  js ='{  \"StudentDetails\": {    \"FirstName\": \"sam\",    \"MiddleName\": \"\",    \"LastName\": \"s\",    \"Email\": \"sam123455@gmail.com\",    \"Mobile1\": \"7455468631\",    \"Mobile2\": \"\",    \"MailingAddress\": \"Inida\",    \"MailingCity\": \"\",    \"MailingPinCode\": \"400070\",    \"PermanentAddress\": \"India\",    \"PermanentCity\": \"1003\",    \"PermanentPinCode\": \"400070\",    \"CentreCode\": \"\",    \"ProductCode\": \"\",    \"VariantCode\": \"\",    \"Description\": \"\",    \"EmployeeReferralName\": \"\",    \"StudentReferralName\": \"\",    \"LeadMode\": \"\",    \"LeadSource\": \"\",    \"ProductDeliveryMode\": \"\",        \"Program\":[{  \"CentreCode\":\"296\",  \"ProductCode\":\"1198\",  \"VariantCode\":\"\"}]     }}';
        
        String js1 = JSON.serialize(js);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //req.requestURI = ''; //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody = Blob.valueof(js1);
        RestContext.request = req;
        RestContext.response = res;
        
        
        String jsun =' {\"imspin\": \"IMS0000553679\",  \"message\": \"Lead Added successfully\"}';
        SendStudentWithProgREST.JSON2ApexLIMASaveLeadResponse resp = SendStudentWithProgREST.JSON2ApexLIMASaveLeadResponse.parse(jsun);      
        
        
        
        
        List<Program_Admitted__c> pi=[SELECT Id, Name,Student_Account__c,Program__r.Name,Program__r.Program_Code__c,
                                      Centre__r.Name,Centre__r.Centre_Code__c,Variant__r.Name,Variant__r.Variant_Code__c FROM Program_Admitted__c ];
        
        
        
        For(Program_Admitted__c p :pi){
            progIDs.add(p.Id);
        } 
        Test.startTest();
        SendStudentWithProgREST.apiCallout(progIDs);
        SendStudentWithProgREST.parse(js);
        Test.stopTest();
        
    }
    
    
    
}