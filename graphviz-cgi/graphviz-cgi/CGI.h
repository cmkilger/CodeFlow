//  Created by Cory Kilger on 5/26/11.
//
//	Copyright (c) 2011 Cory Kilger
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import <Foundation/Foundation.h>


@interface CGI : NSObject

+ (CGI *) defaultCGI;

@property (nonatomic, retain, readonly) NSString * httpHost;
@property (nonatomic, retain, readonly) NSString * httpUserAgent;
@property (nonatomic, retain, readonly) NSString * httpAccept;
@property (nonatomic, retain, readonly) NSString * httpAcceptLanguage;
@property (nonatomic, retain, readonly) NSString * contentType;
@property (nonatomic, retain, readonly) NSString * httpCookie;
@property (nonatomic, retain, readonly) NSString * httpAcceptEncoding;
@property (nonatomic, retain, readonly) NSNumber * contentLength;
@property (nonatomic, retain, readonly) NSString * httpConnection;
@property (nonatomic, retain, readonly) NSString * path;
@property (nonatomic, retain, readonly) NSString * serverSignature;
@property (nonatomic, retain, readonly) NSString * serverSoftware;
@property (nonatomic, retain, readonly) NSString * serverName;
@property (nonatomic, retain, readonly) NSString * serverAddr;
@property (nonatomic, retain, readonly) NSNumber * serverPort;
@property (nonatomic, retain, readonly) NSString * remoteAddr;
@property (nonatomic, retain, readonly) NSString * documentRoot;
@property (nonatomic, retain, readonly) NSString * serverAdmin;
@property (nonatomic, retain, readonly) NSString * scriptFilename;
@property (nonatomic, retain, readonly) NSNumber * remotePort;
@property (nonatomic, retain, readonly) NSString * gatewayInterface;
@property (nonatomic, retain, readonly) NSString * serverProtocol;
@property (nonatomic, retain, readonly) NSString * requestMethod;
@property (nonatomic, retain, readonly) NSString * queryString;
@property (nonatomic, retain, readonly) NSString * requestUri;
@property (nonatomic, retain, readonly) NSString * scriptName;

@property (nonatomic, retain, readonly) NSData * content;
@property (nonatomic, retain, readonly) NSDictionary * allHeaderFields;

- (void) setValue:(NSString *)value forHeaderField:(NSString *)field;
- (void) print:(NSString *)format, ...;

@end
