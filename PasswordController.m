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
	//		NSLog(@"Keychainitem nicht vorhanden");
		}else {
			self.symetricKey = keychainItem.password;
	//		NSLog(@"Keychainitem nicht vorhanden");
		}

		
	}
	return self;
}

- (void) dealloc{
	[symetricKey release];
	[symetricKeyData release];
	[super dealloc];
}


@end
