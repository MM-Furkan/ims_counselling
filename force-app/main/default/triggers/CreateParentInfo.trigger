trigger CreateParentInfo on Account (after insert, after update) {
    
    Set<Id> setacccid = new Set<Id>();
    if(Trigger.isInsert){
        for(Account acc: trigger.new){
            setacccid.add(acc.Id);
        } 
        
        List<Account> acclist=[Select id, name, FirstName, MiddleName, LastName, BillingStreet, BillingCity, BillingPostalCode,
                               BillingState, BillingCountry, ShippingStreet, Mailing_City__c,Mailing_Pin_code__c, ShippingCity, ShippingPostalCode, ShippingState,
                               ShippingCountry, Lead_Stage__c ,Parent_Email_Id__c,Permanent_City__c From Account where id In : setacccid];
        system.debug('****** + '+ acclist[0].MiddleName);
        List<Parent_Information__c> insertAccount = new List<Parent_Information__c>();
        for(Account ac:acclist){
            //if(ac.Lead_Stage__c=='Qualified'){
            if(ac.MiddleName!= ''){
                Parent_Information__c pi= new Parent_Information__c();
                pi.Student_Account__c=ac.Id;
                pi.Salutation__c='Mr.';
                pi.Relationship__c='Father';
                pi.First_Name__c=ac.MiddleName;
                //  pi.Middle_Name__c=ac.FirstName;
                pi.Last_Name__c=ac.LastName;
                pi.Parent_Email__c = ac.Parent_Email_Id__c;
                pi.mailing_Street__c=ac.BillingStreet;
                // pi.Mailing_City__c=ac.BillingCity;
                pi.Mailing_City__c=ac.Mailing_City__c;
                //  pi.Mailing_Pincode__c=ac.BillingPostalCode;
                pi.Mailing_Pincode__c=ac.BillingPostalCode;
                pi.mailing_state__c=ac.BillingState;
                pi.mailing_Country__c=ac.BillingCountry;
                pi.Permanent_Street__c=ac.ShippingStreet;
                //    pi.Permanent_City__c=ac.ShippingCity;
                pi.Permanent_Pin_code__c=ac.ShippingPostalCode;
                pi.Permanent_State__c=ac.ShippingState;
                pi.Permanent_Country__c=ac.ShippingCountry;
                pi.Permanent_City__c=ac.Permanent_City__c;
                pi.Mailing_City__c=ac.Mailing_City__c;
                
             //   insertAccount.add(pi);
                //insert pi;
                
            }
            
            //  }
        }
        
        insert insertAccount;
    }
    if(Trigger.isUpdate){
        for(Account acc: trigger.new){
            setacccid.add(acc.Id);
        } 
        
        List<Parent_Information__c> updateAccount = new List<Parent_Information__c>();
        Parent_Information__c pai=[Select id, name, Student_Account__c, Salutation__c, Relationship__c, First_Name__c, Last_Name__c,Parent_Email__c, mailing_Street__c,
                                   Mailing_Pincode__c, mailing_state__c, mailing_Country__c, Permanent_Street__c, Permanent_Pin_code__c,
                                   Permanent_State__c, Permanent_Country__c,Permanent_City__c,Mailing_City__c From Parent_Information__c where Student_Account__c=:setacccid]; 
        //Permanent_City__c,Mailing_City__c
     /*   for(Account act:[Select id, name, FirstName, MiddleName, LastName,Parent_Email_Id__c, BillingStreet, BillingCity, BillingPostalCode,
                         BillingState, BillingCountry, ShippingStreet, Mailing_City__c,Mailing_Pin_code__c, ShippingCity, ShippingPostalCode, ShippingState,
                         ShippingCountry, Lead_Stage__c,Permanent_City__c  From Account where id In : setacccid]){
                             
                             if(act.MiddleName!=''){
                                 Parent_Information__c pi= new Parent_Information__c();
                                 pi.Student_Account__c=act.id;
                                 pi.Id=pai.id;
                                 pi.Salutation__c='Mr.';
                                 pi.Relationship__c='Father';
                                 pi.First_Name__c=act.MiddleName;
                                 // pi.Middle_Name__c=act.FirstName;
                                 pi.Parent_Email__c = act.Parent_Email_Id__c;
                                 pi.Last_Name__c=act.LastName;
                                 pi.mailing_Street__c=act.BillingStreet;
                                 // pi.Mailing_City__c=act.BillingCity;
                                 pi.Mailing_City__c=act.Mailing_City__c;
                                 pi.Mailing_Pincode__c=act.BillingPostalCode;
                                 pi.mailing_state__c=act.BillingState;
                                 pi.mailing_Country__c=act.BillingCountry;
                                 pi.Permanent_Street__c=act.ShippingStreet;
                                 //  pi.Permanent_City__c=act.ShippingCity;
                                 pi.Permanent_Pin_code__c=act.ShippingPostalCode;
                                 pi.Permanent_State__c=act.ShippingState;
                                 pi.Permanent_Country__c=act.ShippingCountry;
                                 pi.Permanent_City__c=act.Permanent_City__c;
                                 //update pi;
                                 
                             //    updateAccount.add(pi);
                             }
                         }*/
        
      //  update updateAccount;
    } 
}