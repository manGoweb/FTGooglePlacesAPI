//
//  FTGooglePlacesAPISearchResultItem.h
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

/**
 *  Class encapsulating concrete record of Google Places API Response (item in the "results" array)
 */
typedef NS_ENUM(NSUInteger, FTGooglePlacesAPISearchResultItemOpenedState) {
    FTGooglePlacesAPISearchResultItemOpenedStateUnknown,  //  Value was not in the response
    FTGooglePlacesAPISearchResultItemOpenedStateOpened,   //  Item is opened
    FTGooglePlacesAPISearchResultItemOpenedStateClosed    //  Item is closed
};

@interface FTGooglePlacesAPISearchResultItem : NSObject

@property (nonatomic, strong, readonly) NSString *placeId;  // Google's id for the item
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  CLLocation representing results coordinates. If the returned coordinates were invalid,
 *  location will be nil
 */
@property (nonatomic, strong, readonly) CLLocation *location;

@property (nonatomic, strong, readonly) NSString *addressString;    // "vicinity" from the response
@property (nonatomic, assign, readonly) FTGooglePlacesAPISearchResultItemOpenedState openedState;
@property (nonatomic, strong, readonly) NSString *iconImageUrl;
@property (nonatomic, assign, readonly) CGFloat rating;
@property (nonatomic, strong, readonly) NSString *reference;
@property (nonatomic, strong, readonly) NSArray *types;

/**
 *  You can access complete response dictionary using this property.
 *  In case implementation changes in a future and there will be new values
 *  for example, you can access them directly using this property even
 *  if the library is not ready for those yet
 */
@property (nonatomic, strong, readonly) NSDictionary *originalDictionaryRepresentation;

/**
 *  Designated initializer contructs intance from a Google Places API
 *  response dictionary
 *
 *  @param dictionary Response dictionary (parsed JSON/XML)
 *
 *  @return Instance of a result
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Method for comparing equality of two result item objects.
 *  Objects are considered to be equal if their "placeId" equals.
 *
 *  @param item Item to compare with
 *
 *  @return YES if both objects are considered to be equal
 */
- (BOOL)isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)item;


/**
 *  Deprecations
 */
@property (nonatomic, strong, readonly) NSString *itemId DEPRECATED_MSG_ATTRIBUTE("Deprecated in API by Google as of June 24, 2014. Use placeId instead. See https://developers.google.com/places/documentation/details#deprecation for more info.");

@end
