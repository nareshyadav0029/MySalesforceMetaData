global class EmailService implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          EmailService__c service = new EmailService__c();
          service.Firstname__c = email.fromname.substring(0,email.fromname.indexOf(' '));
          service.Lastname__c = email.fromname.substring(email.fromname.indexOf(' '));
          service.FromAddress__c = email.fromAddress;
          service.Body__c = email.htmlBody;
          service.Subject__c = email.subject;
          insert service;
          
          List<Attachment> att = new List<Attachment>();
          if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                      for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                        Attachment attachment = new Attachment();
                        // attach to the newly created contact record
                        attachment.ParentId = service.Id;
                        attachment.Name = email.binaryAttachments[i].filename;
                        attachment.Body = email.binaryAttachments[i].body;
                        att.add(attachment);
                      }
                }
                insert att;
          
          return result;
      }
  }