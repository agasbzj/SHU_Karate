//
//  DojoSelectViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dojos.h"

@class DojoMapViewController;


@interface DojoSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>{
    
    UITableView *tableView;
   
    NSArray *groupKeys;
    NSDictionary *names;
    DojoMapViewController *mapViewController;

    NSMutableArray *dojoList;
    UINavigationController *dojoListNavigationController;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dojoList;
@property (nonatomic, retain) NSArray *groupKeys;
@property (nonatomic, retain) NSDictionary *names;
@property (nonatomic, retain) UINavigationController *dojoListNavigationController;
@property (nonatomic, retain) DojoMapViewController *mapViewController;
@end

