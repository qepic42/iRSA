//
//  GUIController.m
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "MainGUIController.h"
#import "KeyGenerate.h"
#import "KeyPropertys.h"
#import "iRSAAppDelegate.h"
#import "CryptBySSCrypto.h"
#import <SSCrypto/SSCrypto.h>
#import "SendMail.h"
#import "Globals.h"
#import "PreferencesController.h"
#import "AddressBookController.h"
#import "DarkMainController.h"

@implementation MainGUIController
@synthesize notificationPublicKeyDict, sendMailByNotification, mode, tab, currentIdentifier, currentPublicKey, currentPrivateKey, currentText, loopCount, currentPublicKeyData, currentPrivateKeyData, currentEncodedText, currentMail;

#pragma mark -
#pragma mark Initialization & Dealloc

- (id) init{
	self = [super init];
	if (self != nil) {
		[self setupOwnPropertys];
		[self addNSNotificationObserver];
		[self setupPopUpButton];
	}
	return self;
}

-(void)awakeFromNib{
	[self setEnterButtonState];
	if ([[mainWindow title] isEqualToString:@"iRSA-Dark"]) {
		[inputTextView setTextColor:[NSColor whiteColor]];
	}
//	NSColor*	translucent = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.6];
//	[experimentalWindow setBackgroundColor:translucent];
}

- (void)setupOwnPropertys{
	self.mode = 0;
	self.tab = 1;
	self.loopCount = 0;
}

- (void)addNSNotificationObserver{
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enableInterface:)
												 name:@"enableInterface"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setupPopUpButton)
												 name:@"itemCountChanged"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(openResultWindow)
												 name:@"loadingSheetClosed"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startKeyGenerateIndicator)
												 name:@"startKeyGenerate"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stopKeyGenerateIndicator)
												 name:@"endKeyGenerate"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(sendMailByNotification:)
												 name:@"sendMail"
											   object:nil];
	
}

- (void)setPopUpStatus{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if (self.mode == 0) {
		
		if ([myAppDelegate.internalKeyArray count] == 0) {
			[enterButton setEnabled:NO];
			[removeButton setEnabled:NO];
		}else {
			[self setEnterButtonState];
			[removeButton setEnabled:YES];
		}
		
	}else if (self.mode == 1) {
		
		if ([myAppDelegate.externalKeyArray count] == 0) {
			[enterButton setEnabled:NO];
			[removeButton setEnabled:NO];
		}else {
			[self setEnterButtonState];
			[removeButton setEnabled:YES];
		}
		
	}

}

- (void) dealloc{
	[currentMail release];
	[notificationPublicKeyDict release];
	[currentEncodedText release];
	[currentPublicKeyData release];
	[currentPrivateKeyData release];
	[currentText release];
	[currentIdentifier release];
	[currentPublicKey release];
	[currentPrivateKey release];
	[keyClass release];
	[super dealloc];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)enableInterface:(NSNotification *)notification{
	[loadingIndicatorKeyWindow stopAnimation:self];	
	[self setEnterButtonState];
}

- (void)setupPopUpButton{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	BOOL refresh = NO;
	
	[[keyPopUpButton menu]removeAllItems];
	
	if (self.mode == 0) {
		
		if ([myAppDelegate.externalKeyArray count] == 0) {
			[[keyPopUpButton menu]removeAllItems];
			NSMenuItem *fail = [[[NSMenuItem alloc]initWithTitle:@"" action:nil keyEquivalent:@""]autorelease];
			[[keyPopUpButton menu]addItem:fail];
			[[keyPopUpButton menu]removeAllItems];
			[enterButton setEnabled:NO];
			refresh = YES;
			
		}else {
			
			int i;
			int max = [myAppDelegate.externalKeyArray count];
			
			for(i=0;i<max;i++){
				KeyPropertys* item = [myAppDelegate.externalKeyArray objectAtIndex:i];
				
				NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
				[newItem setTarget:self];
				[[keyPopUpButton menu] addItem:newItem];
				[newItem release];
				
			}
			
		}

	}else if (self.mode == 1){
		
		if ([myAppDelegate.internalKeyArray count] == 0) {
			
			[[keyPopUpButton menu]removeAllItems];
			NSMenuItem *fail = [[[NSMenuItem alloc]initWithTitle:@"" action:nil keyEquivalent:@""]autorelease];
			[[keyPopUpButton menu]addItem:fail];
			[[keyPopUpButton menu]removeAllItems];
			[enterButton setEnabled:NO];
			refresh = YES;
			
		}else{
			
			int i;
			int max = [myAppDelegate.internalKeyArray count];
			
			for(i=0;i<max;i++){
				KeyPropertys* item = [myAppDelegate.internalKeyArray objectAtIndex:i];
				
				NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
				[newItem setTarget:self];
				[[keyPopUpButton menu] addItem:newItem];
				[newItem release];
				
			}
			
		}
			
	}
	
	[self setEnterButtonState];
		
	if (refresh == NO) {
		
		KeyPropertys *currentItem;
		
		if (self.mode == 0) {
			currentItem = [myAppDelegate.internalKeyArray objectAtIndex:0];
		}else if (self.mode == 1) {
			currentItem = [myAppDelegate.externalKeyArray objectAtIndex:0];
		}
		
		
		self.currentIdentifier = currentItem.keyIdentifier;
		self.currentPrivateKey = currentItem.privateKey;
		self.currentPrivateKeyData = currentItem.privateKeyData;
		self.currentPublicKey = currentItem.publicKey;
		self.currentPublicKeyData = currentItem.publicKeyData;
		//	[item release];
		
	}else{
		
		self.currentIdentifier = 0;
		self.currentPrivateKey = 0;
		self.currentPrivateKeyData = 0;
		self.currentPublicKey = 0;
		self.currentPublicKeyData = 0;
		
	}	
	
	[self setPopUpStatus];
}

- (void)setupChooseKeyPopUpButton{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if(myAppDelegate.internalKeyArray == 0){
	}else if ([myAppDelegate.internalKeyArray count] >= 1) {
		[[chooseKeyPopUpButton menu]removeAllItems];
		
		int i;
		int max = [myAppDelegate.internalKeyArray count];
		
		for(i=0;i<max;i++){
			KeyPropertys* item = [myAppDelegate.internalKeyArray objectAtIndex:i];
			
			NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
			[newItem setTarget:self];
			[[chooseKeyPopUpButton menu] addItem:newItem];
			[newItem release];
		}
		
		KeyPropertys *currentItem = [myAppDelegate.internalKeyArray objectAtIndex:0];
		self.currentIdentifier = currentItem.keyIdentifier;
		self.currentPrivateKey = currentItem.privateKey;
		self.currentPrivateKeyData = currentItem.privateKeyData;
		self.currentPublicKey = currentItem.publicKey;
		self.currentPublicKeyData = currentItem.publicKeyData;
		//	[item release];
	}
}

- (void)openResultWindow{	
	[NSApp beginSheet:resultWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}


- (void)startKeyGenerateIndicator{
	[keySheetAddButton setEnabled:NO];
	[keySheetDoneButton setEnabled:NO];
	[keySheetRemoveButton setEnabled:NO];
	[loadingIndicatorKeyWindow startAnimation:self];
}

- (void)stopKeyGenerateIndicator{
	[keySheetAddButton setEnabled:YES];
	[keySheetDoneButton setEnabled:YES];
	[keySheetRemoveButton setEnabled:YES];
	[loadingIndicatorKeyWindow stopAnimation:self];
}

-(void)sendMailByNotification:(NSNotification *)notification{
	self.sendMailByNotification = YES;
	self.notificationPublicKeyDict = [notification userInfo];
	[self openInviteSheet];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)pushSwitch:(id)sender{
	if ([switchButton selectedSegment] == 0) {
		[enterButton setTitle:@"Encode"];
		[loadingLabel setStringValue:@"Encode…"];
		self.mode = 0;
	}else if ([switchButton selectedSegment] == 1) {
		[enterButton setTitle:@"Decode"];
		[loadingLabel setStringValue:@"Decode…"];
		self.mode = 1;
		
	}
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL clear = [prefs boolForKey:@"clearTextByModeChange"];
	
	if (clear == YES) {
		[self clearText];
	}
	
	[self setupPopUpButton];
	[self setEnterButtonState];
}

- (IBAction)pushShowKeyWindow:(id)sender{
	[NSApp beginSheet:keyManageSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)pushShowKeyWindowFromMenu:(id)sender{
	[NSApp beginSheet:keyManageSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)pushCloseKeyWindow:(id)sender{
	[keyManageSheet orderOut:nil];
	[NSApp endSheet:keyManageSheet];
}

- (IBAction)pushChooseKey:(id)sender{
	//[self chooseKeyToShare:sender];
	[self chooseExternalKeyToShare:sender];
}

- (IBAction)pushEnter:(id)sender{
	
	if ([[[inputTextView textStorage] string] isEqualToString:@"42"]) {
		[mainWindow orderOut:self];
		[[DarkMainController sharedMainDarkWindowController] showWindow:nil];
	}else {
		[NSApp beginSheet:loadingSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
		[loadingIndicator startAnimation:self];
		
		NSString *resultString = @"";
		BOOL fail;
		
		if([[[inputTextView textStorage] string] length] == 0){
			NSBeep();
			
			NSAlert *alert = [[[NSAlert alloc] init] autorelease];
			[alert addButtonWithTitle:@"OK"];
			[alert setMessageText:@"Enter text"];
			[alert setInformativeText:@"Please enter some text to en/decode"];
			[alert setAlertStyle:NSWarningAlertStyle];
			[alert runModal];
			
			fail = YES;
		}else{
			
			if (self.mode == 0){
				
				@try {
					//	NSLog(@"Text: %@",[[inputTextView textStorage] string]);
					//	NSLog(@"PKey: %@",[[NSString alloc] initWithData:self.currentPublicKeyData encoding:NSUTF8StringEncoding]);
					
					NSDictionary *resultDict = [CryptBySSCrypto encodeByRSAWithData:[[inputTextView textStorage] string] key:self.currentPublicKeyData];
					NSString *resultString = [resultDict objectForKey:@"encryptedString"];
					[resultTextView setString:resultString];
					
					NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
					[center postNotificationName:@"loadingSheetClosed" object:nil userInfo:nil];
					fail = NO;
				}
				@catch (NSException * e) {
					NSBeep();
					
					NSAlert *alert = [[[NSAlert alloc] init] autorelease];
					[alert addButtonWithTitle:@"OK"];
					[alert setMessageText:[e name]];
					[alert setInformativeText:[e reason]];
					[alert setAlertStyle:NSWarningAlertStyle];
					//[alert beginSheetModalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
					[alert runModal];
					
					fail = YES;
				}
				
			}else if (self.mode == 1){
				
				NSData *test = [[[[inputTextView textStorage] string] dataUsingEncoding:NSUTF8StringEncoding] decodeBase64];
				
				@try {
					NSDictionary *resultDict = [CryptBySSCrypto decodeByRSAWithData:test key:self.currentPrivateKeyData];
					NSString *resultString = [[NSString alloc] initWithData:[resultDict objectForKey:@"decryptedData"] encoding:NSUTF8StringEncoding];
					if(!resultString) {
						resultString = [resultDict objectForKey:@"decryptedString"];
					}
					self.currentEncodedText = resultString;
					[resultTextView setString:resultString];
					
					NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
					[center postNotificationName:@"loadingSheetClosed" object:nil userInfo:nil];
					fail = NO;
				}
				@catch (NSException * e) {
					NSBeep();
					NSAlert *alert = [[[NSAlert alloc] init] autorelease];
					[alert addButtonWithTitle:@"OK"];
					[alert setMessageText:[e name]];
					[alert setInformativeText:[e reason]];
					[alert setAlertStyle:NSWarningAlertStyle];
					[alert runModal];
					//[alert beginSheetModalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
					fail = YES;
				}
			}
		}	
		
		[resultString release];
		
		[loadingSheet orderOut:nil];
		[NSApp endSheet:loadingSheet];
		
		if (fail == NO) {
			NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
			[center postNotificationName:@"loadingSheetClosed" object:nil userInfo:nil];
		}
	}
	
}

- (IBAction)pushResultDoneSheet:(id)sender{
	[resultWindow orderOut:nil];
	[NSApp endSheet:resultWindow];
}

- (IBAction)pushShareByEMail:(id)sender{
	
	[NSApp beginSheet:mailSetupWindow modalForWindow:resultWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	
	NSMutableString *publicKeyMutableString = [NSMutableString stringWithCapacity:[self.currentPublicKey length]];
	[publicKeyMutableString setString: self.currentPublicKey];
	NSRange myRange = 
	[publicKeyMutableString rangeOfString:@""options:NSCaseInsensitivePredicateOption];
	
	if (myRange.location != NSNotFound) {
		[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];
	}else{
		
	}
	
	self.currentPublicKey = publicKeyMutableString;
	
	NSString *contentCache= [NSString stringWithFormat:@"%@:\n\n%@\n\n%@:\n%@\n\n\n\n\n\n%@",MESSAGE_PREFIX,self.currentPublicKey, @"Encrypted text", [[resultTextView textStorage]string],MESSAGE_SIGNATURE];

	[sendMailContent setString:contentCache];
	[sendMailFrom setStringValue:[AddressBookController returnOwnMailAddress]];
	NSLog(@"to: %@",self.currentMail);
	[sendMailTo setStringValue:self.currentMail];
	//[sendMailTo setStringValue:self.currentMail];
	[sendMailSubject setStringValue:MESSAGE_SUBJECT];
}

- (IBAction)pushSendMail:(id)sender{
	[SendMail sendEMailMessageWith:[[sendMailContent textStorage]string] targetAddress:[sendMailTo stringValue] from:[sendMailFrom stringValue] and:[sendMailSubject stringValue]];
	[mailSetupWindow orderOut:nil];
	[NSApp endSheet:mailSetupWindow];
}

- (IBAction)pushInvitePerson:(id)sender{
	[self openInviteSheet];
	self.sendMailByNotification = YES;
}

- (IBAction)pushChoosedKeyToShare:(id)sender{
	[publicKeyToShareSheet orderOut:nil];
	[NSApp endSheet:publicKeyToShareSheet];
	[self openInviteSheet];
}

- (IBAction)pushChooseKeyToShare:(id)sender{
	if ([[[sender menu] itemArray]count] == 0) {
		[chooseKeyToShareDoneButton setEnabled:NO];
	}else{
		[self chooseKeyToShare:sender];
		[chooseKeyToShareDoneButton setEnabled:YES];
		[chooseKeyToShareDoneButton highlight:YES];
	}
}

- (IBAction)pushCancelSendMail:(id)sender{
	[mailSetupWindow orderOut:nil];
	[NSApp endSheet:mailSetupWindow];
}

- (IBAction)pushShowPreferencesWindow:(NSToolbarItem *)sender{
//	[oldPreferencesWindow orderFront:self];
//	[oldPreferencesWindow makeKeyWindow];
	[preferencesWindow orderFront:self];
	[preferencesWindow makeKeyWindow];
}


- (IBAction)pushShowKeysWindow:(NSToolbarItem *)sender{
	[NSApp beginSheet:keyManageSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

 -(IBAction)pushShowInviteWindow:(NSToolbarItem *)sender{
	 [self setupChooseKeyPopUpButton];
	 
	 if ([[[chooseKeyPopUpButton menu] itemArray]count] == 0) {
		 [chooseKeyToShareDoneButton setEnabled:NO];
	 }else{
		 [chooseKeyToShareDoneButton setEnabled:YES];
		 [chooseKeyToShareDoneButton highlight:YES];
	 }
	 
	 [chooseKeyToShareDoneButton highlight:YES];
	 [NSApp beginSheet:publicKeyToShareSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

-(IBAction)pushCancelChooseKeyButton:(id)sender{
	[publicKeyToShareSheet orderOut:nil];
	[NSApp endSheet:publicKeyToShareSheet];
}


-(IBAction)showPrefernencesWindow:(id)sender{	
	[[PreferencesController sharedPrefsWindowController] showWindow:nil];
//	[oldPreferencesWindow orderFront:self];
//	[oldPreferencesWindow center];
//	[oldPreferencesWindow makeKeyWindow];
}


#pragma mark -
#pragma mark Other Methods

-(void)chooseExternalKeyToShare:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if ([myAppDelegate.externalKeyArray count] == 0) {
	}else {
		KeyPropertys *item = [myAppDelegate.externalKeyArray objectAtIndex:[sender indexOfSelectedItem]];
		
		self.currentIdentifier = item.keyIdentifier;
		self.currentPublicKey = item.publicKey;
		self.currentPrivateKey = item.privateKey;
		self.currentPublicKeyData = item.publicKeyData;
		self.currentPrivateKeyData = item.privateKeyData;
		self.currentMail = [AddressBookController returnMainMailAddressForPerson:item.keyPerson];
	}
}

-(void)chooseKeyToShare:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if ([myAppDelegate.internalKeyArray count] == 0) {
	}else {
		KeyPropertys *item = [myAppDelegate.internalKeyArray objectAtIndex:[sender indexOfSelectedItem]];
		
		self.currentIdentifier = item.keyIdentifier;
		self.currentPublicKey = item.publicKey;
		self.currentPrivateKey = item.privateKey;
		self.currentPublicKeyData = item.publicKeyData;
		self.currentPrivateKeyData = item.privateKeyData;
		self.currentMail = @"";
	//	self.currentMail = [AddressBookController returnMainMailAddressForPerson:item.keyPerson];
	}
}

-(void)openInviteSheet{
	
	if (self.sendMailByNotification == NO){
		[NSApp beginSheet:mailSetupWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	}else {
		[NSApp beginSheet:mailSetupWindow modalForWindow:infoSheet modalDelegate:self didEndSelector:nil contextInfo:nil];

	}

	NSMutableString *publicKeyMutableString = [NSMutableString stringWithCapacity:[self.currentPublicKey length]];
	[publicKeyMutableString setString: self.currentPublicKey];
	NSRange myRange = 
	[publicKeyMutableString rangeOfString:@""options:NSCaseInsensitivePredicateOption];
	
	if (myRange.location != NSNotFound) {
		[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];
	}else{
		
	}
	
	self.currentPublicKey = publicKeyMutableString;
	
	[sendMailSubject setStringValue:INVITE_SUBJECT];
	[sendMailFrom setStringValue:[AddressBookController returnOwnMailAddress]];
	
	
	if (self.sendMailByNotification == YES) {
		NSString *publicKey = [self.notificationPublicKeyDict objectForKey:@"publicKey"];
		[sendMailContent setString:[NSString stringWithFormat:@"%@%@",INVITE_MESSAGE, publicKey]];
	}else {
		[sendMailContent setString:[NSString stringWithFormat:@"%@%@",INVITE_MESSAGE, self.currentPublicKey]];
	}
}

-(void)setEnterButtonState{
	if ([[[inputTextView textStorage] string] length] == 0) {
		[enterButton setEnabled:NO];
	}else if ([[[inputTextView textStorage] string] length] >= 1){
		[enterButton setEnabled:YES];
	}
}

-(void)clearText{
	[inputTextView setString:@""];
}

#pragma mark -
#pragma mark Delegate Methods

-(void)textViewDidChangeSelection:(NSNotification*)aNotification{
	self.currentText = [[inputTextView textStorage] string];
    int noChars = [self.currentText length];
	[countChars setStringValue:[NSString stringWithFormat:@"%d",noChars]];
	[self setEnterButtonState];
}

-(void)tabView:(NSTabView *)tabV didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
	self.tab = [[tabViewItem identifier]intValue];
}

@end
