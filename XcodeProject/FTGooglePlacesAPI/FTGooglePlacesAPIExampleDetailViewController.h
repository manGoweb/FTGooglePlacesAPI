//
//  FTGooglePlacesAPIExampleDetailViewController.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 29/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTGooglePlacesAPIRequest;

@interface FTGooglePlacesAPIExampleDetailViewController : UITableViewController

- (instancetype)initWithRequest:(id<FTGooglePlacesAPIRequest>)request;

@end
