@isTest
public class SFDCGetLeadRESTTest {
   
    
    static testmethod void test() {
         Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rowsrate';  
        
        req.addParameter('email', 'raviavhad12@gmail.com');
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Account acc = new Account();
        // acc.Name = 'Test ';
        acc.LastName = 'Test';
        //acc.Variant__c=var.id;
        acc.PersonMobilePhone = '8467775437';
        acc.PersonEmail = 'raviavhad12@gmail.com';
        acc.RecordTypeId = objectRecordTypeId;
        
        insert acc;
        
        Test.startTest();
        SFDCGetLeadREST.doGet();
        Test.stopTest();
    }
    static testmethod void test01() {
         Id objectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student Account P').getRecordTypeId();
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rowsrate';  
        
        req.addParameter('email', 'raviavhad12@gmail.com');
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Account acc = new Account();
        // acc.Name = 'Test ';
        acc.LastName = 'Test';
        //acc.Variant__c=var.id;
        acc.PersonMobilePhone = '8467775437';
        acc.PersonEmail = 'raviavhad@gmail.com';
        acc.RecordTypeId = objectRecordTypeId;
        
        insert acc;
        
        Test.startTest();
        SFDCGetLeadREST.doGet();
        Test.stopTest();
    }
}