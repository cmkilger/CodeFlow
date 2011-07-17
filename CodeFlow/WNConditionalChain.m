//
//  WNIfElseChain.m
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNConditionalChain.h"
#import "WNConditional.h"
#import "WNCodeBlock.h"


@implementation WNConditionalChain

@synthesize conditionals;
@synthesize elseStatement;

- (void)dealloc {
	[conditionals release];
	[elseStatement release];
    [super dealloc];
}

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	NSAssert([[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"if"], @"'%@' does not start with 'if'", [string substringFromIndex:*location]);
	
	NSMutableArray * conditionals = [NSMutableArray array];
	WNStatement * elseStatement = nil;
	while (*location < [string length]) {
		unichar character = [string characterAtIndex:*location];
		if (isspace(character)) {
			(*location)++;
			continue;
		}
		else if (character == 'i' && ([string length] - *location) >= 2 && [[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"if"]) {
			WNConditional * conditional = [WNConditional parseString:string location:location];
			if (conditional)
				[conditionals addObject:conditional];
		}
		else if (character == 'e' && ([string length] - *location) >= 4 && [[string substringWithRange:NSMakeRange(*location, 4)] isEqualToString:@"else"]) {
			*location += 4;
			while (*location < [string length]) {
				character = [string characterAtIndex:*location];
				if (!isspace(character))
					break;
				(*location)++;
			}
			if (character == 'i' && ([string length] - *location) >= 2 && [[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"if"]) {
				WNConditional * conditional = [WNConditional parseString:string location:location];
				if (conditional)
					[conditionals addObject:conditional];
			}
			else {
				elseStatement = [WNStatement parseString:string location:location];
                if (elseStatement)
                    break;
			}
		}
		else {
			break;
		}
	}
	
	WNConditionalChain * conditionalChain = [[WNConditionalChain alloc] init];
	conditionalChain.conditionals = conditionals;
	conditionalChain.elseStatement = elseStatement;
	
	return [conditionalChain autorelease];
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	BOOL firstDone = NO;
	for (WNConditional * conditional in self.conditionals) {
		if (firstDone) {
			[string appendString:@"\n"];
			for (int i = 0; i < indentation; i++)
				[string appendString:@"\t"];
			[string appendFormat:@"else %@", [[conditional prettyPrintWithIndentation:indentation] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
		else {
			[string appendString:[conditional prettyPrintWithIndentation:indentation]];
			firstDone = YES;
		}
	}
	if (elseStatement) {
		[string appendString:@"\n"];
		for (int i = 0; i < indentation; i++)
			[string appendString:@"\t"];
		[string appendString:@"else"];
		if ([elseStatement isKindOfClass:[WNCodeBlock class]]) {
			[string appendFormat:@" %@", [elseStatement prettyPrintWithIndentation:indentation]];
		}
		else {
			[string appendString:@"\n"];
			for (int i = 0; i < indentation; i++)
				[string appendString:@"\t"];
			[string appendString:elseStatement.value];
		}
	}
	return string;
}

- (NSString *)description {
	return [self prettyPrintWithIndentation:0];
}

#pragma mark -

- (NSString *)nodeDeclarations {
	NSMutableString * nodes = [NSMutableString string];
	for (WNConditional * conditional in conditionals)
		[nodes appendString:[conditional nodeDeclarations]];
	if (elseStatement)
		[nodes appendString:[elseStatement nodeDeclarations]];
	return nodes;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	NSMutableString * edges = [NSMutableString string];
	WNConditional * prevConditional = nil;
	for (WNConditional * conditional in conditionals) {
		NSString * firstNode = [conditional firstNode];
		if (prevConditional && firstNode)
			[edges appendString:[prevConditional edgeDeclarationsToTrueNode:nextNode falseNode:firstNode breakNode:breakNode]];
		prevConditional = conditional;
	}
	if (prevConditional) {
		if (elseStatement) {
			[edges appendString:[prevConditional edgeDeclarationsToTrueNode:nextNode falseNode:[elseStatement firstNode] breakNode:breakNode]];
			if (nextNode) {
				[edges appendString:[elseStatement edgeDeclarationsToNode:nextNode breakNode:breakNode]];
			}
		}
		else if (nextNode) {
			[edges appendString:[prevConditional edgeDeclarationsToTrueNode:nextNode falseNode:nextNode breakNode:breakNode]];
		}
	}
	return edges;
}

- (NSString *)firstNode {
	return [conditionals count] > 0 ? [[conditionals objectAtIndex:0] firstNode] : nil;
}

@end
