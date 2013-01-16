//
//  ACApi.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface ACApi : AFHTTPClient

+ (ACApi *)api;

- (void)fetchAppsForPage:(NSInteger)page by:(NSInteger)numberOfApps
                 success:(void (^)(NSArray *))successBlock
                 failure:(void (^)(NSError *))failureBlock;
- (void)fetchAppsForPage:(NSInteger)page
                 success:(void (^)(NSArray *))successBlock
                 failure:(void (^)(NSError *))failureBlock;

@end
