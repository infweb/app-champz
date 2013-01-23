//
//  ACMainViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/23/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACMainViewController.h"
#import "ACAppDetailViewController.h"
#import "ACAppsViewController.h"
#import "ACAboutViewController.h"

@interface ACMainViewController ()
    <ACAppDetailViewControllerDelegate, ACAppsViewControllerDelegate,
     ACAboutViewControllerDelegate> {
    BOOL _isRootVisible;
}

@end

@implementation ACMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationController *rootNavigationController =
    [self.storyboard
     instantiateViewControllerWithIdentifier:@"appDetailViewController"];
    UINavigationController *leftNavigationController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"appsListViewController"];
    
    ACAppDetailViewController *vc1 = rootNavigationController.viewControllers[0];
    ACAppsViewController *vc2 = leftNavigationController.viewControllers[0];
    
    vc1.delegate = self;
    vc2.delegate = self;
    _isRootVisible = YES;
    self.leftViewController = leftNavigationController;
    self.rootViewController = rootNavigationController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ACAppDetailViewControllerDelegate
- (void)detailViewControllerPressedPullLeft:(ACAppDetailViewController *)viewController
{
    [self showLeftController:YES];
}

- (void)detailViewControllerPressedPressedAbout:(ACAppDetailViewController *)viewController
{
    id nvc = [self.storyboard
              instantiateViewControllerWithIdentifier:@"aboutViewController"];
    ACAboutViewController *avc = [nvc viewControllers][0];
    avc.delegate = self;
    [self presentModalViewController:nvc animated:YES];
}

#pragma mark ACAppsViewControllerDelegate
- (void)appsViewController:(ACAppsViewController *)viewController didSelectApp:(ACApp *)app
{
    ACAppDetailViewController *vc = [(UINavigationController *)self.rootViewController viewControllers][0];
    [vc loadDataFromApp:app];
    [self showRootController:YES];
}

#pragma mark ACAboutViewControllerDelegate
- (void)aboutViewControllerDidClose:(ACAboutViewController *)aboutViewController
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
