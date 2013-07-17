//
//  ACTemplate.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 7/16/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACTemplate.h"

#define START_TOKEN @"\\{\\{"
#define END_TOKEN @"\\}\\}"

@interface ACTemplate ()
-(void)setContents:(NSString *)contents;
@end

@implementation ACTemplate

-(void)setContents:(NSString *)contents
{
    _contents = contents;
}

-(id)initWithString:(NSString *)contents
{
    if (self = [super init]) {
        self.contents = contents;
    }
    return self;
}

- (void)replaceVariable:(NSString *)name withValue:(id)value
{
    NSString *raw = [NSString stringWithFormat:@"%@\\W*%@\\W*%@", START_TOKEN, name, END_TOKEN];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:raw
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    if (!error) {
        NSArray *ranges = [regex matchesInString:self.contents options:0
                                           range:NSMakeRange(0, self.contents.length)];
        
        for (NSTextCheckingResult *match in ranges) {
            self.contents = [self.contents stringByReplacingCharactersInRange:match.range withString:value];
        }
    }
}

-(NSString *)renderWithContext:(NSDictionary *)context
{
    ACTemplate *copy = [self copy];
    for (NSString *key in context) {
        [copy replaceVariable:key withValue:context[key]];
    }
    return copy.contents;
}

- (id)copyWithZone:(NSZone *)zone
{
    ACTemplate *newTemplate = [[ACTemplate allocWithZone:zone]
                               initWithString:[self.contents copyWithZone:zone]];
    return newTemplate;
}

+(NSString *)renderTemplate:(NSString *)tmpl withContext:(NSDictionary *)context
{
    ACTemplate *t = [[ACTemplate alloc] initWithString:tmpl];
    return [t renderWithContext:context];
}
@end
