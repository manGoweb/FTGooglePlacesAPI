//
//  FTGooglePlacesAPIDictionaryRequest.m
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

#import "FTGooglePlacesAPIDictionaryRequest.h"

@implementation FTGooglePlacesAPIDictionaryRequest {
    
    NSString *_placesAPIRequestMethod;
    NSDictionary *_placesAPIRequestParams;
}

- (instancetype)init
{
    return [self initWithDictionary:nil requestType:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary requestType:(NSString *)requestType
{
    if (!dictionary || [requestType length] == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _placesAPIRequestMethod = requestType;
        _placesAPIRequestParams = dictionary;
    }
    return self;
}

#pragma mark FTGooglePlacesAPIRequest protocol

- (NSString *)placesAPIRequestMethod
{
    return _placesAPIRequestMethod;
}

- (NSDictionary *)placesAPIRequestParams
{
    return _placesAPIRequestParams;
}

@end
