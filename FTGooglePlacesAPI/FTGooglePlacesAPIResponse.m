//
//  FTGooglePlacesAPIResponse.m
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


#import "FTGooglePlacesAPIResponse.h"
#import "FTGooglePlacesAPICommon.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPIResponse (Private)

- (FTGooglePlacesAPIResponseStatus)ftgpr_responseStatusFromString:(NSString *)string;

@end

#pragma mark -

@implementation FTGooglePlacesAPIResponse

#pragma mark Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
{
    if ([dictionary count] == 0) {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _originalResponseDictionary = dictionary;
        _request = request;
        
        //  Parsing of common values
        NSString *statusString = [dictionary ftgp_nilledObjectForKey:@"status"];
        _status = [self ftgpr_responseStatusFromString:statusString];
    }
    return self;
}

#pragma mark Superclass overrides

- (id)valueForUndefinedKey:(NSString *)key
{
    //  Try to find underfined key in a original dictionary
    id value = [_originalResponseDictionary valueForKeyPath:key];
    
    //  If it is there, return it
    if (value) {
        return value;
    }
    
    //  Else call default implementation
    return [super valueForUndefinedKey:key];
}

#pragma mark Class methods

+ (NSString *)localizedNameOfStatus:(FTGooglePlacesAPIResponseStatus)status
{
    NSString *name;
    
    switch (status)
    {
        case FTGooglePlacesAPIResponseStatusOK:
            name = NSLocalizedString(@"OK", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusOK");
            break;
        case FTGooglePlacesAPIResponseStatusNoResults:
            name = NSLocalizedString(@"No Results", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusNoResults");
            break;
        case FTGooglePlacesAPIResponseStatusAPILimitExceeded:
            name = NSLocalizedString(@"API Limit Exceeded", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusAPILimitExceeded");
            break;
        case FTGooglePlacesAPIResponseStatusRequestDenied:
            name = NSLocalizedString(@"Request Denied", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusRequestDenied");
            break;
        case FTGooglePlacesAPIResponseStatusInvalidRequest:
            name = NSLocalizedString(@"Invalid Request", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusInvalidRequest");
            break;
        case FTGooglePlacesAPIResponseStatusNotFound:
            name = NSLocalizedString(@"Place not found", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusNotFound");
            break;
        case FTGooglePlacesAPIResponseStatusUnknown:
            name = NSLocalizedString(@"Unknown", @"FTGooglePlacesAPISearchResponse name of status FTGooglePlacesAPIResponseStatusUnknown");
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
        case FTGooglePlacesAPIResponseStatusNotFound:
            description = NSLocalizedString(@"Referenced place was not found.", nil);
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
    }
    else if ([string isEqualToString:@"NOT_FOUND"]) {
        return FTGooglePlacesAPIResponseStatusNotFound;
    } else {
        return FTGooglePlacesAPIResponseStatusUnknown;
    }
}

@end
