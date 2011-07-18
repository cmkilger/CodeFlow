//
//  NSData+Gzip.h
//  tmxparse
//
//  Created by Cory Kilger on 2/16/10.
//  Copyright 2010 Rivetal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Gzip)

// gzip compression utilities
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;

@end