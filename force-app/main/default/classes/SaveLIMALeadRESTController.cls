public class SaveLIMALeadRESTController {
   // public string baseUrl =label.IMS_Demo;
    public SaveLIMALeadRESTController(){}
    public String recId{get;set;}
    public PageReference entryAction(){
        
        recId = ApexPages.CurrentPage().getparameters().get('id');
        System.debug('I am getting the record Id in action-->'+recId);
        Map<String,Object> StudentDetails = new Map<String,Object>();
        Map<String,Object> EducationalDetails = new Map<String,Object>();
        
        List<Map<String,String>> SSC = new List<Map<String,String>>();
        List<Map<String,String>> HSC = new List<Map<String,String>>();
        List<Map<String,String>> WorkExperience = new List<Map<String,String>>();
        List<Map<String,String>> Graduation  = new List<Map<String,String>>();
        List<Map<String,String>> FamilyDetails  = new List<Map<String,String>>();
        List<Map<String,String>> programs = new List<Map<String,String>>();
        
        Map<String,String> sscMap = new Map<String,String>();
        Map<String,String> hscMap = new Map<String,String>();
        Map<String,String> workExperienceMap = new Map<String,String>();
        Map<String,String> graduationMap = new Map<String,String>();
        Map<String,String> familyDetailsMap = new Map<String,String>();
        Map<String,String> programMap = new Map<String,String>();
        
        List<Account> accList = [SELECT ID, Salutation,FirstName,MiddleName, LastName, PersonEmail, IMS_PIN__c,
                                 PersonMobilePhone, Phone, Description, Employee_Referral_Name__c, Student_Referral_Name__c, 
                                 Referral_Centre__c, Lead_Mode__c, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode,
                                 PersonMailingState, PersonMailingCountry, BillingStreet, BillingCity,
                                 (SELECT Id, Name,Program__r.Name,Program__r.Program_Code__c,
                                  Centre__r.Name,Centre__r.Centre_Code__c,Variant__r.Name,Variant__r.Variant_Code__c FROM Program_Wise_Centres__r),
                                 BillingPostalCode, BillingState, BillingCountry FROM Account WHERE Id=:recId];
        
        
        IF(accList.size()>0){
            
            IF(accList[0].Program_Wise_Centres__r.size()>0){
                System.debug('I am getting the program list-->'+accList[0].Program_Wise_Centres__r[0].Program__r.Program_Code__c);
                System.debug('I am getting the Account List--->'+accList[0].Program_Wise_Centres__r[0].Program__r.Program_Code__c);
                
                
                
                Account acc = accList[0];
                StudentDetails.put('FirstName',acc.FirstName);
                StudentDetails.put('MiddleName',acc.MiddleName);
                StudentDetails.put('LastName',acc.LastName);
                StudentDetails.put('Email',acc.PersonEmail);
                StudentDetails.put('Mobile1',acc.PersonMobilePhone);
                StudentDetails.put('Mobile2','');
                StudentDetails.put('MailingAddress',acc.PersonMailingCity);
                StudentDetails.put('MailingCity',acc.PersonMailingCity);//here i need to put code of city
                StudentDetails.put('MailingPinCode',acc.PersonMailingPostalCode);
                StudentDetails.put('PermanentAddress',acc.BillingCity);
                StudentDetails.put('PermanentCity',acc.BillingCity);//here i need to put code of city
                StudentDetails.put('PermanentPinCode',acc.BillingPostalCode);
                StudentDetails.put('CentreCode','');//here i need to put code of centre
                StudentDetails.put('ProductCode','');//here i need to put code of product
                StudentDetails.put('VariantCode','');//here i need to put code of varient
                StudentDetails.put('Description','');
                StudentDetails.put('EmployeeReferralName',acc.Employee_Referral_Name__c);
                StudentDetails.put('StudentReferralName',acc.Student_Referral_Name__c);
                StudentDetails.put('LeadMode','');
                StudentDetails.put('LeadSource','');
                StudentDetails.put('ProductDeliveryMode','');
                
                List<Program_Admitted__c> progList = acc.Program_Wise_Centres__r;
                For(Program_Admitted__c p:progList){
                    programMap.put('CentreCode',p.Centre__r.Centre_Code__c);
                    programMap.put('ProductCode',p.Program__r.Program_Code__c);
                    programMap.put('VariantCode',p.Variant__r.Variant_Code__c);
                    //programMap.put('VariantCode',p.Variant__r.Name);
                    programs.add(programMap);
                }
                System.debug('Before Final program map'+programs);
                StudentDetails.put('Program',programs);
                
                
                
                
                StudentDetails.put('EducationalDetails',EducationalDetails);//here i need to put empty map
                
                FamilyDetailsMap.put('Salutation','');
                FamilyDetailsMap.put('Name','');
                FamilyDetailsMap.put('Email','');
                FamilyDetailsMap.put('Mobile','');
                
                
                FamilyDetails.add(FamilyDetailsMap);
                
                StudentDetails.put('FamilyDetails',FamilyDetails);
                
                
                workExperienceMap.put('Organisation','');
                workExperienceMap.put('Designation','');
                workExperienceMap.put('Experience','');
                workExperienceMap.put('JobSectorCode','');
                
                WorkExperience.add(workExperienceMap);
                
                StudentDetails.put('WorkExperience',WorkExperience);
                
                System.debug('-------------------------------->savelimalead'+StudentDetails);

                Map<String,Object> jsMap = new Map<String,Object>() ;
                jsMap.put('StudentDetails',StudentDetails);
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
               // req.setEndpoint(baseUrl+'/SF_API/default.aspx?action=savelead');
                System.debug('The request is made to LIMA----'+req);
                System.debug('The request is made to LIMA----'+req.getHeader('Content-Type'));
                
                String sms = req.getBody();
                System.debug('The request is made to LIMA----'+sms);
                HttpResponse res = h.send(req);
                System.debug('The response is getting from LIMA Save Lead---'+res);
                
                String jsun = res.getBody();
                JSON2ApexLIMASaveLeadResponse resp = JSON2ApexLIMASaveLeadResponse.parse(jsun);
                If(resp.imspin==''){ 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resp.message));
                return null;
                }else{
                    
                    System.debug('jsun--jsun'+resp.imspin);
                	System.debug('res.getbody'+res.getBody());
                    
                    acc.IMS_PIN__c = resp.imspin;
                    System.debug('I am going to update the account with IMS Pin'+resp.imspin);
                    
                    update acc;
                    System.debug('After update the account--'+acc);
 
                }
                
                
                PageReference orderPage = new PageReference('/' + recId);
                orderPage.setRedirect(true);
                return orderPage;
                
                
                
                
            }else{
                //error msg on page
                //
                System.debug('The program list is empty--');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Must have programs before sync with LIMA, Please add programs'));
                return null;
                
            }
            
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Must have programs before sync with LIMA, Please add programs'));
            return null;
            
        }
        
        
        
        
        
        
    }
    public PageReference Cancel(){
        
        PageReference orderPage = new PageReference('/' + recId);
        orderPage.setRedirect(true);
        return orderPage;
        
    }
    
    //
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class JSON2ApexLIMASaveLeadResponse {

	public String imspin;
	public String message;
}

	
	public static JSON2ApexLIMASaveLeadResponse parse(String json) {
		return (JSON2ApexLIMASaveLeadResponse) System.JSON.deserialize(json, JSON2ApexLIMASaveLeadResponse.class);
	}

    
    
   /* public Class StudentAccountWrap{
        
        public String FirstName{get;set;}
        public String MiddleName{get;set;}
        public String LastName{get;set;}
        public String Email{get;set;}
        public String Mobile1{get;set;}
        public String Mobile2{get;set;}
        public String MailingAddress{get;set;}
        public String MailingCity{get;set;}
        public String MailingPinCode{get;set;}
        public String PermanentAddress{get;set;}
        public String PermanentCity{get;set;}
        public String PermanentPinCode{get;set;}
        public String CentreCode{get;set;}
        public String ProductCode{get;set;}
        public String VariantCode{get;set;}
        public String Order{get;set;}
        public String Description{get;set;}
        public String LeadStage{get;set;}
        public String Preference{get;set;}
        public String ReferredBy{get;set;}
        public String EmployeeReferralName{get;set;}
        public String StudentReferralName{get;set;}
        public String ReferralCentre{get;set;}
        public String LeadMode{get;set;}
        public String LeadSource{get;set;}
        public String Priority{get;set;}
        public String ProductDeliveryMode{get;set;}
        public String Productwise{get;set;}
        public EducationalDetails EducationalDetails{get;set;}
        public List<FamilyDetails> FamilyDetails{get;set;}
        public List<WorkExperience> WorkExperience{get;set;}
        
    }
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //
    
    public class JSON2ApexLIMASave {
        
        public StudentDetails StudentDetails;
    }
    
    public class SSC {
        public String School;
        public String Percentage;
        public String QualificationCode;
        public String Year;
    }
    
    public class WorkExperience {
        public String Organisation;
        public String Designation;
        public String Experience;
        public String JobSectorCode;
    }
    
    public class Graduation {
        public String College;
        public String Percentage;
        public String QualificationCode;
        public String Year;
    }
    
    public class EducationalDetails {
        public List<SSC> SSC;
        public List<HSC> HSC;
        public List<Graduation> Graduation;
    }
    
    
    
    public class HSC {
        public String College;
        public String Percentage;
        public String QualificationCode;
        public String Year;
        public String Stream;
    }
    
    public class FamilyDetails {
        public String Salutation;
        public String Name;
        public String Email;
        public String Mobile;
    }
    
    public class StudentDetails {
        public String FirstName;
        public String MiddleName;
        public String LastName;
        public String Email;
        public String Mobile1;
        public String Mobile2;
        public String MailingAddress;
        public String MailingCity;
        public String MailingPinCode;
        public String PermanentAddress;
        public String PermanentCity;
        public String PermanentPinCode;
        public String CentreCode;
        public String ProductCode;
        public String VariantCode;
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
        public EducationalDetails EducationalDetails;
        public List<FamilyDetails> FamilyDetails;
        public List<WorkExperience> WorkExperience;
    }
    
    
    public static JSON2ApexLIMASave parse(String json) {
        return (JSON2ApexLIMASave) System.JSON.deserialize(json, JSON2ApexLIMASave.class);
    }*/
    
    
}