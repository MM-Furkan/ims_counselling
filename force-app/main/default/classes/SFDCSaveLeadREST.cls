@RestResource(urlMapping='/saveSFDCLead/*')
global class SFDCSaveLeadREST {
    @HttpPost
    global static void doPost() {  
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='saveSFDCLead';
        
        RestRequest request = RestContext.request;  
        
        RestResponse response = RestContext.response;  
        String centre = '';
        String product = '';
        String city = '';
        String varient = '';
        
        
        String response_msg='';
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        JSON2ApexSaveLead jsonObj = JSON2ApexSaveLead.parse(jSONRequestBody);
        centre = jsonObj.StudentAccount.CentreCode;
        product = jsonObj.StudentAccount.ProductCode;
        city = jsonObj.StudentAccount.CityCode;
        varient = jsonObj.StudentAccount.Variant;
        
        List<Program__c> progList = [SELECT Id, Name,Program_Code__c FROM Program__c WHERE Program_Code__c=:product];
        List<City__c> ctList = [SELECT ID, Name,City_Code__c FROM City__c WHERE City_Code__c =:city];
        List<Centre__c> cntreList = [SELECT Id, Name,Centre_Code__c FROM Centre__c	WHERE Centre_Code__c=:centre];
        List<Variant__c> varntList = [SELECT Id, Name, Variant_Code__c FROM Variant__c WHERE Variant_Code__c=:varient];
        Map<String,Id> cityMap = new Map<String,Id>();
        Map<String,Id> progMap = new Map<String,Id>();
        Map<String,Id> cntreMap = new Map<String,Id>();
        Map<String,Id> varntMap = new Map<String,Id>();
        
        If(progList.size()>0){
            System.debug('I am printing the progList data-->'+progList);
            For(Program__c p:progList){
                progMap.put(p.Program_Code__c,p.Id);
            }
        }
        If(ctList.size()>0){
            System.debug('I am printing the progList data-->'+ctList);
            For(City__c p:ctList){
                cityMap.put(p.City_Code__c,p.Id);
            }
        }
        If(varntList.size()>0){
            System.debug('I am printing the progList data-->'+varntList);
            For(Variant__c p:varntList){
                varntMap.put(p.Variant_Code__c,p.Id);
            }
        }
        If(cntreList.size()>0){
            System.debug('I am printing the progList data-->'+cntreList);
            For(Centre__c p:cntreList){
                cntreMap.put(p.Centre_Code__c,p.Id);
            }
        }
        
        System.debug('progList.size()>0&&ctList.size()>0&&varntList.size()>0&&cntreList.size()');
        System.debug(''+progList.size());
        System.debug(''+ctList.size());
        System.debug(''+varntList.size());
        System.debug(''+cntreList.size());
        
        //IF(progList.size()>0&&ctList.size()>0&&varntList.size()>0&&cntreList.size()>0){
        
        
        StudentAccount s = jsonObj.StudentAccount;
        System.debug('response log '+s);
        System.debug('response log email '+s.Email);

      
        
        List<Account> acc1= [SELECT ID, Salutation,FirstName,MiddleName, LastName, PersonEmail, IMS_PIN__c,
                             PersonMobilePhone, Phone, Description, Employee_Referral_Name__c, Student_Referral_Name__c, 
                             Referral_Centre__c, Lead_Mode__c, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode,
                             PersonMailingState, PersonMailingCountry, BillingStreet, BillingCity,                                 
                             BillingPostalCode, BillingState, BillingCountry FROM Account WHERE PersonMobilePhone=:s.Mobile1 AND FirstName=:s.FirstName AND LastName=:s.LastName LIMIT 1];
        System.debug('acc1-------------------------->'+acc1.size());
        System.debug('acc1-------------------------->'+acc1);
        try{
            if(acc1.size() == 0)
            {
                Account acc = new Account();
                acc.First_Lead_Source__c='Lima';   
                acc.Last_Updated_Lead_Source_Time__c=datetime.now(); 
                acc.IMS_PIN__c=s.IMSPIN;
                api_log.IMS_Pin_log__c= s.IMSPIN;
                acc.Salutation = s.Salutation;
                acc.FirstName = s.FirstName;
                acc.MiddleName = s.MiddleName;
                acc.LastName = s.LastName;
                acc.PersonEmail = s.Email;
                acc.PersonMobilePhone = s.Mobile1;
                acc.Phone = s.Mobile2;
                acc.Description = s.Description;                
                acc.PersonMailingCity = s.MailingCity;
                acc.PersonMailingState = s.MailingState;
                acc.PersonMailingPostalCode = s.MailingPinCode;
                acc.PersonMailingStreet = s.MailingStreet; 
                acc.ShippingStreet = s.Street;
                acc.PersonMailingState = s.State;
                acc.PersonMailingPostalCode = s.PinCode;
                acc.ShippingCity = s.City;
                acc.ShippingCountry = s.Country;
                
                IF(cityMap.get(s.CityCode)!=Null){
                    acc.Mailing_City__c = cityMap.get(s.CityCode);
                }
                insert acc;
                    if(jsonObj.StudentAccount.ProductCode != ''){
                        Program_Admitted__c pa = new Program_Admitted__c();
                        pa.Program__c = progMap.get(s.ProductCode);
                        pa.Variant__c = varntMap.get(s.Variant);
                        pa.Centre__c = cntreMap.get(s.CentreCode);
                        pa.Program_Admitted__c= true;
                        pa.Student_Account__c = acc.Id;                        
                        if(jsonObj.StudentAccount.Status == 'Enrolled'){
                           pa.Stage__c='Enrolled';
                           pa.Amount__c=s.Amount;
                        }
                        insert pa;
                    }
                System.debug('insert complete-------------------------->');
                String resp = '{"Status":"True","Message":"Data inserted successfully"}';
                response.responseBody = Blob.valueOf(resp);
                response.addHeader('Content-Type', 'application/json');
                response.statusCode = 200;
                
                api_log.Response__c= String.valueOf(resp);
                api_log.response_time__c=Datetime.now();
            }
            else{
                
                Account acc = acc1[0];
                acc.IMS_PIN__c=s.IMSPIN;
                api_log.IMS_Pin_log__c= s.IMSPIN;
                acc.Salutation = s.Salutation;
                acc.FirstName = s.FirstName;
                acc.MiddleName = s.MiddleName;
                acc.LastName = s.LastName;
                acc.PersonEmail = s.Email;
                acc.PersonMobilePhone = s.Mobile1;
                acc.Phone = s.Mobile2;
                acc.Description = s.Description;
                acc.PersonMailingCity = s.MailingCity;
                acc.PersonMailingState = s.MailingState;
                acc.PersonMailingPostalCode = s.MailingPinCode;
                acc.PersonMailingStreet = s.MailingStreet;
                
                acc.ShippingStreet = s.Street;
                acc.PersonMailingState = s.State;
                acc.PersonMailingPostalCode = s.PinCode;
                acc.ShippingCity = s.City;
                acc.ShippingCountry = s.Country;
                
                IF(cityMap.get(s.CityCode)!=Null){
                    acc.Mailing_City__c = cityMap.get(s.CityCode);
                }
                update acc;
                
                if(jsonObj.StudentAccount.Status == 'Enrolled')
                {
                    System.debug('update11111111111111--------------------<'+acc.Id);
                    
                    // Program_Admitted__c prgad= [SELECT Id, Name,Stage__c FROM Program_Admitted__c WHERE Student_Account__c=:'0010k00000y4DbBAAU'];
                    List<Program_Admitted__c> prgad= [SELECT Id,Amount__c, Name,Stage__c FROM Program_Admitted__c WHERE Program__r.Program_Code__c=:jsonObj.StudentAccount.ProductCode AND Centre__r.Centre_Code__c=:jsonObj.StudentAccount.CentreCode  AND Variant__r.Variant_Code__c=:jsonObj.StudentAccount.Variant AND Student_Account__c=:acc1[0].Id];
                    if(prgad.size() == 0){
                        response_msg='no row found for update';

                        //add by shashank 07_02_2020

                        Program_Admitted__c pa = new Program_Admitted__c();
                        pa.Program__c = progMap.get(s.ProductCode);
                        pa.Variant__c = varntMap.get(s.Variant);
                        pa.Centre__c = cntreMap.get(s.CentreCode);
                        pa.Program_Admitted__c= true;
                        pa.Student_Account__c = acc.Id;
                        
                        if(jsonObj.StudentAccount.Status == 'Enrolled' ){
                           pa.Stage__c='Enrolled';
                           pa.Amount__c=s.Amount;
                        }
                        response_msg='Data program insert successfully'; 
                        insert pa;
                    }else{
                        
                        prgad[0].Stage__c='Enrolled';
                        prgad[0].Amount__c=s.Amount; 
                        response_msg='Data program Update successfully';          
                        update prgad;
                    }
                }
                Map<String, String> res_msg = new Map<String, String>();
                res_msg.put('Status', 'True');
                res_msg.put('Message', response_msg);
                
                String resp = JSON.serialize(res_msg);
                response.responseBody = Blob.valueOf(resp);
                response.addHeader('Content-Type', 'application/json');
                response.statusCode = 200;
                
                api_log.Response__c= String.valueOf(res_msg);
                api_log.response_time__c=Datetime.now();      
            }
            
        }catch(Exception e){
            String m = e.getMessage();
            String resp = '{"Status":"False","Message":"'+e+'"}';
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            
            response.statusCode = 400;
            api_log.Exception_desc__c=String.valueOf(resp);
        }
        insert api_log;    
        
    }  
    
    public class JSON2ApexSaveLead {
        public StudentAccount StudentAccount;
    }
    public class StudentAccount {
        public String IMSPIN;
        public String Salutation;
        public String FirstName;
        public String MiddleName;
        public String LastName;
        public String Email;
        public String Mobile1;
        public String Mobile2;
        public String Description;
        public String MailingCity;
        public String Order;
        public String LeadStage;
        public String Preference;
        public String ReferredBy;
        public String EmployeeReferralName;
        public String StudentReferralName;
        public String ReferralCentre;
        public String LeadMode;
        public String LeadSource;
        public String Priority;
        public String ProductDeliveryMode;
        public String Productwise;
        public String MailingStreet;
        public String MailingState;
        public String MailingPinCode;
        public String MailingCountry;
        public String Street;
        public String City;
        public String State;
        public String PinCode;
        public String Country;
        public String CityCode;
        public String ProductCode;
        public String ModeCode;
        public String Variant;
        public String CentreCode;
        //add by shashank 17_01_2020
        public String Status;
        public Decimal Amount;
    }
    
    
    
    
    public static JSON2ApexSaveLead parse(String json) {
        return (JSON2ApexSaveLead) System.JSON.deserialize(json, JSON2ApexSaveLead.class);
    }
    
}