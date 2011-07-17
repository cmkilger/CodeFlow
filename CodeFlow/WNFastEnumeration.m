//
//  WNFastEnumeration.m
//  Walnut
//
//  Created by Cory Kilger on 7/4/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNFastEnumeration.h"
#import "WNCodeBlock.h"


@implementation WNFastEnumeration

@synthesize variableDeclaration;
@synthesize collection;
@synthesize statement;

- (void)dealloc {
	[variableDeclaration release];
	[collection release];
	[statement release];
	[super dealloc];
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendFormat:@"for (%@ in %@)", self.variableDeclaration, self.collection];
	if ([self.statement isKindOfClass:[WNCodeBlock class]]) {
		[string appendFormat:@" %@", [[self.statement prettyPrintWithIndentation:indentation] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	else {
		[string appendString:@"\n"];
		for (int i = 0; i < indentation; i++)
			[string appendString:@"\t"];
		[string appendString:self.statement.value];
	}
	return string;
}

#pragma mark -

- (NSString *)nodeDeclarations {
	NSMutableString * nodes = [NSMutableString string];
	[nodes appendFormat:@"\tnode node_%x_condition [label = \"%@ in %@\", shape = diamond];\n", self, [self.variableDeclaration stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""], [self.collection stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[nodes appendString:[self.statement nodeDeclarations]];
	return nodes;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	NSMutableString * edges = [NSMutableString string];
	[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"Yes\"];\n", self, [self.statement firstNode]];
	if (nextNode)
		[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"No\"];\n", self, nextNode];
	[edges appendString:[self.statement edgeDeclarationsToNode:[NSString stringWithFormat:@"node_%x_condition", self] breakNode:nextNode]];
	return edges;
}

- (NSString *)firstNode {
	return [NSString stringWithFormat:@"node_%x_condition", self];
}

@end
