//
//  ACAtomFeedParser.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAtomFeedParser.h"
#import "ACApp.h"

@interface ACAtomFeedParser() {
    BOOL _isInAuthor;
}

@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableDictionary *currentEntry;
@property (nonatomic, strong) NSMutableArray *mutableEntries;
@end


@implementation ACAtomFeedParser
- (NSArray *)entries
{
    return [NSArray arrayWithArray:self.mutableEntries];
}

- (NSMutableArray *)mutableEntries {
    if (!_mutableEntries){
        _mutableEntries = [NSMutableArray array];
    }
    return _mutableEntries;
}

- title
{
    if (!_title) _title = @"";
    return _title;
}

- subtitle
{
    if (!_subtitle) _subtitle = @"";
    return _subtitle;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"%@%@", self.currentEntry ? @"\t" : @"", elementName);
    self.currentElement = elementName;
    
    if (self.currentEntry) {
        // ... process entry feed
        if ([elementName isEqualToString:@"author"]) {
            _isInAuthor = YES;
        }
    } else if ([elementName isEqualToString:@"entry"]) {
        self.currentEntry = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"entry"] && self.currentEntry) {
        ACApp *app = [[ACApp alloc] initWithDictionary:self.currentEntry];
        [self.mutableEntries addObject:app];
        self.currentEntry = nil;
    }
    
    if ([elementName isEqualToString:@"author"] && self.currentEntry) {
        _isInAuthor = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)characters
{
    NSString *string = [characters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length) {
        if (self.currentEntry) {
            NSString *value = self.currentEntry[self.currentElement];
            if (!value) value = @"";
            value = [value stringByAppendingString:string];
            [self.currentEntry setObject:value forKey:self.currentElement];
        } else if ([self.currentElement isEqualToString:@"title"]) {
            self.title = [self.title stringByAppendingString:string];
        } else if ([self.currentElement isEqualToString:@"subtitle"]) {
            self.subtitle = [self.subtitle stringByAppendingString:string];
        } else if ([self.currentElement isEqualToString:@"id"]) {
            self.feedId = [NSURL URLWithString:string];
        }
    }
}
@end
