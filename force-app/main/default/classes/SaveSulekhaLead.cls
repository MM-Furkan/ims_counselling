@RestResource(urlMapping='/saveSulekhaLead/*')
global class SaveSulekhaLead {
    @HttpPost
    global static void doPost() { 
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='saveSulekhaLead';
        
        RestRequest request = RestContext.request;  
        
        RestResponse response = RestContext.response;  
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        System.debug('jSONRequestBody'+jSONRequestBody);
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        
        JSON2ApexSaveChatBotLead jsonObj = JSON2ApexSaveChatBotLead.parse(jSONRequestBody);  
        
        //fetch lead mode 
        Lead_Mode__c ldMode = [SELECT Id, Name From Lead_Mode__c WHERE Name=:'Digital'];
        String ldModeId = ldMode.Id;
       
        //fetch lead source 
        Lead_Source__c ldSource = [SELECT Id, Name FROM Lead_Source__c WHERE Name =:'Sulekha'];
        String ldSourceId = ldSource.Id;

        List<Account> ccList = new List<Account>();
        List<Account> ccList_up = new List<Account>();
        For(SulekhaLead s:jsonObj.SulekhaLead){
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
                      cc.FirstName = (s.FirstName!='')?s.FirstName :  acc[0].FirstName; 
                      cc.LastName = (s.LastName!='')?s.LastName :  acc[0].LastName;  
                      cc.Suffix = (s.Suffix!='')?s.Suffix :  acc[0].Suffix;  
                      cc.PersonTitle = (s.Title!='')?s.Title :  acc[0].PersonTitle;  
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;  
                      cc.Phone = (s.Phone!='')?s.Phone :  acc[0].Phone;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.Website = (s.Website!='')?s.Website :  acc[0].Website;
                      cc.PersonMailingStreet = (s.Street!='')?s.Street :  acc[0].PersonMailingStreet;
                      cc.PersonMailingCity = (s.City!='')?s.City :  acc[0].PersonMailingCity;
                      cc.PersonMailingState = (s.State!='')?s.State :  acc[0].PersonMailingState;
                      cc.PersonMailingPostalCode = (s.PostalCode!='')?s.PostalCode :  acc[0].PersonMailingPostalCode;
                      cc.PersonMailingCountry = (s.Country!='')?s.Country :  acc[0].PersonMailingCountry;
                      cc.Program_Category__c = (s.ProgramCategory!='')?s.ProgramCategory :  acc[0].Program_Category__c;
					  cc.Mode_of_Coaching__c = (s.ModeofCoaching!='')?s.ModeofCoaching :  acc[0].Mode_of_Coaching__c;
                      cc.Description = (s.Description!='')?s.Description :  acc[0].Description;
                      cc.Preference__c = (s.Preferences!='')?s.Preferences :  acc[0].Preference__c;
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
                      cc.Suffix = (s.Suffix!='')?s.Suffix :  acc[0].Suffix;  
                      cc.PersonTitle = (s.Title!='')?s.Title :  acc[0].PersonTitle;  
                      cc.PersonEmail = (s.Email!='')?s.Email :  acc[0].PersonEmail;  
                      cc.Phone = (s.Phone!='')?s.Phone :  acc[0].Phone;
                      cc.PersonMobilePhone = (s.Mobile!='')?s.Mobile :  acc[0].PersonMobilePhone;
                      cc.Website = (s.Website!='')?s.Website :  acc[0].Website;
                      cc.PersonMailingStreet = (s.Street!='')?s.Street :  acc[0].PersonMailingStreet;
                      cc.PersonMailingCity = (s.City!='')?s.City :  acc[0].PersonMailingCity;
                      cc.PersonMailingState = (s.State!='')?s.State :  acc[0].PersonMailingState;
                      cc.PersonMailingPostalCode = (s.PostalCode!='')?s.PostalCode :  acc[0].PersonMailingPostalCode;
                      cc.PersonMailingCountry = (s.Country!='')?s.Country :  acc[0].PersonMailingCountry;
                      cc.Program_Category__c = (s.ProgramCategory!='')?s.ProgramCategory :  acc[0].Program_Category__c;
					  cc.Mode_of_Coaching__c = (s.ModeofCoaching!='')?s.ModeofCoaching :  acc[0].Mode_of_Coaching__c;
                      cc.Description = (s.Description!='')?s.Description :  acc[0].Description;
                      cc.Preference__c = (s.Preferences!='')?s.Preferences :  acc[0].Preference__c;
                      ccList_up.add(cc);
                }
            }else{
                Account cc = new Account();
                cc.Salutation = s.Salutation;
            cc.Lead_Mode__c = ldModeId;
            cc.Lead_Source1__c = ldSourceId;
            cc.FirstName = s.FirstName;
            cc.MiddleName = s.MiddleName;
            cc.First_Lead_Source__c='Sulekha';
            cc.Last_Updated_Lead_Source_Time__c=Datetime.now();
            cc.LastName = s.LastName;
            cc.Suffix = s.Suffix;
            cc.PersonTitle = s.Title;
            cc.PersonEmail = s.Email;
            cc.Phone = s.Phone;
            cc.PersonMobilePhone = s.Mobile;
            cc.Website = s.Website;
            cc.PersonMailingStreet = s.Street;
            cc.PersonMailingCity = s.City;
            cc.PersonMailingState = s.State;
            cc.PersonMailingPostalCode = s.PostalCode;
            cc.PersonMailingCountry = s.Country;

            //add by shashank_15_01_2020
            cc.Program_Category__c=s.ProgramCategory;
            cc.Mode_of_Coaching__c=s.ModeofCoaching;
            cc.Description=s.Description;
            cc.Preference__c=s.Preferences;
           
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
            api_log.Response__c= String.valueOf(e);
            api_log.response_time__c=Datetime.now();
            
        }
        insert api_log;
    }  
    
    //
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class JSON2ApexSaveChatBotLead {
    public List<SulekhaLead> SulekhaLead;
}

	public class SulekhaLead {
		public String LeadStatus;
		public String Owner;
		public String Salutation;
		public String Website;
		public String FirstName;
		//public String Company;
		public String MiddleName;
		//public String Industry;
		public String LastName;
		public String NoOfEmployees;
		public String Suffix;
        //add by shashank_15_01_2020
        public String ProgramCategory;
		public String Description;
		public String Preferences;
		public String ModeofCoaching;

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
	}

	

	
	public static JSON2ApexSaveChatBotLead parse(String json) {
		return (JSON2ApexSaveChatBotLead) System.JSON.deserialize(json, JSON2ApexSaveChatBotLead.class);
	}

    
}