//
//  FTGooglePlacesAPIDetailRequest.m
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


#import "FTGooglePlacesAPIDetailRequest.h"

@implementation FTGooglePlacesAPIDetailRequest

#pragma mark Lifecycle

- (instancetype)initWithPlaceId:(NSString *)placeId
{
    if ([placeId length] == 0) {
        NSLog(@"WARNING: Trying to create FTGooglePlacesAPIDetailRequest with empty placeId. Returning nil");
        return nil;
    }
    
    self = [super init];
    if (self) {
        _placeId = placeId;
    }
    return self;
}

#pragma mark - Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> Place ID: %@", [self class], self, _placeId];
}

#pragma mark - FTGooglePlacesAPIRequest protocol

- (NSString *)placesAPIRequestMethod
{
    return @"details";
}

- (NSDictionary *)placesAPIRequestParams
{
    if (_placeId) {
        return @{@"placeid": _placeId};
    }
    else {
        return @{@"reference": _reference};
    }
    
}

#pragma mark - Deprecations

- (instancetype)initWithReference:(NSString *)reference
{
    if ([reference length] == 0) {
        NSLog(@"WARNING: Trying to create FTGooglePlacesAPIDetailRequest with empty reference. Returning nil");
        return nil;
    }
    
    self = [super init];
    if (self) {
        _reference = reference;
    }
    return self;
}

@end
