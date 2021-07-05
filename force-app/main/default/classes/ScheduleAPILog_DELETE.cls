global class ScheduleAPILog_DELETE  implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        String query='SELECT CreatedDate,Id FROM API_log__c WHERE CreatedDate < yesterday ORDER BY CreatedDate DESC NULLS FIRST';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc,List<API_Log__c> loglist){
        system.debug('size is'+loglist.size());
        system.debug('size is'+loglist.size());
        
        delete loglist;
    }
    public void finish(Database.BatchableContext bc){}

}