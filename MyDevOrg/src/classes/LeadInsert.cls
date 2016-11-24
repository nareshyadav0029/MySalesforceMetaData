global class LeadInsert implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          Lead lead = new Lead(); 
          lead.Firstname = email.fromname.substring(0,email.fromname.indexOf(' '));
          lead.Lastname = email.fromname.substring(email.fromname.indexOf(' '));
          lead.Company = email.fromAddress.substring(email.fromAddress.indexOf('@')+1, email.fromAddress.indexOf('.'));
          lead.Email = email.fromAddress;
          lead.Description = email.PlainTextBody;
          lead.LeadSource = email.subject;
          insert lead;

          return result;
      }
  }