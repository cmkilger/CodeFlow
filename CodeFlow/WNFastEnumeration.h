//
//  WNFastEnumeration.h
//  Walnut
//
//  Created by Cory Kilger on 7/4/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNStatement.h"


@interface WNFastEnumeration : WNStatement

@property (retain) NSString * variableDeclaration;
@property (retain) NSString * collection;
@property (retain) WNStatement * statement;

@end
