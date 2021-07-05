public class ChatbotLeadConversionClass {
    
    public Chatbot_Lead__c ChatbotLead{get;set;}
    public Id cleadid {get;set;}
    public RecordType rt {get;set;}
    
    Public ChatbotLeadConversionClass()
    {
        
         cleadid = ApexPages.currentPage().getParameters().get('Id');
         rt = [Select id,name From RecordType where Name='ReadOnlyChatbot'];
        ChatbotLead = [SELECT id,name,Company__c,Email__c,Salutation__c,First_Name__c,Last_Name__c,Lead_Mode__c,Lead_Source1__c,
                       Middle_Name__c,MobilePhone__c,Phone__c,Centre__c,Program__c,Street__c,Website__c,Zip_Postal_Code__c,Campaign_Id__c,
                      City__c,Country__c,State_Province__c FROM Chatbot_Lead__c WHERE id=:cleadid];
        
       
       
    }
    
    public pagereference Customleadconv()
    {
        Account cacc = new Account();
        cacc.Salutation = ChatbotLead.Salutation__c;
        cacc.FirstName = ChatbotLead.First_Name__c;
        cacc.MiddleName = ChatbotLead.Middle_Name__c;
        cacc.LastName = ChatbotLead.Last_Name__c;
        cacc.PersonEmail = ChatbotLead.Email__c;
        cacc.PersonMobilePhone = ChatbotLead.MobilePhone__c;
        cacc.Phone = ChatbotLead.Phone__c;
        cacc.Lead_Mode__c = ChatbotLead.Lead_Mode__c;
        cacc.Lead_Source1__c = ChatbotLead.Lead_Source1__c;
        cacc.Program__c = ChatbotLead.Program__c;
        cacc.Centre__c = ChatbotLead.Centre__c;
        cacc.Campaign_Id__c = ChatbotLead.Campaign_Id__c;
       
        //  cacc.NumberOfEmployees = ChatbotLead.NumberOfEmployees__c;
        cacc.PersonMailingCountry = ChatbotLead.Country__c;
        cacc.PersonMailingCity = ChatbotLead.City__c;
        cacc.PersonMailingStreet = ChatbotLead.Street__c;
        cacc.PersonMailingState = ChatbotLead.State_Province__c;
        cacc.PersonMailingPostalCode = ChatbotLead.Zip_Postal_Code__c; 
        
        insert cacc;
        
        ChatbotLead.Lead_Status__c='Qualified';
        ChatbotLead.RecordTypeId = rt.Id;
        update ChatbotLead;
        
        
        
        PageReference pageRef=new PageReference('/' +cacc.id );
        pageRef.setRedirect(true);
        return pageRef; 
        
    }
}