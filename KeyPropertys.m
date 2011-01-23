//
//  KeyPropertys.m
//  iRSA
//
//  Created by Jan Galler on 17.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyPropertys.h"
#import "iRSAAppDelegate.h"

@implementation KeyPropertys
@synthesize keyIdentifier, privateKey, publicKey, privateKeyData, publicKeyData;

- (void) dealloc{
	[publicKeyData release];
	[privateKeyData release];
	[keyIdentifier release];
	[privateKey release];
	[publicKey release];
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization
+ (id)keyItem {
	return [[[KeyPropertys alloc] init] autorelease];
}

+ (id)keyItemWithData:(NSString*)identifier:(NSString *)publicKeyData: (NSString *)privateKeyData:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData; {
	return [[[KeyPropertys alloc] initKeyItemWithData:identifier :publicKeyData :privateKeyData :publicKeyNSData :privateKeyNSData]autorelease];
}

- (void)setupInstanceVariables {
	
}

- (id) init {
	self = [super init];
	if (self != nil) {
		[self setupInstanceVariables];
	}
	return self;
}
																		 
- (id)initKeyItemWithData:(NSString*)identifier:(NSString *)publicKeyString: (NSString *)privateKeyString:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData;
{
	self = [super init];
	if (self != nil) {
		[self setupInstanceVariables];
		self.publicKey = publicKeyString;
		self.privateKey = privateKeyString;
		self.keyIdentifier = identifier;
		self.publicKeyData = publicKeyNSData;
		self.privateKeyData = privateKeyNSData;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:self.keyIdentifier forKey:@"keyIdentifier"];
	[encoder encodeObject:self.privateKey forKey:@"privateKey"];
	[encoder encodeObject:self.privateKeyData forKey:@"privateKeyData"];
	[encoder encodeObject:self.publicKey forKey:@"publicKey"];
	[encoder encodeObject:self.publicKeyData forKey:@"publicKeyData"];
}

-(id)initWithCoder:(NSCoder *)decoder{
	
	self = [super init];
	if (self != nil) {
		self.keyIdentifier = [decoder decodeObjectForKey:@"keyIdentifier"];
		self.privateKey = [decoder decodeObjectForKey:@"privateKey"];
		self.privateKeyData = [decoder decodeObjectForKey:@"privateKeyData"];
		self.publicKey = [decoder decodeObjectForKey:@"publicKey"];
		self.publicKeyData = [decoder decodeObjectForKey:@"publicKeyData"];
	}
	return self;
}

@end
