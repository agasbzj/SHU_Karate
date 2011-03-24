//
//  ParseOperation.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneItem.h"
extern NSString *kAddItemsNotif;
extern NSString *kItemResultsKey;

extern NSString *kItemsErrorNotif;
extern NSString *kItemsMsgErrorKey;



@protocol ParseOperationDelegate <NSObject>

- (void)getAParsedItem:(OneItem *)item;

@end

@interface ParseOperation : NSOperation <NSXMLParserDelegate>{
    id <ParseOperationDelegate> delegate;
    NSData *itemData;
    
    NSDateFormatter *dateFormatter;
    OneItem *currentItemObject;
    
    NSMutableArray *currentParseBatch;
    NSMutableString *currentParsedCharacterData;
    
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
    
    NSUInteger parsedItemsCounter;
    NSString *m_currentParse;
}

@property (copy, readonly) NSData *itemData;
@property (nonatomic, retain) OneItem *currentItemObject;
@property (nonatomic, retain) NSMutableArray *currentParseBatch;
@property (nonatomic, retain) NSMutableString *currentParsedCharacterData;
@property (nonatomic, retain) NSString *m_currentParse;
@property (nonatomic, retain) id <ParseOperationDelegate> delegate;


@end
