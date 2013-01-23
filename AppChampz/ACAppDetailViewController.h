//
//  ACAppDetailViewController.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class ACApp;

@class ACAppDetailViewController;

@protocol ACAppDetailViewControllerDelegate <NSObject>
- (void)detailViewControllerPressedPullLeft:(ACAppDetailViewController *)viewController;
- (void)detailViewControllerPressedPressedAbout:(ACAppDetailViewController *)viewController;
@end

@interface ACAppDetailViewController : GAITrackedViewController
@property (nonatomic, strong) NSString *appDescription;
@property (nonatomic, strong) NSString *appTitle;
@property (nonatomic, weak) id<ACAppDetailViewControllerDelegate> delegate;

- (void)loadDataFromApp:(ACApp *)app;
@end
