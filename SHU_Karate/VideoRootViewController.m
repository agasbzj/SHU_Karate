//
//  VideoRootViewController.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoRootViewController.h"


@implementation VideoRootViewController
@synthesize videoListTableView, name, groupKeys, nameDic, videoController;

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
    [videoController release];
    [nameDic release];
    [groupKeys release];
    [videoListTableView release];
    [name release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VideoList" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    self.nameDic = dict;
    [dict release];
    NSArray *array = [[nameDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.groupKeys = array;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [groupKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *key = [groupKeys objectAtIndex:row];
    NSDictionary *tmp = [nameDic objectForKey:key];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [tmp objectForKey:@"Name"];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *key = [groupKeys objectAtIndex:row];
    NSDictionary *tmp = [nameDic objectForKey:key];
    
    VideoViewController *videoView = [[VideoViewController alloc] init];
    NSString *s = [tmp objectForKey:@"Path"];
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    videoView.videoPath = url;
    self.videoController = videoView;
    [videoView release];
    [self.navigationController pushViewController:videoController animated:YES];
}
@end
