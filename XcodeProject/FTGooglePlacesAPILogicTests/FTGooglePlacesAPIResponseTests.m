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
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil andResultsItemClass:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{}];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{} andResultsItemClass:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OK"}];
    XCTAssertNotNil(response, @"response should be non-nil");
}

- (void)testBasicProperties
{
    NSDictionary *dictionary = @{
        @"html_attributions": @[@"atribution1", @"attribution2"],
        @"results": [NSNull null],
        @"status": @"OK"
    };
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(response.htmlAttributions, @"htmlAttributions should not be nil");
    XCTAssertEqualObjects(@([response.htmlAttributions count]), @2, @"wrong number of htmlAttributions");
    NSArray *expectedHtmlAttributions = @[@"atribution1", @"attribution2"];
    XCTAssertEqualObjects(response.htmlAttributions, expectedHtmlAttributions, @"wrong htmlAttributions");
    
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status is wrong");
    
    XCTAssertNil(response.results, @"results should be nil");
}

- (void)testEmptyInputs
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil];
    XCTAssertNil(response, @"response should be nil");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{}];
    XCTAssertNil(response, @"response should be nil");
}

- (void)testStatuses
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"jasngbgbubguobgO"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusUnknown, @"status should be FTGooglePlacesAPIResponseStatusUnknown");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OK"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status should be FTGooglePlacesAPIResponseStatusOK");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"ZERO_RESULTS"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNoResults, @"status should be FTGooglePlacesAPIResponseStatusNoResults");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"OVER_QUERY_LIMIT"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusAPILimitExceeded, @"status should be FTGooglePlacesAPIResponseStatusAPILimitExceeded");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"REQUEST_DENIED"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusRequestDenied, @"status should be FTGooglePlacesAPIResponseStatusRequestDenied");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"INVALID_REQUEST"}];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPIResponseStatusInvalidRequest");
}

- (void)testParsingRealResponseOK
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-OK.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status should be FTGooglePlacesAPIResponseStatusOK");
    XCTAssertEqual([response.results count], (NSUInteger)20, @"response should have 20 results items");
    
    XCTAssertEqual([response.results[0] class], [FTGooglePlacesAPIResultItem class], @"repsonse item should be of class FTGooglePlacesAPIResultItem");
}

- (void)testParsingRealResponseNoResults
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test2-NoResults.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNoResults, @"status should be FTGooglePlacesAPIResponseStatusNoResults");
}

- (void)testParsingRealResponseInvalidRequest
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test3-InvalidRequest.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPIResponseStatusInvalidRequest");
}

- (void)testParsingRealResponseRequestDenied
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test4-RequestDenied.json"];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusRequestDenied, @"status should be FTGooglePlacesAPIResponseStatusRequestDenied");
}

@end
