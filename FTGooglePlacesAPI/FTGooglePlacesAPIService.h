//
//  FTGooglePlacesAPIService.h
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

#import "FTGooglePlacesAPICommon.h"

@class FTGooglePlacesAPISearchResponse;
@class FTGooglePlacesAPIDetailResponse;

extern NSString *const FTGooglePlacesAPIBaseURL;

typedef void (^FTGooglePlacesAPISearchRequestCompletionHandler)(FTGooglePlacesAPISearchResponse *response, NSError *error);

typedef void (^FTGooglePlacesAPIDetailRequestCompletionhandler)(FTGooglePlacesAPIDetailResponse *response, NSError *error);

/**
 *  This class provides encapsulated functionality for communication with Google Places API
 */
@interface FTGooglePlacesAPIService : NSObject

/**
 *  Provides API key for the service. Key must be provided before any requests are porformed,
 *  preferably in the app delegate.
 *
 *  @param APIKey API key to be used for authentication of the requests. Copied.
 */
+ (void)provideAPIKey:(NSString *)APIKey;

/**
 *  This optional method can be used to instruct the service to return search
 *  request's response items as an instances of custom item subclass.
 *
 *  This can be particularly usefull is you want your subclass be for example
 *  map annotation. In that case, just subclass FTGooglePlacesAPIResponse
 *  and implement MKAnnotation protocol
 *
 *  Provided class has to be subclass of FTGooglePlacesAPIResponse
 *    - always call super in the subclass
 *    - override designated initializer
 *
 *  @param responseClass Subclass of the API response class to use
 */
+ (void)registerSearchResultItemClass:(Class)itemClass;

/**
 *  Asks the service to execute the given Google Places API Places Search request.
 *
 *  @param request Request object implementing FTGooglePlacesAPIRequest protocol. This will probably be either FTGooglePlacesAPINearbySearchRequest or FTGooglePlacesAPITextSearchRequest, but you are free to provide own request implementing requred FTGooglePlacesAPIRequest protocol
 *  @param completionBlock Completion block to be called after the request was finished. If everything went without problems, response will be non-nill and error will be nil. In case of failure, response will be nil and error will be either AFNetworking error caused by networking problem or error with FTGooglePlacesAPIErrorDomain domain indicating that the networking request was successfull, but Google Places API responded with non-OK status code
 */
+ (void)executeSearchRequest:(id<FTGooglePlacesAPIRequest>)request
       withCompletionHandler:(FTGooglePlacesAPISearchRequestCompletionHandler)completion;

/**
 *  Asks the service to execute the given Google Places API Places Detail request.
 *
 *  @param request Request object implementing FTGooglePlacesAPIRequest protocol. This will probably be instance of FTGooglePlacesAPIDetailRequest, but you are free to provide own request implementing requred FTGooglePlacesAPIRequest protocol
 *  @param completion Completion block to be called after the request was finished. If everything went without problems, response will be non-nill and error will be nil. In case of failure, response will be nil and error will be either AFNetworking error caused by networking problem or error with FTGooglePlacesAPIErrorDomain domain indicating that the networking request was successfull, but Google Places API responded with non-OK status code
 */
+ (void)executeDetailRequest:(id<FTGooglePlacesAPIRequest>)request
       withCompletionHandler:(FTGooglePlacesAPIDetailRequestCompletionhandler)completion;

/**
 *  If set to YES and running in debug mode (#ifdef DEBUG), service will print some information
 *  info console, including:
 *    - Complete URL of request sent to Google Places API
 *    - Status of response and number of result items in a response
 *
 *  @param enabled YES if logs should be printed to the console in DEBUG mode
 */
+ (void)setDebugLoggingEnabled:(BOOL)enabled;

@end
