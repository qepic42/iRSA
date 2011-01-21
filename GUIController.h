//
//  GUIController.h
//  iRSA
//
//  Created by Jan Galler on 14.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyGenerate.h"
#import "KeyPropertys.h"

@interface GUIController : NSObject <NSTextViewDelegate,NSTabViewDelegate> {
	
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *keysWindow;
	IBOutlet NSWindow *loadingSheet;
	IBOutlet NSWindow *keyManageSheet;
	IBOutlet NSWindow *resultWindow;
	IBOutlet NSButton *enterButton;
	IBOutlet NSButton *removeButton;
	IBOutlet NSButton *newKeyButton;
	IBOutlet NSButton *removeKeyButton;
	IBOutlet NSButton *keyPopUpButton;
	IBOutlet NSButton *loadingButton;
	IBOutlet NSTextView *inputTextView;
	IBOutlet NSTextView *resultTextView;
	IBOutlet NSTextField *outputFormatLabel;
	IBOutlet NSTextField *loadingLabel;
	IBOutlet NSSegmentedControl *switchButton;
	IBOutlet NSProgressIndicator *loadingIndicatorKeyWindow;
	IBOutlet NSProgressIndicator *loadingIndicator;
	
	
	int tab;
	int loopCount;
	BOOL mode;
	KeyGenerate *keyClass;
	NSString *currentText;
	NSString *currentIdentifier;
	NSString *currentPublicKey;
	NSString *currentPrivateKey;
	NSData *currentPublicKeyData;
	NSData *currentPrivateKeyData;
	
}

@property()BOOL mode;
@property() int tab;
@property() int loopCount;
@property(nonatomic,retain)NSString *currentIdentifier;
@property(nonatomic,retain)NSString *currentPublicKey;
@property(nonatomic,retain)NSString *currentPrivateKey;
@property(nonatomic,retain)NSString *currentText;
@property(nonatomic,retain)NSData *currentPublicKeyData;
@property(nonatomic,retain)NSData *currentPrivateKeyData;


-(IBAction)pushEnter:(id)sender;
-(IBAction)typeInTextField:(id)sender;
-(IBAction)pushSwitch:(id)sender;
-(IBAction)pushShowKeyWindow:(id)sender;
-(IBAction)pushCloseKeyWindow:(id)sender;
-(IBAction)pushChooseKey:(id)sender;
-(IBAction)pushResultDoneSheet:(id)sender;
-(void)setPopUpStatus;
-(void)setupPopUpButton;
-(void)openResultWindow;
-(void)startKeyGenerateIndicator;
-(void)stopKeyGenerateIndicator;
-(void)addNSNotificationObserver;
-(void)enableInterface:(NSNotification *)notification;
-(void)setupOwnPropertys;

@end
