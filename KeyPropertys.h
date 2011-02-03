//
//  KeyPropertys.h
//  iRSA
//
//  Created by Jan Galler on 17.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasswordController.h"

@interface KeyPropertys : NSObject <NSCoding> {
	NSString *keyIdentifier; 
	NSString *privateKey;
	NSString *publicKey;
	NSString *keyPerson;
	NSString *keyBit;
	NSData *privateKeyData;
	NSData *publicKeyData;
	
	PasswordController *pwController;
}

@property(nonatomic,retain)NSString *keyIdentifier;
@property(nonatomic,retain)NSString *privateKey;
@property(nonatomic,retain)NSString *publicKey;
@property(nonatomic,retain)NSString *keyPerson;
@property(nonatomic,retain)NSData *privateKeyData;
@property(nonatomic,retain)NSData *publicKeyData;

+ (id)keyItem;
+ (id)keyItemWithData:(NSString*)identifier:(NSString *)publicKeyData: (NSString *)privateKeyData:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData: (NSString *)person;
- (id)initKeyItemWithData:(NSString*)identifier:(NSString *)publicKeyString: (NSString *)privateKeyString:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData: (NSString *)person;
- (void)setupInstanceVariables;

-(NSDictionary *)getPrivateKeyFromKeychain:(NSString *)identifier;
-(void)setPrivateKeyToKeychain:(NSString *)privateKeyParameter :(NSString *)identfier;

@end
