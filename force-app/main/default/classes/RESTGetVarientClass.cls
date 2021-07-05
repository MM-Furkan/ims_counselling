global class RESTGetVarientClass implements Database.Batchable < sObject > , Database.AllowsCallouts {
    // Start Method
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT ID, Name, Program_Code__c, (SELECT Id, Name, Variant_Code__c FROM Variants__r ) From Program__c';
        
        return Database.getQueryLocator(query);
        
    }
    
    // Execute method
    
    global void execute(Database.BatchableContext BC, List < Program__c > scope) {
        
        
        IF(scope.Size() > 0) {
            Set<String> progSet = new Set<String>();
            For(Program__c c: scope){
                progSet.add(c.ID);
            }
            List<Program__c> progList = [SELECT ID, Name, Program_Code__c, (SELECT Id, Name, Variant_Code__c,Centre__r.Centre_Code__c FROM Variants__r ) From Program__c WHERE ID IN:progSet];
            //List<Variant__c> varList = [SELECT Id, Name, Variant_Code__c FROM Variant__c WHERE Program__r.Program_Code__c IN:progSet];
            Map < String, Id > prodMap = new Map < String, Id > ();
            Map<String,String> variantMap = new Map<String,Id>();
            Map<String,String> programMap = new Map<String,Id>();
            System.debug('I am printing the Program result--->');
            System.debug('--->' + scope);
            
            For(Program__c c: progList) {
                prodMap.put(c.Program_Code__c, c.Id);
                for(Variant__c cv: c.Variants__r){
                    String unqV = c.Program_Code__c + '_' +  cv.Variant_Code__c+'_'+cv.Centre__r.Centre_Code__c;
                    variantMap.put(unqV,cv.Id);
                }
                programMap.put(c.Program_Code__c,c.Id);
                
            }
            
            System.debug('I am printing the Program result--->');
            System.debug('--->' + scope);
            Map < String, String > progMap = new Map < String, String > ();
            String prgCode = '';
            for (Program__c a: scope) {
                If(prgCode != '') {
                    prgCode = prgCode + ',' + a.Program_Code__c;
                } else {
                    prgCode = a.Program_Code__c;
                }
                
            }
            
            String cnt = '0';
            String prd = prgCode;
            String mde = '0';
            
            System.debug('I am printing the final Program code--->');
            System.debug('--->' + prgCode);
            Map<String,Object> mapRe=new Map<String,Object>();
            mapRe.put('txtcentre', cnt);
            mapRe.put('txtproduct', prd);
            mapRe.put('txtmode', mde);
            
           // String js = '{\"txtcentre\":\"' + cnt + '\",\"txtproduct\":\"' + prd + '\",\"txtmode\":\"' + mde + '\"}';
            String js=JSON.serialize(mapRe);
            String s = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setMethod('POST');
            req.setBody(js);
            req.setTimeout(120000);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('token', s);
           // req.setEndpoint('https://demo.imsindia.com/SF_API/default.aspx?action=getvariant'); //sandbox url
             req.setEndpoint('https://lima.imsindia.com/SF_API/default.aspx?action=getvariant'); //production url
            
            System.debug('The request is made to LIMA-in Varient---' + req);
            HttpResponse res = h.send(req);
            //System.debug('The response is getting from LIMA-in Varient--' + res);
            System.debug('res.getbody' + res.getbody());
            String jsun = res.getBody();
            JSON2ApexGetVarient jsCentre = JSON2ApexGetVarient.parse(res.getBody());
            If(jsCentre.variant.size() > 0) {
                List<Variant__c> nVariantList = new List<Variant__c>();
                Set<String> centreSet = new Set<String>();
                For(variant st: jsCentre.variant) {
                    centreSet.add(st.CentreCode);
                }
                
                   System.debug('----------------->centreSet'+centreSet);
                
                List < Centre__c > centreList = [SELECT ID, Name, Centre_Code__c FROM Centre__c Where Centre_Code__c IN:centreSet];
                Map < String, Id > cntreMap = new Map < String, Id > ();
                
                IF(centreList.Size() > 0) {
                    For(Centre__c c: centreList) {
                        cntreMap.put(c.Centre_Code__c, c.Id);
                    }
                }
                  System.debug('----------------->cntreMap'+cntreMap);
                
                System.debug('----------------->jsCentre.variant'+jsCentre.variant);
                System.debug('----------------->jsCentre.variant'+jsCentre.variant.size());
                For(variant st: jsCentre.variant) {
                    if(st.CentreCode != '' && st.CentreCode != Null && cntreMap.get(st.CentreCode) != Null){
                        Variant__c nv = new Variant__c();
                        String unqv = st.ProductCode + '_' + st.VariantCode + '_'+st.CentreCode;
                        if(variantMap.get(unqv) != Null){
                            nv.Id = variantMap.get(unqv); 
                        }
                        if(programMap.get(st.ProductCode) != Null){
                            nv.Program__c = programMap.get(st.ProductCode);
                        }
                        nv.Variant_Code__c = st.VariantCode;
                        nv.Name = st.Variant;
                        nv.Fees__c=Decimal.valueOf(st.Fees);
                        if(cntreMap.get(st.CentreCode) !=Null){
                            nv.Centre__c = cntreMap.get(st.CentreCode);
                        }
                        nv.Mode__c = st.ModeName;
                        
                        nVariantList.add(nv);
                     
                    }
                }
                 System.debug('Final list before upsert0-->'+nVariantList);
                 System.debug('Final list before upsertq1-->'+nVariantList.size());
                
                System.debug('Final list before upsert-->'+nVariantList);
                Database.UpsertResult [] nVariantList1 = Database.upsert(nVariantList, true);
            } else {
                System.debug('Varient is Empty');
            }
        }
        
    }
    
    // Finish Method
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //
    
    public class JSON2ApexGetVarient {
        
        public List < Variant > variant;
    }
    public class Variant {
        public String CentreCode;
        public String ProductCode;
        public String ModeCode;
        public String ModeName;
        public String VariantCode;
        public String Variant;
        public String Fees;
    }
    
    
    
    
    public static JSON2ApexGetVarient parse(String json) {
        return (JSON2ApexGetVarient) System.JSON.deserialize(json, JSON2ApexGetVarient.class);
    }
    
}