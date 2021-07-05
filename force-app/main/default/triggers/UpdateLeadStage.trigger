trigger UpdateLeadStage on Program_Admitted__c (after insert, after update, after delete, after undelete) {
    
  set<id> TarList = new set<id>();
    map<id,Account> Targetmap = new map<id,Account>();
      map<id,Account> Targetmap1 = new map<id,Account>();
       map<id,Account> Targetmap2 = new map<id,Account>();
    if(trigger.IsInsert || trigger.IsUpdate || trigger.IsUndelete){
        
        for(Program_Admitted__c C1 : Trigger.new){
            if(C1.Student_Account__c != Null){
               TarList.add(C1.Student_Account__c); 
            }
        }
    }

    if(Trigger.IsDelete){
        for(Program_Admitted__c C2 : Trigger.old) {
             if(C2.Student_Account__c != Null){
               TarList.add(C2.Student_Account__c); 
            }
        }
    }
    
    if(TarList != NULL && TarList.size() >0){
        for(ID q: TarList ){
            Targetmap.put( q,new Account(ID=q,Total_Enrolled_no__c = 0));
            Targetmap1.put( q,new Account(ID=q,Total_Child_Record__c = 0));
            Targetmap2.put( q,new Account(ID=q,Total_Closed_Lost_No__c = 0));
        }
        for(Program_Admitted__c C : [Select id ,LeadUpdateToEnrolled__c,Student_Account__c,Backend_no__c,LeadUpdateToClosedLost__c  
                                     from Program_Admitted__c where Student_Account__c IN :TarList  ]){
            
            Targetmap.get(C.Student_Account__c).Total_Enrolled_no__c += C.LeadUpdateToEnrolled__c;
          Targetmap1.get(C.Student_Account__c).Total_Child_Record__c += c.Backend_no__c;
            Targetmap2.get(C.Student_Account__c).Total_Closed_Lost_No__c += c.LeadUpdateToClosedLost__c; 
        }
    }
    
    if(Targetmap != NULL && Targetmap.size() >0 ){
        update Targetmap.values();
         update Targetmap1.values();
         update Targetmap2.values();
    }
      
      if(Targetmap1 != NULL && Targetmap1.size() >0 ){
        
         update Targetmap1.values();
           
    }
     
     if(Targetmap2 != NULL && Targetmap2.size() >0 ){
        
         update Targetmap2.values();
         system.debug('***Targetmap****'+Targetmap2.values());
    }

}