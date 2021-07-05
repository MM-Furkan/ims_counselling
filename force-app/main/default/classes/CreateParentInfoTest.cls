@isTest
public class CreateParentInfoTest {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.LastName = 'Test';
        
        acc.ShippingPostalCode = '234532';
        acc.Lead_Stage__c = 'Open';
        acc.ShippingCity = 'THANE';
        acc.Copy_Mailing_To_Permanent_Address__c = True;
        insert acc;
        update acc;
    }
    
    public static testMethod void validate2(){
        
        Account acc = new Account();
        acc.LastName = 'Test';
        
        acc.ShippingPostalCode = '234532';
        acc.Lead_Stage__c = 'Open';
        acc.ShippingCity = 'THANE';
        acc.Copy_Mailing_To_Permanent_Address__c = True;
        insert acc;
        
        Program_Admitted__c padmit = new Program_Admitted__c();
        
        padmit.Student_Account__c = acc.Id;
        
        insert padmit;
        update padmit;
    }
    
}