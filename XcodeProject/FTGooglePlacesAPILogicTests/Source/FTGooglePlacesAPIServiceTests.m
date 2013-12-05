//
//  FTGooglePlacesAPIServiceTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 05/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPIService.h"

#import "MockFTGooglePlacesAPIService.h"


/**
 *  This category exposes internal private interface and methods of a FTGooglePlacesAPIService.
 *  This is a helper for testing, because the interface is minimalistic, based on class methods,
 *  and as such would be very difficult to test.
 */
@interface FTGooglePlacesAPIService (PrivateTestsHelpers)

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, weak) Class searchResultsItemClass;

+ (instancetype)sharedService;

+ (void)executeRequest:(id<FTGooglePlacesAPIRequest>)request
 withCompletionHandler:(void(^)(NSDictionary *responseObject, NSError *error))completion;

@end


@interface FTGooglePlacesAPIServiceTests : FTGooglePlacesAPITestCase

@end

@implementation FTGooglePlacesAPIServiceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark Configuration tests

- (void)testAPIKeyIsForwardedToSingletonInstance
{
    NSString *apiKey = @"testingAPIKey";
    
    //  Create mock for service singleton instance and expect setApiKey to be called
    id mockService = [OCMockObject mockForClass:[FTGooglePlacesAPIService class]];
    [[mockService expect] setApiKey:apiKey];
    
    //  Use mock service object with a custom singleton instance
    [MockFTGooglePlacesAPIService setSingletonInstance:mockService];
    
    //  And call a regular public method
    [MockFTGooglePlacesAPIService provideAPIKey:apiKey];
    
    [mockService verify];
}

- (void)testCustomSearchResultsItemClassIsForwardedToSingletonInstance
{
    id mockCustomClass = [OCMockObject mockForClass:[NSObject class]];
    
    //  Create mock for service singleton instance and setSearchResultsItemClass to be called
    id mockService = [OCMockObject mockForClass:[FTGooglePlacesAPIService class]];
    [[mockService expect] setSearchResultsItemClass:mockCustomClass];
    
    //  Use mock service object with a custom singleton instance
    [MockFTGooglePlacesAPIService setSingletonInstance:mockService];
    
    //  And call a regular public method
    [MockFTGooglePlacesAPIService registerSearchResultItemClass:mockCustomClass];
    
    [mockService verify];
}

@end
