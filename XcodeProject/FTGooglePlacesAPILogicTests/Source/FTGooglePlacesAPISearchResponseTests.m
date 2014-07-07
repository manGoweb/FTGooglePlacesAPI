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

#import "MockFTGooglePlacesAPISearchResultItemSubclass.h"

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
    
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status is wrong");
    
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

- (void)testProperResponseClassIsChecked
{
    //  Check that it works with the proper subclass
    id mockSubclass = [[MockFTGooglePlacesAPISearchResultItemSubclass alloc] initWithDictionary:@{@"key":@"value"}];
    
    XCTAssertNoThrow([[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{} request:nil resultsItemClass:mockSubclass], @"Should not throw exception as the provided class is right");
    
    
    //  Check expecption is throws if resultItemClass is specified, but is not the proper subclass
    XCTAssertThrows([[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:@{} request:nil resultsItemClass:[NSObject class]], @"Should throw exception when the resultsItemClass is not subclass of FTGooglePlacesAPISearchResultItem");
}

- (void)testRequestAndNextPageRequestMethod
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-Nearby-Search-OK.json"];
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:request];

    XCTAssertNotNil(request, @"request should not be nil");
    XCTAssertNotNil(response, @"response should not be nil");
    
    XCTAssertEqual(response.request, request, @"request is wrong");
    
    id<FTGooglePlacesAPIRequest>nextPageRequest = [response nextPageRequest];
    XCTAssertNotNil(nextPageRequest, @"nextPageRequest should not be nil");
    
    XCTAssertEqualObjects([nextPageRequest placesAPIRequestMethod], @"testrequest", @"nextPageRequest requestTypeUrlString is wrong");
    NSDictionary *expectedRequestParams = @{@"pagetoken": @"CoQCAAEAACUEBVd58EGiJKFOe1KoEFks9jia46vhv6Bi4sR0ExZaFgvu6XqK2xgB6RXYqdWX1QP26UlcCR7DGiBwhH2-FN528X9J-CUH0JjUxauAzJjuxhyyxt946AW1ETRqecANfJdZ5_cjRwhR-0qQ13HeiQaB_riQPMG4SAqKcb8OMcHMtSJrJUacIIifXTNyxJpEbP8dvETT-pDM-0zl9qmTO0aqGdmz0EzyPAEuMCmZEMUI0gnZJvvDvaar_L4KCL6bhjGFqs5OrW-DIn1Vo5CI8bVD4VRINLdxAk7ovLOxT04p1M9qo6JNJ5ZZYntyX2MC64SvIe2RtFIGDGy046xJho4SECVEEiNhLUaQw1_2dUSO4zUaFKqr08lGcqbMqGhRJ9VG69t6YMgj"};
    XCTAssertEqualObjects([nextPageRequest placesAPIRequestParams], expectedRequestParams, @"pageToken returned by nextPageRequest: is wrong");
}

- (void)testParsingRealResponseOK
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test1-Nearby-Search-OK.json"];
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:request];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusOK, @"status should be FTGooglePlacesAPIResponseStatusOK");
    XCTAssertEqualObjects(response.nextPageToken, @"CoQCAAEAACUEBVd58EGiJKFOe1KoEFks9jia46vhv6Bi4sR0ExZaFgvu6XqK2xgB6RXYqdWX1QP26UlcCR7DGiBwhH2-FN528X9J-CUH0JjUxauAzJjuxhyyxt946AW1ETRqecANfJdZ5_cjRwhR-0qQ13HeiQaB_riQPMG4SAqKcb8OMcHMtSJrJUacIIifXTNyxJpEbP8dvETT-pDM-0zl9qmTO0aqGdmz0EzyPAEuMCmZEMUI0gnZJvvDvaar_L4KCL6bhjGFqs5OrW-DIn1Vo5CI8bVD4VRINLdxAk7ovLOxT04p1M9qo6JNJ5ZZYntyX2MC64SvIe2RtFIGDGy046xJho4SECVEEiNhLUaQw1_2dUSO4zUaFKqr08lGcqbMqGhRJ9VG69t6YMgj", @"nextPageToken is wrong");
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
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNoResults, @"status should be FTGooglePlacesAPIResponseStatusNoResults");
}

- (void)testParsingRealResponseInvalidRequest
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test3-InvalidRequest.json"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusInvalidRequest, @"status should be FTGooglePlacesAPIResponseStatusInvalidRequest");
}

- (void)testParsingRealResponseRequestDenied
{
    NSDictionary *dictionary = [[self class] JSONFromFileNamed:@"FTGooglePlacesAPIResponse-test4-RequestDenied.json"];
    
    FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:dictionary request:nil];
    
    XCTAssertNotNil(response, @"response should not be nil");
    XCTAssertNil(response.results, @"results should be nil");
    XCTAssertNil(response.nextPageToken, @"nextPageToken should be nil");
    XCTAssertNil([response nextPageRequest], @"nextPageRequest should be nil");
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusRequestDenied, @"status should be FTGooglePlacesAPIResponseStatusRequestDenied");
}

@end
