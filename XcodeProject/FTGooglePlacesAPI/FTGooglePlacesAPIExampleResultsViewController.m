//
//  FTGooglePlacesAPIExampleResultsViewController.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPIExampleResultsViewController.h"

#import "FTGooglePlacesAPI.h"

@interface FTGooglePlacesAPIExampleResultsViewController ()

@property (nonatomic, strong) CLLocation *searchLocation;
@property (nonatomic, strong) FTGooglePlacesAPIResponse *response;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FTGooglePlacesAPIExampleResultsViewController

- (id)initWithGooglePlacesAPIRequest:(id<FTGooglePlacesAPIRequest>)request locationCoordinate:(CLLocationCoordinate2D)locationCoordinate;
{
    NSAssert(request, @"Provided request cannot be nil");
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"Results";
        
        _request = request;
        
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
    
    [self startSearching];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_response.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //  Get response object
    FTGooglePlacesAPIResultItem *resultItem = _response.results[indexPath.row];

    
    //  Configure cell
    cell.textLabel.text = resultItem.name;
    
    if (resultItem.location) {
        CLLocationDistance distance = [resultItem.location distanceFromLocation:_searchLocation];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.0fm", distance];
    }
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  Get response object
    FTGooglePlacesAPIResultItem *resultItem = _response.results[indexPath.row];
    
    //  And just print it to the console
    NSLog(@"Selected item: %@", resultItem);
}

#pragma mark - FTGooglePlacesAPI performing search request

- (void)startSearching
{
    //  Show activity indicator
    [_activityIndicatorView startAnimating];
    
    
    //  Execute Google Places API request using FTGooglePlacesAPIService
    [FTGooglePlacesAPIService executePlacesAPIRequest:_request
                                withCompletionHandler:^(FTGooglePlacesAPIResponse *response, NSError *error)
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
        //  You can do whatever you need here, we just reload the table
        self.response = response;
        [self.tableView reloadData];
        
        [_activityIndicatorView stopAnimating];
    }];
    
}

@end
