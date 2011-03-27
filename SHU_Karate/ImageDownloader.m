//
//  ImageDownloader.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"
#define kImageHeight 60
#define kImageWidth kImageHeight * 16 / 9
@implementation ImageDownloader
@synthesize oneItem, indexPath, delegate, imageData, urlConnection;


- (void)dealloc{
    [oneItem release];
    [indexPath release];
    [imageData release];
    [urlConnection cancel];
    [urlConnection release];
    [super dealloc];
}

- (void)startDownload{
    self.imageData = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oneItem.image]] delegate:self];
    self.urlConnection = conn;
    [conn release];
}

- (void)cancelDownload{
    [urlConnection cancel];
    self.urlConnection = nil;
    self.imageData = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.imageData = nil;
    self.urlConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [[UIImage alloc] initWithData:self.imageData];
    
    if (image.size.height != kImageHeight && image.size.width != kImageWidth) {
        CGSize imgSize = CGSizeMake(kImageWidth, kImageHeight);
        UIGraphicsBeginImageContext(imgSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imgSize.width, imgSize.height);
        [image drawInRect:imageRect];
        self.oneItem.theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else {
        self.oneItem.theImage = image;
    }
    
    self.imageData = nil;
    [image release];
    
    self.urlConnection = nil;
    
    [delegate imageDidLoad:self.indexPath];
}
@end
