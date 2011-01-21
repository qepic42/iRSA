//
//  EncodeBySSCrypto.m
//  iRSA
//
//  Created by Jan Galler on 20.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "CryptBySSCrypto.h"
#import <SSCrypto/SSCrypto.h>

@implementation CryptBySSCrypto

+(NSDictionary *)encodeByRSAWithData:(NSString *)clearText:(NSData *)publicKey{
	
	SSCrypto *crypto;
	crypto = [[SSCrypto alloc] initWithPublicKey:publicKey];
	
	NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding];
	
	[crypto setClearTextWithData:data];
	NSData *encryptedData = [crypto encrypt];
	NSString *encryptedString = [encryptedData encodeBase64];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:encryptedData,@"encryptedData",encryptedString,@"encryptedString",nil];
	NSLog(@"encryptedString: %@",encryptedString);
	return dict;
	[crypto release];
}

+(NSDictionary *)decodeByRSAWithData:(NSData *)encodedText:(NSData *)privateKey{
	
	SSCrypto *crypto;
	crypto = [[SSCrypto alloc] initWithPrivateKey:privateKey];
	
	[crypto setCipherText:encodedText];
	NSData *decryptedData = [crypto decrypt];
	NSString *decryptedString = [decryptedData encodeBase64];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:decryptedData,@"decryptedData",decryptedString,@"decryptedString",nil];
	NSLog(@"decryptedString: %@",decryptedString);
	return dict;
	[crypto release];
}


@end
