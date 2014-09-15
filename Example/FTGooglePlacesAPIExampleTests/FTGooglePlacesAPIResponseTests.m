//
//  FTGooglePlacesAPIResponseTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 05/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

#import "FTGooglePlacesAPIResponse.h"

@interface FTGooglePlacesAPIResponseTests : FTGooglePlacesAPITestCase

@end

@implementation FTGooglePlacesAPIResponseTests

- (void)testSimpleInit
{
    FTGooglePlacesAPIResponse *response;
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:nil request:nil];
    XCTAssertNil(response, @"");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{} request:nil];
    XCTAssertNil(response, @"");
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{ @"key" : @"value" } request:nil];
    XCTAssertNotNil(response, @"");
}

- (void)testSharedPropertiesAreSetAfterInit
{
    //  It is expected the response to check number of objects in a dictionary first
    NSDictionary *testDictionary = @{ @"key" : @"value" };
    id dictionaryMock = [OCMockObject partialMockForObject:testDictionary];
    [[[dictionaryMock expect] andForwardToRealObject] count];
    
    id requestMock = [OCMockObject mockForProtocol:@protocol(FTGooglePlacesAPIRequest)];
    
    FTGooglePlacesAPIResponse *response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:dictionaryMock request:requestMock];
    
    XCTAssertEqual(response.originalResponseDictionary, dictionaryMock, @"");
    [dictionaryMock verify];
    
    XCTAssertEqual(response.request, requestMock, @"");
}

- (void)testStatusIsProperlyParsed
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
    
    response = [[FTGooglePlacesAPIResponse alloc] initWithDictionary:@{@"status": @"NOT_FOUND"} request:nil];
    XCTAssertEqual(response.status, FTGooglePlacesAPIResponseStatusNotFound, @"status should be FTGooglePlacesAPIResponseStatusNotFound");
}

- (void)testAllStatusesHaveLocalizedName
{
    NSString *name;
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusUnknown];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusUnknown status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusOK];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusOK status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusNoResults];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusNoResults status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusAPILimitExceeded];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusAPILimitExceeded status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusRequestDenied];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusRequestDenied status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusInvalidRequest];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusInvalidRequest status does not have localized name");
    
    name = [FTGooglePlacesAPIResponse localizedNameOfStatus:FTGooglePlacesAPIResponseStatusNotFound];
    XCTAssert([name length] > 0, @"FTGooglePlacesAPIResponseStatusNotFound status does not have localized name");
}

- (void)testAllStatusesHaveLocalizedDescription
{
    NSString *description;
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusUnknown];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusUnknown status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusOK];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusOK status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusNoResults];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusNoResults status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusAPILimitExceeded];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusAPILimitExceeded status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusRequestDenied];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusRequestDenied status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusInvalidRequest];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusInvalidRequest status does not have a localized description");
    
    description = [FTGooglePlacesAPIResponse localizedDescriptionForStatus:FTGooglePlacesAPIResponseStatusNotFound];
    XCTAssert([description length] > 0, @"FTGooglePlacesAPIResponseStatusNotFound status does not have a localized description");
}

@end
