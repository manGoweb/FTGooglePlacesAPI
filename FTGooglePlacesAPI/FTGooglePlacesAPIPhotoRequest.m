//
//  FTGooglePlacesAPIPhotoRequest.m
//  Aniways
//
//  Created by Danny Shmueli on 5/16/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import "FTGooglePlacesAPIPhotoRequest.h"

@implementation FTGooglePlacesAPIPhotoRequest

- (instancetype)initWithReference:(NSString *)reference maxWidth:(NSNumber *)maxWidth maxHeight:(NSNumber *)maxHeight
{
    if ([reference length] == 0) {
        NSLog(@"WARNING: Trying to create FTGooglePlacesAPIDetailRequest with empty reference. Returning nil");
        return nil;
    }
    
    self = [super init];
    if (self) {
        _reference = reference;
        _maxHeight = maxHeight;
        _maxWidth = maxWidth;
    }
    return self;
}

#pragma mark - Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> Reference: %@", [self class], self, self.reference];
}

#pragma mark - FTGooglePlacesAPIRequest protocol

- (NSString *)placesAPIRequestMethod
{
    return @"photo";
}

- (NSDictionary *)placesAPIRequestParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.reference forKey:@"photoreference"];
    if (self.maxHeight)
        [params setObject:self.maxHeight forKey:@"maxheight"];

    if (self.maxWidth)
        [params setObject:self.maxWidth forKey:@"maxwidth"];

    return params;
}

-(BOOL)isJSONRequest
{
    return NO;
}

@end
