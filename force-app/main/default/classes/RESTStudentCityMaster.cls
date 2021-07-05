global class RESTStudentCityMaster implements Schedulable{
    
     global void execute(SchedulableContext sc){
        
        RESTStudentCityMasterBatch lima = new RESTStudentCityMasterBatch();
        Database.executeBatch(lima,200);
        
        
    }
}