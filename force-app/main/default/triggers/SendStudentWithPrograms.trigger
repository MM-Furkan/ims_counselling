trigger SendStudentWithPrograms on Program_Admitted__c (after insert) {
    
    System.debug('SendStudentWithPrograms----------------?');
    Set<ID> progIDs = new Set<ID>(); 


   For(Program_Admitted__c p :Trigger.New){
    if(p.Program_Admitted__c == false){
        progIDs.add(p.Id);
    }
        System.debug('SendStudentWithPrograms-111---------------?');
    }
    If(progIDs.size()>0){

        System.debug('SendStudentWithPrograms-111---------------?');
         if(!System.isFuture() && !System.isBatch()){
             
             SendStudentWithProgREST.apiCallout(progIDs);
             
             
         }
       
    }

   

}