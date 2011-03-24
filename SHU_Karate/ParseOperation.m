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
@synthesize m_currentParse;
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
    [m_currentParse release];
    [super dealloc];
}

#pragma mark -
#pragma mark Parser constants

// Limit the number of parsed earthquakes to 50
// (a given day may have more than 50 earthquakes around the world, so we only take the first 50)
//
static const const NSUInteger kMaximumNumberOfItemsToParse = 50;

// When an Earthquake object has been fully constructed, it must be passed to the main thread and
// the table view in RootViewController must be reloaded to display it. It is not efficient to do
// this for every Earthquake object - the overhead in communicating between the threads and reloading
// the table exceed the benefit to the user. Instead, we pass the objects in batches, sized by the
// constant below. In your application, the optimal batch size will vary 
// depending on the amount of data in the object and other factors, as appropriate.
//
static NSUInteger const kSizeOfItemBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"entry";
//static NSString * const kLinkElementName = @"link";
static NSString * const kNameElementName = @"name";
static NSString * const kTitleElementName = @"title";
static NSString * const kCategoryElementName = @"category";
static NSString * const kArtistElementName = @"artist";
static NSString * const kPriceElementName = @"price";
static NSString * const kImageElementName = @"image height=\"60\"";

#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    m_currentParse = elementName;
    
    
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
//    if ([elementName isEqualToString:kEntryElementName]) {
//          OneItem *oneItem = [[OneItem alloc] init];
//        self.currentItemObject = oneItem;
//        [oneItem release];
//    } 
//    else if ([elementName isEqualToString:kLinkElementName]) {
//        NSString *relAttribute = [attributeDict valueForKey:@"rel"];
//        if ([relAttribute isEqualToString:@"alternate"]) {
//            NSString *USGSWebLink = [attributeDict valueForKey:@"href"];
//            self.currentItemObject.USGSWebLink = [NSURL URLWithString:USGSWebLink];
//        }
//    } 
//    else if ([elementName isEqualToString:kTitleElementName] ||
//               [elementName isEqualToString:kUpdatedElementName] ||
//               [elementName isEqualToString:kGeoRSSPointElementName]) {
//        // For the 'title', 'updated', or 'georss:point' element begin accumulating parsed character data.
//        // The contents are collected in parser:foundCharacters:.
//        accumulatingParsedCharacterData = YES;
//        // The mutable string needs to be reset to empty.
//        [currentParsedCharacterData setString:@""];
//    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([m_currentParse isEqualToString:@"artist"]) {
        currentItemObject.artist = string;
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.currentParseBatch addObject:self.currentItemObject];
        parsedItemsCounter++;
        if ([self.currentParseBatch count] >= kMaximumNumberOfItemsToParse) {
            [self performSelectorOnMainThread:@selector(addItemsToList::)
                                   withObject:self.currentParseBatch
                                waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    } 
    else if ([elementName isEqualToString:@"artist"]){
        [delegate getAParsedItem:currentItemObject];
        
    }
//    else if ([elementName isEqualToString:kTitleElementName]) {
//        // The title element contains the magnitude and location in the following format:
//        // <title>M 3.6, Virgin Islands region<title/>
//        // Extract the magnitude and the location using a scanner:
//        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
//        // Scan past the "M " before the magnitude.
//        if ([scanner scanString:@"M " intoString:NULL]) {
//            CGFloat magnitude;
//            if ([scanner scanFloat:&magnitude]) {
//                self.currentItemObject.magnitude = magnitude;
//                // Scan past the ", " before the title.
//                if ([scanner scanString:@", " intoString:NULL]) {
//                    NSString *location = nil;
//                    // Scan the remainer of the string.
//                    if ([scanner scanUpToCharactersFromSet:
//                         [NSCharacterSet illegalCharacterSet] intoString:&location]) {
//                        self.currentEarthquakeObject.location = location;
//                    }
//                }
//            }
//        }
//    } 
//    else if ([elementName isEqualToString:kUpdatedElementName]) {
//        if (self.currentItemObject != nil) {
//            self.currentItemObject.date =
//            [dateFormatter dateFromString:self.currentParsedCharacterData];
//        }
//        else {
//            // kUpdatedElementName can be found outside an entry element (i.e. in the XML header)
//            // so don't process it here.
//        }
//    } else if ([elementName isEqualToString:kGeoRSSPointElementName]) {
//        // The georss:point element contains the latitude and longitude of the earthquake epicenter.
//        // 18.6477 -66.7452
//        //
//        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
//        double latitude, longitude;
//        if ([scanner scanDouble:&latitude]) {
//            if ([scanner scanDouble:&longitude]) {
//                self.currentEarthquakeObject.latitude = latitude;
//                self.currentEarthquakeObject.longitude = longitude;
//            }
//        }
//    }
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}
//
//// This method is called by the parser when it find parsed character data ("PCDATA") in an element.
//// The parser is not guaranteed to deliver all of the parsed character data for an element in a single
//// invocation, so it is necessary to accumulate character data until the end of the element is reached.
////
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    if (accumulatingParsedCharacterData) {
//        // If the current element is one whose content we care about, append 'string'
//        // to the property that holds the content of the current element.
//        //
//        [self.currentParsedCharacterData appendString:string];
//    }
//}

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
