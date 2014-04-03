//
//  FTGooglePlacesAPINearbySearchRequestTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 21/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPINearbySearchRequest.h"

@interface FTGooglePlacesAPINearbySearchRequestTests : FTGooglePlacesAPITestCase {
    
    CLLocationCoordinate2D _locationCoordinate;
}

@end

@implementation FTGooglePlacesAPINearbySearchRequestTests

- (void)setUp
{
    [super setUp];
    
    _locationCoordinate = CLLocationCoordinate2DMake(51.501103,-0.124565);
}

- (void)testBasicInitialization
{
    FTGooglePlacesAPINearbySearchRequest *request;
    
    request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:_locationCoordinate];
    XCTAssertNotNil(request, @"request should not be nil");
    
    CLLocationCoordinate2D invalidLocationCoordinate = CLLocationCoordinate2DMake(10000, 10000);
    request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:invalidLocationCoordinate];
    XCTAssertNil(request, @"request should be nil");
}

- (void)testProperties
{
    FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:_locationCoordinate];
    
    XCTAssertEqual(request.locationCoordinate.latitude, _locationCoordinate.latitude, @"locationCoordinate is wrong");
    XCTAssertEqual(request.locationCoordinate.longitude, _locationCoordinate.longitude, @"locationCoordinate is wrong");

    //  Radius
    XCTAssertEqual(request.radius, (NSUInteger)5000, @"default radius is wrong");
    request.radius = 12345;
    XCTAssertEqual(request.radius, (NSUInteger)12345, @"radius is wrong");
    
    //  Keyword
    XCTAssertNil(request.keyword, @"default keyword is wrong");
    request.keyword = @"tested keyword #$~$##@#";
    XCTAssertEqualObjects(request.keyword, @"tested keyword #$~$##@#", @"keyword is wrong");
    
    //  Language
    XCTAssertNotNil(request.language, @"default language should not be nil");
    request.language = @"cs";
    XCTAssertEqualObjects(request.language, @"cs", @"language is wrong");
    
    //  Names
    XCTAssertNil(request.names, @"default names should be nil");
    request.names = @[@"testname", @"agsasg*{;'[>–"];
    NSArray *expectedNames = @[@"testname", @"agsasg*{;'[>–"];
    XCTAssertEqualObjects(request.names, expectedNames, @"names is wrong");
    
    // min and max price
    XCTAssertEqual(request.minPrice, (NSUInteger)NSUIntegerMax, @"default minPrice is wrong");
    XCTAssertEqual(request.maxPrice, (NSUInteger)NSUIntegerMax, @"default maxPrice is wrong");
    
    //  Test accessors are properly adjusting values
    request.minPrice = 123;
    XCTAssertEqual(request.minPrice, (NSUInteger)4, @"minPrice bigger value should be 4");

    request.maxPrice = 3243;
    XCTAssertEqual(request.maxPrice, (NSUInteger)4, @"maxPrice bigger value should be 4");
    
    
    //  Open now
    XCTAssertFalse(request.openNow, @"default openNow is wrong");
    request.openNow = YES;
    XCTAssertTrue(request.openNow, @"openNow is wrong");
    
    //  Rank by
    XCTAssertEqual(request.rankBy, FTGooglePlacesAPIRequestParamRankByProminence, @"default rankBy is wrong");
    request.rankBy = FTGooglePlacesAPIRequestParamRankByDistance;
    XCTAssertEqual(request.rankBy, FTGooglePlacesAPIRequestParamRankByDistance, @"rankyBy is wrong");
    
    //  Types
    XCTAssertNil(request.types, @"default types should be nil");
    request.types = @[@"mytype", @"testtype"];
    NSArray *expectedTypes = @[@"mytype", @"testtype"];
    XCTAssertEqualObjects(request.types, expectedTypes, @"types are wrong");
    
    //  Page token
    XCTAssertNil(request.pageToken, @"default page token is wrong");
    request.pageToken = @"dnagadguiabdsguab";
    XCTAssertEqualObjects(request.pageToken, @"dnagadguiabdsguab", @"pageToken is wrong");
}

- (void)testProtocolRequestType
{
    FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:_locationCoordinate];
    XCTAssertEqualObjects([request placesAPIRequestMethod], @"nearbysearch", @"request type is wrong");
}

- (void)testProtocolParameters1
{
    FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:_locationCoordinate];
    XCTAssertEqualObjects([request placesAPIRequestMethod], @"nearbysearch", @"request type is wrong");
    
    request.keyword = @"test keyword";
    request.rankBy = FTGooglePlacesAPIRequestParamRankByDistance;
    request.types = @[@"art_gallery", @"museum"];
    request.language = @"cs";
    request.openNow = YES;
    
    NSDictionary *expectedOutput = @{
       @"location": @"51.5011030,-0.1245650",
       @"keyword": @"test+keyword",
       @"rankby": @"distance",
       @"types": @"art_gallery|museum",
       @"language": @"cs",
       @"opennow": [NSNull null],
    };
    XCTAssertEqualObjects([request placesAPIRequestParams], expectedOutput, @"ouput params are wrong");
}

- (void)testProtocolParameters2
{
    FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:_locationCoordinate];
    XCTAssertEqualObjects([request placesAPIRequestMethod], @"nearbysearch", @"request type is wrong");
    
    request.rankBy = FTGooglePlacesAPIRequestParamRankByProminence;
    request.types = @[@"store"];
    
    NSDictionary *expectedOutput = @{
        @"location": @"51.5011030,-0.1245650",
        @"types": @"store",
        @"rankby": @"prominence",
        @"language": @"en",
        @"radius": @"5000"
    };
    XCTAssertEqualObjects([request placesAPIRequestParams], expectedOutput, @"ouput params are wrong");
}

@end
