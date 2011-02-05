//
//  InternalKeyTable.h
//  iRSA
//
//  Created by Jan Galler on 02.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InternalKeyTable : NSObject  <NSTableViewDelegate,NSTableViewDataSource,NSTabViewDelegate>  {
	IBOutlet NSTableView *myTable;
	IBOutlet NSButton *removeButton;
	IBOutlet NSWindow *keyInfoSheet;
	IBOutlet NSTextField *infoBoxExternLabel;
	IBOutlet NSWindow *mainKeyWindow;
	IBOutlet NSBox *infoBox;
	IBOutlet NSTextView *publicKeyView;
}

-(IBAction)pushRemoveKey:(id)sender;
-(void)setupKeyPopUpButton;
-(void)doubleClickToRow:(NSTableView *)sender;
-(void)addItem:(NSNotification *)notification;
-(void)reloadTable;

@end
