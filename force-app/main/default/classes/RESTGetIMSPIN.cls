public class RESTGetIMSPIN {
    
    public Id currentId {get;set;}
    
    public RESTGetIMSPIN(){
        currentId = ApexPages.currentPage().getparameters().get('id');
        System.debug('currentId'+currentId);
    }
     public PageReference getImsPin(){
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='GetImsPin';
         
          Account acc = [SELECT ID, Salutation,FirstName,MiddleName, LastName, PersonEmail, IMS_PIN__c,
                                 PersonMobilePhone, Phone, Description, Employee_Referral_Name__c, Student_Referral_Name__c, 
                                 Referral_Centre__c, Lead_Mode__c, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode,
                                 PersonMailingState, PersonMailingCountry, BillingStreet, BillingCity,                                 
                                 BillingPostalCode, BillingState, BillingCountry FROM Account WHERE Id=:currentId];
         Map<String,Object> StudentDetails = new Map<String,Object>();
         
         		StudentDetails.put('IMSPIN', (acc.IMS_PIN__c!=null)?acc.IMS_PIN__c:'');
                StudentDetails.put('FirstName',(acc.FirstName!=null)?acc.FirstName:'');
                StudentDetails.put('MiddleName',(acc.MiddleName!=null)?acc.MiddleName:'');
                StudentDetails.put('LastName',(acc.LastName!=null)?acc.LastName:'');
                StudentDetails.put('Email',(acc.PersonEmail!=null)?acc.PersonEmail:'');
                StudentDetails.put('Mobile1',(acc.PersonMobilePhone!=null)?acc.PersonMobilePhone:'');
                StudentDetails.put('Mobile2',(acc.Phone!=null)?acc.Phone:'');
                StudentDetails.put('MailingAddress',(acc.PersonMailingCity!=null)?acc.PersonMailingCity:'');
                StudentDetails.put('MailingCity',(acc.PersonMailingCity!=null)?acc.PersonMailingCity:'');//here i need to put code of city
                StudentDetails.put('MailingPinCode',(acc.PersonMailingPostalCode!=null)?acc.PersonMailingPostalCode:'');
                StudentDetails.put('PermanentAddress',(acc.BillingCity!=null)?acc.BillingCity:'');
                StudentDetails.put('PermanentCity',(acc.BillingCity!=null)?acc.BillingCity:'');//here i need to put code of city
                StudentDetails.put('PermanentPinCode',(acc.BillingPostalCode!=null)?acc.BillingPostalCode:'');
                StudentDetails.put('Description',(acc.Description!=null)?acc.Description:'');
                StudentDetails.put('EmployeeReferralName',(acc.Employee_Referral_Name__c!=null)?acc.Employee_Referral_Name__c:'');
                StudentDetails.put('StudentReferralName',(acc.Student_Referral_Name__c!=null)?acc.Student_Referral_Name__c:'');
         
         		Map<String,Object> jsMap = new Map<String,Object>() ;
                jsMap.put('StudentDetails',StudentDetails);
         
         	try{
                String js = JSON.serialize(jsMap);
                
                Http h = new Http();		
                HttpRequest req = new HttpRequest();
                
                req.setMethod('POST');
                req.setBody(js);
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint('http://demo.imsindia.com/SF_API/default.aspx?action=savelead');//sandbox url
               // req.setEndpoint('https://lima.imsindia.com/SF_API/default.aspx?action=savelead');// url live
              
                api_log.Request__c= req.getBody();
                api_log.created_date__c=Datetime.now();   
                
                HttpResponse res = h.send(req);  
                String jsun = res.getBody();

                System.debug('res.getbody'+res.getBody());
                    
                api_log.Response__c= res.getBody();
                api_log.response_time__c=Datetime.now();
                    
                JSON2ApexLIMASaveLeadResponse resp = JSON2ApexLIMASaveLeadResponse.parse(jsun);
                System.debug('-----------resp'+resp);

                acc.IMS_PIN__c = resp.imspin;
                api_log.IMS_Pin_log__c= resp.imspin;   
                    
                update acc;
                System.debug('After update the account--'+acc);
 
            }catch(Exception e){
                 System.debug('SendStudentWithProgREST'+e);
                 api_log.Exception_desc__c=e.getStackTraceString();
            }
        insert api_log; 
            
        PageReference pageRef = new PageReference('/' + currentId);
        //  PageReference pageRef = new PageReference('https://imsindia--imssandbox.lightning.force.com/lightning/r/Account/'+currentId+'/view');
        pageRef.setRedirect(true);
        return pageRef;
     }
    
   
    public class JSON2ApexLIMASaveLeadResponse {

	public String imspin;
	public String message;
}

	
	public static JSON2ApexLIMASaveLeadResponse parse(String json) {
		return (JSON2ApexLIMASaveLeadResponse) System.JSON.deserialize(json, JSON2ApexLIMASaveLeadResponse.class);
	}

}