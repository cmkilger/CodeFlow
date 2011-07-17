//
//  RootViewController.h
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {

}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
