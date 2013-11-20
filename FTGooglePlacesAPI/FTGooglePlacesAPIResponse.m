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

#import "FTGooglePlacesAPIResponse.h"
#import "FTGooglePlacesAPICommon.h"
#import "FTGooglePlacesAPIResultItem.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPIResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary;
- (NSArray *)ftgpr_parseResultsItemFromArray:(NSArray *)array;
- (FTGooglePlacesAPIResponseStatus)ftgpr_responseStatusFromString:(NSString *)string;

@end

#pragma mark -

@implementation FTGooglePlacesAPIResponse {
    __weak Class _resultsItemClass;
}

#pragma mark Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithDictionary:dictionary andResultsItemClass:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andResultsItemClass:(Class)resultsItemClass
{
    //  Either there is no custom class or it has to be subclass of FTGooglePlacesAPIResponse so
    //  the code can rely there will be required properties
    NSAssert(!resultsItemClass || [resultsItemClass isSubclassOfClass:[FTGooglePlacesAPIResponse class]], @"Custom response item class in FTGooglePlacesAPIResponse has to be a subclass of FTGooglePlacesAPIResponse");
    
    if ([dictionary count] == 0) {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _status = FTGooglePlacesAPIResponseStatusUnknown;
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

#pragma mark Public interface

+ (NSString *)localizedNameOfStatus:(FTGooglePlacesAPIResponseStatus)status
{
    NSString *name;
    
    switch (status)
    {
        case FTGooglePlacesAPIResponseStatusOK:
            name = NSLocalizedString(@"OK", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusOK");
            break;
        case FTGooglePlacesAPIResponseStatusNoResults:
            name = NSLocalizedString(@"No Results", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusNoResults");
            break;
        case FTGooglePlacesAPIResponseStatusAPILimitExceeded:
            name = NSLocalizedString(@"API Limit Exceeded", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusAPILimitExceeded");
            break;
        case FTGooglePlacesAPIResponseStatusRequestDenied:
            name = NSLocalizedString(@"Request Denied", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusRequestDenied");
            break;
        case FTGooglePlacesAPIResponseStatusInvalidRequest:
            name = NSLocalizedString(@"Invalid Request", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusInvalidRequest");
            break;
        case FTGooglePlacesAPIResponseStatusUnknown:
            name = NSLocalizedString(@"Unknown", @"FTGooglePlacesAPIResponse name of status FTGooglePlacesAPIResponseStatusUnknown");
            break;
    }
    
    return name;
}

+ (NSString *)localizedDescriptionForStatus:(FTGooglePlacesAPIResponseStatus)status
{
    NSString *description;
    
    switch (status)
    {
        case FTGooglePlacesAPIResponseStatusOK:
            description = NSLocalizedString(@"Everything went fine. At least one result was found.", nil);
            break;
        case FTGooglePlacesAPIResponseStatusNoResults:
            description = NSLocalizedString(@"No results were found.", nil);
            break;
        case FTGooglePlacesAPIResponseStatusAPILimitExceeded:
            description = NSLocalizedString(@"Google Places API requests quota was exceeded.", nil);
            break;
        case FTGooglePlacesAPIResponseStatusRequestDenied:
            description = NSLocalizedString(@"Request was denied by Google Places API.", nil);
            break;
        case FTGooglePlacesAPIResponseStatusInvalidRequest:
            description = NSLocalizedString(@"Request was invalid. Either \"location\" or \"radius\" parameter is probably missing.", nil);
            break;
        case FTGooglePlacesAPIResponseStatusUnknown:
            description = NSLocalizedString(@"Google Places API returned unknown status code.", nil);
            break;
    }
    
    return description;
}

@end

#pragma mark - Private methods category

@implementation FTGooglePlacesAPIResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary
{
    _htmlAttributions = [dictionary ftgp_nilledObjectForKey:@"html_attributions"];
    
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
    Class resultsItemClass = (_resultsItemClass ?: [FTGooglePlacesAPIResultItem class]);
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (NSDictionary *resultDictionary in array)
    {
        id resultItem = [[resultsItemClass alloc] initWithDictionary:resultDictionary];
        [results addObject:resultItem];
    }
    
    return [results copy];
}

- (FTGooglePlacesAPIResponseStatus)ftgpr_responseStatusFromString:(NSString *)string
{
    if ([string length] == 0) {
        return FTGooglePlacesAPIResponseStatusUnknown;
    }
    
    if ([string isEqualToString:@"OK"]) {
        return FTGooglePlacesAPIResponseStatusOK;
    } else if ([string isEqualToString:@"ZERO_RESULTS"]) {
        return FTGooglePlacesAPIResponseStatusNoResults;
    }
    else if ([string isEqualToString:@"OVER_QUERY_LIMIT"]) {
        return FTGooglePlacesAPIResponseStatusAPILimitExceeded;
    }
    else if ([string isEqualToString:@"REQUEST_DENIED"]) {
        return FTGooglePlacesAPIResponseStatusRequestDenied;
    }
    else if ([string isEqualToString:@"INVALID_REQUEST"]) {
        return FTGooglePlacesAPIResponseStatusInvalidRequest;
    } else {
        return FTGooglePlacesAPIResponseStatusUnknown;
    }
}

@end