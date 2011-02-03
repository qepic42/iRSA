//
//  ContactPropertys.h
//  iRSA
//
//  Created by Jan Galler on 03.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ContactPropertys : NSObject {
	NSString *contactVorname;
	NSString *contactNachname;
	NSString *contactMainMailAddress;
	NSString *contactPublicKey;
}

@property(nonatomic,retain)NSString *contactVorname;
@property(nonatomic,retain)NSString *contactNachname;
@property(nonatomic,retain)NSString *contactMainMailAddress;
@property(nonatomic,retain)NSString *contactPublicKey;

@end
