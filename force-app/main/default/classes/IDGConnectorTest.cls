@isTest
public class IDGConnectorTest {
    
    public static testMethod void test() {
        
        IDGConnector idg = new IDGConnector();
        IDGConnector.GetUserInfo();
        String text1 = '';
        IDGConnector.GetContactInfo(text1);
    }

}