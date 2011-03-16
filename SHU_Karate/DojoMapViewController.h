//
//  DojoMapViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DojoSelectViewController.h"
@interface DojoMapViewController : UIViewController <MKMapViewDelegate>{
    MKMapView *mapView;
    UINavigationController *dojoListsNavigationController;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) UINavigationController *dojoListsNavigationController;

- (IBAction)setMapStyle:(id)sender;

@end
