public class sendRegistrationEmailStudent {
    
    public Id currentId {get;set;}
    
    public sendRegistrationEmailStudent(){
        currentId = ApexPages.currentPage().getparameters().get('id');
        System.debug('currentId'+currentId);
    }
    
     public PageReference sendEmailData(){
       Account acc=  [SELECT id,name,PersonEmail FROM Account WHERE ID=:currentId];
         
      String p_id =    acc.Id;
         String p_name =    acc.Name;
         String p_email =    acc.PersonEmail;
      // Step 0: Create a master list to hold the emails we'll send
  	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         
      // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(p_email);
      mail.setToAddresses(sendTo);
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo('rohit@finessedirect.com');
      mail.setSenderDisplayName('Official');
    
      // (Optional) Set list of people who should be CC'ed
      //List<String> ccTo = new List<String>();
      //ccTo.add('business@test.com');
      //mail.setCcAddresses(ccTo);

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Student Registrattion');
      String body = 'Dear ' + p_name + ', <br>';
      body += 'Please fill the below details<br>';
	  body += 'id : '+ p_id +' <br>';
      body += 'Thanks';
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);
         
      // Step 6. Send mail
      Messaging.sendEmail(mails);
         
         
        PageReference pageRef = new PageReference('/' + currentId);
        pageRef.setRedirect(true);
        return pageRef;
        // return null;
         
     }

}