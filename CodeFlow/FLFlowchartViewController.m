//
//  FLFlowchartViewController.m
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "FLFlowchartViewController.h"
#import "FLFileBrowserViewController.h"
#import "NSData+Gzip.h"
#import "NSData+Base64.h"
#import "WNStatement.h"


@interface FLFlowchartViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSMutableData * data;

@end


@implementation FLFlowchartViewController

@synthesize toolbar;
@synthesize detailDescriptionLabel;
@synthesize popoverController;
@synthesize webView;
@synthesize activityIndicator;
@synthesize data;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc {
    barButtonItem.title = @"Files";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

#pragma mark - View cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.popoverController = nil;
	self.detailDescriptionLabel = nil;
}

#pragma mark - Set file

// !!!: This all assumes the view is loaded

- (void)setFile:(NSString *)filePath {
	self.detailDescriptionLabel.hidden = YES;
	self.webView.alpha = 0.0;
	[self.activityIndicator startAnimating];
	
	NSString * input = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    WNStatement * statement = [WNStatement statementWithString:input];
    input = [statement graph];
	NSData * content = [input dataUsingEncoding:NSUTF8StringEncoding];
	content = [content gzipDeflate];
	NSString * requestBodyString = [content base64EncodedString];
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://Gideon.local/cgi-bin/graphviz-cgi"]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[requestBodyString dataUsingEncoding:NSUTF8StringEncoding]];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
	[self.data appendData:newData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
	
	if ([string isEqualToString:@"ERROR"]) {
		[string release];
		[self.activityIndicator stopAnimating];
		[[[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There was an error generating the flowchart." delegate:nil cancelButtonTitle:@"Bummer." otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSData * content = [NSData dataFromBase64String:string];
	content = [content gzipInflate];
	NSString * filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	filePath = [filePath stringByAppendingPathComponent:@"flowchart.pdf"]; // TODO: use a more dynamic path
	[content writeToFile:filePath atomically:YES];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.activityIndicator stopAnimating];
	[[[[UIAlertView alloc] initWithTitle:@"Network error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ah, man." otherButtonTitles:nil] autorelease] show];
}

#pragma mark Web view dlegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIView animateWithDuration:0.15 animations:^(void) {
		self.webView.alpha = 1.0;
	}];
	[self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There was an error loading the flowchart." delegate:nil cancelButtonTitle:@"Sheesh." otherButtonTitles:nil] autorelease] show];
}

#pragma mark - Memory management

- (void)dealloc {
	[popoverController release];
	[toolbar release];
	[detailDescriptionLabel release];
	[webView release];
	[activityIndicator release];
	[data release];
    [super dealloc];
}

@end
