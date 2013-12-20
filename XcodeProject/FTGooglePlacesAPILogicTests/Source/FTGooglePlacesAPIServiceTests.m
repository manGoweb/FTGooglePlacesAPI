//
//  FTGooglePlacesAPIServiceTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 05/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPI.h"

#import "AFHTTPRequestOperationManager.h"

#import "MockFTGooglePlacesAPIService.h"
#import "MockAFHTTPRequestOperationManager.h"
#import "MockFTGooglePlacesAPISearchResultItemSubclass.h"


/**
 *  This category exposes internal private interface and methods of a FTGooglePlacesAPIService.
 *  This is a helper for testing, because the interface is minimalistic, based on class methods,
 *  and as such would be very difficult to test.
 */
@interface FTGooglePlacesAPIService (PrivateTestsHelpers)

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpRequestOperationManager;
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

#pragma mark - Configuration tests

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

#pragma mark - Requests tests

- (void)testServiceUsesAllRequiredMethodsFromRequestProtocol
{
    id mockRequest = [OCMockObject mockForProtocol:@protocol(FTGooglePlacesAPIRequest)];
    id mockHTTPManager = [OCMockObject niceMockForClass:[AFHTTPRequestOperationManager class]];
    
    [[[mockRequest expect] andReturn:@"testrequesttype"] placesAPIRequestMethod];
    [[[mockRequest expect] andReturn:@{ @"key": @"value" }] placesAPIRequestParams];
    
    //  Mock service
    [self configureBasicMockService];
    [MockFTGooglePlacesAPIService sharedService].httpRequestOperationManager = mockHTTPManager;
    
    [MockFTGooglePlacesAPIService executeRequest:mockRequest withCompletionHandler:^(NSDictionary *responseObject, NSError *error) {}];

    [mockRequest verify];
}

- (void)testServiceContructsProperRequestURL
{
    [MockFTGooglePlacesAPIService createDefaultSingletonInstance];
    [MockFTGooglePlacesAPIService provideAPIKey:@"fakeAPIKey"];
    
    MockAFHTTPRequestOperationManager *mockHTTPManager = [[MockAFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:FTGooglePlacesAPIBaseURL]];
    [MockFTGooglePlacesAPIService sharedService].httpRequestOperationManager = mockHTTPManager;
    
    id mockRequest = [OCMockObject mockForProtocol:@protocol(FTGooglePlacesAPIRequest)];
    [[[mockRequest expect] andReturn:@"testtype"] placesAPIRequestMethod];
    [[[mockRequest expect] andReturn:@{
        @"xkey1": @"value1",
        @"xkey2": @"value2"
    }] placesAPIRequestParams];
    

    NSString *expectedURLStringPrefix = @"https://maps.googleapis.com/maps/api/place/testtype/json?";
    
    [MockFTGooglePlacesAPIService executeRequest:mockRequest withCompletionHandler:^(NSDictionary *responseObject, NSError *error) {}];
    
    //  We can only test for a prefix because the params are dictionary and we cannot
    //  rely on exact order of parameters
    XCTAssertEqualObjects(mockHTTPManager.lastURLString, @"testtype/json", @"");
    XCTAssert([[[mockHTTPManager.lastURLRequest URL] absoluteString] hasPrefix:expectedURLStringPrefix], @"");
    
    [mockRequest verify];
}

- (void)testExecuteRequestPropagatesErrorToHandlerBlock
{
    //  Expects
    NSError *expectedError = [NSError errorWithDomain:@"TestErrorDomain" code:12345 userInfo:nil];
    
    //  Configure Service to use fake Mock AFNetworking
    [self configureBasicMockService];
    
    MockAFHTTPRequestOperationManager *mockHTTPManager = [[MockAFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:FTGooglePlacesAPIBaseURL]];
    [MockFTGooglePlacesAPIService sharedService].httpRequestOperationManager = mockHTTPManager;

    
    [mockHTTPManager setFailureErrorToReturn:expectedError];
    
    //  Test general public interface
    id mockRequest = [self createMockRequest];
    
    [MockFTGooglePlacesAPIService executeSearchRequest:mockRequest withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
        
        XCTAssertNil(response, @"Response should be nil when the error is not caused by API response code");
        XCTAssertEqualObjects(error, expectedError, @"Error should be passed to Search request handler block");
    }];
    [mockRequest verify];
    
    mockRequest = [self createMockRequest];
    [MockFTGooglePlacesAPIService executeDetailRequest:mockRequest withCompletionHandler:^(FTGooglePlacesAPIDetailResponse *response, NSError *error) {
        
        XCTAssertNil(response, @"Response should be nil when the error is not caused by API response code");
        XCTAssertEqualObjects(error, expectedError, @"Error should be passed to Detail request handler block");
    }];
    
    [mockRequest verify];
}

- (void)testServiceParsesSearchResultsAndPassesThemToHandlerBlock
{
    MockAFHTTPRequestOperationManager *mockManager;
    
    //  Load valid JSON response
    id responseObject = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-Nearby-Search-OK.json"];
    [self configureMockServiceWithResponse:responseObject requestManager:&mockManager];
    mockManager.shouldFireSuccessBlock = YES;
 
    id mockRequest = [self createMockRequest];
    
    [MockFTGooglePlacesAPIService executeSearchRequest:mockRequest withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
        
        XCTAssertNil(error, @"");
        XCTAssertNotNil(response, @"");
        XCTAssertEqual([[response results] count], (NSUInteger)20, @"Result should have 20 results");
        
        [mockRequest verify];
    }];
}

- (void)testServicePassesErrorParsedFromResponseObject
{
    MockAFHTTPRequestOperationManager *mockManager;
    
    //  Load valid JSON response
    id responseObject = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test2-NoResults.json"];
    [self configureMockServiceWithResponse:responseObject requestManager:&mockManager];
    
    id mockRequest = [self createMockRequest];
    
    [MockFTGooglePlacesAPIService executeSearchRequest:mockRequest withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
        
        XCTAssertNotNil(response, @"Response should not be nil when caused by API response status code");
        XCTAssertEqual([response.results count], (NSUInteger)0, @"Response should have no results");
        
        XCTAssertNotNil(error, @"Error should be passed");
        XCTAssertEqualObjects(error.domain, FTGooglePlacesAPIErrorDomain, @"Error should be from FTGooglePlacesAPIErrorDomain");
        XCTAssertEqual(error.code, (NSInteger)FTGooglePlacesAPIResponseStatusNoResults, @"Error status code should be set");
        
        [mockRequest verify];
    }];
}

- (void)testServiceUsesCustomClassForSearchResultsItemsWhenRequested
{
    MockAFHTTPRequestOperationManager *mockManager;
    
    //  Load valid JSON response
    id responseObject = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-Nearby-Search-OK.json"];
    [self configureMockServiceWithResponse:responseObject requestManager:&mockManager];
    mockManager.shouldFireSuccessBlock = YES;
    
    id mockRequest = [self createMockRequest];
    
    //  Register custom result class
    [MockFTGooglePlacesAPIService registerSearchResultItemClass:[MockFTGooglePlacesAPISearchResultItemSubclass class]];
    
    [MockFTGooglePlacesAPIService executeSearchRequest:mockRequest withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
        
        XCTAssert([[response results] count] > 0, @"At least 1 results should be returned for this test");
        
        id resultsItemInstance = [[response results] objectAtIndex:0];
        XCTAssertEqualObjects([resultsItemInstance class], [MockFTGooglePlacesAPISearchResultItemSubclass class], @"Result item should be an instance have requested class");
                                                            
        [mockRequest verify];
    }];
}

#pragma mark - Utilities

- (void)configureBasicMockService
{
    [MockFTGooglePlacesAPIService createDefaultSingletonInstance];
    [MockFTGooglePlacesAPIService provideAPIKey:@"fakeAPIKey"];
}

/**
 *  Creates simple FTGooglePlacesAPIRequest mock expecting all methods to be called
 */
- (id)createMockRequest
{
    id mockRequest = [OCMockObject mockForProtocol:@protocol(FTGooglePlacesAPIRequest)];
    
    [[[mockRequest expect] andReturn:@"testtype"] placesAPIRequestMethod];
    [[[mockRequest expect] andReturn:@{@"param1": @"value1"}] placesAPIRequestParams];
    
    return mockRequest;
}

/**
 *  Creates MockService with a MockAFNetworking
 *
 *  @param responseObject Response object to be returned by the service
 *  @param mockManager    Reference to which the manager instance pointer should be set. Can be NULL (not interested in working with MockAFHTTPRequestOperationManager)
 */
- (void)configureMockServiceWithResponse:(id)responseObject requestManager:(MockAFHTTPRequestOperationManager **)mockManager
{
    //  Configure Service to use fake Mock AFNetworking
    [self configureBasicMockService];
    
    MockAFHTTPRequestOperationManager *mockHTTPManager = [[MockAFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
    [MockFTGooglePlacesAPIService sharedService].httpRequestOperationManager = mockHTTPManager;
    
    //  Load valid JSON response
    [mockHTTPManager setResponseObjectToReturn:responseObject];
    
    if (mockManager) {
        *mockManager = mockHTTPManager;
    }
}


@end
