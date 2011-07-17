//
//  RootViewController.m
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"

@implementation RootViewController
		
@synthesize detailViewController, folder;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

		
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			[detailViewController setFile:[[NSBundle mainBundle] pathForResource:@"adjusthsl.pdf" ofType:nil]];
			break;
		case 1:
			[detailViewController setFile:[[NSBundle mainBundle] pathForResource:@"RGBtoHSL.pdf" ofType:nil]];
			break;
		case 2:
			[detailViewController setFile:[[NSBundle mainBundle] pathForResource:@"imageblending.pdf" ofType:nil]];
			break;
			
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
	[detailViewController release];
    [super dealloc];
}

@end
