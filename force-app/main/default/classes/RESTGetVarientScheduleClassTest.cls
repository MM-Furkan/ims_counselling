@isTest
public class RESTGetVarientScheduleClassTest {
    static testmethod void test() {
        Test.startTest();
        
        RESTGetVarientScheduleClass s = new RESTGetVarientScheduleClass();
         String sch = '0  00 1 3 * ?';
       system.schedule('Test', sch, s);
        
        
        
        Test.stopTest();
    }
}