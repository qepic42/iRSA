//
//  iRSAAppDelegate.m
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "iRSAAppDelegate.h"
#import "AddressBookController.h"

@implementation iRSAAppDelegate
@synthesize window, internalKeyArray, externalKeyArray;

- (id) init{
	self = [super init];
	
	if (self != nil) {
		self.internalKeyArray = [[NSMutableArray alloc]init];
		self.externalKeyArray = [[NSMutableArray alloc]init];
		[self setupUserDefaults];
		[[AddressBookController alloc]init];
	}
	
	return self;
}

- (void) dealloc{
	[internalData release];
	[externalData release];
	[self.internalKeyArray release];
	[self.externalKeyArray release];
	[super dealloc];
}

-(void)setupUserDefaults{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	BOOL clear = [prefs boolForKey:@"clearTextByModeChange"];
	
	if (clear != YES && clear != NO){
		[prefs setBool:YES forKey:@"clearTextByModeChange"];
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	// Begin internal
	
	self.internalKeyArray = [[NSMutableArray alloc]init];
	
	NSData *internalArchive = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile:NO]];
	
	if (internalArchive) {
		NSArray* internalCacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:internalArchive];
		self.internalKeyArray = [NSMutableArray arrayWithArray:internalCacheArray];
	} else {
		self.internalKeyArray = [NSMutableArray array];
	}
	
	// Continue external
	
	self.externalKeyArray = [[NSMutableArray alloc]init];
	
	NSData *externalArchive = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile:YES]];
	
	if (externalArchive) {
		NSArray* externalCacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:externalArchive];
		self.externalKeyArray = [NSMutableArray arrayWithArray:externalCacheArray];
	} else {
		self.externalKeyArray = [NSMutableArray array];
	}
	
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"itemCountChanged" object:nil userInfo:nil];
		
	[window center];
}

- (void)applicationWillTerminate:(NSNotification *)notification{
	NSData *internalArchive = [NSKeyedArchiver archivedDataWithRootObject:self.internalKeyArray];
	[NSKeyedArchiver archiveRootObject:internalArchive toFile:[self pathForDataFile:NO]];
	
	NSData *externalArchive = [NSKeyedArchiver archivedDataWithRootObject:self.externalKeyArray];
	[NSKeyedArchiver archiveRootObject:externalArchive toFile:[self pathForDataFile:YES]];
}

- (NSString *)pathForDataFile:(BOOL)external{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~/Library/Application Support/iRSA/";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	NSString *fileName = @"";
	
    if (external == YES) {
		fileName = @"iRSA_ExternalKeyData.plist";
	}else {
		fileName = @"iRSA_InternalKeyData.plist";
	}

	return [folder stringByAppendingPathComponent: fileName];    
}

#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	internalData = [NSKeyedArchiver archivedDataWithRootObject:self.internalKeyArray];
	[encoder encodeObject:internalData forKey:@"internalData"];
	
	externalData = [NSKeyedArchiver archivedDataWithRootObject:self.externalKeyArray];
	[encoder encodeObject:externalData forKey:@"externalData"];
}

- (id) initWithCoder:(NSCoder*)decoder {
	if (self = [super init]) {
		[super initWithCoder:decoder];
		internalData = [[decoder decodeObjectForKey:@"internalData"] retain];
		self.internalKeyArray = [NSKeyedUnarchiver unarchiveObjectWithData:internalData];
		
		externalData = [[decoder decodeObjectForKey:@"externalData"] retain];
		self.externalKeyArray = [NSKeyedUnarchiver unarchiveObjectWithData:externalData];

    }
	return self;
}


@end
