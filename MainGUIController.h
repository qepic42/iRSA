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

@interface MainGUIController : NSObject <NSTextViewDelegate,NSTabViewDelegate,NSToolbarDelegate> {
	
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *experimentalWindow;
	IBOutlet NSWindow *keysWindow;
	IBOutlet NSWindow *loadingSheet;
	IBOutlet NSWindow *keyManageSheet;
	IBOutlet NSWindow *resultWindow;
	IBOutlet NSWindow *mailSetupWindow;
	IBOutlet NSWindow *publicKeyToShareSheet;
	IBOutlet NSWindow *preferencesWindow;
	IBOutlet NSWindow *infoSheet;
	IBOutlet NSWindow *oldPreferencesWindow;
	IBOutlet NSButton *enterButton;
	IBOutlet NSButton *removeButton;
	IBOutlet NSButton *keyPopUpButton;
	IBOutlet NSButton *chooseKeyPopUpButton;
	IBOutlet NSButton *loadingButton;
	IBOutlet NSButton *chooseKeyToShareDoneButton;
	IBOutlet NSButton *keySheetDoneButton;
	IBOutlet NSButton *keySheetAddButton;
	IBOutlet NSButton *keySheetRemoveButton;
	IBOutlet NSToolbarItem *toolbarKeysItem;
	IBOutlet NSTextView *inputTextView;
	IBOutlet NSTextView *resultTextView;
	IBOutlet NSTextView *sendMailContent;
	IBOutlet NSTextField *countChars;
	IBOutlet NSTextField *outputFormatLabel;
	IBOutlet NSTextField *loadingLabel;
	IBOutlet NSTextField *sendMailSubject;
	IBOutlet NSTextField *sendMailFrom;
	IBOutlet NSTextField *sendMailTo;
	IBOutlet NSTextField *keyInfoIdentifier;
	IBOutlet NSSegmentedControl *switchButton;
	IBOutlet NSProgressIndicator *loadingIndicatorKeyWindow;
	IBOutlet NSProgressIndicator *loadingIndicator;
	IBOutlet NSToolbar *mainViewToolbar;
	IBOutlet NSView *toolbarKeysView;
	
	
	int tab;
	int loopCount;
	BOOL mode;
	BOOL sendMailByNotification;
	KeyGenerate *keyClass;
	NSString *currentText;
	NSString *currentEncodedText;
	NSString *currentIdentifier;
	NSString *currentPublicKey;
	NSString *currentPrivateKey;
	NSString *currentMail;
	NSData *currentPublicKeyData;
	NSData *currentPrivateKeyData;
	NSDictionary *notificationPublicKeyDict;
	
}

@property()BOOL mode;
@property()BOOL sendMailByNotification;
@property() int tab;
@property() int loopCount;
@property(nonatomic,retain)NSString *currentIdentifier;
@property(nonatomic,retain)NSString *currentPublicKey;
@property(nonatomic,retain)NSString *currentPrivateKey;
@property(nonatomic,retain)NSString *currentMail;
@property(nonatomic,retain)NSString *currentText;
@property(nonatomic,retain)NSString *currentEncodedText;
@property(nonatomic,retain)NSData *currentPublicKeyData;
@property(nonatomic,retain)NSData *currentPrivateKeyData;
@property(nonatomic,retain)NSDictionary *notificationPublicKeyDict;


-(IBAction)pushEnter:(id)sender;
-(IBAction)pushSwitch:(id)sender;
-(IBAction)pushShowKeyWindow:(id)sender;
-(IBAction)pushCloseKeyWindow:(id)sender;
-(IBAction)pushChooseKey:(id)sender;
-(IBAction)pushResultDoneSheet:(id)sender;
-(IBAction)pushShareByEMail:(id)sender;
-(IBAction)pushSendMail:(id)sender;
-(IBAction)pushInvitePerson:(id)sender;
-(IBAction)pushChooseKeyToShare:(id)sender;
-(IBAction)pushChoosedKeyToShare:(id)sender;
-(IBAction)pushCancelSendMail:(id)sender;
-(IBAction)pushShowKeyWindowFromMenu:(id)sender;
-(IBAction)pushShowPreferencesWindow:(NSToolbarItem *)sender;
-(IBAction)pushShowKeysWindow:(NSToolbarItem *)sender;
-(IBAction)pushShowInviteWindow:(NSToolbarItem *)sender;
-(IBAction)pushCancelChooseKeyButton:(id)sender;
-(IBAction)showPrefernencesWindow:(id)sender;
-(void)setPopUpStatus;
-(void)setupPopUpButton;
-(void)openResultWindow;
-(void)startKeyGenerateIndicator;
-(void)stopKeyGenerateIndicator;
-(void)addNSNotificationObserver;
-(void)enableInterface:(NSNotification *)notification;
-(void)setupOwnPropertys;
-(void)openInviteSheet;
-(void)chooseKeyToShare:(id)sender;
-(void)setupChooseKeyPopUpButton;
-(void)setEnterButtonState;
-(void)clearText;
-(void)sendMailByNotification:(NSNotification *)notification;
-(void)chooseExternalKeyToShare:(id)sender;

@end
