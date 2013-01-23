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
#import "ACApp.h"

#define AC_API_BASE_URL_STRING @"http://www.infweb.net"
#define AC_API_DEFAULT_PER_PAGE 10

@interface ACApi ()
- (void)startNetworkActivity;
- (void)stopNetworkActivity;
@end

@implementation ACApi

- (void)startNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

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
        
        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:404];
        [acceptableStatusCodes addIndex:304];
        
        [self setDefaultHeader:@"X-Platform" value:operatingSystemString];
        [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/atom+xml"]];
        [AFXMLRequestOperation addAcceptableStatusCodes:acceptableStatusCodes];
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
    [self startNetworkActivity];
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
         [self stopNetworkActivity];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (operation.response.statusCode == 404 && successBlock) {
             successBlock([NSArray array]);
         } else if (failureBlock) {
             failureBlock(error);
         }
         [self stopNetworkActivity];
     }];
}

- (void)fetchLatestAppFromDate:(NSDate *)date success:(void (^)(NSHTTPURLResponse *, ACApp *))successBlock
                       failure:(void (^)(NSHTTPURLResponse *, NSError *))failureBlock;
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"feed/atom"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[df stringFromDate:date] forHTTPHeaderField:@"If-Modified-Since"];
    
    AFXMLRequestOperation *operation;
    operation = [AFXMLRequestOperation
                 XMLParserRequestOperationWithRequest:request
                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                     NSArray *entries = [self entriesWithParser:XMLParser];
                     if (entries.count && successBlock) successBlock(response, entries[0]);
                     else if (successBlock) successBlock(response, nil);
                     [self stopNetworkActivity];
                 }
                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                     if (failureBlock) failureBlock(response, error);
                     [self stopNetworkActivity];
                 }];
    
    [self startNetworkActivity];
    [operation start];
}

- (NSArray *)entriesWithParser:(NSXMLParser *)parser
{
    ACAtomFeedParser *parserDelegate = [[ACAtomFeedParser alloc] init];
    parser.delegate = parserDelegate;
    if ([parser parse]) {
        return parserDelegate.entries;
    }
    return nil;
}
@end
