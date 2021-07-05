@RestResource(urlMapping='/CustomWebToLead/*')
global class saveWebToLeadWS {
    @HttpPost
    global static void doPost() {  
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='CustomWebToLead';
        
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        
        //save request in API Log
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        JSON2ApexSaveWebToLead jsonObj = JSON2ApexSaveWebToLead.parse(jSONRequestBody); 
        System.debug('======----->jsonObj'+jsonObj); 
        String ldSourceId='';
        List<Account> ccList = new List<Account>();
        List<Account> ccList_up = new List<Account>();
        For(StudentAccount s:jsonObj.StudentAccount){
            List<Account> acc=[SELECT Id,FirstName,MiddleName,Description,Mode_of_Coaching__c,Program_Category__c,PersonMailingCountry,PersonMailingPostalCode,PersonMailingState,PersonMailingCity,Website,PersonMailingStreet,Phone,Salutation,Suffix,PersonTitle,Preference__c,LastName,Lead_Source1__c,Name,PersonMobilePhone,Lead_Stage__c,PersonEmail FROM Account WHERE PersonMobilePhone=:s.Mobile AND FirstName=:s.FirstName AND LastName=:s.LastName LIMIT 1]; 
            System.debug('acc==>'+acc);
            if(acc.size()>0){
                if(acc[0].Lead_Stage__c =='Closed Lost' || acc[0].Lead_Stage__c =='Enrolled' || acc[0].Lead_Stage__c =='Partially Enrolled'){
                      Account cc=new Account();
               		  cc.Id=acc[0].Id;
                      cc.Lead_Stage__c='Open';
                      cc.Lead_Mode__c = s.LeadMode;
                      cc.Lead_Source1__c=s.LeadSource;
                      cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.Campaign_Id__c = (s.CampaingId!='')?s.CampaingId :  acc[0].Campaign_Id__c;
                      cc.Mailing_City__c = (s.LeadCity!='')?s.LeadCity :  acc[0].Mailing_City__c;
                      cc.Program__c = (s.Product!='')?s.Product :  acc[0].Program__c;
                      cc.Centre__c = (s.Center!='')?s.Center :  acc[0].Centre__c;
                      ccList_up.add(cc);  
                      ldSourceId=s.LeadSource;
                }else {
                      Account cc=new Account();
               		  cc.Id=acc[0].Id;
                      cc.Lead_Mode__c =  s.LeadMode;
                      cc.Lead_Source1__c=s.LeadSource;
                      cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.Campaign_Id__c = (s.CampaingId!='')?s.CampaingId :  acc[0].Campaign_Id__c;
                      cc.Mailing_City__c = (s.LeadCity!='')?s.LeadCity :  acc[0].Mailing_City__c;
                      cc.Program__c = (s.Product!='')?s.Product :  acc[0].Program__c;
                      cc.Centre__c = (s.Center!='')?s.Center :  acc[0].Centre__c;
                      ccList_up.add(cc);
                     ldSourceId=s.LeadSource;
                }
            }else{
                
            Account cc = new Account();
            cc.FirstName = s.FirstName;
            cc.LastName = s.LastName;
            cc.Lead_Mode__c = s.LeadMode;
            cc.Lead_Source1__c = s.LeadSource;
            cc.PersonEmail = s.Email;
            cc.PersonMobilePhone = s.Mobile;  
            cc.Campaign_Id__c=s.CampaingId;
            cc.Mailing_City__c=s.LeadCity;
            cc.Program__c=s.Product;
            cc.Centre__c=s.Center;    
            
            List<Lead_Source__c> leadSorce=[SELECT Id,Name FROM  Lead_Source__c WHERE Id=:s.LeadSource];
                
                if(leadSorce.size()>0){
                         cc.First_Lead_Source__c=leadSorce[0].Name;
                         cc.Last_Updated_Lead_Source_Time__c=datetime.now(); 
                }
                
            ccList.add(cc);
		  }    
        }
        System.debug('===============---------->'+ccList);
        System.debug('===============---------->'+ccList_up);
        try{
          insert ccList;
          update ccList_up;
        
        //store lead source in related of account
        List<Student_Lead_Source__c> sls_list=new List<Student_Lead_Source__c>();
        for(Account acc:ccList_up){
            Student_Lead_Source__c sls=new Student_Lead_Source__c();
            
            sls.Lead_Source__c=ldSourceId;
            sls.Student_Account__c=acc.Id;
            sls_list.add(sls);
        }
        
        for(Account acc:ccList){
            Student_Lead_Source__c sls=new Student_Lead_Source__c();
            sls.Lead_Source__c=ldSourceId;
            sls.Student_Account__c=acc.Id;
            
            sls_list.add(sls);
        }
            
            upsert sls_list;
            System.debug('-->Data Saved Successfully');
            String resp = JSON.serialize('{"Message":"Data Saved Successfully"}');
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 200;
            api_log.Response__c= String.valueOf(resp);
            api_log.response_time__c=Datetime.now();
            
        }catch(Exception e){
            System.debug('Format Error'+e.getStackTraceString());
            String resp = JSON.serialize('{"Message":"Data Format Error "}');
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            
            response.statusCode = 200;
            api_log.Response__c= String.valueOf(e);
            api_log.response_time__c=Datetime.now();
            
        }
        insert api_log;
    }
    
    public class JSON2ApexSaveWebToLead {
    public List<StudentAccount> StudentAccount;
}

	public class StudentAccount {
		public String FirstName;
		public String MiddleName;
		public String LastName;
		public String Email;
		public String Mobile;
        public String LeadMode;
        public String LeadSource;
        public String LeadCity;
        public String Center;
        public String Product;
        public String CampaingId;
	}

	

	
	public static JSON2ApexSaveWebToLead parse(String json) {
		return (JSON2ApexSaveWebToLead) System.JSON.deserialize(json, JSON2ApexSaveWebToLead.class);
	}

}