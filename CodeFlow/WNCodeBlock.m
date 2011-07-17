//
//  WNCodeBlock.m
//  Walnut
//
//  Created by Cory Kilger on 7/3/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNCodeBlock.h"


@implementation WNCodeBlock

@synthesize statements;

- (void)dealloc {
	[statements release];
	[super dealloc];
}

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	NSAssert([string characterAtIndex:*location] == '{', @"String should start with '{', is %@", [string substringFromIndex:*location]);
	
	(*location)++;
	NSMutableArray * statements = [NSMutableArray array];
	while (*location < [string length]) {
		unichar character = [string characterAtIndex:*location];
		if (isspace(character)) {
			(*location)++;
		}
		else if (character == '}') {
			(*location)++;
			WNCodeBlock * codeBlock = [[WNCodeBlock alloc] init];
			codeBlock.statements = [NSArray arrayWithArray:statements];
			return [codeBlock autorelease];
		}
		else {
			WNStatement * statement = [WNStatement parseString:string location:location];
			if (statement)
				[statements addObject:statement];
		}
	}
	
	return nil;
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendString:@"{"];
	for (WNStatement * statement in self.statements) {
		[string appendString:@"\n"];
		[string appendString:[statement prettyPrintWithIndentation:indentation+1]];
	}
	[string appendString:@"\n"];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendString:@"}"];
	return string;
}

- (NSString *)description {
	return [self prettyPrintWithIndentation:0];
}

#pragma mark -

- (NSString *)nodeDeclarations {
	NSMutableString * nodes = [NSMutableString string];
	for (WNStatement * statement in statements)
		[nodes appendString:[statement nodeDeclarations]];
	return nodes;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	NSMutableString * edges = [NSMutableString string];
	WNStatement * prevStatement = nil;
	for (WNStatement * statement in statements) {
		NSString * firstNode = [statement firstNode];
		if (prevStatement && firstNode)
			[edges appendString:[prevStatement edgeDeclarationsToNode:firstNode breakNode:breakNode]];
		prevStatement = statement;
	}
	if (prevStatement && nextNode)
		[edges appendString:[prevStatement edgeDeclarationsToNode:nextNode breakNode:breakNode]];
	return edges;
}

- (NSString *)firstNode {
	WNStatement * firstStatement = ([statements count] > 0) ? [statements objectAtIndex:0] : nil;
	return [firstStatement firstNode];
}

@end
