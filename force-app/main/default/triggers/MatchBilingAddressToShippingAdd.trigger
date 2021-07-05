trigger MatchBilingAddressToShippingAdd on Account (before insert ,before update) {
    
    for(Account ac : Trigger.new){
        
        if( ac.Copy_Mailing_To_Permanent_Address__c ==true)  {
            ac.ShippingCountry = ac.BillingCountry;
            ac.ShippingStreet = ac.BillingStreet;
            ac.ShippingCity = ac.BillingCity;
            ac.ShippingState = ac.BillingState;
            ac.ShippingPostalCode = ac.BillingPostalCode;
            ac.Permanent_City__c  =  ac.Mailing_City__c;
            
        }
    }
}