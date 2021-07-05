@RestResource(urlMapping='/updateProgramFees/*')
global class Rest_updateProgramfees {
     @HttpPost
    global static void doPost() {  
        API_log__c  api_log=new API_log__c();
        api_log.Log_Name__c='updateProgramFees';
        
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        api_log.Request__c= jSONRequestBody;
        api_log.created_date__c=Datetime.now();
        
       JSON2ApexSaveLead jsonObj = JSON2ApexSaveLead.parse(jSONRequestBody);
       String centre = jsonObj.StudentAccount.CentreCode;
       String product = jsonObj.StudentAccount.ProductCode;
       String varient = jsonObj.StudentAccount.Variant;
       List<Program__c> progList = [SELECT Id, Name,Program_Code__c FROM Program__c WHERE Program_Code__c=:product];
        List<Centre__c> cntreList = [SELECT Id, Name,Centre_Code__c FROM Centre__c	WHERE Centre_Code__c=:centre];
        List<Variant__c> varntList = [SELECT Id, Name, Variant_Code__c FROM Variant__c WHERE Variant_Code__c=:varient];
      
        Map<String,Id> progMap = new Map<String,Id>();
        Map<String,Id> cntreMap = new Map<String,Id>();
        Map<String,Id> varntMap = new Map<String,Id>(); 
        
        If(progList.size()>0){
            System.debug('I am printing the progList data-->'+progList);
            For(Program__c p:progList){
                progMap.put(p.Program_Code__c,p.Id);
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
        try{
            
       
        List<Program_Admitted__c> prgad= [SELECT Id,Amount__c,Student_Account__c,Student_Account__r.IMS_PIN__c, Name,Stage__c FROM Program_Admitted__c WHERE Program__r.Program_Code__c=:jsonObj.StudentAccount.ProductCode AND Centre__r.Centre_Code__c=:jsonObj.StudentAccount.CentreCode  AND Variant__r.Variant_Code__c=:jsonObj.StudentAccount.Variant AND Student_Account__r.IMS_PIN__c =:jsonObj.StudentAccount.IMSPIN];
       
        if(prgad.size()>0){
            for(Program_Admitted__c pg:prgad){
                     pg.Amount__c=pg.Amount__c+jsonObj.StudentAccount.Amount;
            }
            upsert prgad;
            
                Map<String, String> res_msg = new Map<String, String>();
                res_msg.put('Status', 'True');
                res_msg.put('Message', 'Amount update successfully');
                
                String resp = JSON.serialize(res_msg);
                response.responseBody = Blob.valueOf(resp);
                response.addHeader('Content-Type', 'application/json');
                response.statusCode = 200;
                
                api_log.Response__c= String.valueOf(res_msg);
                api_log.response_time__c=Datetime.now(); 
        }else{
            Map<String, String> res_msg = new Map<String, String>();
                res_msg.put('Status', 'Fail');
                res_msg.put('Message', 'no record found');
                
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
        public String ProductCode;
        public String Variant;
        public String CentreCode;
        public Decimal Amount;
    }
    
    
    
    
    public static JSON2ApexSaveLead parse(String json) {
        return (JSON2ApexSaveLead) System.JSON.deserialize(json, JSON2ApexSaveLead.class);
    }

}