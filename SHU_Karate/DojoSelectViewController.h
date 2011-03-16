//
//  DojoSelectViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dojos.h"
#import "DojoMapViewController.h"

@protocol DojoSelectViewControllerDelegate;
@interface DojoSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *tableView;
   
    NSArray *groupKeys;
    NSDictionary *names;
    //DojoMapViewController *mapViewController;
    id <DojoSelectViewControllerDelegate> delegate;
    NSMutableArray *dojoList;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dojoList;
@property (nonatomic, retain) NSArray *groupKeys;
@property (nonatomic, retain) NSDictionary *names;

@end

@protocol DojoSelectViewControllerDelegate

- (void)DojoSelectViewController:(DojoSelectViewController *)controller didChooseDojo:(Dojos *)aDojo;

@end