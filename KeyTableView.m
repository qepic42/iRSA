//
//  PublicKeysTableView.m
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "KeyTableView.h"
#import "KeyPropertys.h"
#import "iRSAAppDelegate.h"

@implementation KeyTableView
@synthesize dataArray, myTable;


#pragma mark -
#pragma mark Initialization & Dealloc

- (id) init{
	self = [super init];
	if (self != nil) {
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		myAppDelegate.keyDataArray = [[NSMutableArray alloc]init];
		[myTable setFocusRingType:NSFocusRingTypeNone];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(addItem:)
													 name:@"addNewKey"
												   object:nil];
	}
	return self;
}

-(void)setupPopUpButton{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"itemCountChanged" object:nil userInfo:nil];	
}

- (void) dealloc{
	[keyClass release];
	[myTable release];
	[dataArray release];
	[super dealloc];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)addItem:(NSNotification *)notification{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	[myAppDelegate.keyDataArray addObject:[KeyPropertys keyItemWithData:@"Untitled" :[[notification userInfo]objectForKey:@"publicKey"] :[[notification userInfo]objectForKey:@"privateKey"] :[[notification userInfo]objectForKey:@"publicKeyData"] :[[notification userInfo]objectForKey:@"privateKeyData"]]];
	
	[self setupPopUpButton];
	[self.myTable noteNumberOfRowsChanged];
	
	NSInteger newRowIndex = [myAppDelegate.keyDataArray count]-1;
	[myTable selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex]
		 byExtendingSelection:NO];
	
	[myTable editColumn:[myTable columnWithIdentifier:@"identifier"]
					row:newRowIndex withEvent:nil select:YES];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)pushAddNewKey:(id)sender{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"startKeyGenerate" object:nil userInfo:nil];

	keyClass = [[KeyGenerate alloc]init];
	[keyClass performSelectorInBackground:@selector (generatePublicAndPrivateRSAKey) withObject:nil];

}

- (IBAction)pushRemoveKey:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	[myAppDelegate.keyDataArray removeObjectsAtIndexes:[self.myTable selectedRowIndexes]];
	[self setupPopUpButton];
	[self.myTable noteNumberOfRowsChanged];
}


#pragma mark -
#pragma mark Delegate Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
    return [myAppDelegate.keyDataArray count];
}

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	NSIndexSet *indexes = [myTable selectedRowIndexes];
	if ([indexes count] == 0) {
		[removeButton setEnabled:NO];
	} else {
		[removeButton setEnabled:YES];
	}
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys* item = [myAppDelegate.keyDataArray objectAtIndex:rowIndex];
	
	NSString *returnString;
	
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]){
		returnString = item.keyIdentifier;
	}else if ([[aTableColumn identifier] isEqualToString:@"publicKey"]){
		returnString = item.publicKey;
	}else if ([[aTableColumn identifier] isEqualToString:@"privateKey"]){
		returnString = item.privateKey;
	}
	
	[self setupPopUpButton];
	
	return returnString;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys* item = [myAppDelegate.keyDataArray objectAtIndex:rowIndex];
	[self setupPopUpButton];
	item.keyIdentifier = anObject;
}

@end
