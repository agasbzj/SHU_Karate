//
//  ImageDownloader.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneItem.h"
@class UtilityRootViewController;

@protocol ImageDownloaderDelegate; 
@interface ImageDownloader : NSObject {
    
    OneItem *oneItem;
    NSIndexPath *indexPath;
    id <ImageDownloaderDelegate> delegate;
    
    NSMutableData *imageData;
    NSURLConnection *urlConnection;
}

@property (nonatomic, retain) OneItem *oneItem;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) NSURLConnection *urlConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloaderDelegate

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end


