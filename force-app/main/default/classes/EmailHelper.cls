public class EmailHelper {
    
    public static boolean sendMail(String subject,String body,String ToAddress)
    {
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.toAddresses = new String[] {ToAddress};
        msg.subject = subject;
        msg.htmlBody=body;
        Messaging.SingleEmailMessage[] msgs = new Messaging.SingleEmailMessage[]{msg};
        Messaging.SendEmailResult[] result = Messaging.sendEmail(msgs);
        if(result[0].Success)
            return true;
        
        else
            return false;
        
        
        
        
        
    }
    
}