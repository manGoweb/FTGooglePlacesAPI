//
//  FTGooglePlacesAPIResponse.h
//
//  Created by Lukas Kukacka on 10/29/13.
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//
//  Some of properties descriptions are copied from the Google Places API Documentation
//  at https://developers.google.com/places/documentation/search
//  Since this library aims to provide almost complete access to the places,
//  Google's docs descriptions are most relevant.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, FTGooglePlacesAPIResponseStatus) {
    /**
     *  Unknown state will be used only in case unknown status is present
     *  in the input dictionary.
     *  This should never happen unless the API specs change
     */
    FTGooglePlacesAPIResponseStatusUnknown = 0,
    FTGooglePlacesAPIResponseStatusOK, // OK
    FTGooglePlacesAPIResponseStatusNoResults, // ZERO_RESULTS
    FTGooglePlacesAPIResponseStatusAPILimitExceeded, // OVER_QUERY_LIMIT
    FTGooglePlacesAPIResponseStatusRequestDenied, // REQUEST_DENIED
    FTGooglePlacesAPIResponseStatusInvalidRequest // INVALID_REQUEST
};

/**
 *  Object encapsulationg response from the Google Places API request
 *  Properties correpond to the keys in a response
 *  Details: https://developers.google.com/places/documentation/search#PlaceSearchResponses
 */
@interface FTGooglePlacesAPIResponse : NSObject

/**
 *  Array of results items. Items are instances of class provided in init... method
 */
@property (nonatomic, strong, readonly) NSArray *results;

/**
 *  Contains response status
 *  Details: https://developers.google.com/places/documentation/search#PlaceSearchStatusCodes
 */
@property (nonatomic, assign, readonly) FTGooglePlacesAPIResponseStatus status;

/**
 *  Contain a set of attributions about this listing which must be displayed to the user
 *  to conform Google Terms and Conditions
 */
@property (nonatomic, strong, readonly) NSArray *htmlAttributions;

/**
 *  Calls designated initializer with nil class
 *  @see initWithDictionary:andResultsItemClass:
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Designated initializer for a response.
 *
 *  @param dictionary       Dictionary from which the response will be parsed.
 *  @param resultsItemClass Class of the result item to be used. You can either subclass of FTGooglePlacesAPIResultItem or nil. When nil is used, default FTGooglePlacesAPIResultItem will be used
 *
 *  @return Initialized instance of the response parsed from the dictionary or nil if anything failed
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary andResultsItemClass:(Class)resultsItemClass;

+ (NSString *)localizedNameOfStatus:(FTGooglePlacesAPIResponseStatus)status;
+ (NSString *)localizedDescriptionForStatus:(FTGooglePlacesAPIResponseStatus)status;

@end