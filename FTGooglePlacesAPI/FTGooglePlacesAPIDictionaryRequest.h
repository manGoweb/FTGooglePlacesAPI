//
//  FTGooglePlacesAPIDictionaryRequest.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 21/11/13.
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
 *  This is basic request accepting dictionary of keys and values used
 *  directly in the request URL.
 *  You shouldn't use this request directly. It is used just as simple
 *  helper for a few very simple tasks like creating "nextPageToken" request
 *  and for the purpose of unit testing
 */

@interface FTGooglePlacesAPIDictionaryRequest : NSObject <FTGooglePlacesAPIRequest>

/**
 *  Creates new instance of simple Places API request.
 *
 *  @param dictionary Dictionary of keys and values used directly in the request URL.
 *  @param requestType Request type string returned as "requestTypeUrlString"
 *
 *  @return Request instance. Returns nil if provided dictionary is nil or requestType is empty
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary requestType:(NSString *)requestType;

@end
