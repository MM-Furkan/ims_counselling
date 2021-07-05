trigger UpdateStagetoClosedLostOnStudentAccount on Program_Admitted__c (After insert,After update) {
    
    
  /*  list<Account> updateAddList = New  list<Account>();
    set<id> setid = new set<id>();
    
    for(Program_Admitted__c ra : trigger.new){
        
        setid.add(ra.Student_Account__c);
    }
    
    List<Account> ProAddList = [Select Id from Account where ID IN :setid];
    list<Program_Admitted__c> plist=new List<Program_Admitted__c>();
    plist=[select ID,Stage__c,Student_Account__c,Aging__c from Program_Admitted__c where Student_Account__c in:ProAddList And Aging__c >=15 AND Stage__c='Intrested' ];
    system.debug('**** Plist'+plist);
    
    For(Program_Admitted__c react : plist){
        
    }
    For(Account ren : ProAddList ){
        
        for(Program_Admitted__c react : plist){
            if(react.Stage__c == 'Intrested'  )  {
                ren.Lead_Stage__c = 'Closed Lost';
                system.debug('**** Plist'+ren.Lead_Stage__c);
                updateAddList.add(ren);
            }
        }
    }
    update updateAddList;
    */
    
}