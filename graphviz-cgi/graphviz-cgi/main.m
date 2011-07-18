//
//  main.m
//  graphviz-cgi
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVGraph.h"
#import "CGI.h"
#import "NSData+Gzip.h"
#import "NSData+Base64.h"

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSData * content = [[CGI defaultCGI] content];
	NSString * contentString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
	//NSString * contentString = @"H4sICHlQeU0AA0F2YW50R2FyZGUuZ3YA3ZJJT4NAGIbPzK+YcLYpXW7CJGxiFUul"
//								"uOthkCkzFgZKp4ua/vdCTRON2uiJhMub+db3y5OJWFzgnL4DqQNbCHYr6VXSPwZl"
//								"7gFOMi44Tokm60vMhYOLiLSMLJvKcE5xTrQwW8MViwTVFEgJi6koHykuYsY1WTlS"
//								"ZCAlOCSJpqqBbrg2NDzfsv2yJkPTdt192PkIxyPdHAydqoyApAY+UgMLfTNX22W2"
//								"FP9Lk2Fa9olzOjhzz92LoTe69MfB1fXN7d39zwM4fI7IJKbsJZkmKc/yWTEXi+Vq"
//								"/fr2b4dH/udt7R0IhJ4qxt0DjL0wYbMFqRX1/obmEO/9QtwiKasN9c68OYz7BxjX"
//								"/as/39AY4mADtoCCMYvMBQAA";
	
	content = [NSData dataFromBase64String:contentString];
	content = [content gzipInflate];
	
	GVGraph * graph = [[GVGraph alloc] initWithData:content error:nil];
	[graph.arguments setValue:@"dot" forKey:@"layout"];
	content = [graph renderWithFormat:@"pdf:quartz"];
	content = [content gzipDeflate];
	
	if (!content) {
		[[CGI defaultCGI] print:@"ERROR"];
		exit(-1);
	}
	
	[[CGI defaultCGI] print:@"%@", [content base64EncodedString]];
	
	[contentString release];
	[pool drain];
	
    return 0;
}

