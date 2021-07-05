@RestResource(urlMapping='/saveChatBotLead/*')
global class SaveChatBotLead {
    @HttpPost
    global static void doPost() {  
        
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='saveChatBotLead';
        RestRequest request = RestContext.request;  
        
        RestResponse response = RestContext.response;  
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        JSON2ApexSaveChatBotLead jsonObj = JSON2ApexSaveChatBotLead.parse(jSONRequestBody);  
        
        Lead_Mode__c ldMode = [SELECT Id, Name From Lead_Mode__c WHERE Name=:'Chat'];
        String ldModeId = ldMode.Id;
     
        
        Lead_Source__c ldSource = [SELECT Id, Name FROM Lead_Source__c WHERE Name =:'Chatbot'];
        String ldSourceId = ldSource.Id;
       
        
        //List<Chatbot_Lead__c> ccList = new List<Chatbot_Lead__c>();
        List<Account> ccList = new List<Account>();
        List<Account> ccList_up = new List<Account>();
        For(ChatBotLead s:jsonObj.ChatBotLead){
            List<Account> acc=[SELECT Id,MiddleName,Description,Mode_of_Coaching__c,Program_Category__c,PersonMailingCountry,PersonMailingPostalCode,PersonMailingState,PersonMailingCity,Website,PersonMailingStreet,Phone,Salutation,Suffix,PersonTitle,Preference__c,LastName,Lead_Source1__c,Name,PersonMobilePhone,Lead_Stage__c,PersonEmail FROM Account WHERE PersonMobilePhone=:s.Mobile AND FirstName=:s.FirstName AND LastName=:s.LastName LIMIT 1]; 
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
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;  
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;  
                      cc.MiddleName = (s.MiddleName!='')?s.MiddleName :  acc[0].MiddleName;  
                      cc.Suffix = (s.Suffix!='')?s.Suffix :  acc[0].Suffix;  
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;  
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.NumberOfEmployees = (s.NoOfEmployees!='')?Integer.valueOf(s.NoOfEmployees):  acc[0].NumberOfEmployees;
                      cc.Website = (s.Website!='')?s.Website :  acc[0].Website;
                      cc.PersonMailingCity = (s.City!='')?s.City :  acc[0].PersonMailingCity;
                      cc.PersonMailingState = (s.State!='')?s.State :  acc[0].PersonMailingState;
                      cc.PersonMailingPostalCode = (s.PostalCode!='')?s.PostalCode :  acc[0].PersonMailingPostalCode;
                      cc.Program_Category__c = (s.Program!='')?s.Program :  acc[0].Program_Category__c;
                      ccList_up.add(cc);  
                      
                }else {
                      Account cc=new Account();
               		  cc.Id=acc[0].Id;
                      cc.Lead_Mode__c = ldModeId;
                      cc.Lead_Source1__c=ldSourceId;
                      cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                      cc.Salutation = (s.Salutation!='')?s.Salutation :  acc[0].Salutation; 
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;  
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName;  
                      cc.MiddleName = (s.MiddleName!='')?s.MiddleName :  acc[0].MiddleName;  
                      cc.Suffix = (s.Suffix!='')?s.Suffix :  acc[0].Suffix;  
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;  
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.NumberOfEmployees = (s.NoOfEmployees!='')?Integer.valueOf(s.NoOfEmployees):  acc[0].NumberOfEmployees;
                      cc.Website = (s.Website!='')?s.Website :  acc[0].Website;
                      cc.PersonMailingCity = (s.City!='')?s.City :  acc[0].PersonMailingCity;
                      cc.PersonMailingState = (s.State!='')?s.State :  acc[0].PersonMailingState;
                      cc.PersonMailingPostalCode = (s.PostalCode!='')?s.PostalCode :  acc[0].PersonMailingPostalCode;
                      cc.Program_Category__c = (s.Program!='')?s.Program :  acc[0].Program_Category__c;
                      ccList_up.add(cc);
                }
            }else{

            Account cc = new Account();
            cc.Salutation = s.Salutation;
            cc.Lead_Mode__c = ldModeId;
            cc.Lead_Source1__c = ldSourceId;
            cc.FirstName = s.FirstName;
            cc.MiddleName=s.MiddleName;
            if(s.LastName !=null){
                  cc.LastName = s.LastName;
            }else{
                 cc.LastName = s.FirstName;
            }
            cc.Suffix = s.Suffix;
            cc.PersonEmail = s.Email;
            cc.Website = s.Website;
            cc.PersonMobilePhone = s.Mobile;
            cc.Program_Category__c=s.Program;
            cc.NumberOfEmployees = Integer.valueOf(s.NoOfEmployees);
            cc.PersonMailingCity = s.City;
            cc.PersonMailingState = s.State;
            cc.PersonMailingPostalCode = s.PostalCode;
            cc.First_Lead_Source__c='Chatbot';
            cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
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
            api_log.Response__c= String.valueOf(resp);
            api_log.response_time__c=Datetime.now();
            
        }
        insert api_log;
    }  
    
    //
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class JSON2ApexSaveChatBotLead {
    public List<ChatBotLead> ChatBotLead;
}

	public class ChatBotLead {
		//public String LeadStatus;
		public String Owner;
		public String Salutation;
		public String Website;
	    public String FirstName;
	    public String MiddleName;
		public String Company;
		public String LastName;
		public String NoOfEmployees;
		public String Suffix;
       
		public String LeadSource;
		public String Title;

        public String Program;

		public String Email;
		public String Phone;
		public String Mobile;
		public String Rating;
		public String Street;
		public String City;
		public String State;
		public String PostalCode;
		public String Country;
	}

	

	
	public static JSON2ApexSaveChatBotLead parse(String json) {
		return (JSON2ApexSaveChatBotLead) System.JSON.deserialize(json, JSON2ApexSaveChatBotLead.class);
	}

    
}