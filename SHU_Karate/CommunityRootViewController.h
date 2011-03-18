//
//  CommunityRootViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityRootTableCell.h"
#import "TextViewController.h"
@interface CommunityRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
   
    CommunityRootTableCell *_tempCell;
    NSArray *_rootDataArray;
    NSString *selectedTitle;
    UITableView *tableView;

    NSArray *texts;
    TextViewController *textViewController;
}
@property (nonatomic, retain) NSArray *_rootDataArray;
@property (nonatomic, assign) IBOutlet CommunityRootTableCell *_tempCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSString *selectedTitle;
@property (nonatomic, retain) NSArray *texts;
@property (nonatomic, retain) TextViewController *textViewController;
@end
