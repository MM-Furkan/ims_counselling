public class RESTGetLIMALead {
    public Boolean b = false;
    public Boolean c = false;
    public PageReference RESTGetLIMALeadAction(){
        String stid = ApexPages.currentPage().getParameters().get('id');
        System.debug('id-->'+stid);
        List<Account> acc = [SELECT Id, LastName, IMS_PIN__c, PersonEmail, PersonMobilePhone FROM Account WHERE Id=:stid];
        System.debug('Account record-->'+acc[0]);
        If(acc[0].PersonEmail!=Null&&acc[0].PersonEmail!=''){
            c = getCallWithEmail(acc[0].PersonEmail,acc[0]);
            if(c){
                pagereference pg= new pagereference('/'+stid);
                pg.setRedirect(true);
                return pg;
            }
        }If(acc[0].PersonMobilePhone!=''&&acc[0].PersonMobilePhone!=Null&&!c){
            c = getCallWithMobile(acc[0].PersonMobilePhone,acc[0]);
            if(c){
                pagereference pg= new pagereference('/'+stid);
                pg.setRedirect(true);
                return pg;
            }else{
                pagereference pg= new pagereference('/'+stid);
                pg.setRedirect(true);
                return pg;
            }
        }
        
        pagereference pg= new pagereference('/'+stid);
        
        pg.setRedirect(true);
        return pg;
        
    }
    
    public Boolean getCallWithEmail(String email,Account acc){
        
        List<Account> upAcc = new List<Account>();        
        //email = 'dipesh.agre@enlitenit.com';
        String js = '{\"txtemail\":\"'+email+'\"}';
        String s = '';
        Http h = new Http();		
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        req.setBody(js);
        req.setHeader('Content-Type', 'text/plain');
        req.setEndpoint('https://lima.imsindia.com/SF_API/default.aspx/?action=getlead');//sandbox url
        System.debug('The request is get Lead from Email---'+req.getBody());
        HttpResponse res = h.send(req);
        System.debug('Response came from request Email->'+res.getBody());
        JSON2ApexLIMALead ll = JSON2ApexLIMALead.parse(res.getBody());
        
        System.debug('ll.mtype--'+ll.mtype);
        IF(ll.mtype!='success'){
            b = false;
            acc.LIMA_Check__c = True;
        }else{
            b = true;
            String mCityCode  = ll.StudentAccount.MailingCityCode;
            String bCityCode  = ll.StudentAccount.CityCode;  
            List<City__c> mCityList = [SELECT ID, Name, City_Code__c FROM City__c WHERE City_Code__c=:mCityCode];
            List<City__c> bCityList = [SELECT ID, Name, City_Code__c FROM City__c WHERE City_Code__c=:bCityCode];
            
            If(mCityList.size()>0){
                acc.Mailing_City__c = mCityList[0].City_Code__c;
            }
            If(bCityList.size()>0){
                acc.Permanent_City__c = bCityList[0].City_Code__c;
            }
            
            System.debug('mtypemtypemtype'+ll.StudentAccount);
            acc.IMS_PIN__c = ll.StudentAccount.IMSPIN;
            acc.FirstName = ll.StudentAccount.FirstName;
            acc.MiddleName = ll.StudentAccount.MiddleName;
            IF(ll.StudentAccount.LastName!=''){
                acc.LastName = ll.StudentAccount.LastName;
            }
            else{
                IF(ll.StudentAccount.FirstName!=''){
                    acc.LastName = ll.StudentAccount.FirstName;
                }
            }
            
            acc.PersonMobilePhone = ll.StudentAccount.Mobile1;
            
            
            acc.Description = ll.StudentAccount.Description;
            acc.Lead_Stage__c = ll.StudentAccount.LeadStage;
            acc.Preference__c = ll.StudentAccount.Preference;
            acc.Referred_By__c = ll.StudentAccount.ReferredBy;
            acc.Employee_Referral_Name__c = ll.StudentAccount.employeeReferralName;
            acc.Student_Referral_Name__c = ll.StudentAccount.StudentReferralName;
            acc.Referral_Centre__c = ll.StudentAccount.ReferralCentre;
            acc.Lead_Mode__c = ll.StudentAccount.LeadMode;
            //acc.Lead_Source__c = ll.StudentAccount.LeadSource;
            acc.Product_delivery_mode__c = ll.StudentAccount.ProductDeliveryMode;
            acc.PersonMailingStreet = ll.StudentAccount.MailingStreet;
            acc.PersonMailingCity = ll.StudentAccount.MailingCity;
            
            acc.PersonMailingPostalCode = ll.StudentAccount.MailingPinCode;
            acc.PersonMailingState = ll.StudentAccount.MailingState;
            acc.PersonMailingCountry = ll.StudentAccount.MailingCountry;
            acc.BillingStreet = ll.StudentAccount.Street;
            acc.BillingCity = ll.StudentAccount.City;
            
            acc.BillingPostalCode = ll.StudentAccount.PinCode;
            acc.BillingState = ll.StudentAccount.State;
            acc.BillingCountry = ll.StudentAccount.Country;
            
            
            
            acc.LIMA_Check__c = True;
            acc.Present_In_LIMA__c = True;
            upAcc.add(acc);
            update upAcc;
        }
        System.debug('bbbbbbbb'+b);
        return b;
        
        
    } 
    public Boolean getCallWithMobile(String mobile,Account acc){
        
        String js = '{"txtmobile\":\"'+mobile+'\"}';
        String s = '';
        Http h = new Http();		
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        req.setBody(js);
        req.setTimeout(120000);
        req.setHeader('Content-Type','text/plain');
        //req.setHeader('token', s);
        req.setEndpoint('https://lima.imsindia.com/SF_API/default.aspx/?action=getlead');//sandbox url
        
        System.debug('The request is get Lead from Mobile---'+req);
        HttpResponse res = h.send(req);
        System.debug('Response came from request Email->'+res.getBody());
        JSON2ApexLIMALead ll = JSON2ApexLIMALead.parse(res.getBody());
        System.debug('mtypemtypemtype'+ll.StudentAccount);
        System.debug('ll.mtype--'+ll.mtype);
        IF(ll.mtype!='success'){
            b = false;
        }else{
            b = true;
            String mCityCode  = ll.StudentAccount.MailingCityCode;
            String bCityCode  = ll.StudentAccount.CityCode;  
            List<City__c> mCityList = [SELECT ID, Name, City_Code__c FROM City__c WHERE City_Code__c=:mCityCode];
            List<City__c> bCityList = [SELECT ID, Name, City_Code__c FROM City__c WHERE City_Code__c=:bCityCode];
            
            If(mCityList.size()>0){
                acc.Mailing_City__c = mCityList[0].Id;
            }
            If(bCityList.size()>0){
                acc.Permanent_City__c = bCityList[0].Id;
            }
            
            System.debug('mtypemtypemtype'+ll.StudentAccount);
            acc.IMS_PIN__c = ll.StudentAccount.IMSPIN;
            acc.FirstName = ll.StudentAccount.FirstName;
            acc.MiddleName = ll.StudentAccount.MiddleName;
            System.debug('ll.StudentAccount.LastName-->'+ll.StudentAccount.LastName);
            System.debug('ll.StudentAccount.First-->'+ll.StudentAccount.FirstName);
            IF(ll.StudentAccount.LastName!=''){
                acc.LastName = ll.StudentAccount.LastName;
            }
            else{
                IF(ll.StudentAccount.FirstName!=''){
                    acc.LastName = ll.StudentAccount.FirstName;
                }
            }
            acc.PersonMobilePhone = ll.StudentAccount.Mobile1;
            
            
            acc.Description = ll.StudentAccount.Description;
            acc.Lead_Stage__c = ll.StudentAccount.LeadStage;
            acc.Preference__c = ll.StudentAccount.Preference;
            acc.Referred_By__c = ll.StudentAccount.ReferredBy;
            acc.Employee_Referral_Name__c = ll.StudentAccount.employeeReferralName;
            acc.Student_Referral_Name__c = ll.StudentAccount.StudentReferralName;
            acc.Referral_Centre__c = ll.StudentAccount.ReferralCentre;
            //acc.Lead_Mode__c = ll.StudentAccount.LeadMode;
            //acc.Lead_Source__c = ll.StudentAccount.LeadSource;
            acc.Product_delivery_mode__c = ll.StudentAccount.ProductDeliveryMode;
            acc.PersonMailingStreet = ll.StudentAccount.MailingStreet;
            acc.PersonMailingCity = ll.StudentAccount.MailingCity;
            
            acc.PersonMailingPostalCode = ll.StudentAccount.MailingPinCode;
            acc.PersonMailingState = ll.StudentAccount.MailingState;
            acc.PersonMailingCountry = ll.StudentAccount.MailingCountry;
            acc.BillingStreet = ll.StudentAccount.Street;
            acc.BillingCity = ll.StudentAccount.City;
            
            acc.BillingPostalCode = ll.StudentAccount.PinCode;
            acc.BillingState = ll.StudentAccount.State;
            acc.BillingCountry = ll.StudentAccount.Country;
            
            
            
            acc.LIMA_Check__c = True;
            acc.Present_In_LIMA__c = True;
            //upAcc.add(acc);
            update acc;
        }
        System.debug('bbbbbbbb'+b);
        return b;
        
        
    }
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //
    
    public class JSON2ApexLIMALead {
        
        public StudentAccount StudentAccount;
        public String mtype;
        public String message;
    }
    
    public class StudentAccount {
        public String IMSPIN;
        public String FirstName;
        public String MiddleName;
        public String LastName;
        public String Email;
        public String Mobile1;
        public String Mobile2;
        public String Order;
        public String Description;
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
        public String MailingCity;
        public String MailingCityCode;
        public String MailingPinCode;
        public String MailingState;
        public String MailingCountry;
        public String Street;
        public String City;
        public String CityCode;
        public String PinCode;
        public String State;
        public String Country;
        //public List<MailingCity> MailingCity;
        //public List<MailingCity> PermanentCity;
    }
    
    public class MailingCity {
    }
    
    
    public static JSON2ApexLIMALead parse(String json) {
        return (JSON2ApexLIMALead) System.JSON.deserialize(json, JSON2ApexLIMALead.class);
    }
    
    
}