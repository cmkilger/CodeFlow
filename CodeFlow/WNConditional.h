//
//  WNConditional.h
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNStatement.h"

@class WNBooleanExpression;

@interface WNConditional : WNStatement

@property (retain) WNBooleanExpression * condition;
@property (retain) WNStatement * statement;

- (NSString *)edgeDeclarationsToTrueNode:(NSString *)trueNode falseNode:(NSString *)falseNode breakNode:(NSString *)breakNode;

@end
