//
//  ACAtomFeedParser.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAtomFeedParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong, readonly) NSArray *entries;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSURL *feedId;
@end
