trigger UpdateProgSourceFromLeadSource on Program_Admitted__c (before insert) {

    Set<Id> ids = new Set<Id>();
 
    list<Program_Admitted__c> tlist = [SELECT Id, Name  FROM Program_Admitted__c Where Id IN : ids];
    
    for(Program_Admitted__c tests : trigger.new){
    	
    }
    insert tlist;
}