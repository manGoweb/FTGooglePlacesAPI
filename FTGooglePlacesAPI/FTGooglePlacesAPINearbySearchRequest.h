//
//  FTGooglePlacesAPIRequest.h
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
//  Some of properties descriptions are copied from the Google Places API Documentation
//  at https://developers.google.com/places/documentation/search
//  Since this library aims to provide almost complete access to the places,
//  Google's docs descriptions are most relevant.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "FTGooglePlacesAPICommon.h"

/**
 *  Class for encapsulating Google Places API "Nearby Search" request
 *  See https://developers.google.com/places/documentation/search#PlaceSearchRequests
 *
 *  A Nearby Search lets you search for Places within a specified area.
 *  You can refine your search request by supplying keywords or specifying
 *  the type of Place you are searching for.
 *
 *  FTGooglePlacesAPINearbySearchRequest and FTGooglePlacesAPITextSearchRequest
 *  have a lot of the same code. They don't have the common superclass
 *  (and so have copied code) to make them totaly standalone.
 *  We don't have any quarantee the single concrete request won't change
 *  in the future (keys dependency or exclusivity etc.) and shared common
 *  code and properties could cause a lot of trouble in that case
 */

/**
 *  @see rankBy
 */
typedef NS_ENUM(NSUInteger, FTGooglePlacesAPIRequestParamRankBy) {
    /**
     *  This option sorts results based on their importance. Ranking will favor prominent
     *  places within the specified area. Prominence can be affected by a Place's ranking
     *  in Google's index, the number of check-ins from your application, global popularity,
     *  and other factors.
     */
    FTGooglePlacesAPIRequestParamRankByProminence,
    /**
     *  This option sorts results in ascending order by their distance from the specified
     *  location. Ranking results by distance will set a fixed search radius of 50km.
     *  One or more of keyword, name, or types is required.
     */
    FTGooglePlacesAPIRequestParamRankByDistance
};


@interface FTGooglePlacesAPINearbySearchRequest : NSObject <FTGooglePlacesAPIRequest>

//  Required parameters

/**
 *  The latitude/longitude around which to retrieve Place information.
 *  Property is read-only, value is set in init method
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D locationCoordinate;

/**
 *  Defines the distance (in meters) within which to return Place results.
 *  The maximum allowed radius is 50 000 meters. Default: 5 000
 */
@property (nonatomic, assign) NSUInteger radius;

/*
 *  Optional parameters
 *  See https://developers.google.com/places/documentation/search for detailed descriptions
 */

/**
 *  A term to be matched against all content that Google has indexed for this Place,
 *  including but not limited to name, type, and address, as well as customer reviews
 *  and other third-party content.
 */
@property (nonatomic, copy) NSString *keyword;

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
 *  One or more terms to be matched against the names of Places provided as an array
 *  of NSStrings. Results will be restricted to those containing the passed name values.
 *  Note that a Place may have additional names associated with it, beyond its listed name.
 *  The API will try to match the passed name value against all of these names;
 *  as a result, Places may be returned in the results whose listed names do not match
 *  the search term, but whose associated names do.
 */
@property (nonatomic, copy) NSArray *names;

/**
 *  Restricts results to only those places within the specified range. Valid values
 *  range between 0 (most affordable) to 4 (most expensive), inclusive. The exact amount
 *  indicated by a specific value will vary from region to region.
 *  When passed in value is >4, 4 is used.
 *  Default value is NSUIntegerMax indicating this value will not be present in a request
 */
@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;

/**
 *  Returns only those Places that are open for business at the time
 *  the query is sent. Places that do not specify opening hours
 *  in the Google Places database will not be returned if you
 *  include this parameter in your query.
 *  Default: NO
 */
@property (nonatomic, assign) BOOL openNow;

/**
 *  Specifies the order in which results are listed.
 *  Default: FTGooglePlacesAPIRequestParamRankByProminence
 */
@property (nonatomic, assign) FTGooglePlacesAPIRequestParamRankBy rankBy;

/**
 *  Restricts the results to Places matching at least one of the specified types.
 *  Provide array of NSStrings
 *  See https://developers.google.com/places/documentation/supported_types
 *  for the list of all available types
 */
@property (nonatomic, copy) NSArray *types;

/**
 *   Returns the next 20 results from a previously run search. Setting a pagetoken parameter will execute
 *   a search with the same parameters used previously
 */
@property (nonatomic, copy) NSString *pageToken;


/**
 *  Creates new intance of Places API request.
 *
 *  @param locationCoordinate The latitude/longitude around which to retrieve Place information. This stands for "location" Google Places API parameter
 *
 *  @return Request instance. If the provided location coordinates are invalid, returns nil
 */
- (instancetype)initWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate;

@end
