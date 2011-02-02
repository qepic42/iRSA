//
//  PasswordController.m
//  iRSA
//
//  Created by Jan Galler on 24.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "PasswordController.h"
#import "CryptBySSCrypto.h"
#import "EMKeychainItem.h"

@implementation PasswordController
@synthesize symetricKeyData, symetricKey;

- (id) init{
	self = [super init];
	if (self != nil) {
		
		[EMInternetKeychainItem unlockKeychain];
		EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:@"iRSA" withUsername:@"aes256-key" path:@"/" port:128 protocol:kSecProtocolTypeFTP];
		
		if (keychainItem.password == nil){
			NSDictionary *dict = [CryptBySSCrypto generateSymetricKeyWith:[NSNumber numberWithInt:128]];
			self.symetricKey = [dict objectForKey:@"symetricKey"];
			[EMInternetKeychainItem addInternetKeychainItemForServer:@"iRSA" withUsername:@"aes256-key" password:self.symetricKey path:@"/" port:128 protocol:kSecProtocolTypeFTP];
		}else {
			self.symetricKey = keychainItem.password;
		}

		
	}
	return self;
}


+(void)addPrivateKeyToKeychains:(NSString *)privateKey:(NSString *)identifier{
	//[EMInternetKeychainItem unlockKeychain];
	EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:identifier path:@"/" port:42 protocol:kSecProtocolTypeSSH];
	
	if (keychainItem.password == nil) {
		[EMInternetKeychainItem addInternetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:identifier password:privateKey path:@"/" port:42 protocol:kSecProtocolTypeSSH];	
	}else if ([keychainItem.password isEqualToString:privateKey]){
	}
	
}

+(NSString *)getPrivateKeyFromKeychains:(NSString *)identifier{
	//[EMInternetKeychainItem unlockKeychain];
	EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:identifier path:@"/" port:42 protocol:kSecProtocolTypeSSH];	
	NSString *privateKey = keychainItem.password;
	return privateKey;
}

+(void)removePrivateKeyFromKeychains:(NSString *)identifier{
	//[EMInternetKeychainItem unlockKeychain];
	EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:identifier path:@"/" port:42 protocol:kSecProtocolTypeSSH];
	[keychainItem removeFromKeychain];
	
}

+(void)renameIdentifierOfPrivateKeyFromKeychains:(NSString *)oldIdentifier :(NSString *)newIdentifier{
	EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:oldIdentifier path:@"/" port:42 protocol:kSecProtocolTypeSSH];
	NSString *privateKey = keychainItem.password;
	[keychainItem removeFromKeychain];
	[EMInternetKeychainItem addInternetKeychainItemForServer:@"iRSA-PrivateKey" withUsername:newIdentifier password:privateKey path:@"/" port:42 protocol:kSecProtocolTypeSSH];
}

- (void) dealloc{
	[symetricKey release];
	[symetricKeyData release];
	[super dealloc];
}


@end
