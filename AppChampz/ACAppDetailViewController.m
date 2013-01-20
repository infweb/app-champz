//
//  ACAppDetailViewController.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAppDetailViewController.h"

@interface ACAppDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *appDescriptionWebView;
@end

@implementation ACAppDetailViewController
@synthesize appDescription = _appDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"App Details";
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *html = [NSString stringWithFormat:
                      @"<!DOCTYPE html>"
                      "<html><head>"
                      "<meta charset=\"utf-8\">"
                      "<style type=\"text/css\"/>"
                      "body { font-family: Marker Felt }"
                      "</style>"
                      "</head>"
                      "<body>%@</body></html>", self.appDescription];
    [self.appDescriptionWebView loadHTMLString:html baseURL:nil];
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
@end
