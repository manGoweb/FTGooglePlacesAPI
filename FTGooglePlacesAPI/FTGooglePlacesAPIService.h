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

@class FTGooglePlacesAPIResponse;

extern NSString *const FTGooglePlacesAPIBaseURL;

typedef void (^FTGooglePlacesAPIRequestCompletionHandler)(FTGooglePlacesAPIResponse *response, NSError *error);

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
 *  This optional method can be used to instruct the service to return response
 *  items as an instances of custom item subclass.
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
+ (void)registerResultItemClass:(Class)itemClass;

/**
 *  Asks the service to execute the given request.
 *
 *  @param request Request object implementing FTGooglePlacesAPIRequest protocol. This will probably be either FTGooglePlacesAPINearbySearchRequest or FTGooglePlacesAPITextSearchRequest, but are free to provide own request implementing requred FTGooglePlacesAPIRequest protocol
 *  @param completionBlock Completion block to be called after the request was finished. If everything went without problems, response will be non-nill and error will be nil. In case of failure, response will be nil and error will be either AFNetworking error caused by networking problem or error with FTGooglePlacesAPIErrorDomain domain indicating that the networking request was successfull, but Google Places API responded with non-OK status code
 */
+ (void)executePlacesAPIRequest:(id<FTGooglePlacesAPIRequest>)request
          withCompletionHandler:(FTGooglePlacesAPIRequestCompletionHandler)completion;

@end
