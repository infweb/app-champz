//
//  ACAboutViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAboutViewController.h"

@interface ACAboutViewController ()
- (IBAction)closePressed:(id)sender;
- (IBAction)gotoWebsite:(id)sender;

@end

@implementation ACAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *bg = [[UIImage imageNamed:@"navbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    
    id titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-title.png"]];
    self.navigationItem.titleView = titleView;
    self.trackedViewName = @"About Page";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePressed:(id)sender {
    [self.delegate aboutViewControllerDidClose:self];
}

- (IBAction)gotoWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.infweb.net"]];
}

- (void)viewDidUnload
{
    self.delegate = nil;
    [super viewDidUnload];
}
@end
