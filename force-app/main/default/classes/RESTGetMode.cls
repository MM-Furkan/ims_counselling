global class RESTGetMode{//needs to create Schedulable  
    
    public void entryAction(){
        
        List<String> cCode = new List<String>();
        Integer totalCount =  [SELECT count() FROM Program__c];
        System.debug('Total count --->'+totalCount);
        
        For(Integer i = 0; i<=totalCount;){
            Integer max = 50;
            
            String cityCode = '';
            List<Program__c> pList = [SELECT  Id, Name,Centre__r.Name,Centre__r.Centre_Code__c,Centre__r.Id, Program_Code__c, ( SELECT  Id, Name, Mode_Code__c, Program__c FROM ProgramMode__r) FROM Program__c  ORDER BY ID LIMIT:Max Offset: i];
            List<String> centreCodeList = new List<String>();
            List<String> programCodeList = new List<String>();
            
            For(Program__c c:pList){
                
                centreCodeList.add(c.Centre__r.Centre_Code__c);
                programCodeList.add(c.Program_Code__c);
                
            }
            List<object> l= new List<object>();
            l.add(centreCodeList);
            l.add(programCodeList);
            
            
            
            
            RESTGetModeBatch rgcb = new RESTGetModeBatch(l);
            Database.executeBatch(rgcb, 50);//(rgcb,cCode);
            
            i = i+max;
            
        }
        
    }
    
    public List<String> getCode(Integer max, Integer off){
        String cityCode = '';
        List<Program__c> pList = [SELECT  Id, Name,Centre__r.Name,Centre__r.Centre_Code__c,Centre__r.Id, Program_Code__c, ( SELECT  Id, Name, Lead_Mode_Code__c,  Centre__c,  Program__c FROM Lead_Mode__r) FROM Program__c  ORDER BY ID LIMIT:Max Offset: off];
        List<String> centreCodeList = new List<String>();
        List<String> programCodeList = new List<String>();
        
        For(Program__c c:pList){
            
            centreCodeList.add(c.Centre__r.Centre_Code__c);
            programCodeList.add(c.Program_Code__c);
            
        }
        
        //System.debug('I am printing the final list of CityCode'+cityCode);
        return null;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String query = 'SELECT  Id, Name,Centre__r.Name,Centre__r.Centre_Code__c,Centre__r.Id, Program_Code__c, ( SELECT  Id, Name, Lead_Mode_Code__c,  Centre__c,  Program__c FROM Lead_Mode__r) FROM Program__c ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Program__c> scope)
    {
        List<Mode> modeFromAPI = new List<Mode>();
        
        System.debug('---the centre details---');
        For(Program__c c:scope){
            //If(c.Program_Code__c=='1197'){
            List<Lead_Mode__c> ldModeDB = c.Lead_Mode__r;
            System.debug('---the program is---'+c.Lead_Mode__r);
            modeFromAPI = getCall(c.Centre__r.Centre_Code__c,c.Program_Code__c);
            For(Mode m:modeFromAPI){
                For(Lead_Mode__c ldM:ldModeDB){
                    If(m.Code==ldm.Lead_Mode_Code__c){
                        System.debug('I am printing the match Ids-->'+m);
                    }else{
                        System.debug('I am printing the unmatch Ids++>'+m);
                    }
                    
                }
            }
            
            //}
            
        }
        
        Set<String> cntre = new Set<String>();
        Set<String> prodSet = new Set<String>();
        for(Program__c c : scope)
        {
            cntre.add(c.Program_Code__c);
        }
        List<Program__c> productList = [SELECT Id, Name, Program_Code__c FROM Program__c WHERE Centre__r.Centre_Code__c IN:cntre];
        For(Program__c p:productList){
            prodSet.add(p.Program_Code__c);
        }
        
        List<Lead_Mode__c> lmode = [SELECT Id, Name From Lead_Mode__c];
        
        
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
    
    
    public List<Mode> getCall(String centre,String product){
        
        String js = '{\"txtcentre\":\"'+centre+'\",\"txtproduct\":\"'+product+'\"}';
        String s = '';
        Http h = new Http();		
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        req.setBody(js);
        req.setTimeout(120000);
        req.setHeader('Content-type', 'application/json');
        req.setHeader('token', s);
        req.setEndpoint('http://lima.imsindia.com/MyIMS/default.aspx?action=getmode');//sandbox url
        
        System.debug('The request is made to Datamatics-in Account---'+req);
        HttpResponse res = h.send(req);
        System.debug('The response is getting from Datamatics--in Account--'+res);
        System.debug('res.getbody'+res.getbody());
        String jsun = res.getBody();
        JSON2ApexGetMode jsCentre = JSON2ApexGetMode.parse(res.getBody());
        List<Mode> needToReturn = new List<Mode>();
        If(jsCentre.mode.size()>0){
            For(mode st:jsCentre.mode){
                System.debug('I am printing --'+st);
                needToReturn.add(st);
            }
            return needToReturn;
        }else{
            System.debug('Centre is Empty');
            return null;
        }
        
        
        
    }
    public void updateCentre(){
        
    } 
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //
    
    public class JSON2ApexGetMode {
        
        public List<Mode> mode;
    }
    
    public class Mode {
        public String Code;
        public String Mode;
    }
    
    
    public static JSON2ApexGetMode parse(String json) {
        return (JSON2ApexGetMode) System.JSON.deserialize(json, JSON2ApexGetMode.class);
    }
    
}