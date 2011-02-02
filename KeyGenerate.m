//
//  KeyClass.m
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyGenerate.h"
#import <SSCrypto/SSCrypto.h>
#import "PasswordController.h"

@implementation KeyGenerate

- (void)generatePublicAndPrivateRSAKeyWithPrivatKeyLength:(NSNumber *)privateKeyLength{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"startKeyGenerate" object:nil userInfo:nil];
	
	NSDictionary *dict = [self generateKeys:privateKeyLength];
	
	NSString *publicKeyString = [[NSString alloc] initWithData:[dict objectForKey:@"publicKeyData"] encoding:NSUTF8StringEncoding];
	
	NSString *privateKeyString = [dict objectForKey:@"privateKeyString"];
	
	NSDictionary *dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:@"internal",@"mode",[dict objectForKey:@"publicKeyData"], @"publicKeyData",[dict objectForKey:@"privateKeyData"], @"privateKeyData", publicKeyString, @"publicKey", privateKeyString, @"privateKey", nil];
	
	[center postNotificationName:@"addNewKey" object:nil userInfo:dictToSend];
	[center postNotificationName:@"endKeyGenerate" object:nil userInfo:nil];
	
	[publicKeyString release];
    [pool release];
}

-(NSDictionary *)generateKeys:(NSNumber *)keyLenght{
	
	//PasswordController *pwController = [[PasswordController alloc]init];
	
//	SSCrypto *crypto;
	
	NSData *privateKeyData = [SSCrypto generateRSAPrivateKeyWithLength:[keyLenght intValue]];
	NSData *publicKeyData = [SSCrypto generateRSAPublicKeyFromPrivateKey:privateKeyData];
	
	NSString *privateKeyString = [[NSString alloc]initWithData:privateKeyData encoding:NSUTF8StringEncoding];
	/*
	crypto = [[SSCrypto alloc] initWithSymmetricKey:[pwController.symetricKey dataUsingEncoding:NSUTF8StringEncoding]];
	
	[crypto setClearTextWithString:privateKeyString];
	
	NSData *cipherText = [crypto encrypt:@"aes256"];
	
	NSString *test = [cipherText encodeBase64];
	*/
	 
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:privateKeyString, @"privateKeyString", privateKeyData,@"privateKeyData", publicKeyData,@"publicKeyData",nil];
	
//	[pwController release];
	[privateKeyString release];
	//[crypto release];	
	
	return dict;
}


- (void) dealloc{
	[super dealloc];
}


@end
