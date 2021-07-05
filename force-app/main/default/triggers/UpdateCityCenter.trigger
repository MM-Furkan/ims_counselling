trigger UpdateCityCenter on Account (before insert,before update) 
{
    Set<id> tliid = new Set<id>();
    set<string> tidset=new Set<String>();
    
    List<Account> tlilist = new List<Account>();
    
    for(Account tli : Trigger.new)
    {
        tidset.add(tli.Identity__c);
    }
    List<Centre_City__c> mtlist = [SELECT ID,Identity__c FROM Centre_City__c WHERE Identity__c in:tidset];
    Map<String,String> tMap=new Map<String,String>();
    for(Centre_City__c m:mtlist)
    {
        tMap.put(m.Identity__c,m.Id);
    }
    
    IF(mtlist.size() != 0 && mtlist.size() > 0 )
    {
        FOR(Account tli : Trigger.new)
        {
            if(tli.Centre__c ==NULL)
           {
           tli.Centre_City__c= tMap.get(tli.Identity__c);
            tlilist.add(TLI);
           }
        }
        //update tlilist;
    }
}