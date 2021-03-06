//
//  CodeFlowAppDelegate.h
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLFileBrowserViewController;
@class FLFlowchartViewController;

@interface FLAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet FLFileBrowserViewController *rootViewController;
@property (nonatomic, retain) IBOutlet FLFlowchartViewController *detailViewController;

@end
