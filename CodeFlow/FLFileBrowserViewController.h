//
//  FLFileBrowserViewController.h
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLFlowchartViewController;

@interface FLFileBrowserViewController : UITableViewController
		
@property (nonatomic, retain) IBOutlet FLFlowchartViewController *flowchartViewController;
@property (nonatomic, retain) NSString * folder;

@end
