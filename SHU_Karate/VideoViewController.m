//
//  VideoViewController.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoViewController.h"


@implementation VideoViewController
@synthesize moviePlayerController;
@synthesize videoPath;
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

    [videoPath release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(playDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//                                             selector:@selector(showNavBar) 
//                                                 name:MPMovieDurationAvailableNotification 
//                                               object:nil];
    self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoPath];
    [self.view addSubview:self.moviePlayerController.view];
    MPMoviePlayerController *controller = self.moviePlayerController.moviePlayer;
    controller.repeatMode = YES;
    [controller prepareToPlay];
    [controller play];
    [self.moviePlayerController release];
}

- (void) playDidFinish:(NSNotification*)notification
{
//	[moviePlayerController.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

//- (void)showNavBar
//{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

- (void)viewDidUnload
{
    self.moviePlayerController = nil;
    self.videoPath = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
