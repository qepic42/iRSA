//
//  AddressBookController.m
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "AddressBookController.h"
#import <AddressBook/AddressBook.h>
#import "ContactPropertys.h"

@implementation AddressBookController

- (id) init{
	self = [super init];
	if (self != nil) {
		book = [ABAddressBook sharedAddressBook];
		
	//	NSArray *everyone = [book people];
		
	//	ABPerson *person;
/*		
		for(person in everyone){
			if ([person valueForProperty:kABFirstNameProperty] != nil) {
				NSLog(@"Vorname: %@", [person valueForProperty:kABFirstNameProperty] );
				NSLog(@"Nachname: %@", [person valueForProperty:kABLastNameProperty] );
				NSLog(@"Mail: %@", [person valueForProperty:kABEmailProperty] );

			}
		}
	*/	
		
	}
	return self;
}


- (void) dealloc
{
	[contactPropertys release];
	[super dealloc];
}


+(NSString *)returnOwnMailAddress{
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	ABPerson *me = [book me];
	ABMultiValue *test = [me valueForProperty:kABEmailProperty];
	NSString *mailAddress = [test valueForIdentifier:[test primaryIdentifier]];
	return mailAddress;
}

+(NSMutableArray *)returnAllPeople{
	NSMutableArray *allPeople = [[[NSMutableArray alloc]init]autorelease];
	
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	NSArray *everyone = [book people];
	ABPerson *person;
	
	for(person in everyone){
		if ([person valueForProperty:kABFirstNameProperty] != nil) {
			ContactPropertys *contactPropertys = [[ContactPropertys alloc]init];
			contactPropertys.contactVorname = [person valueForProperty:kABFirstNameProperty];
			contactPropertys.contactNachname =  [person valueForProperty:kABLastNameProperty];
			contactPropertys.contactMainMailAddress = [[person valueForProperty:kABEmailProperty] valueForIdentifier:[[person valueForProperty:kABEmailProperty] primaryIdentifier]];
			[allPeople addObject:contactPropertys];
		}
	}
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"contactVorname"
												  ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	NSArray *allPeopleNormal = [NSArray arrayWithArray:allPeople];
	sortedArray = [allPeopleNormal sortedArrayUsingDescriptors:sortDescriptors];
	
	NSMutableArray *resultArray = [NSMutableArray arrayWithArray:sortedArray];
	
	return resultArray;
}

+(NSString *)returnMainMailAddressForPerson:(NSString *)numberAsString{
	NSString *mainMailAddress = @"";
/*	
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	NSArray *everyone = [book people];
	ABPerson *person = [everyone objectAtIndex:[numberAsString integerValue]];
	
	NSLog(@"person: %@",numberAsString);
	
	ABMultiValue *test = [person valueForProperty:kABEmailProperty];
	mainMailAddress = [test valueForIdentifier:[test primaryIdentifier]];
	
	NSLog(@"mail: %@",mainMailAddress);
*/	
	
	NSMutableArray *allPeople = [[[NSMutableArray alloc]init]autorelease];
	
	ABAddressBook *book = [ABAddressBook sharedAddressBook];
	NSArray *everyone = [book people];
	ABPerson *person;
	
	for(person in everyone){
		if ([person valueForProperty:kABFirstNameProperty] != nil) {
			ContactPropertys *contactPropertys = [[ContactPropertys alloc]init];
			contactPropertys.contactVorname = [person valueForProperty:kABFirstNameProperty];
			contactPropertys.contactNachname =  [person valueForProperty:kABLastNameProperty];
			contactPropertys.contactMainMailAddress = [[person valueForProperty:kABEmailProperty] valueForIdentifier:[[person valueForProperty:kABEmailProperty] primaryIdentifier]];
			[allPeople addObject:contactPropertys];
		}
	}
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"contactVorname"
												  ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	NSArray *allPeopleNormal = [NSArray arrayWithArray:allPeople];
	sortedArray = [allPeopleNormal sortedArrayUsingDescriptors:sortDescriptors];
	
	NSMutableArray *resultArray = [NSMutableArray arrayWithArray:sortedArray];
	
	ContactPropertys *contactProperyts = [resultArray objectAtIndex:[numberAsString intValue]];
	mainMailAddress = contactProperyts.contactMainMailAddress;
	
	return mainMailAddress;
}

@end
