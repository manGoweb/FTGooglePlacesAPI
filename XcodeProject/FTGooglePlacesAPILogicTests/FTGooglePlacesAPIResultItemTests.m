//
//  FTGooglePlacesAPIResponseItemTests.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FTGooglePlacesAPIResultItem.h"


@interface FTGooglePlacesAPIResultItemTests : XCTestCase

@end


@implementation FTGooglePlacesAPIResultItemTests

- (void)testParsingFromManualDictionary
{
    //  Example output JSON examples
    NSDictionary *dictionary = @{
        @"geometry": @{
            @"location": @{
                @"lat": @(51.502514),
                @"lng": @(-0.118782)
            }
        },
        @"icon": @"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png",
        @"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5",
        @"name": @"London Film Museum South Bank",
        @"opening_hours": @{
            @"open_now": @(YES)
        },
        @"photos": @[
            @{
                @"height": @(1154),
                @"html_attributions": @[@"<a href=\"https://plus.google.com/104713496079301355451\">cesar vazquez</a>"],
                @"photo_reference": @"CpQBhwAAAPP1yLpftkF_7O6WJpEM-SNyONWXeonrVGI5IJv77BOW3kzRmnpVS6e9Ig1eExkAvi0",
                @"width": @(2048)
            }
        ],
        @"rating": @(3.6),
        @"reference": @"CoQBgAAAAFjx_1xLA2D3kuZ83rCChllMEaGrxSeoPh6",
        @"types": @[@"museum", @"establishment"],
        @"vicinity": @"1st Floor, Riverside Building, County Hall, London"
    };
    

    FTGooglePlacesAPIResultItem *item = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary];
    XCTAssertNotNil(item, @"Initialiazation should succeed");
    
    XCTAssertEqualObjects(item.itemId, @"5139d09fbccf4c974fce66f7d88269c149bac0a5", @"itemId is wrong");
    XCTAssertEqualObjects(item.name, @"London Film Museum South Bank", @"name is wrong");
    
    XCTAssertNotNil(item.location, @"location should be non-nil");
    XCTAssertEqual(item.location.coordinate.latitude, 51.502514, @"location.latitude is wrong");
    XCTAssertEqual(item.location.coordinate.longitude, -0.118782, @"location.longitude is wrong");
    
    XCTAssertEqualObjects(item.addressString, @"1st Floor, Riverside Building, County Hall, London");
    
    XCTAssertEqual(item.openedState, FTGooglePlacesAPIResultItemOpenedStateOpened, @"openedState is wrong");
    XCTAssertEqualObjects(item.iconImageUrl, @"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png", @"iconImageUrl is wrong");
    XCTAssertEqual(item.rating, 3.6f, @"rating is wrong");
    XCTAssertEqualObjects(item.reference, @"CoQBgAAAAFjx_1xLA2D3kuZ83rCChllMEaGrxSeoPh6", @"reference is wrong");
    
    NSArray *typesExpectedResult = @[@"museum", @"establishment"];
    XCTAssertEqualObjects(item.types, typesExpectedResult, @"types are wrong");
    
    XCTAssertEqualObjects(item.originalDictionaryRepresentation, [dictionary copy], @"originalDictionaryRepresentation is wrong");
}

- (void)testVeryBasicObjectWithJustId
{
    FTGooglePlacesAPIResultItem *item = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:@{@"id": @"someValue"}];
    XCTAssertNotNil(item, @"item should be valid once it has id");
    
    item = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:@{}];
    XCTAssertNil(item, @"item should be nil when no id is provided");
    
    item = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:@{@"id": @""}];
    XCTAssertNil(item, @"item should be nil when id has 0 length");
}

- (void)testEqualityChecking
{
    NSDictionary *dictionary1a = @{@"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5"};
    NSDictionary *dictionary1b = @{@"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5"};
    
    FTGooglePlacesAPIResultItem *item1a = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary1a];
    FTGooglePlacesAPIResultItem *item1b = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary1b];
    
    XCTAssertEqualObjects(item1a, item1b, @"object are not considered to be equal, but should be");
    
    
    NSDictionary *dictionary2a = @{@"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5"};
    NSDictionary *dictionary2b = @{@"id": @"XAXAGFKANGOKANOAOGNAOGOIANGOI AOAANGO"};
    
    FTGooglePlacesAPIResultItem *item2a = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary2a];
    FTGooglePlacesAPIResultItem *item2b = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary2b];
    
    XCTAssertNotEqualObjects(item2a, item2b, @"object with differents ids should not be considered to be equal");
}

- (void)testEmptyValues
{
    NSDictionary *dictionary = @{@"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5"};
    
    FTGooglePlacesAPIResultItem *item = [[FTGooglePlacesAPIResultItem alloc] initWithDictionary:dictionary];
    
    XCTAssertNil(item.name, @"name should be nil");
    XCTAssertNil(item.location, @"location should be nil");
    XCTAssertNil(item.addressString, @"addressString should be nil");
    XCTAssertEqual(item.openedState, FTGooglePlacesAPIResultItemOpenedStateUnknown, @"openedState should be Unknown");
    XCTAssertNil(item.iconImageUrl, @"iconImageUrl should be nil");
    XCTAssertEqual(item.rating, 0.0f, @"rating should be 0.0f");
    XCTAssertNil(item.reference, @"reference should be nil");
    XCTAssertNil(item.types, @"types should be nil");
    
    XCTAssertEqualObjects(item.originalDictionaryRepresentation, @{@"id": @"5139d09fbccf4c974fce66f7d88269c149bac0a5"}, @"originalDictionaryRepresentation is wrong");
}

@end
