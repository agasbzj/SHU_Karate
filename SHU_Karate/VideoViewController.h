//
//  VideoViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : UIViewController {
    NSURL *videoPath;
    MPMoviePlayerViewController *moviePlayerController;
}
@property (nonatomic, retain) IBOutlet MPMoviePlayerViewController *moviePlayerController;
@property (nonatomic, retain) NSURL *videoPath;
@end
