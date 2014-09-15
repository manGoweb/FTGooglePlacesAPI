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

/**
 *  Please note that this controller is not 100% functional and glitches-proof
 *  We try to keep the code as simple as possible so some cases which should be
 *  handled in production code are not handled here
 */

@interface FTGooglePlacesAPIExampleResultsViewController : UITableViewController

/**
 *  @param request This is initial request used for the first request
 *  @param locationCoordinate Location from which the distance should be shown
 *
 *  @return Instance
 */
- (id)initWithGooglePlacesAPIRequest:(id<FTGooglePlacesAPIRequest>)request locationCoordinate:(CLLocationCoordinate2D)locationCoordinate;

@end
