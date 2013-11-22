//
//  FTGooglePlacesAPIResponseTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPISearchResponse.h"
#import "FTGooglePlacesAPISearchResultItem.h"
#import "FTGooglePlacesAPIDictionaryRequest.h"

@interface FTGooglePlacesAPISearchResponseTests : FTGooglePlacesAPITestCase

@end

@implementation FTGooglePlacesAPISearchResponseTests

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
    FTGooglePlacesAPISearchResponse *response;
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:nil request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:nil request:nil resultsItemClass:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
    XCTAssertNil(response.request, @"request should be nil");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"OK"} request:nil];
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
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response.htmlAttributions, @"htmlAttributions should not be nil");
    XCTAssertEqualObjects(@([response.htmlAttributions count]), @2, @"wrong number of htmlAttributions");
    NSArray *expectedHtmlAttributions = @[@"atribution1", @"attribution2"];
    XCTAssertEqualObjects(response.htmlAttributions, expectedHtmlAttributions, @"wrong htmlAttributions");
    XCTAssertNil(response.request, @"request should be nil");
    
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusOK, @"status is wrong");
    
    XCTAssertNil(response.results, @"results should be nil");
}

- (void)testEmptyInputs
{
    FTGooglePlacesAPISearchResponse *response;
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:nil request:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"response should be nil");
}

- (void)testStatuses
{
    FTGooglePlacesAPISearchResponse *response;
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"jasngbgbubguobgO"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusUnknown, @"status should be FTGooglePlacesAPISearchResponseStatusUnknown");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"OK"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusOK, @"status should be FTGooglePlacesAPISearchResponseStatusOK");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"ZERO_RESULTS"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusNoResults, @"status should be FTGooglePlacesAPISearchResponseStatusNoResults");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"OVER_QUERY_LIMIT"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusAPILimitExceeded, @"status should be FTGooglePlacesAPISearchResponseStatusAPILimitExceeded");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"REQUEST_DENIED"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusRequestDenied, @"status should be FTGooglePlacesAPISearchResponseStatusRequestDenied");
    
    response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{@"status": @"INVALID_REQUEST"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPISearchResponseStatusInvalidRequest");
}

- (void)testRequestAndNextPageRequestMethod
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-OK.json"];
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:request];

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
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:request];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusOK, @"status should be FTGooglePlacesAPISearchResponseStatusOK");
    XCTAssertEqualObjects(response.nextPageToken, @"CmRbAAAAPRe43WuMoqKDiLcauzH5NR5Agm6U5pqiP5gPALHlvKSe89bdGpjNj7VCnHXn0-7gr1b2CeuZyJW0PvUultBCu8IAFOWINBvhQ2u_b1URH6Fs_MI_P6jN551VrBxSYjEKEhBf08hzwZ3fXu4zMRhhIpMfGhR75rfrvBBpTtlS9AwJ2JpIeCrMBA", @"nextPageToken is wrong");
    XCTAssertNotNil([response nextPageRequest], @"nextPageRequest should not be nil");
    
    XCTAssertEqual([response.results count], (NSUInteger)20, @"response should have 20 results items");
    XCTAssertEqual([response.results[0] class], [FTGooglePlacesAPISearchResultItem class], @"repsonse item should be of class FTGooglePlacesAPISearchResultItem");
}

- (void)testParsingRealResponseNoResults
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test2-NoResults.json"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusNoResults, @"status should be FTGooglePlacesAPISearchResponseStatusNoResults");
}

- (void)testParsingRealResponseInvalidRequest
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test3-InvalidRequest.json"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPISearchResponseStatusInvalidRequest");
}

- (void)testParsingRealResponseRequestDenied
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test4-RequestDenied.json"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPISearchResponseStatusRequestDenied, @"status should be FTGooglePlacesAPISearchResponseStatusRequestDenied");
}

@end
