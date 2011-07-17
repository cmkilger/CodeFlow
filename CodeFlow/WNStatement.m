//
//  WNCodeComponent.m
//  Walnut
//
//  Created by Cory Kilger on 6/13/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNStatement.h"
#import "WNWhileLoop.h"
#import "WNBooleanExpression.h"
#import "WNCodeBlock.h"
#import "WNConditionalChain.h"
#import "WNForLoop.h"
#import "WNReturn.h"
#import "WNComment.h"
#import "WNBreak.h"


@implementation WNStatement

@synthesize value;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
	[value release];
    [super dealloc];
}

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	
	// TODO: switch
	
	NSInteger startPos = -1;
	while (*location < [string length]) {
		unichar character = [string characterAtIndex:*location];
		if (startPos != -1);
		else if (isspace(character)) {
			(*location)++;
			continue;
		}
		else if (character == 'w' && ([string length] - *location) >= 5 && [[string substringWithRange:NSMakeRange(*location, 5)] isEqualToString:@"while"]) {
			return [WNWhileLoop parseString:string location:location];
		}
		else if (character == 'i' && ([string length] - *location) >= 2 && [[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"if"]) {
			return [WNConditionalChain parseString:string location:location];
		}
		else if (character == 'f' && ([string length] - *location) >= 3 && [[string substringWithRange:NSMakeRange(*location, 3)] isEqualToString:@"for"]) {
			return [WNForLoop parseString:string location:location];
		}
		else if (character == 'r' && ([string length] - *location) >= 6 && [[string substringWithRange:NSMakeRange(*location, 6)] isEqualToString:@"return"]) {
			return [WNReturn parseString:string location:location];
		}
		else if (character == 'b' && ([string length] - *location) >= 5 && [[string substringWithRange:NSMakeRange(*location, 5)] isEqualToString:@"break"]) {
			return [WNBreak parseString:string location:location];
		}
		else if (character == '{') {
			return [WNCodeBlock parseString:string location:location];
		}
		else if (character == '/') {
			return [WNComment parseString:string location:location];
		}
		
		// Single statement
		if (startPos == -1) {
			startPos = *location;
		}
		if (startPos != -1 && character == ';') {
			(*location)++;
			WNStatement * statement = [[WNStatement alloc] init];
			statement.value = [string substringWithRange:NSMakeRange(startPos, *location-startPos)];
            if ([statement.value hasPrefix:@"else "])
                NSLog(@"sdfg kjhdsfkgjhdfgkdfd");
			return [statement autorelease];
		}
		
		(*location)++;
	}
	return nil;
}

+ (id) statementWithString:(NSString *)string {
	NSUInteger location = 0;
	return [self parseString:[NSString stringWithFormat:@"%@", string] location:&location];
}

- (NSString *)prettyPrintWithIndentation:(NSUInteger)indentation {
	NSMutableString * string = [NSMutableString string];
	for (int i = 0; i < indentation; i++)
		[string appendString:@"\t"];
	[string appendString:self.value];
	return string;
}

- (NSString *)description {
	return [self prettyPrintWithIndentation:0];
}

#pragma mark -

- (NSString *)graph {
	NSMutableString * graph = [NSMutableString string];
	[graph appendString:@"digraph {\n"];
	[graph appendString:@"\tnode node_start [label = \"Start\", shape = ellipse];\n"];
	[graph appendString:@"\tnode node_end [label = \"End\", shape = ellipse];\n"];
	[graph appendString:[self nodeDeclarations]];
	[graph appendFormat:@"\tnode_start -> %@;\n", [self firstNode]];
	[graph appendString:[self edgeDeclarationsToNode:@"node_end" breakNode:@"node_end"]];
	[graph appendString:@"}\n"];
	return graph;
}

- (NSString *)nodeDeclarations {
    if ([self.value hasPrefix:@"else"])
        NSLog(@"sdflgk hdsfkjgh dsfk");
	return [NSString stringWithFormat:@"\tnode %@ [label = \"%@\", shape = box];\n", [self firstNode], [self.value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	return [NSString stringWithFormat:@"\t%@ -> %@;\n", [self firstNode], nextNode];
}

- (NSString *)firstNode {
	return [NSString stringWithFormat:@"node_%x", self];
}

@end
