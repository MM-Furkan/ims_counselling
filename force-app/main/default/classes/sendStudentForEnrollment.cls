public class sendStudentForEnrollment {
    
    public Id currentId {get;set;}
    
    public sendStudentForEnrollment(){
        currentId = ApexPages.currentPage().getparameters().get('id');
        System.debug('currentId'+currentId);
    }
    
     public PageReference sendEnrollData(){
         Program_Admitted__c pg=[SELECT Id,Student_Account__r.IMS_PIN__c,Centre__r.Centre_Code__c,Variant__r.Variant_Code__c FROM Program_Admitted__c Where Id =:currentId];
         String imsPin=pg.Student_Account__r.IMS_PIN__c!=null?pg.Student_Account__r.IMS_PIN__c:'';
         String centercode=pg.Centre__r.Centre_Code__c!=null?pg.Centre__r.Centre_Code__c:'';
         String variantcode=pg.Variant__r.Variant_Code__c!=null?pg.Variant__r.Variant_Code__c:'';
         
         String limaurl='https://lima.imsindia.com/detailenrollment/default.aspx?action=addenrollment&imspin='+imsPin+'&centrecode='+centercode+'&pmvcode='+variantcode+'';
       
        System.debug('===>limaurl '+limaurl);
        PageReference pageRef = new PageReference(limaurl);
        pageRef.setRedirect(true);
        return pageRef;
       
     }

}