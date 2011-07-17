//
//  WNBooleanExpression.m
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNBooleanExpression.h"


@implementation WNBooleanExpression

@synthesize expression;

- (void)dealloc {
	[expression release];
    [super dealloc];
}

@end
