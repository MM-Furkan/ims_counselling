global class SendStudentWithProgREST {
	@Future(callout=true)
    global static void apiCallout(Set<Id> ids){
        System.debug('----------------->SendStudentWithProgREST apiCallout');
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='SendStudentWithProgREST';

        List<Program_Admitted__c> progList = [SELECT Id, Name,Student_Account__c,Program__r.Name,Program__r.Program_Code__c,
                                  Centre__r.Name,Centre__r.Centre_Code__c,Variant__r.Name,Variant__r.Variant_Code__c FROM Program_Admitted__c WHERE Id IN:ids];
       	
        String accId = progList[0].Student_Account__c;
        List<Account> accList = [SELECT ID, Salutation,FirstName,MiddleName, LastName, PersonEmail, IMS_PIN__c,
                                 PersonMobilePhone, Phone, Description, Employee_Referral_Name__c, Student_Referral_Name__c, 
                                 Referral_Centre__c, Lead_Mode__c, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode,
                                 PersonMailingState, PersonMailingCountry, BillingStreet, BillingCity,                                 
                                 BillingPostalCode, BillingState, BillingCountry FROM Account WHERE Id=:accId];
       
        Map<String,Object> StudentDetails = new Map<String,Object>();
       

        List<Map<String,String>> programs = new List<Map<String,String>>();
        System.debug('----------------->ids '+ids);
        System.debug('----------------->accId '+accId);
        System.debug('----------------->account '+accList);
        System.debug('----------------->progList  '+progList);
        System.debug('----------------->progList size '+progList.size());
        System.debug('----------------->account size '+accList.size());
      
         IF(accList.size()>0){
                
                Account acc = accList[0];
                StudentDetails.put('IMSPIN', acc.IMS_PIN__c);
                StudentDetails.put('FirstName',acc.FirstName);
                StudentDetails.put('MiddleName',acc.MiddleName);
                StudentDetails.put('LastName',acc.LastName);
                StudentDetails.put('Email',acc.PersonEmail);
                StudentDetails.put('Mobile1',acc.PersonMobilePhone);
                StudentDetails.put('Mobile2',acc.Phone);
                StudentDetails.put('MailingAddress',acc.PersonMailingCity);
                StudentDetails.put('MailingCity',acc.PersonMailingCity);//here i need to put code of city
                StudentDetails.put('MailingPinCode',acc.PersonMailingPostalCode);
                StudentDetails.put('PermanentAddress',acc.BillingCity);
                StudentDetails.put('PermanentCity',acc.BillingCity);//here i need to put code of city
                StudentDetails.put('PermanentPinCode',acc.BillingPostalCode);
                StudentDetails.put('CentreCode','');//here i need to put code of centre
                StudentDetails.put('ProductCode','');//here i need to put code of product
                StudentDetails.put('VariantCode','');//here i need to put code of varient
                StudentDetails.put('Description',acc.Description);
                StudentDetails.put('EmployeeReferralName',acc.Employee_Referral_Name__c);
                StudentDetails.put('StudentReferralName',acc.Student_Referral_Name__c);
                StudentDetails.put('LeadMode','');
                StudentDetails.put('LeadSource','');
                StudentDetails.put('ProductDeliveryMode','');
                
               // List<Program_Admitted__c> progList = acc.Program_Wise_Centres__r;
                For(Program_Admitted__c p:progList){
                     Map<String,String> programMap = new Map<String,String>();
                    programMap.put('CentreCode',p.Centre__r.Centre_Code__c);
                    System.debug('CentreCode'+p.Centre__r.Centre_Code__c);

                    programMap.put('ProductCode',p.Program__r.Program_Code__c);
                    System.debug('ProductCode'+p.Program__r.Program_Code__c);

                    programMap.put('VariantCode',p.Variant__r.Variant_Code__c);
                    System.debug('VariantCode'+p.Variant__r.Variant_Code__c);
                    //programMap.put('VariantCode',p.Variant__r.Name);
                    programs.add(programMap);
                }
                System.debug('Before Final program map'+programs);

                StudentDetails.put('Program',programs);

                System.debug('-------------------------------->savelimalead'+StudentDetails);

                 Map<String,Object> jsMap = new Map<String,Object>() ;
                jsMap.put('StudentDetails',StudentDetails);
                System.debug('-------------------------------->jsMap'+jsMap);

                try{
                String js = JSON.serialize(jsMap);
                String token = '';
                
                Http h = new Http();		
                HttpRequest req = new HttpRequest();
                
                req.setMethod('POST');
                req.setBody(js);
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                //req.setHeader('token', token);
                req.setEndpoint('http://demo.imsindia.com/SF_API/default.aspx?action=savelead');//sandbox url
                // req.setEndpoint('https://lima.imsindia.com/SF_API/default.aspx?action=savelead');// url live
               // req.setEndpoint(baseUrl+'/SF_API/default.aspx?action=savelead');
                System.debug('The request is made to LIMA----'+req);
                System.debug('The request is made to LIMA----'+req.getHeader('Content-Type'));
                
                String sms = req.getBody();
                System.debug('The request is made to LIMA----'+sms);
                api_log.Request__c= req.getBody();
                api_log.created_date__c=Datetime.now();    
                HttpResponse res = h.send(req);
                System.debug('The response is getting from LIMA Save Lead---'+res);
                
                String jsun = res.getBody();

                System.debug('res.getbody'+res.getBody());
                    
                api_log.Response__c= res.getBody();
                api_log.response_time__c=Datetime.now();
                    
                JSON2ApexLIMASaveLeadResponse resp = JSON2ApexLIMASaveLeadResponse.parse(jsun);
                System.debug('-----------resp'+resp);

                acc.IMS_PIN__c = resp.imspin;
                System.debug('I am going to update the account with IMS Pin'+resp.imspin);
                api_log.IMS_Pin_log__c= resp.imspin;   
                    
                update acc;
                System.debug('After update the account--'+acc);
 
            }catch(Exception e){
                 System.debug('SendStudentWithProgREST'+e);
                 api_log.Exception_desc__c=e.getStackTraceString();
            }
                
            
         }
        insert api_log;
   
    }

    
public class JSON2ApexLIMASaveLeadResponse {

	public String imspin;
	public String message;
}

	
	public static JSON2ApexLIMASaveLeadResponse parse(String json) {
		return (JSON2ApexLIMASaveLeadResponse) System.JSON.deserialize(json, JSON2ApexLIMASaveLeadResponse.class);
	}
}