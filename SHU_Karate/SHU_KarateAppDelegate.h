//
//  SHU_KarateAppDelegate.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHU_KarateAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {


}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;



@end
