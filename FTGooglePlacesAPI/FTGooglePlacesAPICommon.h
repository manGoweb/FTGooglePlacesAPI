//
//  FTGooglePlacesAPICommon.h
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

#import <Foundation/Foundation.h>

/**
 *  Error domain used in NSErrors representing error response code returned
 *  in a Places API response
 */
extern NSString * const FTGooglePlacesAPIErrorDomain;

/**
 *  Each request passed to the FTGooglePlacesAPIService needs to implement this
 *  protocol.
 */
@protocol FTGooglePlacesAPIRequest <NSObject>

/**
 *  Returns type (method) of request as a string used in the request URL as a last component
 *  of the Places API url (after ../place/ and before /json?params)
 *
 *  @return String usable in the request URL
 */
- (NSString *)placesAPIRequestMethod;

/**
 *  Returns dictionary of all request parameters (without "output" format)
 *  Keys are parameter names, values are values for a given name in a proper format.
 *  For params which should be just defined, without value, set value to [NSNull null]
 *
 *  This method should NOT contain following keys/values:
 *      - API key as the service takes care of authentication
 *      - "sensor" as the service takes care of this itself
 *
 *  @return Dictionary of request parameters.
 */
- (NSDictionary *)placesAPIRequestParams;

@end

//  Utilities

@interface FTGooglePlacesAPIUtils : NSObject

/**
 *  Returns device language (localization) read from NSUserDefaults
 *
 *  @return Device language or nil if cannot be determined
 */
+ (NSString *)deviceLanguage;

@end


//  Helper categories

@interface NSDictionary (FTGPAdditions)

/**
 *  Returns object for a given key, ensuring [NSNull null] will never be returned
 *  and "nil" will be returned instead.
 *  This can greatly reduce risk of the crash on "[NSNull null] unrecognized selector"
 *  when used for parsing JSON
 *
 *  @param aKey Key of the object to return
 *
 *  @return Object for a given key. If the object was [NSNull null], "nil" is returned instead
 */
- (id)ftgp_nilledObjectForKey:(id)aKey;

/**
 *  "valueForKeyPath" variant of - (id)ftgp_nilledObjectForKey:(id)aKey
 */
- (id)ftgp_nilledValueForKeyPath:(NSString *)keyPath;

@end
