//
//  FTGooglePlacesAPIExampleResultsViewController.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol FTGooglePlacesAPIRequest;

@interface FTGooglePlacesAPIExampleResultsViewController : UITableViewController

@property (nonatomic, readonly) id<FTGooglePlacesAPIRequest>request;

- (id)initWithGooglePlacesAPIRequest:(id<FTGooglePlacesAPIRequest>)request locationCoordinate:(CLLocationCoordinate2D)locationCoordinate;

@end
