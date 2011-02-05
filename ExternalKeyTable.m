//
//  ExternalKeyTable.m
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "ExternalKeyTable.h"
#import "iRSAAppDelegate.h"
#import "KeyPropertys.h"
#import "AddressBookController.h"
#import "ContactPropertys.h"

@implementation ExternalKeyTable
@synthesize currentPerson, currentPersonIndex;

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
													 name:@"reloadExternalTable"
												   object:nil];
		
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		myAppDelegate.externalKeyArray = [[NSMutableArray alloc]init];
		
	}
	return self;
}

- (void) dealloc
{
	[currentPerson release];
	[super dealloc];
}


- (void)awakeFromNib{
	[myTable setTarget:self];
	[removeButton setEnabled:NO];
	[myTable setDoubleAction:@selector(doubleClickToRow:)];
	
	[personPopupMenu removeAllItems];
	
	NSMutableArray *people = [AddressBookController returnAllPeople];
	
	int i;
	int max = [people count];
	
	for(i=0;i<max;i++){
		
		ContactPropertys *item = [people objectAtIndex:i];
		
		if (item.contactNachname == nil) {
			NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@: %@",item.contactVorname, item.contactMainMailAddress] action:nil keyEquivalent:@""];
			[newItem setTarget:self];
			[personPopupMenu addItem:newItem];
			[newItem release];
		}else {
			NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",item.contactVorname,item.contactNachname] action:nil keyEquivalent:@""];
			[newItem setTarget:self];
			[personPopupMenu addItem:newItem];
			[newItem release];
		}
		
	}
	
}


#pragma mark -
#pragma mark Other Methods

-(void)doubleClickToRow:(NSTableView *)sender{
	if ([sender clickedColumn] == 3){
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		KeyPropertys* item = [myAppDelegate.externalKeyArray objectAtIndex:[sender clickedRow]];
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
	
	if ([[[notification userInfo]objectForKey:@"mode"] isEqualToString:@"external"]) {
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		
		[myAppDelegate.externalKeyArray addObject:[KeyPropertys keyItemWithData:@"untitled" :[[notification userInfo]objectForKey:@"publicKey"] :[[notification userInfo]objectForKey:@"privateKey"] :[[notification userInfo]objectForKey:@"publicKeyData"] :[[notification userInfo]objectForKey:@"privateKeyData"]: @"noOne"]];
		
		[self setupKeyPopUpButton];
		[myTable noteNumberOfRowsChanged];
		
		NSInteger newRowIndex = [myAppDelegate.externalKeyArray count]-1;
		[myTable selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex]
			 byExtendingSelection:NO];
		
		[myTable editColumn:[myTable columnWithIdentifier:@"identifier"]
						row:newRowIndex withEvent: select:YES];
		
		[myTable editColumn:[myTable columnWithIdentifier:@"person"]
						row:newRowIndex withEvent: select:YES];
		
	}
	
}

-(void)reloadTable{
	[myTable reloadData];	
}


#pragma mark -
#pragma mark IBActions

- (IBAction)pushRemoveKey:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys *item = [myAppDelegate.externalKeyArray objectAtIndex:[myTable selectedRow]];
	[PasswordController removePrivateKeyFromKeychains:item.keyIdentifier];
	[myAppDelegate.internalKeyArray removeObjectAtIndex:[myTable selectedRow]];
	[self setupKeyPopUpButton];
	[myTable noteNumberOfRowsChanged];
}

- (IBAction)pushChoosePerson:(id)sender{
}

#pragma mark -
#pragma mark Delegate Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	NSInteger returnInteger = [myAppDelegate.externalKeyArray count];
	
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
	KeyPropertys* item = [myAppDelegate.externalKeyArray objectAtIndex:rowIndex];
	
	NSString *returnString;
	
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]){
		returnString = item.keyIdentifier;
	}else if ([[aTableColumn identifier] isEqualToString:@"publicKey"]){
		returnString = item.publicKey;
	}else if ([[aTableColumn identifier] isEqualToString:@"person"]){
		returnString = item.keyPerson;
	}else if ([[aTableColumn identifier] isEqualToString:@"bit"]) {
		returnString = [NSString stringWithFormat:@"%i",42];
	}
	
	
	[self setupKeyPopUpButton];	
	
	return returnString;
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys* item = [myAppDelegate.externalKeyArray objectAtIndex:rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]) {
		item.keyIdentifier = anObject;
		[self setupKeyPopUpButton];
	}else if ([[aTableColumn identifier] isEqualToString:@"person"]){
		[personPopupButton selectItemAtIndex:[anObject integerValue]];		
		NSMutableArray *people = [AddressBookController returnAllPeople];
		ContactPropertys *person = [people objectAtIndex:[anObject integerValue]];
		item.keyPerson = [NSString stringWithFormat:@"%i",[anObject integerValue]];
		self.currentPersonIndex = [anObject integerValue];
		self.currentPerson = person.contactVorname;
		NSLog(@"currentperson: %@",person.contactMainMailAddress);
	}
}

@end
