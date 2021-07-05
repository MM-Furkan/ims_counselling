public class IDGConnector {  
    public static String GetUserInfo() {
        User currentuser=new User();
        currentuser=[Select UserName,Extension from User where Id=:userinfo.getuserId()];
        return JSON.serialize(currentuser);
    }
    public static String GetContactInfo(String cli) {
        List<Contact> resultContact=[Select Id, Name from Contact where HomePhone=:cli OR Phone=:cli OR MobilePhone=:cli LIMIT 1];
        if(resultContact.size() > 0)
            return JSON.serialize(resultContact[0]);
        else            
           return null;
    }
}