//
//  KeyPropertys.m
//  iRSA
//
//  Created by Jan Galler on 17.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyPropertys.h"
#import "iRSAAppDelegate.h"
#import "PasswordController.h"
#import "CryptBySSCrypto.h"

@implementation KeyPropertys
@synthesize keyIdentifier, privateKey, publicKey, privateKeyData, publicKeyData, keyPerson;

- (void) dealloc{
	[keyPerson release];
	[pwController release];
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

+ (id)keyItemWithData:(NSString*)identifier:(NSString *)publicKeyData: (NSString *)privateKeyData:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData: (NSString *)person {
	return [[[KeyPropertys alloc] initKeyItemWithData:identifier :publicKeyData :privateKeyData :publicKeyNSData :privateKeyNSData :person]autorelease];
}

- (void)setupInstanceVariables {
	
}

- (id) init {
	self = [super init];
	if (self != nil) {
		[self setupInstanceVariables];
		pwController = [[PasswordController alloc]init];
	}
	return self;
}
																		 
- (id)initKeyItemWithData:(NSString*)identifier:(NSString *)publicKeyString: (NSString *)privateKeyString:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData: (NSString *)person;
{
	self = [super init];
	if (self != nil) {
		[self setupInstanceVariables];
		self.publicKey = publicKeyString;
		self.privateKey = privateKeyString;
		self.keyIdentifier = identifier;
		self.publicKeyData = publicKeyNSData;
		self.privateKeyData = privateKeyNSData;
		self.keyPerson = person;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
	NSLog(@"set: %@",self.keyPerson);
	[encoder encodeObject:self.keyIdentifier forKey:@"keyIdentifier"];
	[self setPrivateKeyToKeychain:self.privateKey :self.keyIdentifier];
	//[encoder encodeObject:self.privateKey forKey:@"privateKey"];
	//[encoder encodeObject:self.privateKeyData forKey:@"privateKeyData"];
	[encoder encodeObject:self.publicKey forKey:@"publicKey"];
	[encoder encodeObject:self.publicKeyData forKey:@"publicKeyData"];
	[encoder encodeObject:self.keyPerson forKey:@"keyPerson"];}

-(id)initWithCoder:(NSCoder *)decoder{
	
	self = [super init];
	if (self != nil) {
		self.keyIdentifier = [decoder decodeObjectForKey:@"keyIdentifier"];
	//	self.privateKey = [decoder decodeObjectForKey:@"privateKey"];
		NSDictionary *dict = [self getPrivateKeyFromKeychain:self.keyIdentifier];
		self.privateKeyData = [dict objectForKey:@"privateKeyData"];
		self.privateKey = [dict objectForKey:@"privateKey"];
		//self.privateKeyData = [decoder decodeObjectForKey:@"privateKeyData"];
		self.publicKey = [decoder decodeObjectForKey:@"publicKey"];
		self.publicKeyData = [decoder decodeObjectForKey:@"publicKeyData"];
		self.keyPerson = [decoder decodeObjectForKey:@"keyPerson"];
		NSLog(@"get: %@",self.keyPerson);
	}
	return self;
}


-(NSDictionary *)getPrivateKeyFromKeychain:(NSString *)identifier{
	NSString *privateKeyParamter = [PasswordController getPrivateKeyFromKeychains:identifier ];
	NSData *data = [privateKeyParamter dataUsingEncoding:NSUTF8StringEncoding];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:privateKeyParamter,@"privateKey",data,@"privateKeyData",nil];
	
	return dict;
}

-(void)setPrivateKeyToKeychain:(NSString *)privateKeyParameter :(NSString *)identfier{
	[PasswordController addPrivateKeyToKeychains:privateKeyParameter :identfier];
}


@end
