//
//  KeyClass.m
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyGenerate.h"
#import <SSCrypto/SSCrypto.h>

@implementation KeyGenerate

-(void)generatePublicAndPrivateRSAKey{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"startKeyGenerate" object:nil userInfo:nil];
	
	NSDictionary *dict = [self generateKeysBySSCrypto];
		
	NSString *publicKeyString = [[NSString alloc] initWithData:[dict objectForKey:@"publicKeyData"] encoding:NSUTF8StringEncoding];
	NSString *privateKeyString = [[NSString alloc] initWithData:[dict objectForKey:@"privateKeyData"] encoding:NSUTF8StringEncoding];
	
	NSMutableString *publicKeyMutableString = [NSMutableString stringWithCapacity:[publicKeyString length]];
	[publicKeyMutableString setString: publicKeyString];
	NSRange myRange = 
	[publicKeyMutableString rangeOfString:@"-----BEGIN PUBLIC KEY-----"options:NSCaseInsensitiveSearch];
	[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];
	[publicKeyMutableString rangeOfString:@"-----END PUBLIC KEY-----"options:NSCaseInsensitiveSearch];
	[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];
	
	NSMutableString *privateKeyMutableString = [NSMutableString stringWithCapacity:[privateKeyString length]];
	[privateKeyMutableString setString: privateKeyString];
	NSRange myRangePrivate = 
	[privateKeyMutableString rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"options:NSCaseInsensitiveSearch];
	[privateKeyMutableString replaceCharactersInRange:myRangePrivate withString:@""];
	[privateKeyMutableString rangeOfString:@"-----END RSA PRIVATE KEY-----"options:NSCaseInsensitiveSearch];
	[privateKeyMutableString replaceCharactersInRange:myRangePrivate withString:@""];

	NSDictionary *dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"publicKeyData"], @"publicKeyData",[dict objectForKey:@"privateKeyData"], @"privateKeyData", publicKeyMutableString, @"publicKey", privateKeyMutableString, @"privateKey", nil];
	
	[center postNotificationName:@"addNewKey" object:nil userInfo:dictToSend];
	
	[center postNotificationName:@"endKeyGenerate" object:nil userInfo:nil];
	
    [pool release];
}

-(NSDictionary *)generateKeysBySSCrypto{
	
    NSData *privateKeyData = [SSCrypto generateRSAPrivateKeyWithLength:2048];
    NSData *publicKeyData = [SSCrypto generateRSAPublicKeyFromPrivateKey:privateKeyData];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:privateKeyData,@"privateKeyData", publicKeyData,@"publicKeyData",nil];
	
	return dict;
}

- (void) dealloc{
	[super dealloc];
}


@end
