public class AddPrograms {
    
    public List < Program_University__c  > selist {get;set;}
    public Id opid {get;set;}
    Static Id sId;
    public List<wrTra> wrlist{get; set;}          
    public String wrlist1 {get; set;}
    set<String> acctben = new set<String>();
    
    public AddPrograms() {
        
        opid = ApexPages.currentPage().getParameters().get('id');
        sId = opid;
        System.debug('SID'+sId);
        wrlist = new List<wrTra>(); 
        
        for(Program_University__c  ab: [SELECT Id, Name, Program__c ,University__c FROM Program_University__c Where University__c =:opid ]){
            
            acctben.add(ab.Program__c);
            system.debug('acctben------'+acctben);
        }
        
        for(Program__c tc:[  SELECT  Id, Name, Program_Code__c, Program_Category__c, Status__c 
                             FROM Program__c where Status__c='Active' and Id NOT IN :acctben order by name]){
                                 
                                 System.debug('====> data: ' + JSON.serialize(tc));    
                                 wrlist.add(new wrTra(tc));
                             }
        wrlist1 = JSON.serialize(wrlist);
    }
    
    @RemoteAction
    public static void save(String json, String id) {
        
        List<wrTra> wrlist = parsewTra(json);        
        List<Program_University__c > selist=new List<Program_University__c >();
        
        for(wrTra wt:wrlist){ 
            if(wt.chk){
                
                Program_University__c  oppt = new Program_University__c ();
                oppt.University__c= id;
                oppt.Program__c=wt.tra.id;                 
                selist.add(oppt);
                system.debug('selist------------'+selist);
            }           
        }
        insert selist;
        
        PageReference pageRef = new PageReference('/' + id);
        pageRef.setRedirect(true);
    }
    
    public static List<wrTra> parsewTra(String json) {
        return (List<wrTra>) System.JSON.deserialize(json, List<wrTra>.class);
    }
    
    public PageReference cancel() {
        
        PageReference pageRef = new PageReference('/' + opid);
        pageRef.setRedirect(true);
        return pageRef;      
    }
    
    public class wrTra{
        
        public Program__c   tra {get;set;}
        public Boolean chk{get;set;}
        
        public wrTra(Program__c   doc){
            this.tra=doc;
            this.chk=false;
        }
    }   
    
}