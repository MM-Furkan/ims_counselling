public class Add_Programs {
    
    public id stid {get;set;}
    public id progid {get;set;}
    public id vrid {get;set;}
    public id moid {get;set;}  
    public Id selectProgId {get; set;}
    public Id selectCentId {get; set;}
    public Id ProgVarId {get; set;}
  //  public Id selectModeId {get; set;}
    public Account acc= new Account();
    public list<Program__c> progList{get;set;}
    public list<Program_Admitted__c> progadmList {get;set;}
    public list<Variant__c> varList{get;set;}
    public list<Centre__c> cenList{get;set;}
    public Variant__c var{get;set;}
    public String ModeName {get;set;}
  // public list<Mode__c> modList{get;set;}
    public Program_Admitted__c prg {get;set;}
    public Integer row{get;set;}
    public Decimal Fees{get;set;}
    public String Yrs{get;set;}
 
   
    
    public Add_Programs(){
        stid = ApexPages.currentPage().getParameters().get('id');
        system.debug('stiddd'+stid);
       // acc=[Select id, name From Account Where id=:stid];
       // system.debug('accout'+acc);
        prg = new Program_Admitted__c();
        var = new Variant__c();
        progadmList= new List<Program_Admitted__c>();
       
    }
    
    public List<selectOption> getProgramIdList(){
        List<Program__c> programIDs=[select ID, name FROM Program__c];
        list<selectoption> ProgramIdList = new list<selectoption>();        
        ProgramIdList.add(new SelectOption( ' ' ,'---Select---'));
        for(Program__c p:programIDs){
            ProgramIdList.add(new SelectOption(p.Id, p.Name));
        }
        return ProgramIdList; 
    }
    
    public List<SelectOption> getVariantList(){
        List < SelectOption > options = new List < SelectOption > ();
        varList=[ select ID, name,Program__c, Program__r.Name ,Mode__c,Year__c FROM Variant__c where Program__c=:selectProgId and Centre__c=:selectCentId ORDER by name ASC];
        options.add(new SelectOption('None', 'None'));
        for(Variant__c v:varList){
            options.add(new SelectOption(v.id, v.Name));
        }
        return options;
    }  
    
    
  /*  public List<SelectOption> getModeList(){
        List < SelectOption > options = new List < SelectOption > ();
        modList=[ select ID, name,Variant__c FROM Mode__c where Variant__c=:ProgVarId ORDER by name ASC];
        system.debug('mode list'+modList);
        options.add(new SelectOption('None', 'None'));
        for(Mode__c m:modList){
            options.add(new SelectOption(m.id, m.Name));
        } 
        return options;
        
    }  */
    
    public void getVaMode(){
        
        List<Variant__c> vari=[ select ID, name,Program__c,Fees__c, Program__r.Name ,Mode__c,Year__c FROM Variant__c where id=:ProgVarId];
        ModeName=vari[0].Mode__c;
        Yrs=vari[0].Year__c;
        Fees=vari[0].Fees__c;
        system.debug('ModeName===>' +ModeName);
        system.debug('Yrs===>' +Yrs);
        system.debug('Fees===>' +Fees);
        
    }
    
    public List<SelectOption> getCenterList(){
        List<Program_Admitted__c> progadmList= new List<Program_Admitted__c>();
        List < SelectOption > options = new List < SelectOption > ();
       cenList=[ select ID, name  FROM Centre__c ORDER by name ASC];
        system.debug('center list'+cenList);
        options.add(new SelectOption('None', 'None'));
        for(Centre__c c:cenList){
            options.add(new SelectOption(c.id, c.Name));
        }
        
        return options;
    }  
    
    public void Add(){  
        system.debug('***add');
        
       Program_Admitted__c pa = new Program_Admitted__c();
        pa.Student_Account__c=stid;
        system.debug('student acc*******'+pa.Student_Account__c);
        pa.Program__c=selectProgId;
        pa.Variant__c=ProgVarId;
     	pa.Mode__c=ModeName;
        pa.Centre__c =selectCentId;
        pa.exam_Year__c=Yrs;
        pa.Total_Fees__c=Fees;
      
        progadmList.add(pa);
        
        selectProgId=null;
        ProgVarId =null;
        selectCentId =null;  
        ModeName=null;
        Yrs=null;
        Fees=null;
    //   system.debug('mode---'+pa.Mode__c);
        system.debug('add'+progadmList);
    }
    
    public Pagereference Save(){   
        system.debug('save funtion');
        system.debug('Save------------->'+progadmList);
        insert progadmList;


      
        // insert prlList; 
        pagereference pg= new pagereference('/'+stid);
        pg.setRedirect(true);
        return pg;  	
    }
    
    public void Del(){
         progadmList.remove(row);
    }
    
    public Pagereference Cancel(){
        
        pagereference pg=new pagereference('/'+stid);
        pg.setRedirect(true);
        return pg;        
    }    
}