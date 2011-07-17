//
//  WNConditional.m
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNConditional.h"
#import "WNBooleanExpression.h"
#import "WNCodeBlock.h"


@implementation WNConditional

@synthesize condition;
@synthesize statement;

- (void)dealloc {
	[condition release];
	[statement release];
    [super dealloc];
}

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	NSAssert([[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"if"], @"'%@' does not start with 'if'", [string substringFromIndex:*location]);
	
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
	
	WNConditional * ifStatement = [[WNConditional alloc] init];
	WNBooleanExpression * condition = [[WNBooleanExpression alloc] init];
	condition.expression = [string substringWithRange:NSMakeRange(firstParenthesisPos+1, lastParenthesisPos-firstParenthesisPos-1)];
	ifStatement.condition = condition;
	ifStatement.statement = [WNStatement parseString:string location:location];
	[condition release];
	
	return [ifStatement autorelease];
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendFormat:@"if (%@)", self.condition.expression];
	if ([self.statement isKindOfClass:[WNCodeBlock class]]) {
		[string appendFormat:@" %@", [[self.statement prettyPrintWithIndentation:indentation] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	else {
		[string appendString:@"\n"];
		for (int i = 0; i <= indentation; i++)
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
	[nodes appendFormat:@"\tnode node_%x_condition [label = \"%@\", shape = diamond];\n", self, [self.condition.expression stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[nodes appendString:[self.statement nodeDeclarations]];
	return nodes;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
    [NSException raise:@"WNNotImplementedException" format:@"%@ should not be used. Use -edgeDeclarationsToTrueNode:fasleNode instead"];
    return nil;
}

- (NSString *)edgeDeclarationsToTrueNode:(NSString *)trueNode falseNode:(NSString *)falseNode breakNode:(NSString *)breakNode {
	NSMutableString * edges = [NSMutableString string];
	[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"Yes\"];\n", self, [self.statement firstNode]];
	if (trueNode)
		[edges appendFormat:@"\tnode_%x_condition -> %@ [label = \"No\"];\n", self, falseNode];
	[edges appendString:[self.statement edgeDeclarationsToNode:trueNode breakNode:breakNode]];
	return edges;
}

- (NSString *)firstNode {
	return [NSString stringWithFormat:@"node_%x_condition", self];
}

@end
