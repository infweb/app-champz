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
@synthesize name = _name, screenshotURL = _screenshotURL,
            summary = _summary, description = _description;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.name = [dictionary objectForKey:@"title"];
        self.summary = [dictionary objectForKey:@"summary"];
        self.description = [dictionary objectForKey:@"content"];
    }
    return self;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    return nil;
}
@end
