//
//  ACTemplate.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 7/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACTemplate : NSObject <NSCopying>
@property (nonatomic, strong, readonly) NSString *contents;

-(id)initWithString:(NSString *)contents;
-(void)replaceVariable:(NSString *)name withValue:(NSString *)value;
-(NSString *)renderWithContext:(NSDictionary *)context;

+(NSString *)renderTemplate:(NSString *)tmpl withContext:(NSDictionary *)context;
@end
