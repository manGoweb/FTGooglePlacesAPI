//
//  FTGooglePlacesAPIResponse.m
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

#import "FTGooglePlacesAPISearchResponse.h"
#import "FTGooglePlacesAPICommon.h"
#import "FTGooglePlacesAPISearchResultItem.h"
#import "FTGooglePlacesAPIDictionaryRequest.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPISearchResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary;
- (NSArray *)ftgpr_parseResultsItemFromArray:(NSArray *)array;

@end

#pragma mark -

@implementation FTGooglePlacesAPISearchResponse {
    __weak Class _resultsItemClass;
}

#pragma mark Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
{
    return [self initWithDictionary:dictionary request:request resultsItemClass:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
                  resultsItemClass:(Class)resultsItemClass
{
    //  Either there is no custom class or it has to be subclass of FTGooglePlacesAPIResponse so
    //  the code can rely there will be required properties
    //  If this expectation fails, it is clearly programmers fault, so let him know!
    if (resultsItemClass &&
        ![resultsItemClass isSubclassOfClass:[FTGooglePlacesAPISearchResultItem class]])
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Custom response item class in FTGooglePlacesAPISearchResponse must be a subclass of FTGooglePlacesAPIResponse"
                                     userInfo:nil];
    }

    self = [super initWithDictionary:dictionary request:request];
    if (self)
    {
        _resultsItemClass = resultsItemClass;
        [self ftgpr_importDictionary:dictionary];
    }
    return self;
}

#pragma mark - Public interface

- (id<FTGooglePlacesAPIRequest>)nextPageRequest
{
    if (![self hasNextPage]) {
        return nil;
    }
    
    NSDictionary *dictionary = @{@"pagetoken": _nextPageToken};
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:dictionary requestType:[self.request placesAPIRequestMethod]];
    
    return request;
}

- (BOOL)hasNextPage
{
    return ([_nextPageToken length] > 0);
}

@end

#pragma mark - Private methods category

@implementation FTGooglePlacesAPISearchResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary
{
    _htmlAttributions = [dictionary ftgp_nilledObjectForKey:@"html_attributions"];
    _nextPageToken = [dictionary ftgp_nilledObjectForKey:@"next_page_token"];
    
    NSArray *results = [dictionary ftgp_nilledObjectForKey:@"results"];
    _results = [self ftgpr_parseResultsItemFromArray:results];
}

- (NSArray *)ftgpr_parseResultsItemFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || [array count] == 0) {
        return nil;
    }
    
    //  If there is a custom class response item defined, use that one
    //  else use the default response item class
    Class resultsItemClass = (_resultsItemClass ?: [FTGooglePlacesAPISearchResultItem class]);
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (NSDictionary *resultDictionary in array)
    {
        id resultItem = [[resultsItemClass alloc] initWithDictionary:resultDictionary];
        [results addObject:resultItem];
    }
    
    return [results copy];
}

@end