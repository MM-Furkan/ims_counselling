@isTest
public class ChatbotleadConversionTest {
    
    public static testMethod void ChatbotleadConversion(){
        
        Centre__c cen = new Centre__c();
        
        cen.Name = 'Dadar';
        cen.Centre_Code__c = '0129';
        cen.Email_Id__c = 'Test@gmail.com';
        insert cen;
        
        Program__c pgrm = new Program__c();
        pgrm.Name = 'CET';
        pgrm.Status__c = 'Active';
        pgrm.Centre__c = cen.id;
        insert pgrm;
        
        Account ac = new Account();
        ac.LastName='test';
        ac.Centre__c=cen.Id;
        ac.Total_Enrolled_no__c = 2;
        ac.Total_Closed_Lost_No__c =3;
        ac.Total_Child_Record__c = 1;
        
        //  ac.RecordTypeId = '0122v000000wPRuAAM';
        insert ac;
        
        Chatbot_Lead__c chat = new Chatbot_Lead__c();
        chat.Centre__c = cen.id;
        chat.Program__c = pgrm.id;
        chat.Last_Name__c = 'Benioff';
        insert chat;
        
        ApexPages.currentPage().getParameters().put('id', chat.id);
        
        ChatbotLeadConversionClass chatcll = new ChatbotLeadConversionClass();
        chatcll.Customleadconv();
         Chatbot_Lead__c ChatbotLead =  chatcll.ChatbotLead;
    }
    
}