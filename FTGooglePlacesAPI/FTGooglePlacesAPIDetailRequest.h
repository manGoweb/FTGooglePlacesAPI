//
//  FTGooglePlacesAPIDetailRequest.h
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


#import <Foundation/Foundation.h>

#import "FTGooglePlacesAPICommon.h"

/**
 *  Request on an item details
 */
@interface FTGooglePlacesAPIDetailRequest : NSObject <FTGooglePlacesAPIRequest>

@property (nonatomic, strong, readonly) NSString *placeId;

/**
 *  Creates new request on a detail of place with given placeId
 */
- (instancetype)initWithPlaceId:(NSString *)placeId;

/**
 *  Deprecations
 */

/**
 *  Reference with which the request was initialized.
 *  This is a unique identifier for a place (itemId from the ResultItem)
 */
@property (nonatomic, strong, readonly) NSString *reference DEPRECATED_MSG_ATTRIBUTE("Deprecated in API by Google as of June 24, 2014. Use placeId instead. See https://developers.google.com/places/documentation/details#deprecation for more info.");

- (instancetype)initWithReference:(NSString *)reference DEPRECATED_MSG_ATTRIBUTE("Uses deprecated property reference (see @reference)");

@end
