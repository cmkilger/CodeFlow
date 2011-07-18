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

#import "CGI.H"

static CGI * defaultCGI = nil;


@interface CGI ()

@property (nonatomic, retain) NSMutableDictionary * header;
@property (nonatomic, assign) BOOL printedHeader;

- (id) initPrivately; // We don't override init, which can be called externally

@end


@implementation CGI

@synthesize header, printedHeader;

+ (CGI *) defaultCGI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCGI = [[super allocWithZone:nil] initPrivately];
    });
    return defaultCGI;
}

- (id)initPrivately {
    if (!(self = [super init]))
        return nil;
    self.header = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - Singleton

// Methods that assist this class in acting as a singleton
+ (id)allocWithZone:(NSZone*)zone { return defaultCGI; }
- (id)copyWithZone:(NSZone *)zone { return self; }
- (id)retain { return self; }
- (NSUInteger)retainCount { return UINT_MAX; }
- (void)release {}
- (id)autorelease { return self; }

#pragma mark - Properties

- (NSString *) httpHost {
	static NSString * httpHost = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpHost = [[NSString alloc] initWithCString:getenv("HTTP_HOST") encoding:NSUTF8StringEncoding];
	});
	return httpHost;
}

- (NSString *) httpUserAgent {
	static NSString * httpUserAgent = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpUserAgent = [[NSString alloc] initWithCString:getenv("HTTP_USER_AGENT") encoding:NSUTF8StringEncoding];
	});
	return httpUserAgent;
}

- (NSString *) httpAccept {
	static NSString * httpAccept = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpAccept = [[NSString alloc] initWithCString:getenv("HTTP_ACCEPT") encoding:NSUTF8StringEncoding];
	});
	return httpAccept;
}

- (NSString *) httpAcceptLanguage {
	static NSString * httpAcceptLanguage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpAcceptLanguage = [[NSString alloc] initWithCString:getenv("HTTP_ACCEPT_LANGUAGE") encoding:NSUTF8StringEncoding];
	});
	return httpAcceptLanguage;
}

- (NSString *) contentType {
	static NSString * contentType = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		contentType = [[NSString alloc] initWithCString:getenv("CONTENT_TYPE") encoding:NSUTF8StringEncoding];
	});
	return contentType;
}

- (NSString *) httpCookie {
	static NSString * httpCookie = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpCookie = [[NSString alloc] initWithCString:getenv("HTTP_COOKIE") encoding:NSUTF8StringEncoding];
	});
	return httpCookie;
}

- (NSString *) httpAcceptEncoding {
	static NSString * httpAcceptEncoding = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpAcceptEncoding = [[NSString alloc] initWithCString:getenv("HTTP_ACCEPT_ENCODING") encoding:NSUTF8StringEncoding];
	});
	return httpAcceptEncoding;
}

- (NSNumber *) contentLength {
	static NSNumber * contentLength = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        NSString * string = [[NSString alloc] initWithCString:getenv("CONTENT_LENGTH") encoding:NSUTF8StringEncoding];
		contentLength = (string) ? [[NSNumber alloc] initWithInteger:[string integerValue]] : nil;
        [string release];
	});
	return contentLength;
}

- (NSString *) httpConnection {
	static NSString * httpConnection = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		httpConnection = [[NSString alloc] initWithCString:getenv("HTTP_CONNECTION") encoding:NSUTF8StringEncoding];
	});
	return httpConnection;
}

- (NSString *) path {
	static NSString * path = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		path = [[NSString alloc] initWithCString:getenv("PATH") encoding:NSUTF8StringEncoding];
	});
	return path;
}

- (NSString *) serverSignature {
	static NSString * serverSignature = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverSignature = [[NSString alloc] initWithCString:getenv("SERVER_SIGNATURE") encoding:NSUTF8StringEncoding];
	});
	return serverSignature;
}

- (NSString *) serverSoftware {
	static NSString * serverSoftware = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverSoftware = [[NSString alloc] initWithCString:getenv("SERVER_SOFTWARE") encoding:NSUTF8StringEncoding];
	});
	return serverSoftware;
}

- (NSString *) serverName {
	static NSString * serverName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverName = [[NSString alloc] initWithCString:getenv("SERVER_NAME") encoding:NSUTF8StringEncoding];
	});
	return serverName;
}

- (NSString *) serverAddr {
	static NSString * serverAddr = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverAddr = [[NSString alloc] initWithCString:getenv("SERVER_ADDR") encoding:NSUTF8StringEncoding];
	});
	return serverAddr;
}

- (NSNumber *) serverPort {
	static NSNumber * serverPort = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        NSString * string = [[NSString alloc] initWithCString:getenv("SERVER_PORT") encoding:NSUTF8StringEncoding];
		serverPort = (string) ? [[NSNumber alloc] initWithInteger:[string integerValue]] : nil;
        [string release];
	});
	return serverPort;
}

- (NSString *) remoteAddr {
	static NSString * remoteAddr = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		remoteAddr = [[NSString alloc] initWithCString:getenv("REMOTE_ADDR") encoding:NSUTF8StringEncoding];
	});
	return remoteAddr;
}

- (NSString *) documentRoot {
	static NSString * documentRoot = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		documentRoot = [[NSString alloc] initWithCString:getenv("DOCUMENT_ROOT") encoding:NSUTF8StringEncoding];
	});
	return documentRoot;
}

- (NSString *) serverAdmin {
	static NSString * serverAdmin = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverAdmin = [[NSString alloc] initWithCString:getenv("SERVER_ADMIN") encoding:NSUTF8StringEncoding];
	});
	return serverAdmin;
}

- (NSString *) scriptFilename {
	static NSString * scriptFilename = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		scriptFilename = [[NSString alloc] initWithCString:getenv("SCRIPT_FILENAME") encoding:NSUTF8StringEncoding];
	});
	return scriptFilename;
}

- (NSNumber *) remotePort {
	static NSNumber * remotePort = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        NSString * string = [[NSString alloc] initWithCString:getenv("REMOTE_PORT") encoding:NSUTF8StringEncoding];
		remotePort = (string) ? [[NSNumber alloc] initWithInteger:[string integerValue]] : nil;
        [string release];
	});
	return remotePort;
}

- (NSString *) gatewayInterface {
	static NSString * gatewayInterface = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gatewayInterface = [[NSString alloc] initWithCString:getenv("GATEWAY_INTERFACE") encoding:NSUTF8StringEncoding];
	});
	return gatewayInterface;
}

- (NSString *) serverProtocol {
	static NSString * serverProtocol = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		serverProtocol = [[NSString alloc] initWithCString:getenv("SERVER_PROTOCOL") encoding:NSUTF8StringEncoding];
	});
	return serverProtocol;
}

- (NSString *) requestMethod {
	static NSString * requestMethod = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		requestMethod = [[NSString alloc] initWithCString:getenv("REQUEST_METHOD") encoding:NSUTF8StringEncoding];
	});
	return requestMethod;
}

- (NSString *) queryString {
	static NSString * queryString = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		queryString = [[NSString alloc] initWithCString:getenv("QUERY_STRING") encoding:NSUTF8StringEncoding];
	});
	return queryString;
}

- (NSString *) requestUri {
	static NSString * requestUri = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		requestUri = [[NSString alloc] initWithCString:getenv("REQUEST_URI") encoding:NSUTF8StringEncoding];
	});
	return requestUri;
}

- (NSString *) scriptName {
	static NSString * scriptName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		scriptName = [[NSString alloc] initWithCString:getenv("SCRIPT_NAME") encoding:NSUTF8StringEncoding];
	});
	return scriptName;
}

#pragma mark - Header & Content 

- (NSData *) content {
    static NSData * content = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileHandle * input = [NSFileHandle fileHandleWithStandardInput];
        content = [[input readDataToEndOfFile] retain];
    });
    return content;
}

- (NSDictionary *)allHeaderFields {
    return [NSDictionary dictionaryWithDictionary:self.header];
}

- (void) setValue:(NSString *)value forHeaderField:(NSString *)field {
    NSAssert(printedHeader == NO, @"Cannot change the header after printing");
    [header setValue:value forKey:field];
}

- (void) print:(NSString *)format, ... {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [header enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop) {
            const char * field = [[key description] cStringUsingEncoding:NSUTF8StringEncoding];
            const char * value = [[obj description] cStringUsingEncoding:NSUTF8StringEncoding];
            printf("%s: %s\n", field, value);
        }];
        printf("\n");
    });
    
    va_list arguments;
    va_start(arguments, format);
    NSString * string = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    printf("%s", [string cStringUsingEncoding:NSUTF8StringEncoding]);
    [string release];
}

@end
