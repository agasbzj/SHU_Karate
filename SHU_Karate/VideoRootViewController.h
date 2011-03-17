//
//  VideoRootViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"

@interface VideoRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *videoListTableView;
    NSString *name;
    NSDictionary *nameDic;
    NSArray *groupKeys;
    VideoViewController *videoController;
}
@property (nonatomic, retain) IBOutlet UITableView *videoListTableView;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *groupKeys;
@property (nonatomic, retain) NSDictionary *nameDic;
@property (nonatomic, retain) VideoViewController *videoController;
@end
