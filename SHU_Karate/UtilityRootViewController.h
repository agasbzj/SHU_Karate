//
//  UtilityRootViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseOperation.h"
#import "ImageDownloader.h"

@interface UtilityRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, UIActionSheetDelegate, ImageDownloaderDelegate, UIScrollViewDelegate>{
    UITableView *tableView;
    
    NSURLConnection *itemFeedConnection;
    
    NSOperationQueue *parseQueue;
    
    NSMutableData *itemData;    //接收XML下载数据
    
    NSMutableArray *itemList;   //用于在tableview中显示的数据列表
    NSDateFormatter *dateFormatter;
    
    NSMutableDictionary *imageDownloadInProgress;   //接收图片下载数据
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSURLConnection *itemFeedConnection;
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) NSMutableData *itemData;
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadInProgress;

- (void)addItemToList:(NSArray *)items;
- (void)handleError:(NSError *)error;
- (void)insertItems:(NSArray *)items;
- (void)loadImagesForOnscreenRows;
- (void)startImageDownload:(OneItem *)item forIndexPath:(NSIndexPath *)indexPath;
@end
