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
@property (weak, nonatomic) IBOutlet UITextView *aboutDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutTitleLabel;

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
    [self setAboutDescriptionLabel:nil];
    [self setAboutTitleLabel:nil];
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [UIView animateWithDuration:duration animations:^{
            self.aboutDescriptionLabel.alpha = 0;
            self.aboutTitleLabel.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.aboutDescriptionLabel.alpha = 1.0;
            self.aboutTitleLabel.alpha = 1.0;
        }];
    }
}
@end
