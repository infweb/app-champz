//
//  ACApi.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACApi.h"
#import "AFNetworking.h"
#import "ACAtomFeedParser.h"

#define AC_API_BASE_URL_STRING @"http://www.infweb.net"
#define AC_API_DEFAULT_PER_PAGE 10

@implementation ACApi

+(ACApi *)api
{
    static ACApi *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ACApi alloc] initWithBaseURL:[NSURL URLWithString:AC_API_BASE_URL_STRING]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        // extra config
        [self registerHTTPOperationClass:[AFXMLRequestOperation class]];
        NSString *operatingSystemString;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            operatingSystemString = @"iPhone";
        } else {
            operatingSystemString = @"iPad";
        }
        
        operatingSystemString = [NSString stringWithFormat:@"iOS-%@", operatingSystemString];
        
        [self setDefaultHeader:@"X-Platform" value:operatingSystemString];
    }
    return self;
}

- (void)fetchAppsForPage:(NSInteger)page
                 success:(void (^)(NSArray *))successBlock
                 failure:(void (^)(NSError *))failureBlock;
{
    [self fetchAppsForPage:page by:AC_API_DEFAULT_PER_PAGE success:successBlock failure:failureBlock];
}

- (void)fetchAppsForPage:(NSInteger)page by:(NSInteger)numberOfApps
                 success:(void (^)(NSArray *))successBlock
                 failure:(void (^)(NSError *))failureBlock;
{
    NSString *path = [NSString stringWithFormat:@"/feed/atom/?paged=%d", page];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self
     getPath:path parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (successBlock) {
             NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
             ACAtomFeedParser *parserDelegate = [[ACAtomFeedParser alloc] init];
             parser.delegate = parserDelegate;
             if ([parser parse]) {
                 successBlock(parserDelegate.entries);
             } else if (failureBlock) {
                 failureBlock(parser.parserError);
             }
         }
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (operation.response.statusCode == 404 && successBlock) {
             successBlock([NSArray array]);
         } else if (failureBlock) {
             failureBlock(error);
         }
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }];
}
@end
