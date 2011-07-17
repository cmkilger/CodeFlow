//
//  WNComment.m
//  Walnut
//
//  Created by Cory Kilger on 7/5/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "WNComment.h"


@implementation WNComment

+ (id) parseString:(NSString *)string location:(NSUInteger *)location {
	if ([[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"//"]) {
        while (*location < [string length]) {
            unichar character = [string characterAtIndex:*location];
            if (character == '\n' || character == '\r')
                return nil;
            (*location)++;
        }
    }
    else if ([[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"/*"]) {
        while (*location < [string length]) {
            unichar character = [string characterAtIndex:*location];
            if (character == '*' && ([string length] - *location) >= 2 && [[string substringWithRange:NSMakeRange(*location, 2)] isEqualToString:@"*/"]) {
                (*location) += 2;
                return nil;
            }
            (*location)++;
        }
    }
    
	return nil;
}

@end
