//
//  iRSAAppDelegate.m
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "iRSAAppDelegate.h"
#import "AGKeychain.h"

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
	
	NSData* archive = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];

	if (archive) {
		NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
		self.keyDataArray = [NSMutableArray arrayWithArray:array];
	} else {
		self.keyDataArray = [NSMutableArray array];
	}
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"itemCountChanged" object:nil userInfo:nil];
	
	[window center];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
	
	NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:self.keyDataArray];
	[NSKeyedArchiver archiveRootObject:archive toFile:[self pathForDataFile]];
}

- (NSString *)pathForDataFile{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~/Library/Application Support/iRSA/";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
	NSString *fileName = @"iRSA_Keys.plist";
	return [folder stringByAppendingPathComponent: fileName];    
}

/*
-(void)saveArray{
	
	BOOL result = [AGKeychain addKeychainItem:[keychainItemNameTextField stringValue] 
								 withItemKind:[keychainItemKindTextField stringValue] 
								  forUsername:[usernameTextField stringValue] 
								 withPassword:[passwordTextField stringValue]];
	
}
*/

#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.keyDataArray];
	[encoder encodeObject:data forKey:@"keyDataArray"];
}

- (id) initWithCoder:(NSCoder*)decoder {
	if (self = [super init]) {
		[super initWithCoder:decoder];
		NSData *data = [[decoder decodeObjectForKey:@"keyDataArray"] retain];
		self.keyDataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    }
	return self;
}


@end
