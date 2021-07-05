global class RESTGetVarientScheduleClass implements Schedulable {
   global void execute(SchedulableContext SC) {
      RESTGetVarientClass M = new RESTGetVarientClass(); 
       Database.executebatch(m,1);

   }

}