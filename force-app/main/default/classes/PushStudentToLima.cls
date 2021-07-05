public with sharing class PushStudentToLima {

    @Future(callout = true)
    public static void apiCall(String lid) {

        Account acct = [SELECT Id, Name, LastName, FirstName, Salutation, Type, RecordTypeId, ParentId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
            BillingLatitude, BillingLongitude, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude,
            ShippingLongitude, ShippingAddress, Phone, Fax, AccountNumber, Website, PhotoUrl, Sic, Industry, AnnualRevenue, NumberOfEmployees, Ownership, TickerSymbol,
            Description, Rating, Site, OwnerId, CreatedById, LastModifiedById, SystemModstamp, PersonContactId, IsPersonAccount, PersonMailingStreet, PersonMailingCity,
            PersonMailingState, PersonMailingPostalCode, PersonMailingCountry, PersonMailingLatitude, PersonMailingLongitude, PersonMailingAddress, PersonMobilePhone,
            PersonEmail, PersonTitle, PersonDepartment, PersonEmailBouncedReason, Jigsaw, JigsawCompanyId, AccountSource, SicDesc, Mobile_Number__c, IMS_PIN__c, status__c,
            Follow_up_date__c, Referred_By__c, Referred_Name__c, Updated_on__c, Updated_by__c, Preference__c, Order__c, Lead_Score__c, Product_delivery_mode__c, Program__c,
            Centre__c,  How_IMS__c, Lead_Stage__c, Product_wise__c, Mailing_Add1__c, Mailing_Add2__c, Mailing_Add3__c, Mailing_City__c, Mailing_Pin_code__c, Permanent_Add1__c,
            Permanent_Add2__c, Permanent_Add3__c, Permanent_City__c, Permanent_Pincode__c, Category__c, Lead_source__c, Lead_Activity__c, Lead_Mode__c, Variant__c,
            Country__c FROM Account where id =: lid]; //Center__c ,State__c, City__c,Mode__c

        Lead2Lima lima = new Lead2Lima();
        lima.studentdetails = new Studentdetails();
        lima.studentdetails.Fname = acct.FirstName;
        lima.studentdetails.Lname = acct.LastName;
        lima.studentdetails.Email=acct.PersonEmail;
        lima.studentdetails.Mobile1=acct.PersonMobilePhone;
        lima.Studentdetails.Mobile2=acct.Phone;
        
        lima.Studentdetails.MailingAddress = new MailingAddress();
        lima.Studentdetails.MailingAddress.Address1=acct.BillingStreet;
        lima.Studentdetails.MailingAddress.State=acct.BillingState;
        lima.Studentdetails.MailingAddress.City=acct.BillingCity;
        lima.Studentdetails.MailingAddress.Zipcode=acct.BillingPostalCode;
        
        lima.Studentdetails.PermanentAddress = new MailingAddress();
        lima.Studentdetails.PermanentAddress.Address1=acct.ShippingStreet;
        lima.Studentdetails.PermanentAddress.State=acct.ShippingState;
        lima.Studentdetails.PermanentAddress.City=acct.ShippingCity;
        lima.Studentdetails.PermanentAddress.Zipcode=acct.ShippingPostalCode;
        
        
        Lima.Studentdetails.FamilyDetails = new List<FamilyDetails>();
        
        for(Parent_Information__c pi:[ SELECT  Id,  Name,  Last_Name__c,  Parent_Mobile__c,  Parent_Email__c,  Relationship__c,  Salutation__c,  First_Name__c,
                                      Mailing_Address_1__c,  Mailing_Pincode__c,  Permanent_Address_1__c,  Permanent_Pin_code__c,  
                                      Student_Account__c,  Lead__c,  Middle_Name__c,  Mailing_Street__c,  Mailing_State__c,  Mailing_Country__c,  Permanent_Street__c,  
                                      Permanent_State__c,  Permanent_Country__c FROM Parent_Information__c where Student_Account__c=:acct.id]){
              //Permanent_City__c,Mailing_City__c
            FamilyDetails f = new FamilyDetails();
            
            //f.Title=pi.Parent_Title__c;
            f.Name=pi.Parent_Title__c;
            f.Email=pi.Parent_Email__c;
            f.Mobile=pi.Parent_Mobile__c;
            f.Relationship=pi.Relationship__c;
            
            Lima.Studentdetails.FamilyDetails.add(f);
        }
        
        // lima.Studentdetails.CourseDetails;
        // lima.Studentdetails.Education;
        // lima.Studentdetails.PersonalDet;
        // lima.Studentdetails.EducationalDet;
        // lima.Studentdetails.FamilyDet;
        // lima.Studentdetails.WorkDet;

        String jsonData = JSON.serialize(lima);
        // //String jsonData = JSON.serialize(opj);
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        String url = 'http://lima.imsindia.com/MyIMS/default.aspx?action=signup';
        // String url = Label.Integration_URL + '/insertLCO';
        req.setEndpoint(url);

        System.debug('jsonData ====='+jsonData);

        req.setBody(jsonData);

        try{
            HttpResponse res = h.send(req);
            System.debug('res=======>' +res.getBody());

            String jsdata = res.getBody();
            // SuccessJSON resdata = new SuccessJSON();
            // SaveLocalOperatorInCAFClass c = new SaveLocalOperatorInCAFClass();
            // resdata = c.parse(jsdata);

            // if(resdata.flag == '1'){
            //     List<opData> oprRData = resdata.data;
            //     recdata.CAFID__c = oprRData[0].lco_id;
            //     update recdata;

            // }

        }catch(System.calloutException e){
            System.debug('Exception=======>' +e.getMessage());
        }

    }

    public class Lead2Lima {
        public Studentdetails studentdetails;
    }

    public class PostGraduation {}


    public class SSC {
        public String School;
        public String Percentage;
        public String Board;
        public String BoardCode;
        public String Qualification;
        public String QualificationCode;
        public String Year;
    }

    public class WorkExperience {
        public String Organisation;
        public String Designation;
        public String Experience;
        public String JobSector;
        public String JobSectorCode;
    }

    public class Category {
        public String Code;
        public String Name;
    }

    public class Graduation {
        public String College;
        // public String Percentage / CGPA;
        public String University;
        public String UniversityCode;
        public String Qualification;
        public String QualificationCode;
        public String Year;
    }

    public class MailingAddress {
        public String Address1;
        public String Address2;
        public String Address3;
        public String City;
        public String CityCode;
        public String State;
        public String Zipcode;
    }


    public class CATAttempts {
        public String Test;
        public String Marks;
        public String Year;
    }

    public class Education {
        public List < SSC > SSC;
        public List < HSC > HSC;
        public List < Graduation > Graduation;
        public List < PostGraduation > PostGraduation;
        public List < ProfessionalCourse > ProfessionalCourse;
        public List < CATAttempts > CATAttempts;
    }

    public class CourseDetails {
        public String CourseName;
        public String CourseID;
        public String BranchID;
        public String ExamYear;
    }

    public class Studentdetails {
        public String Fname;
        public String Lname;
        public String Email;
        public String Mobile1;
        public String Mobile2;
        public String Gender;
        public String DOB;
        public List < Category > Category;
        public MailingAddress MailingAddress;
        public MailingAddress PermanentAddress;
        public CourseDetails CourseDetails;
        public Education Education;
        public List < WorkExperience > WorkExperience;
        public List < FamilyDetails > FamilyDetails;
        public String PersonalDet;
        public String EducationalDet;
        public String FamilyDet;
        public String WorkDet;
    }

    public class HSC {
        public String College;
        public String Percentage;
        public String Board;
        public String BoardCode;
        public String Qualification;
        public String QualificationCode;
        public String Year;
    }

    public class ProfessionalCourse {
        public String QualificationCode;
        public String Marks;
        public String Year;
    }

    public class FamilyDetails {
        public String Title;
        public String Name;
        public String Email;
        public String Mobile;
        public String Relationship;
    }
    
    public class SuccessJSON {
        // public List<opData> data{get;set;}
        public String mtype{get;set;}
        public String pin{get;set;}
        public String message{get;set;}
    }
    
    // public class opData{
    //     public String lco_id{get;set;}
    // }
    
    public SuccessJSON parse(String json) {
        return (SuccessJSON) System.JSON.deserialize(json, SuccessJSON.class);
    }
    
    


    // public static List < Lead2Lima > parse(String json) {
    //     return (List < Lead2Lima > ) System.JSON.deserialize(json, List < Lead2Lima > .class);
    // }


}