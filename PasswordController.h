//
//  PasswordController.h
//  iRSA
//
//  Created by Jan Galler on 24.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PasswordController : NSObject {
	NSData *symetricKeyData;
	NSString *symetricKey;
}

@property(nonatomic,retain)NSData *symetricKeyData;
@property(nonatomic,retain)NSString *symetricKey;

+(void)removePrivateKeyFromKeychains:(NSString *)identifier;
+(void)addPrivateKeyToKeychains:(NSString *)privateKey:(NSString *)identifier;
+(NSString *)getPrivateKeyFromKeychains:(NSString *)identifier;
+(void)renameIdentifierOfPrivateKeyFromKeychains:(NSString *)oldIdentifier :(NSString *)newIdentifier;

@end
