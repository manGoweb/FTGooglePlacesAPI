//
//  FTGooglePlacesAPISearchResultItem.m
//
//  Created by Lukas Kukacka on 10/30/13.
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

#import "FTGooglePlacesAPISearchResultItem.h"
#import "FTGooglePlacesAPICommon.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPISearchResultItem (Private)

- (void)ftgpi_importDictionary:(NSDictionary *)dictionary;

@end


#pragma mark -

@implementation FTGooglePlacesAPISearchResultItem

#pragma mark Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _originalDictionaryRepresentation = dictionary;
        [self ftgpi_importDictionary:dictionary];
        
        //  Object cannot be valid with no id
        if ([_placeId length] == 0) {
            return nil;
        }
        
    }
    return self;
}

#pragma mark Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> \"%@\", Location: (%f,%f), Address: %@", [self class], self, _name, _location.coordinate.latitude, _location.coordinate.longitude, _addressString];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, _originalDictionaryRepresentation];
}

- (NSUInteger)hash
{
    //  Google's ID is unique identifier of the item
    return [_placeId hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object class] == [self class]) {
        return [self isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)object];
    } else {
        return [super isEqual:object];
    }
}

#pragma mark Public interface

- (BOOL)isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)item
{
    return [_placeId isEqualToString:item.placeId];
}

@end

#pragma mark - Private category

@implementation FTGooglePlacesAPISearchResultItem (Private)

//  Private methods are prefixed to avoid methods names collisions on subclassing

- (void)ftgpi_importDictionary:(NSDictionary *)dictionary
{
    _originalDictionaryRepresentation = dictionary;
    
    _placeId = [dictionary ftgp_nilledObjectForKey:@"place_id"];
    _name = [dictionary ftgp_nilledObjectForKey:@"name"];
    
    
    //  location is nil by default on errors or returned invalid values of Lat and Lon
    _location = nil;
    
    //  Extract Lat and Lon from the response. If combination of Lat and Lon make
    //  valid coordinates, create CLLocation object from them
    NSDictionary *geometryDict = [dictionary ftgp_nilledObjectForKey:@"geometry"];
    NSNumber *latitudeNumber = [geometryDict ftgp_nilledValueForKeyPath:@"location.lat"];
    NSNumber *longitudeNumber = [geometryDict ftgp_nilledValueForKeyPath:@"location.lng"];
    if (geometryDict && latitudeNumber && longitudeNumber)
    {
        CLLocationDegrees latitude = [latitudeNumber doubleValue];
        CLLocationDegrees longitude = [longitudeNumber doubleValue];
        
        //  If the LAT and LON are valid, create CLLocation object
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        if (CLLocationCoordinate2DIsValid(locationCoordinate)) {
            _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        }
        
    }
    
    _addressString = [dictionary ftgp_nilledObjectForKey:@"vicinity"];
    
    //  Openeed state may or may not be present
    NSNumber *openedState = [dictionary ftgp_nilledValueForKeyPath:@"opening_hours.open_now"];
    if (openedState) {
        _openedState = ([openedState boolValue] ? FTGooglePlacesAPISearchResultItemOpenedStateOpened : FTGooglePlacesAPISearchResultItemOpenedStateClosed);
    } else {
        _openedState = FTGooglePlacesAPISearchResultItemOpenedStateUnknown;
    }
    
    _iconImageUrl = [dictionary ftgp_nilledObjectForKey:@"icon"];
    _rating = [[dictionary ftgp_nilledObjectForKey:@"rating"] floatValue];
    _reference = [dictionary ftgp_nilledObjectForKey:@"reference"];
    _types = [dictionary ftgp_nilledObjectForKey:@"types"];
    
    //  Deprecated, left for backwards compatibility
    _itemId = [dictionary ftgp_nilledObjectForKey:@"id"];
}

@end
