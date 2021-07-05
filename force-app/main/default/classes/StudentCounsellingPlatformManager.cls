public without sharing class StudentCounsellingPlatformManager {
    public StudentCounsellingPlatformManager() {

    }

    @AuraEnabled(cacheable=false)
    public static returnCounsellingApex createCounselling(String accountRecordId,String centerRecordId,String productRecordId){
        returnCounsellingApex rcApex = new returnCounsellingApex();
        try {

            List<Counselling__c> listCounselling = new List<Counselling__c>();
            listCounselling = [ SELECT Id,Name,(SELECT Id,Name FROM Centre__r LIMIT 1 )
            ,(SELECT Id,Name FROM Profile_Discovery__r LIMIT 1 )
            ,(SELECT Id,Name FROM Program__r LIMIT 1 ) FROM Counselling__c WHERE Student__c =: accountRecordId LIMIT 1 ];
            if(listCounselling.size() > 0){
                rcApex.Counselling_id = listCounselling[0].Id;
                rcApex.Counselling_Centre_id = listCounselling[0].Centre__r[0].Id;
                rcApex.Profile_Discovery_id = listCounselling[0].Profile_Discovery__r[0].Id;
                rcApex.Counselling_Program_id = listCounselling[0].Program__r[0].Id;
                rcApex.status = true;
                rcApex.message = 'success';
            }else{

                Counselling__c Counselling = new Counselling__c();
                Counselling.Student__c = accountRecordId;
                insert Counselling;
                
                rcApex.Counselling_id = Counselling.id;
                
                Counselling_Centre__c Counselling_Centre = new Counselling_Centre__c(); 
                Counselling_Centre.Centre__c = centerRecordId;
                Counselling_Centre.Counselling__c = Counselling.id;
    
                insert Counselling_Centre;
    
                rcApex.Counselling_Centre_id = Counselling_Centre.id;
    
                Counselling_Program__c Counselling_Program = new Counselling_Program__c(); 
                Counselling_Program.Counselling__c = Counselling.id;
                Counselling_Program.Product__c = productRecordId;
                insert Counselling_Program;
                
                rcApex.Counselling_Program_id = Counselling_Program.id;
                
                Profile_Discovery__c Profile_Discovery = new Profile_Discovery__c(); 
                Profile_Discovery.Counselling__c = Counselling.id;
                insert Profile_Discovery;
                
                rcApex.Profile_Discovery_id = Profile_Discovery.id;
                rcApex.status = true;
                rcApex.message = 'success';
            }

            return rcApex;
        } catch (Exception e) {
            rcApex.status = false;
            rcApex.message =  String.valueOf(e);
            // throw new AuraHandledException(e.getMessage());
            return rcApex;
        }
    }

    @AuraEnabled(cacheable=false)
    public static string getAcademicProfileId(String recordId){
        try {
            Academic_Profile__c apc = [SELECT Id,Name FROM Academic_Profile__c WHERE Profile_Discovery__c =: recordId LIMIT 1];
            return apc.Id;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static string getaspirationId(String recordId){
        try {
            Aspiration__c apc = [SELECT Id,Name FROM Aspiration__c WHERE Profile_Discovery__c =: recordId LIMIT 1];
            return apc.Id;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Interest_and_Hobbies__c> getInterestAndHpobbies(String profileDiscoveryRecordId){
        try {
            List<Interest_and_Hobbies__c> IAH = [SELECT Id,Name,Interest_And_Hobbies__c  FROM Interest_and_Hobbies__c WHERE Profile_Discovery__c =: profileDiscoveryRecordId   ];
            return IAH;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Achievement__c> getAchivements(String profileDiscoveryRecordId){
        try {
            List<Achievement__c> IAH = [SELECT Id,Name,Achievement__c FROM Achievement__c WHERE Profile_Discovery__c =: profileDiscoveryRecordId   ];
            return IAH;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Target_Institutes__c> getTargetAndInstitue(String aspirationRecordId){
        try {
            List<Target_Institutes__c> IAH = [SELECT Id,Name,Aspiration__c,Institute__c,Institute__r.Name,Institute__r.Id FROM Target_Institutes__c WHERE Aspiration__c =: aspirationRecordId   ];
            return IAH;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    public class returnCounsellingApex{
        @AuraEnabled
        public boolean status;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public string Counselling_Program_id;
        @AuraEnabled
        public string Profile_Discovery_id;
        @AuraEnabled
        public string Counselling_Centre_id;
        @AuraEnabled
        public string Counselling_id;
    }
}