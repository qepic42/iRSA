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

@implementation MainGUIController
@synthesize mode, tab, currentIdentifier, currentPublicKey, currentPrivateKey, currentText, loopCount, currentPublicKeyData, currentPrivateKeyData, currentEncodedText;

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
	[enterButton setEnabled:YES];
}

- (void)setupPopUpButton{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if(myAppDelegate.keyDataArray == 0){
		NSLog(@"Keine Items");
	}else if ([myAppDelegate.keyDataArray count] >= 1) {
		[[keyPopUpButton menu]removeAllItems];
		
		int i;
		int max = [myAppDelegate.keyDataArray count];
		
		for(i=0;i<max;i++){
			KeyPropertys* item = [myAppDelegate.keyDataArray objectAtIndex:i];
			if (self.mode == 1) {
				if ([item.privateKey isEqualToString:@"-"]) {
					
				}else {
					NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
					[newItem setTarget:self];
					[[keyPopUpButton menu] addItem:newItem];
					[newItem release];
				}
			}else{
				NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
				[newItem setTarget:self];
				[[keyPopUpButton menu] addItem:newItem];
				[newItem release];
			}
		}
		
		KeyPropertys *currentItem = [myAppDelegate.keyDataArray objectAtIndex:0];
		self.currentIdentifier = currentItem.keyIdentifier;
		self.currentPrivateKey = currentItem.privateKey;
		self.currentPrivateKeyData = currentItem.privateKeyData;
		self.currentPublicKey = currentItem.publicKey;
		self.currentPublicKeyData = currentItem.publicKeyData;
		//	[item release];
	}
	
	[self setPopUpStatus];
}

- (void)setupChooseKeyPopUpButton{
	
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if(myAppDelegate.keyDataArray == 0){
		NSLog(@"Keine Items");
	}else if ([myAppDelegate.keyDataArray count] >= 1) {
		[[chooseKeyPopUpButton menu]removeAllItems];
		
		int i;
		int max = [myAppDelegate.keyDataArray count];
		
		for(i=0;i<max;i++){
			KeyPropertys* item = [myAppDelegate.keyDataArray objectAtIndex:i];
			if (self.mode == 1) {
				if ([item.privateKey isEqualToString:@"-"]) {
					
				}else {
					NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
					[newItem setTarget:self];
					[[chooseKeyPopUpButton menu] addItem:newItem];
					[newItem release];
				}
			}else{
				NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:item.keyIdentifier action:nil keyEquivalent:@""];
				[newItem setTarget:self];
				[[chooseKeyPopUpButton menu] addItem:newItem];
				[newItem release];
			}
		}
		
		KeyPropertys *currentItem = [myAppDelegate.keyDataArray objectAtIndex:0];
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
	[loadingIndicatorKeyWindow startAnimation:self];
}

- (void)stopKeyGenerateIndicator{
	[loadingIndicatorKeyWindow stopAnimation:self];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)pushSwitch:(id)sender{
	if ([switchButton selectedSegment] == 0) {
		[enterButton setTitle:@"Encode"];
		[loadingLabel setStringValue:@"Encode…"];
		self.mode = 0;
		[self setupPopUpButton];
	}else if ([switchButton selectedSegment] == 1) {
		[enterButton setTitle:@"Decode"];
		[loadingLabel setStringValue:@"Decode…"];
		self.mode = 1;
		[self setupPopUpButton];
	}
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
	[self chooseKeyToShare:sender];
}

- (IBAction)pushEnter:(id)sender{
	[NSApp beginSheet:loadingSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	[loadingIndicator startAnimation:self];

	NSString *resultString = @"";
	BOOL fail;
	
	if (self.mode == 0){
		
		@try {
			NSDictionary *resultDict = [CryptBySSCrypto encodeByRSAWithData:[[inputTextView textStorage] string] key:self.currentPublicKeyData];
			NSString *resultString = [resultDict objectForKey:@"encryptedString"];
			[resultTextView setString:resultString];
			
			NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
			[center postNotificationName:@"loadingSheetClosed" object:nil userInfo:nil];
			fail = NO;
		}
		@catch (NSException * e) {
			NSBeep();
			[errorName setStringValue:[e name]];
			[errorReason setStringValue:[e reason]];
			[errorWindow setTitle:[e name]];
			[errorWindow orderFront:self];
			[errorWindow center];
			[errorWindow makeKeyWindow];
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
			[errorName setStringValue:[e name]];
			[errorReason setStringValue:[e reason]];
			[errorWindow setTitle:[e name]];
			[errorWindow orderFront:self];
			[errorWindow center];
			[errorWindow makeKeyWindow];
			fail = YES;
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

- (IBAction)pushResultDoneSheet:(id)sender{
	[resultWindow orderOut:nil];
	[NSApp endSheet:resultWindow];
}

- (IBAction)pushShareByEMail:(id)sender{
	[NSApp beginSheet:mailSetupWindow modalForWindow:resultWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	
	NSMutableString *publicKeyMutableString = [NSMutableString stringWithCapacity:[self.currentPublicKey length]];
	[publicKeyMutableString setString: self.currentPublicKey];
	NSRange myRange = 
	[publicKeyMutableString rangeOfString:@"-----END PUBLIC KEY-----"options:NSCaseInsensitivePredicateOption];
	[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];
	self.currentPublicKey = [NSString stringWithFormat:@"%@",publicKeyMutableString];
	
	NSString *contentCache = [NSString stringWithFormat:@"%@:\n%@%@:\n%@",@"I used the following publick key to encrypt this mail",self.currentPublicKey, @"Encrypted text", [[resultTextView textStorage]string]];
	[sendMailContent setString:contentCache];

	[sendMailSubject setStringValue:[NSString stringWithFormat:@"Public key: %@",self.currentPublicKey]];
}

- (IBAction)pushSendMail:(id)sender{
	[SendMail sendEMailMessageWith:[[sendMailContent textStorage]string] targetAddress:[sendMailTo stringValue] from:[sendMailFrom stringValue] and:[sendMailSubject stringValue]];
	[mailSetupWindow orderOut:nil];
	[NSApp endSheet:mailSetupWindow];
}

- (IBAction)pushInvitePerson:(id)sender{
	[self setupChooseKeyPopUpButton];
	[NSApp beginSheet:publicKeyToShareSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)pushChoosedKeyToShare:(id)sender{
	[publicKeyToShareSheet orderOut:nil];
	[NSApp endSheet:publicKeyToShareSheet];
	[self openInviteSheet];
}

- (IBAction)pushChooseKeyToShare:(id)sender{
	if ([[[sender menu] itemArray]count] == 0) {
		NSLog(@"nil");
		[chooseKeyToShareDoneButton setEnabled:NO];
	}else{
		[self chooseKeyToShare:sender];
		[chooseKeyToShareDoneButton setEnabled:YES];
	}
}

- (IBAction)pushCancelSendMail:(id)sender{
	[mailSetupWindow orderOut:nil];
	[NSApp endSheet:mailSetupWindow];
}

- (IBAction)pushOkErrorButton:(id)sender{
	[errorWindow orderOut:self];
}

- (IBAction)pushShowPreferencesWindow:(NSToolbarItem *)sender{
	[preferencesWindow orderFront:self];
	[preferencesWindow makeKeyWindow];
}


- (IBAction)pushShowKeysWindow:(NSToolbarItem *)sender{
	[NSApp beginSheet:keyManageSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

 -(IBAction)pushShowInviteWindow:(NSToolbarItem *)sender{
	 [self setupChooseKeyPopUpButton];
	 [NSApp beginSheet:publicKeyToShareSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

-(IBAction)pushCancelChooseKeyButton:(id)sender{
	[publicKeyToShareSheet orderOut:nil];
	[NSApp endSheet:publicKeyToShareSheet];
}

#pragma mark -
#pragma mark Other Methods

-(void)chooseKeyToShare:(id)sender{
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
	NSLog(@"Items: %i",[myAppDelegate.keyDataArray count]);
	if ([myAppDelegate.keyDataArray count] == 0) {
		NSLog(@"Kein Key vorhanden");
	}else {
		KeyPropertys *item = [myAppDelegate.keyDataArray objectAtIndex:[sender indexOfSelectedItem]];
		
		self.currentIdentifier = item.keyIdentifier;
		self.currentPublicKey = item.publicKey;
		self.currentPrivateKey = item.privateKey;
		self.currentPublicKeyData = item.publicKeyData;
		self.currentPrivateKeyData = item.privateKeyData;
	}
}

-(void)openInviteSheet{
	[NSApp beginSheet:mailSetupWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	
	NSString *cache = @"Invite\nI want invite you to enjoy mailing with me encrypted by RSA.\nYou can easily download this App here: http://galler-web.de/iRSA.zip\"\nTo encrypt my texts use my following public key:\n\n ";
	
	NSMutableString *publicKeyMutableString = [NSMutableString stringWithCapacity:[self.currentPublicKey length]];
	[publicKeyMutableString setString: self.currentPublicKey];
	NSRange myRange = 
	[publicKeyMutableString rangeOfString:@"-----END PUBLIC KEY-----"options:NSCaseInsensitivePredicateOption];
	[publicKeyMutableString replaceCharactersInRange:myRange withString:@""];	
	
	[sendMailSubject setStringValue:@"Invite to use iRSA"];
	[sendMailContent setString:[NSString stringWithFormat:@"%@%@",cache, publicKeyMutableString]];
}


#pragma mark -
#pragma mark Delegate Methods

-(void)textViewDidChangeSelection:(NSNotification*)aNotification{
	self.currentText = [[inputTextView textStorage] string];
    int noChars = [self.currentText length];
	[countChars setStringValue:[NSString stringWithFormat:@"%d",noChars]];
}

-(void)tabView:(NSTabView *)tabV didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
	self.tab = [[tabViewItem identifier]intValue];
}


#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder*)encoder {
	iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];
    [super encodeWithCoder:encoder];
    [encoder encodeObject:myAppDelegate.keyDataArray forKey:@"keyDataArray"];
}

- (id) initWithCoder:(NSCoder*)decoder {
    if (self = [super init]) {
		[super initWithCoder:decoder];
		iRSAAppDelegate *myAppDelegate = (iRSAAppDelegate *)[[NSApplication sharedApplication] delegate];

		myAppDelegate.keyDataArray = [[decoder decodeObjectForKey:@"keyDataArray"] retain];
    }
	
    return self;
}

@end
