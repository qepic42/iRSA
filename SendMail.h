//
//  SendMail.h
//  iRSA
//
//  Created by Jan Galler on 22.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SendMail : NSObject {

}

+(void)sendEMailMessageWith:(NSString *)content targetAddress:(NSString *)targetMailAdress from:(NSString *)mailSender and:(NSString *)publicKey;

@end
