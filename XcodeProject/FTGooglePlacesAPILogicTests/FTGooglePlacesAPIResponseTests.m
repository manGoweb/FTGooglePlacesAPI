//
//  FTGooglePlacesAPIResponseTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPIResponse.h"
#import "FTGooglePlacesAPIResultItem.h"
#import "FTGooglePlacesAPIDictionaryRequest.h"

@interface FTGooglePlacesAPIResponseTests : FTGooglePlacesAPITestCase

@end

@implementation FTGooglePlacesAPIResponseTests

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

- (void)testBasicInitializers
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil request:nil resultsItemClass:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OK"} request:nil];
    XCTAssertNotNil(response, @"response should be non-nil");
    XCTAssertNil(response.request, @"request should be nil");
}

- (void)testBasicProperties
{
    NSDictionary *dictionary = @{
        @"html_attributions": @[@"atribution1", @"attribution2"],
        @"results": [NSNull null],
        @"status": @"OK"
    };
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response.htmlAttributions, @"htmlAttributions should not be nil");
    XCTAssertEqualObjects(@([response.htmlAttributions count]), @2, @"wrong number of htmlAttributions");
    NSArray *expectedHtmlAttributions = @[@"atribution1", @"attribution2"];
    XCTAssertEqualObjects(response.htmlAttributions, expectedHtmlAttributions, @"wrong htmlAttributions");
    XCTAssertNil(response.request, @"request should be nil");
    
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status is wrong");
    
    XCTAssertNil(response.results, @"results should be nil");
}

- (void)testEmptyInputs
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil request:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
}

- (void)testStatuses
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"jasngbgbubguobgO"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusUnknown, @"status should be FTGooglePlacesAPIResponseStatusUnknown");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OK"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status should be FTGooglePlacesAPIResponseStatusOK");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"ZERO_RESULTS"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNoResults, @"status should be FTGooglePlacesAPIResponseStatusNoResults");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OVER_QUERY_LIMIT"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusAPILimitExceeded, @"status should be FTGooglePlacesAPIResponseStatusAPILimitExceeded");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"REQUEST_DENIED"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusRequestDenied, @"status should be FTGooglePlacesAPIResponseStatusRequestDenied");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"INVALID_REQUEST"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPIResponseStatusInvalidRequest");
}

- (void)testRequestAndNextPageRequestMethod
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-OK.json"];
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:request];

    XCTAssertNotNil(request, @"request should not be nil");
    XCTAssertNotNil(response, @"response should not be nil");
    
    XCTAssertEqual(response.request, request, @"request is wrong");
    
    id<FTGooglePlacesAPIRequest>nextPageRequest = [response nextPageRequest];
    XCTAssertNotNil(nextPageRequest, @"nextPageRequest should not be nil");
    
    XCTAssertEqualObjects([nextPageRequest requestTypeUrlString], @"testrequest", @"nextPageRequest requestTypeUrlString is wrong");
    NSDictionary *expectedRequestParams = @{@"pagetoken": @"CmRbAAAAPRe43WuMoqKDiLcauzH5NR5Agm6U5pqiP5gPALHlvKSe89bdGpjNj7VCnHXn0-7gr1b2CeuZyJW0PvUultBCu8IAFOWINBvhQ2u_b1URH6Fs_MI_P6jN551VrBxSYjEKEhBf08hzwZ3fXu4zMRhhIpMfGhR75rfrvBBpTtlS9AwJ2JpIeCrMBA"};
    XCTAssertEqualObjects([nextPageRequest placesAPIRequestParams], expectedRequestParams, @"pageToken returned by nextPageRequest: is wrong");
}

- (void)testParsingRealResponseOK
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-OK.json"];
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:request];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status should be FTGooglePlacesAPIResponseStatusOK");
    XCTAssertEqualObjects(response.nextPageToken, @"CmRbAAAAPRe43WuMoqKDiLcauzH5NR5Agm6U5pqiP5gPALHlvKSe89bdGpjNj7VCnHXn0-7gr1b2CeuZyJW0PvUultBCu8IAFOWINBvhQ2u_b1URH6Fs_MI_P6jN551VrBxSYjEKEhBf08hzwZ3fXu4zMRhhIpMfGhR75rfrvBBpTtlS9AwJ2JpIeCrMBA", @"nextPageToken is wrong");
    XCTAssertNotNil([response nextPageRequest], @"nextPageRequest should not be nil");
    
    XCTAssertEqual([response.results count], (NSUInteger)20, @"response should have 20 results items");
    XCTAssertEqual([response.results[0] class], [FTGooglePlacesAPIResultItem class], @"repsonse item should be of class FTGooglePlacesAPIResultItem");
}

- (void)testParsingRealResponseNoResults
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test2-NoResults.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNoResults, @"status should be FTGooglePlacesAPIResponseStatusNoResults");
}

- (void)testParsingRealResponseInvalidRequest
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test3-InvalidRequest.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPIResponseStatusInvalidRequest");
}

- (void)testParsingRealResponseRequestDenied
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test4-RequestDenied.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusRequestDenied, @"status should be FTGooglePlacesAPIResponseStatusRequestDenied");
}

@end
