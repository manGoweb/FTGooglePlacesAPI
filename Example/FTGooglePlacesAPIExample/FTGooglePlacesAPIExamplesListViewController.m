//
//  FTGooglePlacesAPIExamplesListViewController.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPIExamplesListViewController.h"

#import "FTGooglePlacesAPI.h"
#import "FTGooglePlacesAPIExampleResultsViewController.h"

typedef NS_ENUM(NSUInteger, FTGooglePlacesAPIExampleType) {
    FTGooglePlacesAPIExampleTypeNearestCulture,
    FTGooglePlacesAPIExampleTypeMuseumKeyword,
    FTGooglePlacesAPIExampleTypeTextSearchPizzaInLondon,
    FTGooglePlacesAPIExampleTypeExpensiveRestaurant
};


@interface FTGooglePlacesAPIExamplesListViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

@end

@implementation FTGooglePlacesAPIExamplesListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"FTGooglePlacesAPI";
        
        //  For sake of simplicity of the example, we do not get real location, which would require
        //  additional code and just use constant latitude and longitude of London's Big Ben
        //  For easy to use getting of current location, you take a look at FTLocationManager
        //  https://github.com/FuerteInternational/FTLocationManager
        self.locationCoordinate = CLLocationCoordinate2DMake(51.501103,-0.124565);
    }
    return self;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;   //  Number of items in FTGooglePlacesAPIExampleType enum
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExampleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    FTGooglePlacesAPIExampleType exampleType = (FTGooglePlacesAPIExampleType)indexPath.row;
    
    cell.textLabel.text = [self titleForExampleType:exampleType];
    cell.detailTextLabel.text = [self subtitleForExampleType:exampleType];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  Get request for current row
    FTGooglePlacesAPIExampleType exampleType = (FTGooglePlacesAPIExampleType)indexPath.row;
    id<FTGooglePlacesAPIRequest> request = [self googlePlacesAPIRequestForExampleType:exampleType];
    
    //  Create search / results controller and push it to the navigation controller
    FTGooglePlacesAPIExampleResultsViewController *controller = [[FTGooglePlacesAPIExampleResultsViewController alloc] initWithGooglePlacesAPIRequest:request locationCoordinate:self.locationCoordinate];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark Helpers and convenience methods
/**
 *  Below are helper method for getting title and subtitle for cells for each
 *  example type. Using switch helps us not to forget to implement any
 *  example item by compiler warnings
 */
- (NSString *)titleForExampleType:(FTGooglePlacesAPIExampleType)type
{
    NSString *title;
    
    switch (type)
    {
        case FTGooglePlacesAPIExampleTypeNearestCulture:
            title = @"Nearest galleries and museums";
            break;
        case FTGooglePlacesAPIExampleTypeMuseumKeyword:
            title = @"Matching \"museum\", near and open";
            break;
        case FTGooglePlacesAPIExampleTypeTextSearchPizzaInLondon:
            title = @"Text search \"pizza in london\"";
            break;
        case FTGooglePlacesAPIExampleTypeExpensiveRestaurant:
            title = @"Nearest very expensive restaurants";
            break;
    }
    
    return title;
}

- (NSString *)subtitleForExampleType:(FTGooglePlacesAPIExampleType)type
{
    NSString *subtitle;
    
    switch (type)
    {
        case FTGooglePlacesAPIExampleTypeNearestCulture:
            subtitle = @"rankBy=distance&types=art_gallery|museum";
            break;
        case FTGooglePlacesAPIExampleTypeMuseumKeyword:
            subtitle = @"keyword=museum&opennow=true&radius=2000";
            break;
        case FTGooglePlacesAPIExampleTypeTextSearchPizzaInLondon:
            subtitle = @"query=pizza+in+london";
            break;
        case FTGooglePlacesAPIExampleTypeExpensiveRestaurant:
            subtitle = @"types=restaurant&minprice=4";
            break;
    }
    
    return subtitle;
}

#pragma mark - Creating Google Places API requests objects

/**
 *  This method constructs request for each API example type
 *
 *  @param type Example type
 *
 *  @return Request object conforming to <FTGooglePlacesAPIRequest> protocol, which can be used in API service
 */
- (id<FTGooglePlacesAPIRequest>)googlePlacesAPIRequestForExampleType:(FTGooglePlacesAPIExampleType)type
{
    id<FTGooglePlacesAPIRequest> result;
    
    
    switch (type)
    {
        /**
         *  Create request for searching for some culture around
         */
        case FTGooglePlacesAPIExampleTypeNearestCulture:
        {
            FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:self.locationCoordinate];
            request.rankBy = FTGooglePlacesAPIRequestParamRankByDistance;
            request.types = @[@"art_gallery", @"museum"];
            
            result = request;
        }
            break;
        
        /**
         *  Create request for searching places around *best matching*
         *  word "museum" and which are open right now and max 2km away
         *  Because we are using *best matching* and default "rankBy" by
         *  "prominence" (importance), don't be surprised that results may
         *  not appear ordered by distance
         */
        case FTGooglePlacesAPIExampleTypeMuseumKeyword:
        {
            FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:self.locationCoordinate];
            request.keyword = @"museum";
            request.openNow = YES;
            request.radius = 2000;
            
            result = request;
        }
            break;
        
        /**
         *  This is example of Google Places API "Text Search Request"
         *  We are making search for phrase "pizza in london" without
         *  providing any location around which to search.
         *  Note that in results screen, there will still be displayed
         *  distance from Big Ben to examples structure simple
         */
        case FTGooglePlacesAPIExampleTypeTextSearchPizzaInLondon:
        {
            FTGooglePlacesAPITextSearchRequest *request = [[FTGooglePlacesAPITextSearchRequest alloc] initWithQuery:@"pizza in london"];
            
            result = request;
        }
            break;
        
        /**
         *  This is an example of request defining results price.
         *  You can use minPrice and maxPrice for example for searching
         *  free museums, expensive restaurants etc.
         */
        case FTGooglePlacesAPIExampleTypeExpensiveRestaurant:
        {
            FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:self.locationCoordinate];
            request.types = @[@"restaurant"];
            request.minPrice = 4;
            
            result = request;
        }
    }
    
    return result;
}

@end
