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
#import "GAI.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define kLoadingTag 4688

@interface ACAppsViewController () <ACAboutViewControllerDelegate> {
    BOOL _isLoading;
}

@property (nonatomic, strong) NSMutableArray* appCollection;
@property (nonatomic) NSInteger currentPage;
@end

@implementation ACAppsViewController

- (void)fetchAppsForPagePage:(NSInteger)page clearCurrent:(BOOL)clear
{
    [self fetchAppsForPagePage:page clearCurrent:clear callback:nil];
}

- (void)refreshRequested
{
    self.currentPage = 1;
    [self fetchAppsForPagePage:1 clearCurrent:YES callback:^{
        if ([self respondsToSelector:@selector(refreshControl)]) {
            [self.refreshControl endRefreshing];
        } else {
            [self.tableView.pullToRefreshView stopAnimating];
        }
    }];
}

- (void)fetchAppsForPagePage:(NSInteger)page clearCurrent:(BOOL)clear callback:(void (^)(void))callback
{
    if (_isLoading) return;
    _isLoading = YES;
    [[ACApi api]
     fetchAppsForPage:page success:^(NSArray *apps) {
         _isLoading = NO;
         if (clear) self.appCollection = [NSMutableArray array];
         
         self.appCollection = [[self.appCollection arrayByAddingObjectsFromArray:apps] mutableCopy];
         
         if (apps.count > 0)
             [self.tableView reloadData];
         if (callback) callback();
     }
     failure:^(NSError *error) {
         _isLoading = NO;
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", @"Error Message Title")
                                     message:[error localizedDescription]
                                    delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"OK", @"Cancel Button")
                           otherButtonTitles:nil] show];
         if (callback) callback();
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appCollection = [NSMutableArray array];

    __block ACAppsViewController *this = self;
    
    if ([self respondsToSelector:@selector(refreshControl)]) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshRequested)
                      forControlEvents:UIControlEventValueChanged];
    } else {
        [self.tableView addPullToRefreshWithActionHandler:^{
            [this refreshRequested];
        }];
    }
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [this fetchAppsForPagePage:++this.currentPage clearCurrent:NO callback:^{
            [this.tableView.infiniteScrollingView stopAnimating];
        }];
    }];
    
    [self fetchAppsForPagePage:++self.currentPage clearCurrent:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GAI sharedInstance].defaultTracker sendView:@"Apps List"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAppAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"app"];
    ACApp *app = [self.appCollection objectAtIndex:indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.summary;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForAppAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return self.currentPage ? self.appCollection.count + 1 : 1;
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
