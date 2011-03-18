//
//  TextViewController.h
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextViewController : UIViewController {
    UITextView *textView;
    NSString *file;
}
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *file;
@end
