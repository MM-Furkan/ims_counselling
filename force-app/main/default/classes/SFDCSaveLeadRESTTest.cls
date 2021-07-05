@isTest
public class SFDCSaveLeadRESTTest {
    
  
    static testmethod void test() {
        
        Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        
        Centre__c cen = new Centre__c();
        cen.Name = 'Thane';
        cen.Centre_Code__c = '101';
        insert cen;
        
        Program__c pgrm = new Program__c();
        pgrm.Name = 'TestProgram';
        pgrm.Program_Code__c = '011';
        pgrm.Centre__c = cen.id;
        insert pgrm;
        
        Variant__c var = new Variant__c();
        var.Name = 'TestVariants';
        var.Program__c = pgrm.Id;
        var.Centre__c = cen.id;
        insert var;
        
        Account acc = new Account();
        // acc.Name = 'Test ';
        acc.LastName = 'Test';
        //acc.Variant__c=var.id;
        acc.PersonMobilePhone = '8467775437';
        acc.PersonEmail = 'raviavhad12@gmail.com';
        acc.RecordTypeId = objectRecordTypeId;
        acc.Program__c = pgrm.id;
        acc.Centre__c = cen.id;
        acc.Variant__c = var.id;
        insert acc;
        
        
        String  js = '{ \"StudentAccount\": {   \"IMSPIN\": \"IMS0000329643\",   \"Salutation\": \"\",   \"FirstName\": \"Man\",   \"MiddleName\": \"In\",   \"LastName\": \"Middle\",   \"Email\": \"ravindra@finessedirect.com\",   \"Mobile1\": \"9619462736\",   \"Mobile2\": \"9619462736\",   \"Description\": \"\",   \"MailingCity\": \"\",   \"Order\": \"\",   \"LeadStage\": \"\",   \"Preference\": \"\",   \"ReferredBy\": \"\",   \"EmployeeReferralName\": \"\",   \"StudentReferralName\": \"\",   \"ReferralCentre\": \"\",   \"LeadMode\": \"\",   \"LeadSource\": \"\",   \"Priority\": \"\",   \"ProductDeliveryMode\": \"\",   \"Productwise\": \"\",   \"MailingStreet\": \"\",   \"MailingState\": \"\",   \"MailingPinCode\": \"\",   \"MailingCountry\": \"\",   \"Street\": \"\",   \"City\": \"\",   \"State\": \"\",   \"PinCode\": \"\",   \"Country\": \"\",   \"CityCode\": \"1053\",   \"ProductCode\": \"1195\",   \"ModeCode\": \"1003\",   \"Variant\": \"2675\",   \"CentreCode\": \"446\" }}';
            
            
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //req.requestURI = ''; //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody = Blob.valueof(js);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
       
      
        
  //     Test.setMock(HttpCalloutMock.class, new Mock());
        SFDCSaveLeadREST.doPost();
        
        Test.stopTest();
        
    }
     static testmethod void test1() {
        
        Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        
        Centre__c cen = new Centre__c();
        cen.Name = 'Thane';
        cen.Centre_Code__c = '101';
        insert cen;
        
        Program__c pgrm = new Program__c();
        pgrm.Name = 'TestProgram';
        pgrm.Program_Code__c = '011';
        pgrm.Centre__c = cen.id;
        insert pgrm;
        
        Variant__c var = new Variant__c();
        var.Name = 'TestVariants';
        var.Program__c = pgrm.Id;
        var.Centre__c = cen.id;
        insert var;
        
        Account acc = new Account();
        // acc.Name = 'Test ';
        acc.LastName = 'Test';
        //acc.Variant__c=var.id;
        acc.PersonMobilePhone = '8467775437';
        acc.PersonEmail = 'raviavhad12@gmail.com';
        acc.RecordTypeId = objectRecordTypeId;
        acc.Program__c = pgrm.id;
        acc.Centre__c = cen.id;
        acc.Variant__c = var.id;
        insert acc;
        
        
        String  js = '{ \"StudentAccount\": {   \"IMSPIN\": \"IMS0000329643\",   \"Salutation\": \"\",   \"FirstName\": \"Man\",   \"MiddleName\": \"In\",   \"LastName\": \"Middle\",   \"Email\": \"raviavhad12@gmail.com\",   \"Mobile1\": \"9619462736\",   \"Mobile2\": \"9619462736\",   \"Description\": \"\",   \"MailingCity\": \"\",   \"Order\": \"\",   \"LeadStage\": \"\",   \"Preference\": \"\",   \"ReferredBy\": \"\",   \"EmployeeReferralName\": \"\",   \"StudentReferralName\": \"\",   \"ReferralCentre\": \"\",   \"LeadMode\": \"\",   \"LeadSource\": \"\",   \"Priority\": \"\",   \"ProductDeliveryMode\": \"\",   \"Productwise\": \"\",   \"MailingStreet\": \"\",   \"MailingState\": \"\",   \"MailingPinCode\": \"\",   \"MailingCountry\": \"\",   \"Street\": \"\",   \"City\": \"\",   \"State\": \"\",   \"PinCode\": \"\",   \"Country\": \"\",   \"CityCode\": \"1053\",   \"ProductCode\": \"1195\",   \"ModeCode\": \"1003\",   \"Variant\": \"2675\",   \"CentreCode\": \"446\" }}';
            
            
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //req.requestURI = ''; //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody = Blob.valueof(js);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
       
      
        
  //     Test.setMock(HttpCalloutMock.class, new Mock());
        SFDCSaveLeadREST.doPost();
        
        Test.stopTest();
        
    }
}