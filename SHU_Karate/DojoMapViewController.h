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
@interface DojoMapViewController : UIViewController <MKMapViewDelegate, DojoSelectViewControllerDelegate>{
    MKMapView *mapView;
    Dojos *theDojo;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Dojos *theDojo;

- (IBAction)setMapStyle:(id)sender;
- (void)startLacating:(Dojos *)aDojo;
@end
