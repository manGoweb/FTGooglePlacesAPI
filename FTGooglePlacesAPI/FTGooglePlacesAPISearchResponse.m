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
- (FTGooglePlacesAPISearchResponseStatus)ftgpr_responseStatusFromString:(NSString *)string;

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
    NSAssert(!resultsItemClass || [resultsItemClass isSubclassOfClass:[FTGooglePlacesAPISearchResponse class]], @"Custom response item class in FTGooglePlacesAPISearchResponse has to be a subclass of FTGooglePlacesAPIResponse");
    
    if ([dictionary count] == 0) {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _request = request;
        _status = FTGooglePlacesAPISearchResponseStatusUnknown;
        _resultsItemClass = resultsItemClass;
        [self ftgpr_importDictionary:dictionary];
    }
    return self;
}

#pragma mark Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, _results];
}

#pragma mark - Public interface

- (id<FTGooglePlacesAPIRequest>)nextPageRequest
{
    if ([_nextPageToken length] == 0) {
        return nil;
    }
    
    NSDictionary *dictionary = @{@"pagetoken": _nextPageToken};
    
    FTGooglePlacesAPIDictionaryRequest *request = [[FTGooglePlacesAPIDictionaryRequest alloc] initWithDictionary:dictionary requestType:[_request requestTypeUrlString]];
    
    return request;
}

- (BOOL)hasNextPage
{
    return ([_nextPageToken length] > 0);
}

#pragma mark Class methods

+ (NSString *)localizedNameOfStatus:(FTGooglePlacesAPISearchResponseStatus)status
{
    NSString *name;
    
    switch (status)
    {
        case FTGooglePlacesAPISearchResponseStatusOK:
            name = NSLocalizedString(@"OK", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusOK");
            break;
        case FTGooglePlacesAPISearchResponseStatusNoResults:
            name = NSLocalizedString(@"No Results", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusNoResults");
            break;
        case FTGooglePlacesAPISearchResponseStatusAPILimitExceeded:
            name = NSLocalizedString(@"API Limit Exceeded", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusAPILimitExceeded");
            break;
        case FTGooglePlacesAPISearchResponseStatusRequestDenied:
            name = NSLocalizedString(@"Request Denied", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusRequestDenied");
            break;
        case FTGooglePlacesAPISearchResponseStatusInvalidRequest:
            name = NSLocalizedString(@"Invalid Request", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusInvalidRequest");
            break;
        case FTGooglePlacesAPISearchResponseStatusUnknown:
            name = NSLocalizedString(@"Unknown", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPISearchResponseStatusUnknown");
            break;
    }
    
    return name;
}

+ (NSString *)localizedDescriptionForStatus:(FTGooglePlacesAPISearchResponseStatus)status
{
    NSString *description;
    
    switch (status)
    {
        case FTGooglePlacesAPISearchResponseStatusOK:
            description = NSLocalizedString(@"Everything went fine. At least one result was found.", nil);
            break;
        case FTGooglePlacesAPISearchResponseStatusNoResults:
            description = NSLocalizedString(@"No results were found.", nil);
            break;
        case FTGooglePlacesAPISearchResponseStatusAPILimitExceeded:
            description = NSLocalizedString(@"Google Places API requests quota was exceeded.", nil);
            break;
        case FTGooglePlacesAPISearchResponseStatusRequestDenied:
            description = NSLocalizedString(@"Request was denied by Google Places API.", nil);
            break;
        case FTGooglePlacesAPISearchResponseStatusInvalidRequest:
            description = NSLocalizedString(@"Request was invalid. Either \"location\" or \"radius\" parameter is probably missing.", nil);
            break;
        case FTGooglePlacesAPISearchResponseStatusUnknown:
            description = NSLocalizedString(@"Google Places API returned unknown status code.", nil);
            break;
    }
    
    return description;
}

@end

#pragma mark - Private methods category

@implementation FTGooglePlacesAPISearchResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary
{
    _htmlAttributions = [dictionary ftgp_nilledObjectForKey:@"html_attributions"];
    _nextPageToken = [dictionary ftgp_nilledObjectForKey:@"next_page_token"];
    
    NSString *statusString = [dictionary ftgp_nilledObjectForKey:@"status"];
    _status = [self ftgpr_responseStatusFromString:statusString];
    
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

- (FTGooglePlacesAPISearchResponseStatus)ftgpr_responseStatusFromString:(NSString *)string
{
    if ([string length] == 0) {
        return FTGooglePlacesAPISearchResponseStatusUnknown;
    }
    
    if ([string isEqualToString:@"OK"]) {
        return FTGooglePlacesAPISearchResponseStatusOK;
    } else if ([string isEqualToString:@"ZERO_RESULTS"]) {
        return FTGooglePlacesAPISearchResponseStatusNoResults;
    }
    else if ([string isEqualToString:@"OVER_QUERY_LIMIT"]) {
        return FTGooglePlacesAPISearchResponseStatusAPILimitExceeded;
    }
    else if ([string isEqualToString:@"REQUEST_DENIED"]) {
        return FTGooglePlacesAPISearchResponseStatusRequestDenied;
    }
    else if ([string isEqualToString:@"INVALID_REQUEST"]) {
        return FTGooglePlacesAPISearchResponseStatusInvalidRequest;
    } else {
        return FTGooglePlacesAPISearchResponseStatusUnknown;
    }
}

@end