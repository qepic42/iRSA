//
//  InternalKeyTable.m
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "InternalKeyTable.h"
#import "iRSAAppDelegate.h"
#import "KeyPropertys.h"
#import "PasswordController.h"

@implementation InternalKeyTable

#pragma mark -
#pragma mark Initialization Methods

- (id) init{
	self = [super init];
	if (self != nil) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(addItem:)
													 name:@"addNewKey"
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(reloadTable)
													 name:@"reloadInternalTable"
												   object:nil];
		
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		myAppDelegate.internalKeyArray = [[NSMutableArray alloc]init];
		
	}
	return self;
}


- (void)awakeFromNib{
	[myTable setTarget:self];
	[myTable setDoubleAction:@selector(doubleClickToRow:)];
	[removeButton setEnabled:NO];
}


#pragma mark -
#pragma mark Other Methods

-(void)doubleClickToRow:(NSTableView *)sender{
	if ([sender clickedColumn] == 2){
		
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		KeyPropertys* item = [myAppDelegate.internalKeyArray objectAtIndex:[sender clickedRow]];
		//[infoBox setTitle:item.keyIdentifier];
		[infoBoxExternLabel setStringValue:item.keyIdentifier];
		[publicKeyView setString:item.publicKey];
		
		[NSApp beginSheet:keyInfoSheet modalForWindow:mainKeyWindow modalDelegate:self didEndSelector:nil contextInfo:@""];
	}
}

-(void)setupKeyPopUpButton{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"itemCountChanged" object:nil userInfo:nil];	
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)addItem:(NSNotification *)notification{
	
	if ([[[notification userInfo]objectForKey:@"mode"] isEqualToString:@"internal"]) {
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		
		[myAppDelegate.internalKeyArray addObject:[KeyPropertys keyItemWithData:@"untitled" :[[notification userInfo]objectForKey:@"publicKey"] :[[notification userInfo]objectForKey:@"privateKey"] :[[notification userInfo]objectForKey:@"publicKeyData"] :[[notification userInfo]objectForKey:@"privateKeyData"]: @"0"]];
		
		[self setupKeyPopUpButton];
		[myTable noteNumberOfRowsChanged];
		
		NSInteger newRowIndex = [myAppDelegate.internalKeyArray count]-1;
		[myTable selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex]
			 byExtendingSelection:NO];
		
//		[myTable editColumn:[myTable columnWithIdentifier:@"identifier"]
//						row:newRowIndex withEvent: select:YES];
	}
	
}

-(void)reloadTable{
	[myTable reloadData];	
}


#pragma mark -
#pragma mark IBActions

- (IBAction)pushRemoveKey:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys *item = [myAppDelegate.internalKeyArray objectAtIndex:[myTable selectedRow]];
	[PasswordController removePrivateKeyFromKeychains:item.keyIdentifier];
	[myAppDelegate.internalKeyArray removeObjectAtIndex:[myTable selectedRow]];
	[self setupKeyPopUpButton];
	[myTable noteNumberOfRowsChanged];
}


#pragma mark -
#pragma mark Delegate Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	NSInteger returnInteger = [myAppDelegate.internalKeyArray count];
	
    return returnInteger;
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
	KeyPropertys* item = [myAppDelegate.internalKeyArray objectAtIndex:rowIndex];
	
	NSString *returnString;
	
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]){
		returnString = item.keyIdentifier;
	}else if ([[aTableColumn identifier] isEqualToString:@"publicKey"]){
		returnString = item.publicKey;
	}else if ([[aTableColumn identifier] isEqualToString:@"privateKey"]){
		returnString = item.privateKey;
	}else if ([[aTableColumn identifier] isEqualToString:@"bit"]) {
		returnString = @"42";
	}
	
	[self setupKeyPopUpButton];	
	
	return returnString;
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys* item = [myAppDelegate.internalKeyArray objectAtIndex:rowIndex];
	
	[PasswordController renameIdentifierOfPrivateKeyFromKeychains:item.keyIdentifier :anObject];
	
	item.keyIdentifier = anObject;
	
	[self setupKeyPopUpButton];
	
}

@end
