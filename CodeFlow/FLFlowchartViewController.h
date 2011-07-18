//
//  FLFlowchartViewController.h
//  CodeFlow
//
//  Created by Cory Kilger on 7/17/11.
//  Copyright 2011 Cory Kilger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLFlowchartViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicator;

- (void)setFile:(NSString *)filePath;

@end
