//
//  OneItem.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneItem.h"


@implementation OneItem
@synthesize name, title, artist, price, category, image, theImage;

- (void)dealloc{
    [name release];
    [title release];
    [artist release];
    [price release];
    [category release];
    [image release];
    [theImage release];
    [super dealloc];
}
@end
