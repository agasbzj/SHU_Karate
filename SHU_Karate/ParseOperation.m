//
//  ParseOperation.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ParseOperation.h"
#import "OneItem.h"
NSString *kAddItemsNotif = @"AddItemsNotif";
NSString *kItemsErrorNotif = @"ItemsErrorNotif";
NSString *kItemResultsKey = @"ItemResultsKey";
NSString *kItemsMsgErrorKey = @"ItemsMsgErrorKey";
@implementation ParseOperation
@synthesize itemData, currentItemObject, currentParseBatch, currentParsedCharacterData;

- (id)initWithData:(NSData *)parseData
{
    if (self = [super init]) {    
        itemData = [parseData copy];
        
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+8]];
//        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    }
    return self;
}

- (void)addItemsToList:(NSArray *)items {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddItemsNotif
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:items
                                                                                           forKey:kItemResultsKey]]; 
}

// the main function for this NSOperation, to start the parsing
- (void)main {
    self.currentParseBatch = [NSMutableArray array];
    self.currentParsedCharacterData = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is
    // not desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.itemData];
    [parser setDelegate:self];
    [parser parse];
    
    // depending on the total number of earthquakes parsed, the last batch might not have been a
    // "full" batch, and thus not been part of the regular batch transfer. So, we check the count of
    // the array and, if necessary, send it to the main thread.
    //
    if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addItemsToList:)
                               withObject:self.currentParseBatch
                            waitUntilDone:NO];
    }
    
    self.currentParseBatch = nil;
    self.currentItemObject = nil;
    self.currentParsedCharacterData = nil;
    
    [parser release];
}
- (void)dealloc {
    [itemData release];
    
    [currentItemObject release];
    [currentParsedCharacterData release];
    [currentParseBatch release];
    [dateFormatter release];
    [super dealloc];
}

#pragma mark -
#pragma mark Parser constants

//解析总数的限制。
static const const NSUInteger kMaximumNumberOfItemsToParse = 30;


//解析多少个为一批传送过去并更新表试图
static NSUInteger const kSizeOfItemBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"entry";
static NSString * const kNameElementName = @"im:name";
static NSString * const kTitleElementName = @"title";
static NSString * const kCategoryElementName = @"category";
static NSString * const kArtistElementName = @"im:artist";
static NSString * const kPriceElementName = @"im:price";
static NSString * const kImageElementName = @"im:image";

//static NSString * const kImageElementName = @"image height=\"60\"";

#pragma mark -
#pragma mark NSXMLParser delegate methods

//节点开始
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {

    accumulatingParsedCharacterData = NO;
    // If the number of parsed earthquakes is greater than
    // kMaximumNumberOfEarthquakesToParse, abort the parse.
    //
    if (parsedItemsCounter >= kMaximumNumberOfItemsToParse) {
        // Use the flag didAbortParsing to distinguish between this deliberate stop
        // and other parser errors.
        //
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kEntryElementName]) {
          OneItem *oneItem = [[OneItem alloc] init];
        self.currentItemObject = oneItem;
        [oneItem release];
    } 
    else if ([elementName isEqualToString:kCategoryElementName]) {
        NSString *categoryValue = [attributeDict valueForKey:@"label"];
        self.currentItemObject.category = categoryValue;
    } 
    else if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kNameElementName] ||[elementName isEqualToString:kArtistElementName] || [elementName isEqualToString:kPriceElementName]) {

        // The contents are collected in parser:foundCharacters:.
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [currentParsedCharacterData setString:@""];

    }
    else if ([elementName isEqualToString:kImageElementName]) {
        if ([[attributeDict valueForKey:@"height"] isEqualToString:@"60"]) {
            accumulatingParsedCharacterData = YES;
            [currentParsedCharacterData setString:@""];
        }
    }

}

//解析字符串
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (accumulatingParsedCharacterData) {
        [self.currentParsedCharacterData appendString:string]; 
    }
}

//一个节点完毕
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.currentParseBatch addObject:self.currentItemObject];
        parsedItemsCounter++;
        if ([self.currentParseBatch count] >= kSizeOfItemBatch) {
            [self performSelectorOnMainThread:@selector(addItemsToList:)
                                   withObject:self.currentParseBatch
                                waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    } 
    else if ([elementName isEqualToString:kNameElementName]) {
        NSString *tmpString = [currentParsedCharacterData copy];
        self.currentItemObject.name = tmpString;
        [tmpString release];
//        self.currentItemObject.name = currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kArtistElementName]) {
        NSString *tmpString = [currentParsedCharacterData copy];
        self.currentItemObject.artist = tmpString;
        [tmpString release];
//        self.currentItemObject.artist = currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kPriceElementName]) {
        NSString *tmpString = [currentParsedCharacterData copy];
        self.currentItemObject.price = tmpString;
        [tmpString release];
//        self.currentItemObject.price = currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kTitleElementName]) {
        NSString *tmpString = [currentParsedCharacterData copy];
        self.currentItemObject.title = tmpString;
        [tmpString release];
//        self.currentItemObject.title = currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kImageElementName] && accumulatingParsedCharacterData) {
        NSString *tmpString = [currentParsedCharacterData copy];
        self.currentItemObject.image = tmpString;
        [tmpString release];
//        self.currentItemObject.image = currentParsedCharacterData;
    }
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
    [currentParsedCharacterData setString:@""];
}


// an error occurred while parsing the earthquake data,
// post the error as an NSNotification to our app delegate.
// 
- (void)handleItemsError:(NSError *)parseError {
    [[NSNotificationCenter defaultCenter] postNotificationName:kItemsErrorNotif
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:parseError
                                                                                           forKey:kItemsMsgErrorKey]];
}

// an error occurred while parsing the earthquake data,
// pass the error to the main thread for handling.
// (note: don't report an error if we aborted the parse due to a max limit of earthquakes)
//
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing)
    {
        [self performSelectorOnMainThread:@selector(handleItemsError::)
                               withObject:parseError
                            waitUntilDone:NO];
    }
}

@end
