//
//  FTGooglePlacesAPIDetailResponse.h
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
//  at https://developers.google.com/places/documentation/details
//  Since this library aims to provide almost complete access to the places,
//  Google's docs descriptions are most relevant.


#import "FTGooglePlacesAPIResponse.h"
#import <CoreLocation/CoreLocation.h>

@interface FTGooglePlacesAPIDetailResponse : FTGooglePlacesAPIResponse

/**
 *  Contain a set of attributions about this listing which must be displayed to the user
 *  to conform Google Terms and Conditions
 */
@property (nonatomic, strong, readonly) NSArray *htmlAttributions;

/**
 *  A unique stable identifier denoting this place. This identifier may not be
 *  used to retrieve information about this place, but can be used to consolidate
 *  data about this Place, and to verify the identity of a Place across separate
 *  searches. As ids can occasionally change, it's recommended that the stored id
 *  for a Place be compared with the id returned in later Details requests for
 *  the same Place, and updated if necessary.
 */
@property (nonatomic, strong, readonly) NSString *itemId;

/**
 *  Human-readable name for the returned result.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  CLLocation representing results coordinates. If the returned coordinates were invalid,
 *  location will be nil
 */
@property (nonatomic, strong, readonly) CLLocation *location;

/**
 *  "vicinity" from response
 *  Simplified address for the Place, including the street name, street number,
 *  and locality, but not the province/state, postal code, or country.
 */
@property (nonatomic, strong, readonly) NSString *addressString;

/**
 *  String containing the human-readable address of this place.
 *  Often this address is equivalent to the "postal address," which sometimes
 *  differs from country to country. This address is generally composed of
 *  one or more address_component fields
 */
@property (nonatomic, strong, readonly) NSString *formattedAddress;

@property (nonatomic, strong, readonly) NSString *formattedPhoneNumber;
@property (nonatomic, strong, readonly) NSString *internationalPhoneNumber;

@property (nonatomic, strong, readonly) NSString *iconImageUrl;
@property (nonatomic, assign, readonly) CGFloat rating;

/**
 *  Contains a unique token that you can use to retrieve additional information
 *  about this place in a Place Details request. You can store this token and use
 *  it at any time in future to refresh cached data about this Place, but the same
 *  token is not guaranteed to be returned for any given Place across different searches.
 */
@property (nonatomic, strong, readonly) NSString *reference;
@property (nonatomic, strong, readonly) NSArray *types;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSURL *websiteUrl;

@property (nonatomic, assign, readonly) NSTimeInterval utcOffset;

@end
