//
//  ContactPropertys.m
//  iRSA
//
//  Created by Jan Galler on 03.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "ContactPropertys.h"


@implementation ContactPropertys
@synthesize contactVorname, contactNachname, contactMainMailAddress, contactPublicKey;

- (void) dealloc{
	[self.contactVorname release];
	[self.contactNachname release];
	[self.contactMainMailAddress release];
	[self.contactPublicKey release];
	[super dealloc];
}


@end
