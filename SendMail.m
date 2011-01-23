//
//  SendMail.m
//  iRSA
//
//  Created by Jan Galler on 22.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "SendMail.h"
#import "Mail.h"

@implementation SendMail

+(void)sendEMailMessageWith:(NSString *)content targetAddress:(NSString *)targetMailAdress from:(NSString *)mailSender and:(NSString *)publicKey{
	
	MailApplication *mail = [SBApplication
							 applicationWithBundleIdentifier:@"com.apple.Mail"];
	
	MailOutgoingMessage *emailMessage =
	[[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties: [NSDictionary dictionaryWithObjectsAndKeys:
	  publicKey, @"subject", content, @"content", nil]];
	[[mail outgoingMessages] addObject: emailMessage];
	
	emailMessage.sender = mailSender;
    emailMessage.visible = YES;
	
	MailToRecipient *theRecipient =
	[[[mail classForScriptingClass:@"to recipient"] alloc] initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
	  targetMailAdress, @"address",nil]];
    [emailMessage.toRecipients addObject: theRecipient];
	
	[emailMessage send];
	[emailMessage release];
	[theRecipient release];
}

/*
- (IBAction)sendEmailMessage:(id)sender {
	
	/* create a Scripting Bridge object for talking to the Mail application */
//    MailApplication *mail = [SBApplication
		//					 applicationWithBundleIdentifier:@"com.apple.Mail"];
    
	/* create a new outgoing message object */
  //  MailOutgoingMessage *emailMessage =
	//[[[mail classForScriptingClass:@"outgoing message"] alloc]
//	 initWithProperties:
//[NSDictionary dictionaryWithObjectsAndKeys:
//	  [self.subjectField stringValue], @"subject",
//	  [[self.messageContent textStorage] string], @"content",
//	  nil]];
	
	/* add the object to the mail app  */
//    [[mail outgoingMessages] addObject: emailMessage];
    
	/* set the sender, show the message */
//    emailMessage.sender = [self.fromField stringValue];
//    emailMessage.visible = YES;
	
	/* create a new recipient and add it to the recipients list */
 //   MailToRecipient *theRecipient =
//	[[[mail classForScriptingClass:@"to recipient"] alloc]
//	 initWithProperties:
//	 [NSDictionary dictionaryWithObjectsAndKeys:
//	  [self.toField stringValue], @"address",
//	  nil]];
//    [emailMessage.toRecipients addObject: theRecipient];
    
	/* add an attachment, if one was specified */
//    NSString *attachmentFilePath = [self.fileAttachmentField stringValue];
 //   if ( [attachmentFilePath length] > 0 ) {
		
		/* create an attachment object */
   //     MailAttachment *theAttachment = [[[mail
	//									   classForScriptingClass:@"attachment"] alloc]
	//									 initWithProperties:
	//									 [NSDictionary dictionaryWithObjectsAndKeys:
							//			  attachmentFilePath, @"fileName",
							// 			  nil]];
		
		/* add it to the list of attachments */
    //    [[emailMessage.content attachments] addObject: theAttachment];
  //  }
	/* send the message */
   // [emailMessage send];
//}
//*/

@end
