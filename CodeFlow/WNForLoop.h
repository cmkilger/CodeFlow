//
//  WNForLoop.h
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNWhileLoop.h"


@interface WNForLoop : WNWhileLoop

@property (retain) NSString * initialExpression;
@property (retain) NSString * endExpression;

@end
