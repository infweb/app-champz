//
//  ACApp.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACApp.h"
@interface ACApp ()
- (NSDate *)dateFromString:(NSString *)dateString;
@end

@implementation ACApp
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.name = dictionary[@"title"];
        self.summary = dictionary[@"summary"];
        self.description = dictionary[@"content"];
    }
    return self;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    return nil;
}
@end
