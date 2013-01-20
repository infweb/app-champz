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

@end

@implementation ACAboutViewController

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

- (void)viewDidUnload
{
    self.delegate = nil;
    [super viewDidUnload];
}
@end
