//
//  UtilityRootViewController.m
//  SHU_Karate
//
//  Created by 卞 中杰 on 11-3-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UtilityRootViewController.h"
#import "OneItem.h"

#import <CFNetwork/CFNetwork.h>



@implementation UtilityRootViewController
@synthesize tableView;
@synthesize itemData;
@synthesize itemFeedConnection;
@synthesize parseQueue;
@synthesize itemList;
@synthesize dateFormatter;
@synthesize imageDownloadInProgress;
//static NSUInteger const kItemMax = 300;
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
    [imageDownloadInProgress release];
    [itemFeedConnection cancel];
    [itemFeedConnection release];
    [tableView release];
    [itemData release];
    [parseQueue release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [itemList release];
    [imageDownloadInProgress release];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    static NSString *feedURLString = @"http://itunes.apple.com/us/rss/topsongs/limit=300/xml";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    self.itemFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    NSAssert(self.itemFeedConnection != nil, @"Failure to create URL connection");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addItems:) name:kAddItemsNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsError:) name:kItemsErrorNotif object:nil];
                                
    self.itemList = [NSMutableArray array];
    [self addObserver:self forKeyPath:@"itemList" options:0 context:NULL];
    
    self.tableView.rowHeight = 60;  //行高
    self.imageDownloadInProgress = [NSMutableDictionary dictionary];    //初始化字典

}

- (void)viewDidUnload
{
    self.itemList = nil;
    [self removeObserver:self forKeyPath:@"itemList"];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is
// how the connection object, which is working in the background, can asynchronously communicate back
// to its delegate on the thread from which it was started - in this case, the main thread.
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/atom+xml"]) {
        self.itemData = [NSMutableData data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        [self handleError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [itemData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.itemFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.itemFeedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // Spawn an NSOperation to parse the earthquake data so that the UI is not blocked while the
    // application parses the XML data.
    //
    // IMPORTANT! - Don't access or affect UIKit objects on secondary threads.
    //
    ParseOperation *parseOperation = [[ParseOperation alloc] initWithData:self.itemData];
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release];   // once added to the NSOperationQueue it's retained, we don't need it anymore
    
    // earthquakeData will be retained by the NSOperation until it has finished executing,
    // so we no longer need a reference to it in the main thread.
    


    self.itemData = nil;
}

// Handle errors in the download by showing an alert to the user. This is a very
// simple way of handling the error, partly because this application does not have any offline
// functionality for the user. Most real applications should handle the error in a less obtrusive
// way and provide offline functionality to the user.
//
- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"Error Title",
                       @"Title for alert displayed when download or parse error occurs.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

// Our NSNotification callback from the running NSOperation to add the earthquakes
//
- (void)addItems:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self addItemToList:[[notif userInfo] valueForKey:kItemResultsKey]];
}

// Our NSNotification callback from the running NSOperation when a parsing error has occurred
//
- (void)itemsError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self handleError:[[notif userInfo] valueForKey:kItemsMsgErrorKey]];
}



#pragma mark -
#pragma mark UITableViewDelegate

// The number of rows is equal to the number of earthquakes in the array.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemList count];
}

// The cell uses a custom layout, but otherwise has standard behavior for UITableViewCell.
// In these cases, it's preferable to modify the view hierarchy of the cell's content view, rather
// than subclassing. Instead, view "tags" are used to identify specific controls, such as labels,
// image views, etc.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellIdentifier = @"CellIdentifier";
    static NSString *placeHolderCellIdentifier = @"PlaceHolderCellIdentifier";
    int nodeCount = [itemList count];
    if (nodeCount == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeHolderCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeHolderCellIdentifier];
            cell.textLabel.text = @"加载中，请稍候...";
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        return cell;
    }
  	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
        // No reusable cell was available, so we create a new cell and configure its subviews.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    } 
    if (nodeCount > 0) {
        OneItem *item = [itemList objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.artist;
        if (!item.theImage) {
            
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                [self startImageDownload:item forIndexPath:indexPath];
            }
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            
        }
        else {
            cell.imageView.image = item.theImage;
        }
    }
    

    
	return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	

}

#pragma mark -
#pragma mark Table cell image support

- (void)startImageDownload:(OneItem *)item forIndexPath:(NSIndexPath *)indexPath {
    ImageDownloader *imageDownloader = [imageDownloadInProgress objectForKey:indexPath];
    if (imageDownloader == nil) {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.oneItem = item;
        imageDownloader.indexPath = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
        [imageDownloader release];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)loadImagesForOnscreenRows
{
    if ([self.itemList count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            OneItem *oneItem = [self.itemList objectAtIndex:indexPath.row];
            if (!oneItem.theImage) {
                [self startImageDownload:oneItem forIndexPath:indexPath];
            }
        }
    }
}
// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadInProgress objectForKey:indexPath];
    if (imageDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:imageDownloader.indexPath];
        
        // Display the newly loaded image
        cell.imageView.image = imageDownloader.oneItem.theImage;
    }
}

#pragma mark -
#pragma mark KVO support

- (void)insertItems:(NSArray *)items
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"itemList"];
    [self.itemList addObjectsFromArray:items];
    [self didChangeValueForKey:@"itemList"];
}
- (void)addItemToList:(NSArray *)items {
    
    // insert the earthquakes into our rootViewController's data source (for KVO purposes)
    [self insertItems:items];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self.tableView reloadData];
}
// listen for changes to the earthquake list coming from our app delegate.





@end
