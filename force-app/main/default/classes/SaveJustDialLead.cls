@RestResource(urlMapping='/saveJustDialLead/*')
global class SaveJustDialLead {
    @HttpPost
    global static void doPost() {  
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='saveJustDialLead';
        
        RestRequest request = RestContext.request;  
        
        RestResponse response = RestContext.response;  
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        
        //save request in API Log
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        JSON2ApexSaveChatBotLead jsonObj = JSON2ApexSaveChatBotLead.parse(jSONRequestBody); 
        System.debug('======----->jsonObj'+jsonObj); 
        
        //fetch lead mode
        Lead_Mode__c ldMode = [SELECT Id, Name From Lead_Mode__c WHERE Name=:'Digital'];
        String ldModeId = ldMode.Id;
        
        //fetch lead source
        Lead_Source__c ldSource = [SELECT Id, Name FROM Lead_Source__c WHERE Name =:'Just Dial'];
        String ldSourceId = ldSource.Id;
       
        
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
                      cc.Lead_Mode__c = ldModeId;
                      cc.Lead_Source1__c=ldSourceId;
                      cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                      cc.Salutation = (s.Salutation!='')?s.Salutation :  acc[0].Salutation;
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;
                      cc.Phone = (s.Phone!='')?s.Phone :  acc[0].Phone;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      If(s.dncphone!='0'){
                		cc.DNC_Phone__c = True;
            		  }
            		  If(s.dncmobile!='0'){
                		cc.DNC_Mobile__c = True;
            		  }
                      ccList_up.add(cc);  
                }else {
                      Account cc=new Account();
               		  cc.Id=acc[0].Id;
                       cc.Lead_Mode__c = ldModeId;
                      cc.Lead_Source1__c=ldSourceId;
                      cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                      cc.Salutation = (s.Salutation!='')?s.Salutation :  acc[0].Salutation;
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;
                      cc.Phone = (s.Phone!='')?s.Phone :  acc[0].Phone;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      If(s.dncphone!='0'){
                		cc.DNC_Phone__c = True;
            		  }
            		  If(s.dncmobile!='0'){
                		cc.DNC_Mobile__c = True;
            		  }
                     ccList_up.add(cc);
                }
            }else{
                
            Account cc = new Account();
            cc.Salutation = s.Salutation;
            cc.FirstName = s.FirstName;
            cc.LastName = s.LastName;
            cc.Lead_Mode__c = ldModeId;
            cc.Lead_Source1__c = ldSourceId;
            cc.PersonEmail = s.Email;
            cc.Phone = s.Phone;
            cc.PersonMobilePhone = s.Mobile;
            cc.First_Lead_Source__c='Just Dial';   
            cc.Last_Updated_Lead_Source_Time__c=datetime.now(); 
            If(s.dncphone!='0'){
                cc.DNC_Phone__c = True;
            }
            If(s.dncmobile!='0'){
                cc.DNC_Mobile__c = True;
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
            System.debug('Format Error');
            String resp = JSON.serialize('{"Message":"Data Format Error"}');
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            
            response.statusCode = 200;
            api_log.Response__c= String.valueOf(e);
            api_log.response_time__c=Datetime.now();
            
        }
        insert api_log;
    }  
    
    //
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class JSON2ApexSaveChatBotLead {
    public List<StudentAccount> StudentAccount;
}

	public class StudentAccount {
		public String LeadStatus;
		public String Owner;
		public String Salutation;
		public String Website;
		public String FirstName;
		public String Company;
		public String MiddleName;
		public String Industry;
		public String LastName;
		public String NoOfEmployees;
		public String Suffix;
		public String LeadSource;
		public String Title;
		public String Email;
		public String Phone;
		public String Mobile;
		public String Rating;
		public String Street;
		public String City;
		public String State;
		public String PostalCode;
		public String Country;
        public String DNCMobile;
        public string DNCPhone;
        
        //add by shashank 08_04_2020
        public String ProgramCategory;
	}

	

	
	public static JSON2ApexSaveChatBotLead parse(String json) {
		return (JSON2ApexSaveChatBotLead) System.JSON.deserialize(json, JSON2ApexSaveChatBotLead.class);
	}

    
}