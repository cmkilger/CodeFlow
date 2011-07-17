//
//  WNForLoop.m
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNForLoop.h"
#import "WNBooleanExpression.h"
#import "WNCodeBlock.h"
#import "WNFastEnumeration.h"
#import "RegexKitLite.h"


@implementation WNForLoop

@synthesize initialExpression;
@synthesize endExpression;

- (void)dealloc {
	[initialExpression release];
	[endExpression release];
    [super dealloc];
}

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	NSAssert([[string substringWithRange:NSMakeRange(*location, 3)] isEqualToString:@"for"], @"%@ does not start with 'for'", [string substringFromIndex:*location]);
	
	NSUInteger parenthesisCount = 0;
	NSUInteger firstParenthesisPos = -1;
	NSUInteger lastParenthesisPos = -1;
	for (NSUInteger pos = *location; pos < [string length]; pos++) {
		unichar character = [string characterAtIndex:pos];
		if (character == '(') {
			parenthesisCount++;
			if (firstParenthesisPos == -1 && character == '(')
				firstParenthesisPos = pos;
		}
		else if (character == ')') {
			if (parenthesisCount == 1) {
				lastParenthesisPos = pos;
				break;
			}
			parenthesisCount--;
		}
	}
	
	if (firstParenthesisPos == -1 || lastParenthesisPos == -1) {
		*location = [string length];
		return nil;
	}
	
	*location = lastParenthesisPos+1;
	
	NSString * insideParenthesis = [string substringWithRange:NSMakeRange(firstParenthesisPos+1, lastParenthesisPos-firstParenthesisPos-1)];
	NSArray * forComponents = [insideParenthesis componentsSeparatedByString:@";"];
	NSArray * enumerationComponents = [insideParenthesis componentsSeparatedByRegex:@"\\sin\\s"];
	if ([forComponents count] == 3) {
		WNForLoop * forLoop = [[WNForLoop alloc] init];
		WNBooleanExpression * condition = [[WNBooleanExpression alloc] init];
		forLoop.condition = condition;
		forLoop.initialExpression = [[forComponents objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		condition.expression = [[forComponents objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		forLoop.endExpression = [[forComponents objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[condition release];
		forLoop.statement = [WNStatement parseString:string location:location];
		return [forLoop autorelease];
	}
	else if ([enumerationComponents count] == 2) {
		WNFastEnumeration * fastEnumeration = [[WNFastEnumeration alloc] init];
		fastEnumeration.variableDeclaration = [[enumerationComponents objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		fastEnumeration.collection = [[enumerationComponents objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		fastEnumeration.statement = [WNStatement parseString:string location:location];
		return [fastEnumeration autorelease];
	}
	return nil;
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendFormat:@"for (%@; %@; %@)", self.initialExpression, self.condition.expression, self.endExpression];
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

- (NSString *)description {
	return [self prettyPrintWithIndentation:0];
}

#pragma mark -

- (NSString *)nodeDeclarations {
	NSMutableString * nodes = [NSMutableString string];
	[nodes appendFormat:@"\tnode node_%x_initial [label = \"%@\", shape = box];\n", self, [self.initialExpression stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[nodes appendFormat:@"\tnode node_%x_condition [label = \"%@\", shape = diamond];\n", self, [self.condition.expression stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[nodes appendFormat:@"\tnode node_%x_update [label = \"%@\", shape = box];\n", self, [self.endExpression stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[nodes appendString:[self.statement nodeDeclarations]];
	return nodes;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	NSMutableString * edges = [NSMutableString string];
	[edges appendFormat:@"\tnode_%x_initial -> node_%x_condition;\n", self, self];
	[edges appendFormat:@"\tnode_%x_update -> node_%x_condition;\n", self, self];
	[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"Yes\"];\n", self, [self.statement firstNode]];
	if (nextNode)
		[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"No\"];\n", self, nextNode];
	[edges appendString:[self.statement edgeDeclarationsToNode:[NSString stringWithFormat:@"node_%x_update", self] breakNode:nextNode]];
	return edges;
}

- (NSString *)firstNode {
	return [NSString stringWithFormat:@"node_%x_initial", self];
}

@end
