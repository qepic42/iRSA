//
//  KeyGenerateBySSCrypto.m
//  iRSA
//
//  Created by Jan Galler on 20.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyGenerateBySSCrypto.h"
#import <SSCrypto/SSCrypto.h>

@implementation KeyGenerateBySSCrypto

+(NSDictionary *)generateKeys{

    NSData *privateKeyData = [SSCrypto generateRSAPrivateKeyWithLength:2048];
    NSData *publicKeyData = [SSCrypto generateRSAPublicKeyFromPrivateKey:privateKeyData];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:privateKeyData,@"privateKeyData", publicKeyData,@"publicKeyData",nil];
	
	return dict;
}

@end
