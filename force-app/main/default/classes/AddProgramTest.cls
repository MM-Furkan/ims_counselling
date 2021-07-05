@isTest
public class AddProgramTest {
    
    public static testMethod void validate(){
        
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
        
        Variant__c var = new Variant__c();
        
        var.Name = 'LAW-Intact-2020';
        var.Centre__c = cen.id;
        var.Program__c = pgrm.id;
        var.Mode__c = 'Classroom';
        var.Year__c = '2019';
        insert var;
        
        Account ac = new Account();
        ac.LastName='test';
        ac.Centre__c=cen.Id;
        ac.Total_Enrolled_no__c = 2;
        ac.Total_Closed_Lost_No__c =3;
        ac.Total_Child_Record__c = 1;
        
        //  ac.RecordTypeId = '0122v000000wPRuAAM';
        insert ac;
        
        /* acct.LastName = 'Pande';
acct.Centre__c = cen.Id;
acct.Variant__c = var.id;
acct.Program__c =  pgrm.id;
acct.Lead_Stage__c = 'Open';
acct.PersonTitle = 'Test';
acct.RecordTypeId = '0120k000000IcAx';
insert acct;*/
        
        Program_Admitted__c padmit = new Program_Admitted__c();
        
        padmit.Centre__c = cen.Id;
        padmit.Program__c = pgrm.id;
        padmit.Variant__c = var.Id;
        padmit.Stage__c = 'Enrolled';
        padmit.Backend_no__c = 3;
        padmit.Student_Account__c = ac.id;
        //  padmit.Student_Account__c = ac.Id;
        insert padmit;
        //ApexPages.currentPage().getParameters().put('id',rfq.id); 
        ApexPages.currentPage().getParameters().put('id', padmit.id);
        
        Add_Programs addpro = new Add_Programs();
        List<SelectOption> options=addpro.getCenterList();
        List<SelectOption> options3=addpro.getProgramIdList();
        List<SelectOption> options2=addpro.getVariantList();
        List<Program__c> prg = addpro.progList;
        List<Variant__c> vart = addpro.varList;
        addpro.Add();
        
        
        //addpro.Save();
        addpro.Cancel();
        
    }
}