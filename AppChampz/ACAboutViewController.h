//
//  ACAboutViewController.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACAboutViewController;

@protocol ACAboutViewControllerDelegate <NSObject>
- (void)aboutViewControllerDidClose:(ACAboutViewController *)aboutViewController;
@end

@interface ACAboutViewController : UIViewController
@property (nonatomic, weak) id<ACAboutViewControllerDelegate> delegate;
@end
