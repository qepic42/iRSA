//
//  iRSAAppDelegate.h
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iRSAAppDelegate : NSObject <NSApplicationDelegate,NSCoding> {
    NSWindow *window;
	NSMutableArray *internalKeyArray;
	NSMutableArray *externalKeyArray;
	NSData *internalData;
	NSData *externalData;
}

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain)NSMutableArray *internalKeyArray;
@property(nonatomic,retain)NSMutableArray *externalKeyArray;

-(NSString *)pathForDataFile:(BOOL)external;
-(void)setupUserDefaults;

@end
