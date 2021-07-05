global class RESTCentreCityMaster implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        RESTCentreCityMasterBatch lima = new RESTCentreCityMasterBatch();
        Database.executeBatch(lima,200);
        
        
    }
    
}