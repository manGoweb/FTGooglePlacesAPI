//
//  FTGooglePlacesAPIDictionaryRequestTest.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 21/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPIDictionaryRequest.h"

@interface FTGooglePlacesAPIDictionaryRequestTest : FTGooglePlacesAPITestCase

@end

@implementation FTGooglePlacesAPIDictionaryRequestTest

- (void)testBasicInitialization
{
    FTGooglePlacesAPIDictionaryRequest *request;
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:nil requestType:nil];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{} requestType:nil];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:nil requestType:@""];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{} requestType:@""];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:nil];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@""];
    XCTAssertNil(request, @"request should be nil");
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{} requestType:@"testrequest"];
    XCTAssertNotNil(request, @"request should not be nil");
}

- (void)testProtocolImplementation
{
    FTGooglePlacesAPIDictionaryRequest *request;
    
    request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:@{@"testkey": @"testvalue"} requestType:@"testrequest"];
    
    XCTAssertEqualObjects([request placesAPIRequestMethod], @"testrequest", @"requestTypeUrlString is wrong");
    XCTAssertEqualObjects([request placesAPIRequestParams], @{@"testkey": @"testvalue"}, @"placesAPIRequestParams is wrong");
}

@end
