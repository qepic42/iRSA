//
//  Preferences Controller.h
//  iRSA
//
//  Created by Jan Galler on 26.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSWindowController <NSToolbarDelegate> {

	IBOutlet NSToolbar *prefsBar;
	IBOutlet NSView	   *generalPreferenceView;
	IBOutlet NSView	   *advancedPreferenceView;
	IBOutlet NSView	   *updatePreferencesView;

	
	NSInteger currentViewTag;
	
}

- (IBAction)switchView:(id)sender;
+ (PreferencesController *)sharedPrefsWindowController;
+ (NSString *)nibName;

@end
