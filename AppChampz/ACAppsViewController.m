//
//  ACViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAppsViewController.h"
#import "ACAboutViewController.h"
#import "ACAppDetailViewController.h"
#import "ACApi.h"
#import "ACApp.h"

@interface ACAppsViewController () <ACAboutViewControllerDelegate>
@property (nonatomic, strong) NSArray* appCollection;

@end

@implementation ACAppsViewController
@synthesize appCollection = _appCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ACApi api]
     fetchAppsForPage:1 success:^(NSArray *apps) {
         self.appCollection = apps;
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", @"Error Message Title")
                                     message:[error localizedDescription]
                                    delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button")
                           otherButtonTitles:nil] show];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"app"];
    ACApp *app = [self.appCollection objectAtIndex:indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.summary;
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
        ACApp *app = [self.appCollection objectAtIndex:currentSelection];
        ACAppDetailViewController *advc = segue.destinationViewController;
        advc.navigationItem.title = app.name;
        advc.appDescription = app.description;
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
