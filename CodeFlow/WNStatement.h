//
//  WNCodeComponent.h
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WNStatement : NSObject

@property (retain) NSString * value;

+ (id) statementWithString:(NSString *)string;
+ (id) parseString:(NSString *)string location:(NSUInteger *)location;

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation;

- (NSString *)graph;
- (NSString *)nodeDeclarations;
- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode;
- (NSString *)firstNode;

@end
