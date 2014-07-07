//
//  FTGooglePlacesAPIExampleResultsViewController.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPIExampleResultsViewController.h"

#import "FTGooglePlacesAPI.h"
#import "UIImageView+AFNetworking.h"

#import "FTGooglePlacesAPIExampleDetailViewController.h"


@interface FTGooglePlacesAPIExampleResultsViewController ()

@property (nonatomic, strong) id<FTGooglePlacesAPIRequest> initialRequest;
@property (nonatomic, strong) id<FTGooglePlacesAPIRequest> actualRequest;
@property (nonatomic, strong) CLLocation *searchLocation;
@property (nonatomic, strong) FTGooglePlacesAPISearchResponse *lastResponse;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

/**
 *  This array holds all results. Mutable array is used because we can have
 *  multiple responses, but want to keep all result items
 */
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation FTGooglePlacesAPIExampleResultsViewController

- (id)initWithGooglePlacesAPIRequest:(id<FTGooglePlacesAPIRequest>)request locationCoordinate:(CLLocationCoordinate2D)locationCoordinate;
{
    NSAssert(request, @"Provided request cannot be nil");
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"Results";
        
        _initialRequest = request;
        _actualRequest = request;
        
        _results = [NSMutableArray array];
        
        //  Create CLLocation object from search coordinate. We will use this for calculating
        //  distance of result item
        _searchLocation = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    
    UIBarButtonItem *activityBarButton = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    self.navigationItem.rightBarButtonItem = activityBarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  Controller is first displayed - start searching
    if ([_results count] == 0) {
        [self startSearching];
    }
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_results count] + ([_lastResponse hasNextPage]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ResultCellIdentifier = @"ResultCell";
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    BOOL isLoadMoreResultsCell = [self isLoadMoreResultsCellAtIndexPath:indexPath];
    
    //  Get appropriate cell
    NSString *cellIdentifier = (isLoadMoreResultsCell? LoadMoreCellIdentifier:ResultCellIdentifier);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //  Configure "Load more" cell
    if (isLoadMoreResultsCell)
    {
        //  This is constant cell, so we can preconfigure it on the init
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Load more results...";
        }
    }
    //  Configure results cell
    else
    {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        //  Get response object
        FTGooglePlacesAPISearchResultItem *resultItem = _results[indexPath.row];
        
        
        //  Configure cell
        cell.textLabel.text = resultItem.name;
        
        if (resultItem.location) {
            CLLocationDistance distance = [resultItem.location distanceFromLocation:_searchLocation];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.0fm", distance];
        }
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:resultItem.iconImageUrl] placeholderImage:[self placeholderImage]];
    }
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  Selected "Load more results" cell
    if ([self isLoadMoreResultsCellAtIndexPath:indexPath])
    {
        //  Get request for a new page of results and start search
        id<FTGooglePlacesAPIRequest> nextPageRequest = [_lastResponse nextPageRequest];
        _actualRequest = nextPageRequest;
        [self startSearching];
    }
    //  Selected result item cell
    else
    {
        //  Get response object
        FTGooglePlacesAPISearchResultItem *resultItem = _results[indexPath.row];
        
        //  Create detail request
        FTGooglePlacesAPIDetailRequest *request = [[FTGooglePlacesAPIDetailRequest alloc] initWithPlaceId:resultItem.placeId];
        
        //  Create detail controller
        FTGooglePlacesAPIExampleDetailViewController *detailController = [[FTGooglePlacesAPIExampleDetailViewController alloc] initWithRequest:request];
        
        [self.navigationController pushViewController:detailController animated:YES];
        
        //  And print it to the console
        NSLog(@"Selected item: %@", resultItem);
    }
}

#pragma mark - Helper methods

- (BOOL)isLoadMoreResultsCellAtIndexPath:(NSIndexPath *)indexPath
{
    //  It is load more cell if there is more results to read and this is
    //  the last cell in a table view
    NSInteger numberOfRows = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    
    return ((indexPath.row == numberOfRows - 1) && [_lastResponse hasNextPage]);
}

/**
 *  Little helper for generating plain white image used as a placeholder
 *  in UITableViewCell's while loading icon images
 */
- (UIImage *)placeholderImage
{
    static UIImage *PlaceholderImage;
    
    if (!PlaceholderImage)
    {
        CGRect rect = CGRectMake(0, 0, 40.0f, 40.0f);
        
        UIGraphicsBeginImageContext(rect.size);
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithRect:rect] fill];
        PlaceholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return PlaceholderImage;
}

#pragma mark - FTGooglePlacesAPI performing search request

- (void)startSearching
{
    //  Show activity indicator
    [_activityIndicatorView startAnimating];
    
    
    //  Execute Google Places API request using FTGooglePlacesAPIService
    [FTGooglePlacesAPIService executeSearchRequest:_actualRequest
                                withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error)
    {
        //  If error is not nil, request failed and you should handle the error
        //  We just show alert
        if (error)
        {
            //  There may be a lot of causes for an error (for example networking error).
            //  If the network communication with Google Places API was successfull,
            //  but the API returned some status code, NSError will have
            //  FTGooglePlacesAPIErrorDomain domain and status code from
            //  FTGooglePlacesAPIResponseStatus enum
            //  You can inspect error's domain and status code for more detailed info
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [_activityIndicatorView stopAnimating];
            return;
        }
        
        //  Everything went fine, we have response object
        //  You can do whatever you need here, we just add new items to the
        //  data source array and reload the table
        //  You could add new rows with animation etc., but it would add useless
        //  complexity to the sample code app
        
        //  Update last response object
        _lastResponse = response;
        
        //  Add new results to the data source array
        [_results addObjectsFromArray:response.results];
        
        [self.tableView reloadData];

        [_activityIndicatorView stopAnimating];
    }];
    
}

@end
