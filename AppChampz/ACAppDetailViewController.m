//
//  ACAppDetailViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAppDetailViewController.h"
#import "ACAboutViewController.h"
#import "ACMainViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "ACApp.h"
#import "ACApi.h"

@interface ACAppDetailViewController () <UIWebViewDelegate, ACAboutViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *appDescriptionWebView;

- (void)pullLeftPressed:(id)sender;
- (IBAction)aboutPressed:(id)sender;
@end

@implementation ACAppDetailViewController

- (void)setAppDescription:(NSString *)appDescription
{
    if (_appDescription != appDescription) {
        _appDescription = appDescription;
        [self updateOutlets];
    }
}

- (void)setAppTitle:(NSString *)appTitle
{
    if (_appTitle != appTitle) {
        _appTitle = appTitle;
        [self updateOutlets];
    }
}

- (void)requestLatestAppSuccess:(void (^)(NSError *))callback;
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:@"LatestAppFetch"];
    if (!date) date = [NSDate dateWithTimeIntervalSince1970:0];
    [[ACApi api] fetchLatestAppFromDate:date
                                success:^(NSHTTPURLResponse *response, ACApp *app) {
                                    if (app)
                                        [self loadDataFromApp:app];
                                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
                                    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                                    NSDate *date = [df dateFromString:[response allHeaderFields][@"Last-Modified"]];
                                    [defaults setObject:date forKey:@"LatestAppFetch"];
                                    [defaults synchronize];
                                    callback(nil);
                                }
                                failure:^(NSHTTPURLResponse *response, NSError *error) {
                                    NSLog(@"ERROR!");
                                    callback(error);
                                }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"App Details";
    UIImage *bg = [[UIImage imageNamed:@"navbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    id titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-title.png"]];
    [self.navigationController.navigationBar setBackgroundImage:bg
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"applist-button.png"]
                                     style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(pullLeftPressed:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithWhite:0.22 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    [self.appDescriptionWebView.scrollView addPullToRefreshWithActionHandler:^{
        [self requestLatestAppSuccess:^(NSError *error) {
            [self.appDescriptionWebView.scrollView.pullToRefreshView stopAnimating];
        }];
        
    }];
    [self.appDescriptionWebView.scrollView triggerPullToRefresh];
}

- (void)updateOutlets
{
    NSString *html = @"";
    if (self.appTitle && self.appDescription) {
        html = [NSString stringWithFormat:
                @"<!DOCTYPE html>"
                "<html><head>"
                "<meta charset=\"utf-8\">"
                "</head>"
                "<body><h1>%@</h1>%@</body></html>",
                self.appTitle,
                self.appDescription];
    }
    [self.appDescriptionWebView loadHTMLString:html baseURL:nil];
}

- (void)loadDataFromApp:(ACApp *)app
{
    self.appTitle = app.name;
    self.appDescription = app.description;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateOutlets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAppDescriptionWebView:nil];
    [super viewDidUnload];
}

- (void)pullLeftPressed:(id)sender
{
    [self.delegate detailViewControllerPressedPullLeft:self];
}

- (IBAction)aboutPressed:(id)sender {
    [self.delegate detailViewControllerPressedPressedAbout:self];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

#pragma mark ACAboutViewControllerDelegate
- (void)aboutViewControllerDidClose:(ACAboutViewController *)aboutViewController
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
