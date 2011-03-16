//
//  Dojos.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Dojos : NSObject {
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSNumber *latitude;
    NSNumber *longitude;
    
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;
@end
