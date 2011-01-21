//
//  KeyClass.h
//  iRSA
//
//  Created by Jan Galler on 16.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrimClass.h"

@interface KeyGenerate : NSObject {
	int Q;
	int P;
	long long N;
	long long Phi;
	long long E;
	long long D;
	PrimClass *primClass;
}

@property() int Q;
@property() int P;
@property() long long N;
@property() long long Phi;
@property() long long E;
@property() long long D;

-(void)generateKey;

@end
