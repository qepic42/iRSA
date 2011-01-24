//
//  EncodeBySSCrypto.h
//  iRSA
//
//  Created by Jan Galler on 20.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasswordController.h"

@interface CryptBySSCrypto : NSObject {}

+(NSDictionary *)encodeByRSAWithData:(NSString *)clearText key:(NSData *)publicKey;
+(NSDictionary *)decodeByRSAWithData:(NSData *)encodedText key:(NSData *)privateKey;
+(NSDictionary *)encodePrivateKeyWithData:(NSData *)password key:(NSData *)privateKey;
+(NSDictionary *)decodePrivateKeyWithData:(NSData *)password key:(NSData *)encryptedPrivateKey;
+(NSDictionary *)generateSymetricKeyWith:(NSNumber *)length;


@end
