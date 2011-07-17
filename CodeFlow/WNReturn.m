//
//  WNReturn.m
//  Walnut
//
//  Created by Cory Kilger on 7/5/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNReturn.h"


@implementation WNReturn

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	NSInteger startPos = *location;
	while (*location < [string length]) {
		unichar character = [string characterAtIndex:*location];
		if (character == ';') {
			(*location)++;
			WNReturn * statement = [[WNReturn alloc] init];
			statement.value = [string substringWithRange:NSMakeRange(startPos, *location-startPos)];
			return [statement autorelease];
		}
		(*location)++;
	}
	return nil;
}

- (NSString *)edgeDeclarationsToNode:(NSString *)nextNode breakNode:(NSString *)breakNode {
	return [NSString stringWithFormat:@"%@ -> node_end;\n", [self firstNode]];
}

@end
