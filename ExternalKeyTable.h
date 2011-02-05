//
//  ExternalKeyTable.h
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ExternalKeyTable : NSObject <NSTableViewDelegate,NSTableViewDataSource,NSTabViewDelegate> {
	IBOutlet NSTableView *myTable;
	IBOutlet NSButton *removeButton;
	IBOutlet NSWindow *keyInfoSheet;
	IBOutlet NSWindow *mainKeyWindow;
	IBOutlet NSBox *infoBox;
	IBOutlet NSTextField *infoBoxExternLabel;
	IBOutlet NSTextView *publicKeyView;
	IBOutlet NSMenu *personPopupMenu;
	IBOutlet NSPopUpButtonCell *personPopupButton;
	NSString *currentPerson;
	int currentPersonIndex;
}

@property(nonatomic,retain)NSString *currentPerson;
@property()int currentPersonIndex;

-(IBAction)pushRemoveKey:(id)sender;
-(IBAction)pushChoosePerson:(id)sender;
-(void)setupKeyPopUpButton;
-(void)doubleClickToRow:(NSTableView *)sender;
-(void)addItem:(NSNotification *)notification;
-(void)reloadTable;

@end
