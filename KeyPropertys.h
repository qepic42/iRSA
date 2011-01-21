//
//  KeyPropertys.h
//  iRSA
//
//  Created by Jan Galler on 17.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KeyPropertys : NSObject {
	NSString *keyIdentifier; 
	NSString *privateKey;
	NSString *publicKey;
	NSData *privateKeyData;
	NSData *publicKeyData;
}

@property(nonatomic,retain)NSString *keyIdentifier;
@property(nonatomic,retain)NSString *privateKey;
@property(nonatomic,retain)NSString *publicKey;
@property(nonatomic,retain)NSData *privateKeyData;
@property(nonatomic,retain)NSData *publicKeyData;

+ (id)keyItem;
+ (id)keyItemWithData:(NSString*)identifier:(NSString *)publicKeyData: (NSString *)privateKeyData:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData;
- (id)initKeyItemWithData:(NSString*)identifier:(NSString *)publicKeyData: (NSString *)privateKeyData:(NSData *)publicKeyNSData: (NSData *)privateKeyNSData;
- (void)setupInstanceVariables;

@end
