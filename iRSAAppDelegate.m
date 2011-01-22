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
		/*
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		// Das Standard-Einstellungen-Objekt für dieses Programm vom System holen
		NSData* archive = [defaults objectForKey:@"keyDataArray"];
		// Das Array abholen, in Form eines NSData-Objekts
		if (archive) {
			NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
			// Das NSData-Objekt "entpacken"
			self.keyDataArray = [NSMutableArray arrayWithArray:array];
			// Das so entstandene NSArray in ein NSMutableArray umwandeln
		} else {
			self.keyDataArray = [NSMutableArray array];
		}
		*/
	}
	
	return self;
}

- (void) dealloc{
	[self.keyDataArray release];
	[super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 

	[window center];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.keyDataArray];
	[defaults setObject:data forKey:@"keyDataArray"];
}


#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.keyDataArray forKey:@"keyDataArray"];
}

- (id) initWithCoder:(NSCoder*)decoder {
    if (self = [super init]) {
		[super initWithCoder:decoder];
		self.keyDataArray = [[NSMutableArray alloc]init];
		self.keyDataArray = [[decoder decodeObjectForKey:@"keyDataArray"] retain];
    }
	
    return self;
}


@end
