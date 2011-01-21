//
//  EncodeBySSCrypto.h
//  iRSA
//
//  Created by Jan Galler on 20.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CryptBySSCrypto : NSObject {

}

+(NSDictionary *)encodeByRSAWithData:(NSString *)clearText:(NSData *)publicKey;
+(NSDictionary *)decodeByRSAWithData:(NSData *)encodedText:(NSData *)privateKey;

@end
