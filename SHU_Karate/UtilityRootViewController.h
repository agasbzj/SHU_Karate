//
//  UtilityRootViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseOperation.h"

@interface UtilityRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, UIActionSheetDelegate, ParseOperationDelegate>{
    UITableView *tableView;
    
    NSURLConnection *itemFeedConnection;
    NSOperationQueue *parseQueue;
    NSMutableData *itemData;
    
    NSMutableArray *itemList;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSURLConnection *itemFeedConnection;
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) NSMutableData *itemData;
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;

- (void)addItemToList:(NSArray *)items;
- (void)handleError:(NSError *)error;
- (void)insertItems:(NSArray *)items;
@end
