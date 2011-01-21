//
//  GUIController.m
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "GUIController.h"
#import "PrimClass.h"
#import "KeyGenerate.h"
#import "KeyPropertys.h"
#import "KeyDataModel.h"
#import "iRSAAppDelegate.h"
#import "CryptBySSCrypto.h"

@implementation GUIController
@synthesize mode, tab, currentIdentifier, currentPublicKey, currentPrivateKey, currentText, loopCount, currentPublicKeyData, currentPrivateKeyData;

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
	
}

- (void)setPopUpStatus{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	if ([myAppDelegate.keyDataArray count] == 0) {
		[enterButton setEnabled:NO];
		[removeButton setEnabled:NO];
	}else {
		[enterButton setEnabled:YES];
		[removeButton setEnabled:YES];
	}
}

- (void) dealloc{
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
	[enterButton setEnabled:YES];
	[newKeyButton setEnabled:YES];
}

- (void)setupPopUpButton{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	[[keyPopUpButton menu]removeAllItems];
	
	int i;
	int max = [myAppDelegate.keyDataArray count];
	
	for(i=0;i<max;i++){
		KeyPropertys* item = [myAppDelegate.keyDataArray objectAtIndex:i];
		NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
		[newItem setTarget:self];
		[[keyPopUpButton menu] addItem:newItem];
		[newItem release];
	}
	
	KeyPropertys *currentItem = [myAppDelegate.keyDataArray objectAtIndex:0];
	self.currentIdentifier = @"Fail";
	self.currentPrivateKey = currentItem.privateKey;
	self.currentPrivateKeyData = currentItem.privateKeyData;
	self.currentPublicKey = currentItem.publicKey;
	self.currentPublicKeyData = currentItem.publicKeyData;
	//	[item release];
	
	[self setPopUpStatus];
}

- (void)openResultWindow{	
	[NSApp beginSheet:resultWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}


- (void)startKeyGenerateIndicator{
	[loadingIndicatorKeyWindow startAnimation:self];
}

- (void)stopKeyGenerateIndicator{
	[loadingIndicatorKeyWindow stopAnimation:self];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)typeInTextField:(id)sender{
	self.currentText = [[inputTextView textStorage] string];
}

- (IBAction)pushSwitch:(id)sender{
	if ([switchButton selectedSegment] == 0) {
		[enterButton setTitle:@"Encode"];
		self.mode = 0;
	}else if ([switchButton selectedSegment] == 1) {
		[enterButton setTitle:@"Decode"];
		self.mode = 1;
	}
}

- (IBAction)pushShowKeyWindow:(id)sender{
	[NSApp beginSheet:keyManageSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)pushCloseKeyWindow:(id)sender{
	[keyManageSheet orderOut:nil];
	[NSApp endSheet:keyManageSheet];
}

- (IBAction)pushChooseKey:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	KeyPropertys *item = [myAppDelegate.keyDataArray objectAtIndex:[sender indexOfSelectedItem]];
	
	self.currentIdentifier = item.keyIdentifier;
	self.currentPublicKey = item.publicKey;
	self.currentPrivateKey = item.privateKey;
	self.currentPublicKeyData = item.publicKeyData;
	self.currentPrivateKeyData = item.privateKeyData;
}

- (IBAction)pushEnter:(id)sender{
	[NSApp beginSheet:loadingSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	[loadingIndicator startAnimation:self];

	if (self.mode == 0){
		NSDictionary *resultDict = [CryptBySSCrypto encode:[[inputTextView textStorage]string] :self.currentPublicKeyData];
		NSString *resultString = [resultDict objectForKey:@"encryptedString"];
		[resultTextView setString:resultString];
	}else if (self.mode == 1){
		NSData *test = [[[inputTextView textStorage]string ]dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *resultDict = [CryptBySSCrypto decode:test :self.currentPrivateKeyData];
		NSString *resultString = [resultDict objectForKey:@"decryptedString"];
		[resultTextView setString:resultString];
	}

	[loadingSheet orderOut:nil];
	[NSApp endSheet:loadingSheet];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"loadingSheetClosed" object:nil userInfo:nil];
}

- (IBAction)pushResultDoneSheet:(id)sender{
	[resultWindow orderOut:nil];
	[NSApp endSheet:resultWindow];
}


#pragma mark -
#pragma mark Delegate Methods

-(void)textViewDidChangeSelection:(NSNotification*)aNotification{
	
}

-(void)tabView:(NSTabView *)tabV didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
	self.tab = [[tabViewItem identifier]intValue];
}


@end
