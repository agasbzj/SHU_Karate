//
//  DojoSelectViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MapKit.h>

@interface DojoSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    //MKPlacemark *placeMark;
    UITableView *tableView;
    UIBarButtonItem *selectButton;
    NSArray *groupKeys;
    NSDictionary *names;
    
}
//@property (nonatomic, retain) MKPlacemark *placeMark;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *selectButton;
@property (nonatomic, retain) NSArray *groupKeys;
@property (nonatomic, retain) NSDictionary *names;
- (IBAction)done;
@end
