//
//  FTGooglePlacesAPIExampleDetailViewController.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 29/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPIExampleDetailViewController.h"

#import "FTGooglePlacesAPI.h"

@interface FTGooglePlacesAPIExampleDetailViewController ()

@property (nonatomic, strong) id<FTGooglePlacesAPIRequest> request;
@property (nonatomic, strong) FTGooglePlacesAPIDetailResponse *response;

@property (nonatomic, strong) NSDictionary *responseTableRepresentation;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FTGooglePlacesAPIExampleDetailViewController

- (instancetype)initWithRequest:(id<FTGooglePlacesAPIRequest>)request
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Detail";
        _request = request;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_responseTableRepresentation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *key = [_responseTableRepresentation allKeys][indexPath.row];
    
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [_responseTableRepresentation[key] description];
    
    return cell;
}

#pragma mark - FTGooglePlacesAPI performing search request

- (void)startSearching
{
    //  Show activity indicator
    [_activityIndicatorView startAnimating];


    //  Execute Google Places API request using FTGooglePlacesAPIService
    [FTGooglePlacesAPIService executeDetailRequest:_request
                             withCompletionHandler:^(FTGooglePlacesAPIDetailResponse *response, NSError *error)
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
        //  You can do whatever you need here, we just construct "table representation"
        //  of response to the dictionary and reload table
        _responseTableRepresentation = @{
             @"Name": (response.name?:@"N/A"),
            @"Location": [NSString stringWithFormat:@"(%.6f,%.6f)", response.location.coordinate.latitude, response.location.coordinate.longitude],
            @"Address": (response.addressString?:@"N/A"),
            @"Form. address": (response.formattedAddress?:@"N/A"),
            @"Form. phone": (response.formattedPhoneNumber?:@"N/A"),
            @"Int. phone": (response.internationalPhoneNumber?:@"N/A"),
            @"Rating": [NSString stringWithFormat:@"%.1f", response.rating],
            @"Types": [response.types componentsJoinedByString:@","],
            @"Website:": (response.websiteUrl?:@"N/A"),
        };

        [self.tableView reloadData];

        [_activityIndicatorView stopAnimating];
     }];
    
}

@end
