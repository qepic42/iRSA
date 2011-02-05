//
//  DarkMainController.m
//  iRSA
//
//  Created by Jan Galler on 05.02.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "DarkMainController.h"

static DarkMainController *_sharedMainDarkWindowController = nil;

@implementation DarkMainController

+ (DarkMainController *)sharedMainDarkWindowController{
	if (!_sharedMainDarkWindowController) {
		_sharedMainDarkWindowController = [[self alloc] initWithWindowNibName:[self nibName]];
	}
	return _sharedMainDarkWindowController;
}

+ (NSString *)nibName
{
	return @"DarkMain";
}

@end
