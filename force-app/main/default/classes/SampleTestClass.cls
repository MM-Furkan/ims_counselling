public class SampleTestClass {//have written for Centre class

     
    public void getRecords(){
        
        List<String> cCode = new List<String>();
        Integer totalCount =  [SELECT count() FROM Centre_City__c];
        System.debug('Total count --->'+totalCount);
        
        For(Integer i = 0; i<=totalCount;){
            Integer max = 50;
            cCode = getCode(max,i);
            System.debug('After i'+i+cCode);
            RESTGetCentreBatch rgcb = new RESTGetCentreBatch(cCode);
            Database.executeBatch(rgcb, 50);//(rgcb,cCode);
            
            i = i+max;
            
        }
        
    }
    
    public List<String> getCode(Integer max, Integer off){
        String cityCode = '';
        List<Centre_City__c> cList = [SELECT ID, Name, City_Code__c FROM Centre_City__c ORDER BY ID LIMIT:Max Offset: off];
        List<String> codeList = new List<String>();
            
        For(Centre_City__c c:cList){
            
                codeList.add(c.City_Code__c);
            
        }
        
        //System.debug('I am printing the final list of CityCode'+cityCode);
        return codeList;
    }
}