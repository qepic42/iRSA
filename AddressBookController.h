//
//  AddressBookController.h
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>
#import "ContactPropertys.h"

@interface AddressBookController : NSObject {
	ABAddressBook *book;
	ContactPropertys *contactPropertys;
}

+(NSString *)returnOwnMailAddress;
+(NSMutableArray *)returnAllPeople;
+(NSString *)returnMainMailAddressForPerson:(NSString *)numberAsString;

@end
