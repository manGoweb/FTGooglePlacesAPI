//
//  MockFTGooglePlacesAPIService.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 05/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPIService.h"

@interface MockFTGooglePlacesAPIService : FTGooglePlacesAPIService

+ (FTGooglePlacesAPIService *)singletonInstance;
+ (void)setSingletonInstance:(FTGooglePlacesAPIService *)singletonInstance;

+ (void)createDefaultSingletonInstance;

@end
