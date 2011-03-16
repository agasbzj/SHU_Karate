//
//  DojoSelectViewController.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DojoSelectViewController.h"
#import "DojoMapViewController.h"

@implementation DojoSelectViewController
@synthesize  tableView, groupKeys, names, dojoList;
@synthesize mapViewController;
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
    [mapViewController release];
    [tableView release];
    [names release];
    [groupKeys release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//- (void)viewWillAppear:(BOOL)animated
//{
//    [tableView reloadData];
//}

- (void)viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Dojos" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.names = dict;
    [dict release];
    
    NSArray *array = [[names allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.groupKeys = array;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.groupKeys = nil;
    self.names = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [groupKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [groupKeys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}



- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *key = [groupKeys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
   
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
             cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *tmp = [nameSection objectAtIndex:row];
    cell.textLabel.text = [tmp objectForKey:@"Name"];
    cell.detailTextLabel.text = [tmp objectForKey:@"Position"];
   
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [groupKeys objectAtIndex:section];
    return key;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *key = [groupKeys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    NSDictionary *tmp = [nameSection objectAtIndex:row];
    Dojos *theDojo = [[[Dojos alloc] init] autorelease];
    theDojo.name = [tmp objectForKey:@"Name"];
    theDojo.latitude = [tmp objectForKey:@"Latitude"];
    theDojo.longitude = [tmp objectForKey:@"Longitude"];
    
    [delegate DojoSelectViewController:self didChooseDojo:theDojo];

    
    DojoMapViewController *mapView = [[[DojoMapViewController alloc] init] autorelease];
    mapView.title = theDojo.name;
    mapView.theDojo = theDojo;
    mapViewController = mapView;
    [self.navigationController pushViewController:mapViewController animated:YES];
    
//    [self.navigationController presentModalViewController:self.mapViewController animated:YES];

}

//- (DojoMapViewController *)mapViewController
//{
//    if (mapViewController == nil)
//    {
//        mapViewController = [[DojoMapViewController alloc] init];
//        //mapViewController.delegate = self;
//        //mapViewController.title = @"Choose a city:";
//    }
//    return mapViewController;
//}
//- (UINavigationController *)dojoListNavigationController
//{
//    if (dojoListNavigationController == nil)
//    {
//        dojoListNavigationController = [[UINavigationController alloc] initWithRootViewController:self.dojoListNavigationController];
//    }
//    return dojoListNavigationController;
//}

@end
