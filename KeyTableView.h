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
	IBOutlet NSTabView *keyAddMode;
	IBOutlet NSWindow *infoSheet;
	IBOutlet NSBox *infoBox;
	IBOutlet NSTextView *publicKeyView;
	IBOutlet NSTabView *keyModeTab;
	NSMutableArray *dataArray;
	NSTableView *myTable;
	NSTableView *otherTable;
	NSArray *bitArray;
	KeyGenerate *keyClass;
	int keyAddModeInt;
	NSNumber *currentKeyLength;
}

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic, assign)IBOutlet NSTableView *myTable;
@property (nonatomic, assign)IBOutlet NSTableView *otherTable;
@property int keyAddModeInt;
@property (nonatomic,retain)NSArray *bitArray;
@property (nonatomic,retain)NSNumber *currentKeyLength;

-(IBAction)pushAddNewKey:(id)sender;
-(IBAction)pushRemoveKey:(id)sender;
-(IBAction)pushGenerateSetupKey:(id)sender;
-(IBAction)pushChooseBit:(id)sender;
-(IBAction)pushCancelGenerate:(id)sender;
-(IBAction)doubleClickAction:(NSTableView *)sender;
-(IBAction)pushDoneButton:(id)sender;
-(IBAction)pushCancelButton:(id)sender;
-(IBAction)pushShareByMailButton:(id)sender;
-(void)addItem:(NSNotification *)notification;
-(void)setupKeyPopUpButton;
-(void)setupBitPopupButton;
-(void)doubleClickToRow:(NSTableView *)sender;


@end
