public class MassLeadConvert {

    public List < Lead > selist {get;set;}
    public List<Lead> ldlist {get;set;}
    // public Lead ld {get;set;}
    public Id ledid {get;set;}
    public List<wrTra> wrlist{get; set;}  
    public Account acc{get;set;}
    public Lead tc {get;set;}
    // List<Account> aList {get;set;}
    public List<User> uList1 {get;set;}
    public List<User> uList2 {get;set;}
    public String selectUserlId1 {get;set;}
    public String selectUserlId2 {get;set;}
    // public string cityName {get;set;}
    // public string ProgramName {get;set;}
    public RecordType rct {get; set;}
    public User use {get; set;}
    
    public MassLeadConvert() {
        
        ledid = ApexPages.currentPage().getParameters().get('id');
        wrlist = new List<wrTra>(); 
        selist = new List< Lead >();
        selectUserlId1 = '';
        selectUserlId2 = '';
        system.debug('selectUserlId1****'+selectUserlId1);  
        system.debug('selectUserlId2****'+selectUserlId2);  
        use = [SELECT Id,name,ProfileId,IsActive FROM User WHERE isActive =: true AND Id=:Userinfo.getUserId()];
        // ldlist= [  SELECT  Id,  Name, salutation, MobilePhone,FirstName, MiddleName, LastName, OwnerId,  Owner.Name, Email, Company,
        //                 Program__c, Program__r.Name, Campaign_Id__c, Centre__c, Centre__r.Name, Web_To_Lead_Program__c, Web_To_Lead_Centre__c, Lead_Mode__c,
        //                 Lead_Source1__c, City, Street, State, Country, Status, Converted__c
        //                 FROM Lead Where IsConverted=false AND Converted__c=false order by name];
        
         ldlist= [  SELECT  Id,  Name, salutation, MobilePhone,FirstName, MiddleName, LastName, OwnerId,  Owner.Name, Email, Company,
                     Program1__c, Program1__r.Name, Campaign_Id__c, Centre__c, Centre__r.Name, Web_To_Lead_Program__c, Web_To_Lead_Centre__c, Lead_Mode__c,
                        Lead_Source1__c, City, Street, State, Country, Converted__c, Status, PostalCode
                        FROM Lead where IsConverted=false AND Converted__c=false order by name ];
        system.debug('ldlist****'+ldlist); 
        rct=[select id, Name, SobjectType from RecordType where SobjectType='Lead' 
             AND IsActive = true and Name='Read Only' ]; 
       
       String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer'); 

        // Use the referrer parameter to only show the message when coming from Page 1
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('MassLeadConvert') && message != 'null')
        {
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message)); 
        }
             
             
        for(Lead tc: ldlist){
            wrlist.add(new wrTra(tc));
             system.debug('wrlist****'+wrlist);
        
        
        for(Lead ld: ldlist){
                        
        if(ld.Status =='Converted'){
            
            acc = new Account();            
        }
        // else{
        //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
        //                                                   'Please ensure Lead Stage is Converted before Convert');
        //     ApexPages.addMessage(msg);
        // } 
        }
        // system.debug('ldlist****'+ldlist);              
        // for(Lead tc: ldlist){
        //     wrlist.add(new wrTra(tc));
        //      system.debug('wrlist****'+wrlist);
        // }
    }
    }
    
    public List<SelectOption> getuserlist1(){
        List < SelectOption > options = new List < SelectOption > ();
       uList1= [SELECT Id,name,ProfileId,IsActive FROM User where IsActive=true];
       system.debug('user list'+uList1);
        options.add(new SelectOption('None', 'None'));
        for(User us:uList1){
            options.add(new SelectOption(us.id, us.Name));
        }
        return options;
    } 
    
    public List<SelectOption> getuserlist2(){
        List < SelectOption > options = new List < SelectOption > ();
        uList2= [SELECT Id,name,ProfileId,IsActive, Profile.Name FROM User WHERE isActive =: true AND Profile.Name!= 'Chatter Free User'];
        options.add(new SelectOption('None', 'None'));
        for(User ur:uList2){
            options.add(new SelectOption(ur.Id, ur.Name));
        }
        return options;
    } 
    
    //  public pageReference usermethod(){
    //     system.debug('selectUserlId1****'+selectUserlId1);  
    //     system.debug('selectUserlId2****'+selectUserlId2);
        
    //      ldlist= [  SELECT  Id,  Name, salutation, MobilePhone,FirstName, MiddleName, LastName, OwnerId,  Owner.Name, Email, Company,
    //                     Program__c, Program__r.Name, Campaign_Id__c, Centre__c, Centre__r.Name, Web_To_Lead_Program__c, Web_To_Lead_Centre__c, Lead_Mode__c,
    //                     Lead_Source1__c, City, Street, State, Country, Converted__c
    //                     FROM Lead where OwnerId=:selectUserlId1 AND IsConverted=false AND Converted__c=false order by name];
    //     system.debug('ldlist****'+ldlist);              
    //     for(Lead tc: ldlist){
    //         wrlist.add(new wrTra(tc));
    //          system.debug('wrlist****'+wrlist);
    //     }
    //       PageReference pageRef = new PageReference('/lightning/o/Account/list');
    //       pageRef.setRedirect(true);
    //       return null;
    // }
    
    Public pageReference Convert(){
        system.debug('selectUserlId1****'+selectUserlId1);  
        system.debug('selectUserlId2****'+selectUserlId2);
        system.debug('inside convt****'+wrlist);

          //fetch lead mode
          Lead_Mode__c ldMode = [SELECT Id, Name From Lead_Mode__c WHERE Name=:'IMS Website'];
          String ldModeId = ldMode.Id;

          //fetch lead source
          Lead_Source__c ldSource = [SELECT Id, Name FROM Lead_Source__c WHERE Name =:'IMS Website'];
          String ldSourceId = ldSource.Id;
        // List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        List<Account> ccList = new List<Account>();
        List<Account> ccList_up = new List<Account>();

        for(wrTra wp:wrlist){
            system.debug('wp****'+wp);
            if(wp.chk){
                system.debug('wp****'+wp);
                 Lead pbw=new Lead();
                 pbw=wp.tra;
                 pbw.Converted__c=true;
                 pbw.Status='Qualified';
                 pbw.RecordTypeId=rct.Id;
                 selist.add(pbw);
                
                if(wp.tra.Company==Null){
                    List<Account> acc_li=[SELECT Id,MiddleName,Description,Mode_of_Coaching__c,Program_Category__c,PersonMailingCountry,PersonMailingPostalCode,PersonMailingState,PersonMailingCity,Website,PersonMailingStreet,Phone,Salutation,Suffix,PersonTitle,Preference__c,LastName,Lead_Source1__c,Name,PersonMobilePhone,Lead_Stage__c,PersonEmail FROM Account WHERE (PersonMobilePhone=:wp.tra.MobilePhone OR PersonEmail=:wp.tra.Email) AND LastName=:wp.tra.LastName LIMIT 1]; 
                    System.debug('acc_li==>'+acc_li);
                    if(acc_li.size()>0){
                        if(acc_li[0].Lead_Stage__c =='Closed Lost' || acc_li[0].Lead_Stage__c =='Enrolled' || acc_li[0].Lead_Stage__c =='Partially Enrolled'){
                            Account acc= new Account();
                            acc.Id=acc_li[0].id;
                            acc.Lead_Stage__c='Open';
                            acc.Lead_Mode__c = ldModeId;
                            acc.Lead_Source1__c=ldSourceId;
                            acc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                            acc.OwnerId=selectUserlId2;
                            acc.salutation=(wp.tra.salutation!='')?wp.tra.salutation :  acc_li[0].Salutation;
                            acc.FirstName=(wp.tra.FirstName!='')?wp.tra.FirstName :  acc_li[0].FirstName;
                            acc.LastName=(wp.tra.LastName!='')?wp.tra.LastName :  acc_li[0].LastName;
                            acc.MiddleName=(wp.tra.MiddleName!='')?wp.tra.MiddleName :  acc_li[0].MiddleName;
                            acc.PersonMobilePhone=(wp.tra.MobilePhone!='')?wp.tra.MobilePhone:acc_li[0].PersonMobilePhone;
                            acc.PersonEmail=(wp.tra.Email!='')?wp.tra.Email:acc_li[0].PersonEmail;
                            acc.Campaign_Id__c=(wp.tra.Campaign_Id__c!='')?wp.tra.Campaign_Id__c:acc_li[0].Campaign_Id__c;
                            acc.Web_To_Lead_Program__c=(wp.tra.Web_To_Lead_Program__c!='')?wp.tra.Web_To_Lead_Program__c:acc_li[0].Web_To_Lead_Program__c;
                            acc.Web_To_Lead_Centre__c=(wp.tra.Web_To_Lead_Centre__c!='')?wp.tra.Web_To_Lead_Centre__c:acc_li[0].Web_To_Lead_Centre__c;
                            acc.BillingStreet=(wp.tra.Street!='')?wp.tra.Street:acc_li[0].BillingStreet;
                            acc.BillingCity=(wp.tra.City!='')?wp.tra.City:acc_li[0].BillingCity;
                            acc.BillingState=(wp.tra.State!='')?wp.tra.State:acc_li[0].BillingState;
                            acc.BillingCountry=(wp.tra.Country!='')?wp.tra.Country:acc_li[0].BillingCountry;
                            acc.BillingPostalCode=(wp.tra.PostalCode!='')?wp.tra.PostalCode:acc_li[0].BillingPostalCode;
                            acc.PersonMailingCity=(wp.tra.City!='')?wp.tra.City:acc_li[0].PersonMailingCity;
                            ccList_up.add(acc);
                        }else{
                            Account acc= new Account();
                            acc.Id=acc_li[0].id;
                            acc.Lead_Mode__c = ldModeId;
                            acc.Lead_Source1__c=ldSourceId;
                            acc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                            acc.OwnerId=selectUserlId2;
                            acc.salutation=(wp.tra.salutation!='')?wp.tra.salutation :  acc_li[0].Salutation;
                            acc.FirstName=(wp.tra.FirstName!='')?wp.tra.FirstName :  acc_li[0].FirstName;
                            acc.LastName=(wp.tra.LastName!='')?wp.tra.LastName :  acc_li[0].LastName;
                            acc.MiddleName=(wp.tra.MiddleName!='')?wp.tra.MiddleName :  acc_li[0].MiddleName;
                            acc.PersonMobilePhone=(wp.tra.MobilePhone!='')?wp.tra.MobilePhone:acc_li[0].PersonMobilePhone;
                            acc.PersonEmail=(wp.tra.Email!='')?wp.tra.Email:acc_li[0].PersonEmail;
                            acc.Campaign_Id__c=(wp.tra.Campaign_Id__c!='')?wp.tra.Campaign_Id__c:acc_li[0].Campaign_Id__c;
                            acc.Web_To_Lead_Program__c=(wp.tra.Web_To_Lead_Program__c!='')?wp.tra.Web_To_Lead_Program__c:acc_li[0].Web_To_Lead_Program__c;
                            acc.Web_To_Lead_Centre__c=(wp.tra.Web_To_Lead_Centre__c!='')?wp.tra.Web_To_Lead_Centre__c:acc_li[0].Web_To_Lead_Centre__c;
                            acc.BillingStreet=(wp.tra.Street!='')?wp.tra.Street:acc_li[0].BillingStreet;
                            acc.BillingCity=(wp.tra.City!='')?wp.tra.City:acc_li[0].BillingCity;
                            acc.BillingState=(wp.tra.State!='')?wp.tra.State:acc_li[0].BillingState;
                            acc.BillingCountry=(wp.tra.Country!='')?wp.tra.Country:acc_li[0].BillingCountry;
                            acc.BillingPostalCode=(wp.tra.PostalCode!='')?wp.tra.PostalCode:acc_li[0].BillingPostalCode;
                            acc.PersonMailingCity=(wp.tra.City!='')?wp.tra.City:acc_li[0].PersonMailingCity;
                            ccList_up.add(acc);
                        }
                       
                    }else{

                    Account acc= new Account();
                    acc.salutation=wp.tra.salutation;
                    acc.OwnerId=selectUserlId2;
                    acc.Lead_Mode__c = ldModeId;
                    acc.Lead_Source1__c = ldSourceId;
                    acc.FirstName=wp.tra.FirstName;
                    acc.LastName=wp.tra.LastName;
                    acc.MiddleName=wp.tra.MiddleName;
                    acc.PersonMobilePhone=wp.tra.MobilePhone;
                    acc.PersonEmail=wp.tra.Email;
                    acc.Campaign_Id__c=wp.tra.Campaign_Id__c;
                    acc.Web_To_Lead_Program__c=wp.tra.Web_To_Lead_Program__c;
                    acc.Web_To_Lead_Centre__c=wp.tra.Web_To_Lead_Centre__c;
                    acc.BillingStreet=wp.tra.Street;
                    acc.BillingCity=wp.tra.City;
                    acc.BillingState=wp.tra.State;
                    acc.BillingCountry=wp.tra.Country;
                    acc.BillingPostalCode=wp.tra.PostalCode;
                    acc.PersonMailingCity=wp.tra.City;
                    acc.First_Lead_Source__c='IMS Website';
                    acc.Last_Updated_Lead_Source_Time__c=Datetime.now();
                    ccList.add(acc);
                   // insert acc;
                }
            }
          update selist;

          //record store on Account object
          insert ccList;
          update ccList_up;
        
        //store lead source in related of account
        List<Student_Lead_Source__c> sls_list=new List<Student_Lead_Source__c>();
        for(Account acc:ccList_up){
            Student_Lead_Source__c sls=new Student_Lead_Source__c();
            sls.Campaign_Id__c=acc.Campaign_Id__c;
            sls.Lead_Source__c=ldSourceId;
            sls.Student_Account__c=acc.Id;
            sls_list.add(sls);
        }
        
        for(Account acc:ccList){
            Student_Lead_Source__c sls=new Student_Lead_Source__c();
            sls.Campaign_Id__c=acc.Campaign_Id__c;
            sls.Lead_Source__c=ldSourceId;
            sls.Student_Account__c=acc.Id;
            sls_list.add(sls);
        }
            
            upsert sls_list;
            
        }
        }
  
        
      PageReference pageRef = new PageReference('/apex/MassLeadconvert');
      pageRef.setRedirect(true);
      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));

      return pageRef;
    }
    
    public PageReference cancel() {
        
        PageReference pageRef = new PageReference('/');
        pageRef.setRedirect(true);
        return pageRef;      
    }
    
    public void processSelected() {
    ldlist = new List<Lead>();
 
        for(wrTra wrapLeadObj : wrlist) {
            if(wrapLeadObj.chk == true) {
                ldlist.add(wrapLeadObj.tra);
            }
        }
    }
    
    public class wrTra{
        
        public Lead tra {get;set;}
        public Boolean chk{get;set;}
        
        public wrTra(Lead doc){
            this.tra=doc;
            this.chk=false;
            
        }
    }

}