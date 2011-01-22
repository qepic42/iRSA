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
	NSMutableArray *keyDataArray;
}

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain)NSMutableArray *keyDataArray;


@end
