//
//  DojoMapViewController.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DojoMapViewController.h"


@implementation DojoMapViewController
@synthesize mapView;
@synthesize theDojo;


- (IBAction)setMapStyle:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:
        {
            mapView.mapType = MKMapTypeStandard;
            break;
        } 
        case 1:
        {
            mapView.mapType = MKMapTypeSatellite;
            break;
        } 
//        default:
//        {
//            mapView.mapType = MKMapTypeHybrid;
//            break;
//        } 
    }

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [theDojo release];
    [mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
- (void)navagateBack:(id)sender{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(navagateBack:)];
//    
//    self.navigationItem.leftBarButtonItem = backButton;
// 
//    设置导航栏透明
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.translucent = YES;
    
    UISegmentedControl *mapStyle = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"地图",
                                             @"卫星",
                                             nil]];
    [mapStyle addTarget:self action:@selector(setMapStyle:) forControlEvents:UIControlEventValueChanged];
    mapStyle.segmentedControlStyle = UISegmentedControlStyleBar;

    UIBarButtonItem *seg = [[UIBarButtonItem alloc] initWithCustomView:mapStyle];
    [mapStyle release];
    self.navigationItem.rightBarButtonItem = seg;
    [seg release];
    [self startLacating:theDojo];

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:theDojo];
    
}
- (void)viewDidUnload
{
    self.mapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)animateToWorld:(Dojos *)aDojo
{    
    MKCoordinateRegion current = mapView.region;
    MKCoordinateRegion zoomOut = { { (current.center.latitude + aDojo.coordinate.latitude)/2.0 , (current.center.longitude + aDojo.coordinate.longitude)/2.0 }, {90, 90} };
    [mapView setRegion:zoomOut animated:YES];
}

- (void)animateToPlace:(Dojos *)aDojo
{
    MKCoordinateRegion region;
    region.center = aDojo.coordinate;
    MKCoordinateSpan span = {0.006, 0.006}; //缩放大小
    region.span = span;
    [mapView setRegion:region animated:YES];

}

- (void)startLacating:(Dojos *)aDojo
{
    self.title = aDojo.name;
    
    MKCoordinateRegion current = mapView.region;
    if (current.span.latitudeDelta < 10)
    {
        [self performSelector:@selector(animateToWorld:) withObject:aDojo afterDelay:0.3];
        [self performSelector:@selector(animateToPlace:) withObject:aDojo afterDelay:1.7];        
    }
    else
    {
        [self performSelector:@selector(animateToPlace:) withObject:aDojo afterDelay:0.3];        
    }

}

- (void)DojoSelectViewController:(DojoSelectViewController *)controller didChooseDojo:(Dojos *)aDojo
{

    self.title = aDojo.name;

    MKCoordinateRegion current = mapView.region;
    if (current.span.latitudeDelta < 10)
    {
        [self performSelector:@selector(animateToWorld:) withObject:aDojo afterDelay:0.3];
        [self performSelector:@selector(animateToPlace:) withObject:aDojo afterDelay:1.7];        
    }
    else
    {
        [self performSelector:@selector(animateToPlace:) withObject:aDojo afterDelay:0.3];        
    }

}

@end
