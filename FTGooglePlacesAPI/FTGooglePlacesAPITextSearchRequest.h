//
//  FTGooglePlacesAPITextSearchRequest.h
//
//  Created by Lukas Kukacka on 10/30/13.
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FTGooglePlacesAPICommon.h"

/**
 *  Class for encapsulating Google Places API "Text Search" request.
 *  See https://developers.google.com/places/documentation/search
 *
 *  The Google Places API Text Search Service is a web service that
 *  returns information about a set of Places based on a string
 *  — for example "pizza in New York" or "shoe stores near Ottawa".
 *  The service responds with a list of Places matching the text
 *  string and any location bias that has been set.
 *
 *  FTGooglePlacesAPINearbySearchRequest and FTGooglePlacesAPITextSearchRequest
 *  have a lot of the same code. They don't have the common superclass
 *  (and so have copied code) to make them totaly standalone.
 *  We don't have any quarantee the single concrete request won't change
 *  in the future (keys dependency or exclusivity etc.) and shared common
 *  code and properties could cause a lot of trouble in that case
 */

@interface FTGooglePlacesAPITextSearchRequest : NSObject <FTGooglePlacesAPIRequest>

/**
 *  The text string on which to search, for example: "restaurant". The Place service 
 *  will return candidate matches based on this string and order the results based
 *  on their perceived relevance.
 *  Property is read-only, is set in init method.
 */
@property (nonatomic, copy, readonly) NSString *query;

/**
 *  The latitude/longitude around which to retrieve Place information.
 *  This stands for "location" Google Places API parameter
 *  This must be specified as latitude,longitude. If you specify a location
 *  parameter, you must also specify a radius parameter.
 */
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

/**
 *  Defines the distance (in meters) within which to return Place results.
 *  The maximum allowed radius is 50 000 meters. Default: none
 */
@property (nonatomic, assign) NSUInteger radius;

/**
 *  The language code, indicating in which language the results should be returned, if possible.
 *  See http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 for a complete list
 *
 *  Default value is determined by active application language from NSUserDefaults
 *  if available
 *  (details: https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/Articles/ChoosingLocalizations.html)
 */
@property (nonatomic, copy) NSString *language;

/**
 *  Restricts results to only those places within the specified range. Valid values
 *  range between 0 (most affordable) to 4 (most expensive), inclusive. The exact amount
 *  indicated by a specific value will vary from region to region.
 *  When passed in value is >4, 4 is used
 *  Default value is NSUIntegerMax indicating this value will not be present in a request
 */
@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;

/**
 *  Returns only those Places that are open for business at the time
 *  the query is sent. Places that do not specify opening hours
 *  in the Google Places database will not be returned if you
 *  include this parameter in your query.
 */
@property (nonatomic, assign) BOOL openNow;

/**
 *  Restricts the results to Places matching at least one of the specified types.
 *  Provide array of NSStrings
 *  See https://developers.google.com/places/documentation/supported_types
 *  for the list of all available types
 */
@property (nonatomic, copy) NSArray *types;

/**
 *  Creates new intance of Places API request.
 *
 *  @param The text string on which to search, for example: "restaurant". The Place service will return candidate matches based on this string and order the results based on their perceived relevance.
 *
 *  @return Request instance. If the location provided is invalid, returns nil
 */
- (instancetype)initWithQuery:(NSString *)query;

@end
