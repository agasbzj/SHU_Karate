//
//  Dojos.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Dojos.h"


@implementation Dojos
@synthesize name, position, time, latitude, longitude;

+ (NSSet *)keyPathsForValuesAffectingCoordinate
{
    return [NSSet setWithObjects:@"latitude", @"longitude", nil];
}

// derive the coordinate property.
- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude.doubleValue;
    coordinate.longitude = self.longitude.doubleValue;
    return coordinate;
}


// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return position;
}

// optional
- (NSString *)subtitle
{
    return time;
}



- (void)dealloc
{
    [name release];
    [position release];
    [time release];
    [super dealloc];
}
@end
