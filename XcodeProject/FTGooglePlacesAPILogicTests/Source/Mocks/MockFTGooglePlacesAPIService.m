//
//  MockFTGooglePlacesAPIService.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 05/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "MockFTGooglePlacesAPIService.h"

@implementation MockFTGooglePlacesAPIService

static FTGooglePlacesAPIService *MockFTGooglePlacesAPIServiceSingletonInstance;
static id MockFTGooglePlacesAPIServiceHTTPRequestOperatioManager;

+ (FTGooglePlacesAPIService *)sharedService
{
    return [[self class] singletonInstance];
}

#pragma mark - Helper methods

+ (FTGooglePlacesAPIService *)singletonInstance
{
    return MockFTGooglePlacesAPIServiceSingletonInstance;
}

+ (void)setSingletonInstance:(FTGooglePlacesAPIService *)singletonInstance
{
    MockFTGooglePlacesAPIServiceSingletonInstance = singletonInstance;
}

+ (void)createDefaultSingletonInstance
{
    MockFTGooglePlacesAPIServiceSingletonInstance = [[FTGooglePlacesAPIService alloc] init];
}

@end
