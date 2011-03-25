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





@interface ParseOperation : NSOperation <NSXMLParserDelegate>{

    NSData *itemData;
    
    NSDateFormatter *dateFormatter;
    OneItem *currentItemObject;
    
    NSMutableArray *currentParseBatch;  //当前缓存
    NSMutableString *currentParsedCharacterData;    //当前解析的字符串
    
    BOOL accumulatingParsedCharacterData;   //是否堆积当前解析的字符
    BOOL didAbortParsing;
    
    NSUInteger parsedItemsCounter;

}

@property (copy, readonly) NSData *itemData;
@property (nonatomic, retain) OneItem *currentItemObject;
@property (nonatomic, retain) NSMutableArray *currentParseBatch;
@property (nonatomic, retain) NSMutableString *currentParsedCharacterData;




@end
