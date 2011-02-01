//
//  EncodeBySSCrypto.m
//  iRSA
//
//  Created by Jan Galler on 20.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "CryptBySSCrypto.h"
#import <SSCrypto/SSCrypto.h>
#import "PasswordController.h"

@implementation CryptBySSCrypto

+(NSDictionary *)encodeByRSAWithData:(NSString *)clearText key:(NSData *)publicKey{
	
	SSCrypto *crypto;
	
	crypto = [[SSCrypto alloc] initWithPublicKey:publicKey];
	
	NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding];
	
	[crypto setClearTextWithData:data];
	NSData *encryptedData = [crypto encrypt];
	NSString *encryptedString = [encryptedData encodeBase64];
	
	if (clearText != nil) {
		if (encryptedData == nil) {
			NSException *e = [[NSException alloc]initWithName:@"Encode fails!" reason:@"Data too large for key size!" userInfo:nil];
			@throw e;
		}
	}
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:encryptedData,@"encryptedData",encryptedString,@"encryptedString",nil];

	[crypto release];
	return dict;
}

+(NSDictionary *)decodeByRSAWithData:(NSData *)encodedText key:(NSData *)privateKey{
	
	SSCrypto *crypto;
	
	// Now let RSA working
	crypto = [[SSCrypto alloc] initWithPrivateKey:privateKey];
	
	[crypto setCipherText:encodedText];
	NSData *decryptedData = [crypto decrypt];
	NSString *decryptedString = [decryptedData encodeBase64];
	
	if (encodedText != nil) {
		if (decryptedData == nil) {
			NSException *e = [[NSException alloc]initWithName:@"Decode fails!" reason:@"No symmetric key or private key is set!" userInfo:nil];
			@throw e;
		}
	}
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:decryptedData,@"decryptedData",decryptedString,@"decryptedString", nil];
	
	[crypto release];
	
	return dict;
}

/* Old using aes256
+(NSDictionary *)decodeByRSAWithData:(NSData *)encodedText key:(NSData *)privateKey{
	
	SSCrypto *crypto;
	PasswordController	*pwController = [[PasswordController alloc]init];
	
	// Decrypt privateKey
	crypto = [[SSCrypto alloc] initWithSymmetricKey:[pwController.symetricKey dataUsingEncoding:NSUTF8StringEncoding]];
	
	[crypto setCipherText:privateKey];
	
	NSData *clearText = [crypto decrypt:@"aes256"];
	
	NSString *decryptedPrivateKey = [[NSString alloc] initWithData:clearText encoding:NSUTF8StringEncoding];
	
	[crypto release];
	
	
	// Now let RSA working
	crypto = [[SSCrypto alloc] initWithPrivateKey:clearText];
	
	[crypto setCipherText:encodedText];
	NSData *decryptedData = [crypto decrypt];
	NSString *decryptedString = [decryptedData encodeBase64];
	
	if (encodedText != nil) {
		if (decryptedData == nil) {
			NSException *e = [[NSException alloc]initWithName:@"Decode fails!" reason:@"No symmetric key or private key is set!" userInfo:nil];
			@throw e;
		}
	}
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:decryptedData,@"decryptedData",decryptedString,@"decryptedString", nil];

	[decryptedPrivateKey release];
	[crypto release];
	[pwController release];
	
	return dict;
}
 */

+(NSDictionary *)encodePrivateKeyWithData:(NSData *)password key:(NSData *)privateKey{
	
	SSCrypto *crypto;
	crypto = [[SSCrypto alloc] initWithSymmetricKey:password];
	
	[crypto setClearTextWithData:privateKey];
	NSData *encryptedData = [crypto encrypt:@"aes256"];
	NSString *encryptedString = [encryptedData encodeBase64];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:encryptedData, @"encryptedPrivateKey", encryptedString, @"encryptedString",nil];
	
	[crypto release];
	return dict;
}

+(NSDictionary *)decodePrivateKeyWithData:(NSData *)password key:(NSData *)encryptedPrivateKey{
	
	SSCrypto *crypto;
	crypto = [[SSCrypto alloc] initWithSymmetricKey:password];
	
	[crypto setCipherText:encryptedPrivateKey];
	NSData *decryptedData = [crypto decrypt:@"aes256"];
	NSString *decryptedString = [decryptedData encodeBase64];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:decryptedData, @"decryptedPrivateKey", decryptedString, @"decryptedString",nil];
	
	[crypto release];
	return dict;
	
}

+(NSDictionary *)generateSymetricKeyWith:(NSNumber *)length{

	NSData *symetricKeyData = [SSCrypto getKeyDataWithLength:[length intValue]];
	
	NSString *symetricKey = [symetricKeyData encodeBase64];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:symetricKeyData, @"symetricKeyData", symetricKey, @"symetricKey", nil];
	
	return dict;
}


@end
