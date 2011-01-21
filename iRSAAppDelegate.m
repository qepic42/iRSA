//
//  iRSAAppDelegate.m
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "iRSAAppDelegate.h"

@implementation iRSAAppDelegate
@synthesize window, keyDataArray;

- (id) init{
	self = [super init];
	if (self != nil) {
		self.keyDataArray = [[NSMutableArray alloc]init];
	}
	return self;
}

- (void) dealloc{
	[self.keyDataArray release];
	[super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

@end
