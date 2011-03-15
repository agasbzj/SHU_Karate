//
//  CommunityRootTableCell.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommunityRootTableCell : UITableViewCell {
    UIImageView *_icon;
    UILabel *_title;
    UILabel *_brief;
    BOOL useDarkBackground;
}
@property (nonatomic, retain) IBOutlet UIImageView *_icon;
@property (nonatomic, retain) IBOutlet UILabel *_title;
@property (nonatomic, retain) IBOutlet UILabel *_brief;

@property BOOL useDarkBackground;
@end
