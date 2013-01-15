//
//  ACViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAppsViewController.h"
#import "ACAboutViewController.h"

@interface ACAppsViewController () <ACAboutViewControllerDelegate>
@property (nonatomic, strong) NSArray* appCollection;

@end

@implementation ACAppsViewController
@synthesize appCollection = _appCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appCollection = [NSArray arrayWithObjects:@"App 1", @"App 2", @"App 3", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"app"];
    cell.textLabel.text = [self.appCollection objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appCollection.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showApp"]) {
        NSInteger currentSelection = [self.tableView indexPathForSelectedRow].row;
        [segue.destinationViewController navigationItem].title =
        [self.appCollection objectAtIndex:currentSelection];
    } else if ([segue.identifier isEqualToString:@"showAbout"]) {
        UINavigationController *nvc = segue.destinationViewController;
        ACAboutViewController* vc = [nvc.viewControllers objectAtIndex:0];
        vc.delegate = self;
    }
}

- (void)aboutViewControllerDidClose:(ACAboutViewController *)aboutViewController
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
