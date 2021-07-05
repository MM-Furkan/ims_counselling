@RestResource(urlMapping='/UpdateStudentInfo/*')
global class Rest_UpdateStudentInfo {
    @HttpPost
    global static void doPost() {  
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='UpdateStudentInfo';
       
        RestRequest request = RestContext.request;  
        
        RestResponse response = RestContext.response;  
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        
        //save request in API Log
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
        JSON2ApexUpdateStudentInfo jsonObj = JSON2ApexUpdateStudentInfo.parse(jSONRequestBody); 
        System.debug('======----->jsonObj'+jsonObj); 
		List<Parent_Information__c> picList=new List<Parent_Information__c>();
        List<Educational_Detail__c> edList=new List<Educational_Detail__c>();
        List<Work_Detail__c> wdList=new List<Work_Detail__c>();
        List<Account> accList=new List<Account>();
        try{
            if(jsonObj.SF_Id!=''){
                List<Account> ac=[SELECT Id,Name FROM Account WHERE Id=:jsonObj.SF_Id ];
                if(ac.size()>0){
                    Account cc=new Account();
                    cc.Id=jsonObj.SF_Id;
                    //cc.Lead_Source1__c=ldSourceId;
                    cc.FirstName = jsonObj.FirstName;
                    cc.PersonMobilePhone =jsonObj.WhatsappNumber;
                    cc.Gender__c=jsonObj.Gender;
                    cc.DOb__c=Date.valueOf(jsonObj.DOB);
                    cc.category1__c=jsonObj.Category;
                    cc.Test_preparation_required_for__c=jsonObj.TestPreparationRequiredFor;
                    cc.Total_Work_experience_in_months__c=jsonObj.TotalWork_experience_in_months;
                    for(FamilyDetails fmd:jsonObj.FamilyDetails){
                        Parent_Information__c pic=new Parent_Information__c();
                        pic.Student_Account__c=jsonObj.SF_Id;
                        pic.Relationship__c=fmd.Parent_Guardian_Relation;
                        pic.Parent_Email__c=fmd.Parent_Guardian_Email_ID;
                        pic.Parent_Mobile__c=fmd.Parent_Guardian_Mobile_No;
                        pic.Last_Name__c=fmd.Parent_Guardian_LastName;
                        pic.Middle_Name__c=fmd.Parent_Guardian_MiddleName;
                        pic.First_Name__c=fmd.Parent_Guardian_FirstName;
                       // pic.Parent_Title__c=fmd.Parent_Guardian_Title;
                        picList.add(pic);
                    }
                    
                    for(EducationalDetails ed:jsonObj.EducationalDetails){
                        Educational_Detail__c edc=new Educational_Detail__c();
                        edc.Student_Account__c=jsonObj.SF_Id;
                        edc.CGPA__c=ed.CGPA_x_y;
                        edc.EducationType__c=ed.EducationType;
                        edc.Expected_Actual_Yr_of_completion__c=ed.Expected_Actual_Yr_of_completion;
                        edc.School_College__c=ed.School_College;
                        edc.University_Board__c=ed.University_Board;
                        edc.Marks__c=ed.Marks;
                        edc.Qualification_Stream__c=ed.Qualification_Stream;
                        edc.Specialisation__c=ed.Specialisation;
                        edList.add(edc);
                    }
                    for(WorkDetails wds:jsonObj.WorkDetails){
                        Work_Detail__c wd=new Work_Detail__c();
                        wd.Student_Account__c =jsonObj.SF_Id;
                        wd.Organisation__c=wds.Organisation;
                        wd.Designation__c=wds.Designation;
                        wd.Work_experience_in_months__c=wds.Work_experience_in_months;
                        wdList.add(wd);
                    }
                    accList.add(cc);
                    
                    system.debug('wdList'+wdList);
                    upsert accList;
                    upsert wdList;
                    upsert edList;
                    upsert picList;
                    
                    String resp = JSON.serialize('{"Message":"Record updated successfully"}');
                    response.responseBody = Blob.valueOf(resp);
                    response.addHeader('Content-Type', 'application/json');
                    response.statusCode = 200;
                    api_log.Response__c= String.valueOf(resp);
                    api_log.response_time__c=Datetime.now();
                    
                }else{
                    String resp = JSON.serialize('{"Message":"Student ID is not Present"}');
                    response.responseBody = Blob.valueOf(resp);
                    response.addHeader('Content-Type', 'application/json');
                    response.statusCode = 200;
                    api_log.Response__c= String.valueOf(resp);
                    api_log.response_time__c=Datetime.now();
                }
               
            }
            
        }catch(Exception e){
            System.debug('Format Error');
            String resp = JSON.serialize('{"Message":"'+e.getStackTraceString()+'"}');
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            
            response.statusCode = 200;
            api_log.Response__c= String.valueOf(e);
            api_log.response_time__c=Datetime.now();

        }
        insert api_log;
        
    }

    public class JSON2ApexUpdateStudentInfo {

        public String SF_Id;
        public String FirstName;
        public String LeadSource;
        public String Gender;
        public String DOB;
        public String Category;
        public String WhatsappNumber;
        public String TestPreparationRequiredFor;
        public List<FamilyDetails> FamilyDetails;
        public List<EducationalDetails> EducationalDetails;
        public List<WorkDetails> WorkDetails;
        public Integer TotalWork_experience_in_months;
    }
    
        public class EducationalDetails {
            public String EducationType;
            public String Expected_Actual_Yr_of_completion;
            public String School_College;
            public String University_Board;
            public Double Marks;
            public String CGPA_x_y;
            public String Qualification_Stream;
            public String Specialisation;
        }
    
        public class WorkDetails {
            public String Organisation;
            public String Designation;
            public Integer Work_experience_in_months;
        }
    
        public class FamilyDetails {
            public String Parent_Guardian_Title;
            public String Parent_Guardian_FirstName;
            public String Parent_Guardian_MiddleName;
            public String Parent_Guardian_LastName;
            public String Parent_Guardian_Relation;
            public String Parent_Guardian_Mobile_No;
            public String Parent_Guardian_Email_ID;
        }
    
        
        public static JSON2ApexUpdateStudentInfo parse(String json) {
            return (JSON2ApexUpdateStudentInfo) System.JSON.deserialize(json, JSON2ApexUpdateStudentInfo.class);
        }
    

}