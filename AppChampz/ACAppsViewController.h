//
//  ACViewController.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACAppsViewController;
@class ACApp;

@protocol ACAppsViewControllerDelegate <NSObject>
- (void)appsViewController:(ACAppsViewController *)viewController didSelectApp:(ACApp *)app;
@end

@interface ACAppsViewController : UITableViewController

@property (nonatomic, weak) id<ACAppsViewControllerDelegate> delegate;
@end
