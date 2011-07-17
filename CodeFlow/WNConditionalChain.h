//
//  WNIfElseChain.h
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNStatement.h"

@class WNBooleanExpression;

@interface WNConditionalChain : WNStatement

@property (retain) NSArray * conditionals;
@property (retain) WNStatement * elseStatement;

@end
