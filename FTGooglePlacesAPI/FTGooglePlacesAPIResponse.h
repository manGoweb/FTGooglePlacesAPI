//
//  FTGooglePlacesAPIResponse.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 29/11/13.
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

@protocol FTGooglePlacesAPIRequest;


typedef NS_ENUM(NSUInteger, FTGooglePlacesAPIResponseStatus) {
    FTGooglePlacesAPIResponseStatusUnknown = 0, // Default or UNKNOWN_ERROR
    FTGooglePlacesAPIResponseStatusOK, // OK
    FTGooglePlacesAPIResponseStatusNoResults, // ZERO_RESULTS
    FTGooglePlacesAPIResponseStatusAPILimitExceeded, // OVER_QUERY_LIMIT
    FTGooglePlacesAPIResponseStatusRequestDenied, // REQUEST_DENIED
    FTGooglePlacesAPIResponseStatusInvalidRequest, // INVALID_REQUEST
    FTGooglePlacesAPIResponseStatusNotFound // NOT_FOUND
};

/**
 *  Basic "abstract" object for encapsulating Google Places API response.
 *  DO NOT USE this class DIRECTLY. It is meant to be more of a abstract
 *  class, which is unfortunatelly not supported in Objective-C.
 *
 *  This class and all of its subclasses are Key-Value coding ready.
 *  You can use |valueForKeyPath:| for accessing values from the original 
 *  response dictionary.
 */
@interface FTGooglePlacesAPIResponse : NSObject

/**
 *  Request which resulted in this response
 */
@property (nonatomic, strong, readonly) id<FTGooglePlacesAPIRequest> request;

/**
 *  NSDictionary returned as a response and passed in the initialization
 */
@property (nonatomic, strong, readonly) NSDictionary *originalResponseDictionary;

/**
 *  Contains response status
 *  Details: https://developers.google.com/places/documentation/search#PlaceSearchStatusCodes
 */
@property (nonatomic, assign, readonly) FTGooglePlacesAPIResponseStatus status;

/**
 *  Designated initializer with nil class
 *  @see initWithDictionary:request:resultsItemClass:
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request;


+ (NSString *)localizedNameOfStatus:(FTGooglePlacesAPIResponseStatus)status;
+ (NSString *)localizedDescriptionForStatus:(FTGooglePlacesAPIResponseStatus)status;

@end
