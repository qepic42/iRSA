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
#import "SendMail.h"

@implementation KeyTableView
@synthesize dataArray, currentKeyLength, bitArray, keyAddModeInt, keyMode;


#pragma mark -
#pragma mark Initialization & Dealloc

- (id) init{
	self = [super init];
	if (self != nil) {
		self.currentKeyLength = [NSNumber numberWithInt:2048];
		self.bitArray = [[NSArray alloc]init];
	}
	return self;
}


- (void)awakeFromNib{
	[self setupBitPopupButton];
	self.keyMode = 0;
}

- (void) dealloc{
	[bitArray release];
	[currentKeyLength release];
	[keyClass release];
	[dataArray release];
	[super dealloc];
}


#pragma mark -
#pragma mark Other Methods

-(void)setupKeyPopUpButton{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"itemCountChanged" object:nil userInfo:nil];	
}

-(void)setupBitPopupButton{
	self.bitArray = [NSArray arrayWithObjects:@"512",@"1024",@"2048",@"4096",@"8192",@"16384",@"32768",@"65536",nil];
	
	for(NSString *currentBit in self.bitArray){
		NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:currentBit action:nil keyEquivalent:@""];
		[newItem setTarget:self];
		[[setupBitPopUpButton menu] addItem:newItem];
		[newItem release];		
	}
	
	int cache = [[self.bitArray objectAtIndex:0] intValue];
	self.currentKeyLength = [NSNumber numberWithInt:cache];
}


-(IBAction)removeItemFromExternalArray:(id)sender{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if (self.keyMode == 0) {
		
		KeyPropertys *item = [myAppDelegate.internalKeyArray objectAtIndex:[internalTable selectedRow]];
		[PasswordController removePrivateKeyFromKeychains:item.keyIdentifier];
		[myAppDelegate.internalKeyArray removeObjectAtIndex:[internalTable selectedRow]];
		
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:@"reloadInternalTable" object:nil userInfo:nil];
		
	}else if (self.keyMode == 1){
		KeyPropertys *item = [myAppDelegate.externalKeyArray objectAtIndex:[externalTable selectedRow]];
		[PasswordController removePrivateKeyFromKeychains:item.keyIdentifier];
		[myAppDelegate.externalKeyArray removeObjectAtIndex:[externalTable selectedRow]];
		
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:@"reloadExternalTable" object:nil userInfo:nil];
		
	}
	
	
	[self setupKeyPopUpButton];
	
}

#pragma mark -
#pragma mark IBActions

- (IBAction)pushAddNewKey:(id)sender{
	[NSApp beginSheet:keySetupSheet modalForWindow:keyTableView modalDelegate:self didEndSelector:nil contextInfo:nil];
}

-(IBAction)pushGenerateSetupKey:(id)sender{
	
	if(self.keyAddModeInt == 0){
		
		[keySetupSheet orderOut:nil];
		[NSApp endSheet:keySetupSheet];
		
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:@"startKeyGenerate" object:nil userInfo:nil];
		
		if (self.currentKeyLength == 0) {
			self.currentKeyLength = [NSNumber numberWithInt:2048];
		}
		
		keyClass = [[KeyGenerate alloc]init];
		[keyClass performSelectorInBackground:@selector (generatePublicAndPrivateRSAKeyWithPrivatKeyLength:) withObject:self.currentKeyLength];
		
	}else if (self.keyAddModeInt == 1) {
		
		[keySetupSheet orderOut:nil];
		[NSApp endSheet:keySetupSheet];
		
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
		NSData *cache = [[enterOwnPublicKey stringValue] dataUsingEncoding:NSUTF8StringEncoding];
		
		[myAppDelegate.externalKeyArray addObject:[KeyPropertys keyItemWithData:@"untitled" :[enterOwnPublicKey stringValue] :@"-" :cache :nil :@"noOne"]];
		
		[self setupKeyPopUpButton];
		
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:@"reloadExternalTable" object:nil userInfo:nil];

	
	}
	
		

}

-(IBAction)pushChooseBit:(id)sender{
	int cache = [[self.bitArray objectAtIndex:[sender indexOfSelectedItem]] intValue];
	self.currentKeyLength = [NSNumber numberWithInt:cache];
}

-(IBAction)pushCancelGenerate:(id)sender{
	[keySetupSheet orderOut:nil];
	[NSApp endSheet:keySetupSheet];
}

-(IBAction)pushDoneButton:(id)sender{
	[infoSheet orderOut:nil];
	[NSApp endSheet:infoSheet];
}

-(IBAction)pushCancelButton:(id)sender{
	[infoSheet orderOut:nil];
	[NSApp endSheet:infoSheet];
}

-(IBAction)pushShareByMailButton:(id)sender{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[publicKeyView textStorage]string],@"publicKey",nil];	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"sendMail" object:nil userInfo:dict];
}


#pragma mark -
#pragma mark Delegate Methods

- (void)tabView:(NSTabView *)tabV didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
	
	if ([[tabViewItem label] isEqualToString:@"Internal keys"]) {
		self.keyMode = 0;
	}else if ([[tabViewItem label] isEqualToString:@"External keys"]) {
		self.keyMode = 1;
	}else {
		
		self.keyAddModeInt = [[tabViewItem identifier]intValue];
		
		if (self.keyAddModeInt == 0) {
			[keyAddEnterButton setTitle:@"Generate"];
		}else if(self.keyAddModeInt == 1){
			[keyAddEnterButton setTitle:@"Enter"];
		}
		
	}

}

@end
