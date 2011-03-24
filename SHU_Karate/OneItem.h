//
//  OneItem.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OneItem : NSObject {
    NSString *name;
    NSString *title;
    NSString *category;
    NSString *artist;
    NSString *price;
    NSString *image;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *image;
@end
