//
//  ACApp.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACApp : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *screenshotURL;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
