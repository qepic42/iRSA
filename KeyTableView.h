//
//  PublicKeysTableView.h
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyDataModel.h"
#import "KeyGenerate.h"

@interface KeyTableView : NSObject <NSTableViewDelegate,NSTableViewDataSource> {
	IBOutlet NSButton *keyPopUpButton;
	IBOutlet NSButton *removeButton;
	NSMutableArray *dataArray;
	NSTableView *myTable;
	KeyDataModel *keyDataModel;
	KeyGenerate *keyClass;
}

@property (nonatomic,retain)	NSMutableArray *dataArray;
@property (nonatomic, assign)	IBOutlet NSTableView *myTable;

-(void)addItem:(NSNotification *)notification;
-(IBAction)pushAddNewKey:(id)sender;
-(IBAction)pushRemoveKey:(id)sender;
-(void)setupPopUpButton;

@end
