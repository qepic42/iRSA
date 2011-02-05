//
//  PublicKeysTableView.h
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyGenerate.h"

@interface KeyTableView : NSObject <NSTableViewDelegate,NSTableViewDataSource,NSTabViewDelegate> {
	IBOutlet NSButton *keyPopUpButton;
	IBOutlet NSButton *removeButton;
	IBOutlet NSButton *setupBitPopUpButton;
	IBOutlet NSWindow *keySetupSheet;
	IBOutlet NSWindow *keyTableView;
	IBOutlet NSButton *keyAddEnterButton;
	IBOutlet NSTextField *enterOwnPublicKey;
	IBOutlet NSTextField *infoBoxExternLabel;
	IBOutlet NSTabView *keyAddMode;
	IBOutlet NSWindow *infoSheet;
	IBOutlet NSBox *infoBox;
	IBOutlet NSTextView *publicKeyView;
	IBOutlet NSTabView *keyModeTab;
	IBOutlet NSTableView *internalTable;
	IBOutlet NSTableView *externalTable;
	NSMutableArray *dataArray;
	NSArray *bitArray;
	KeyGenerate *keyClass;
	int keyAddModeInt;
	int keyMode;
	NSNumber *currentKeyLength;
}

@property (nonatomic,retain)NSMutableArray *dataArray;
@property int keyAddModeInt;
@property int keyMode;
@property (nonatomic,retain)NSArray *bitArray;
@property (nonatomic,retain)NSNumber *currentKeyLength;

-(IBAction)pushAddNewKey:(id)sender;
-(IBAction)pushGenerateSetupKey:(id)sender;
-(IBAction)pushChooseBit:(id)sender;
-(IBAction)pushCancelGenerate:(id)sender;
-(IBAction)pushDoneButton:(id)sender;
-(IBAction)pushCancelButton:(id)sender;
-(IBAction)pushShareByMailButton:(id)sender;
-(IBAction)removeItemFromExternalArray:(id)sender;
-(void)setupKeyPopUpButton;
-(void)setupBitPopupButton;


@end
