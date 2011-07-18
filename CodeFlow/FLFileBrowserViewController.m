//
//  FLFileBrowserViewController.m
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "FLFileBrowserViewController.h"
#import "FLFlowchartViewController.h"

@implementation FLFileBrowserViewController
		
@synthesize flowchartViewController, folder;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	// Configure the cell.
	cell.imageView.image = [UIImage imageNamed:@"icn_New_File.m_512.png"];
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"AdjustHSL.m";
			break;
		case 1:
			cell.textLabel.text = @"ImageBlending.m";
			break;
		case 2:
			cell.textLabel.text = @"RGBtoHSL.m";
			break;
		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			[flowchartViewController setFile:[[NSBundle mainBundle] pathForResource:@"adjusthsl.txt" ofType:nil]];
			break;
		case 1:
			[flowchartViewController setFile:[[NSBundle mainBundle] pathForResource:@"RGBtoHSL.txt" ofType:nil]];
			break;
		case 2:
			[flowchartViewController setFile:[[NSBundle mainBundle] pathForResource:@"imageblending.txt" ofType:nil]];
			break;
		default:
			break;
	}
}

- (void)dealloc {
	[flowchartViewController release];
    [super dealloc];
}

@end
