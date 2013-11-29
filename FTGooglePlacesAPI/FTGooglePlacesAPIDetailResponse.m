//
//  FTGooglePlacesAPIDetailResponse.m
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


#import "FTGooglePlacesAPIDetailResponse.h"

#import "FTGooglePlacesAPICommon.h"

@interface FTGooglePlacesAPIDetailResponse (Private)

- (void)ftgp_importDictionary:(NSDictionary *)dictionary;

@end


#pragma mark -

@implementation FTGooglePlacesAPIDetailResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary request:(id<FTGooglePlacesAPIRequest>)request
{
    self = [super initWithDictionary:dictionary request:request];
    if (self) {
        [self ftgp_importDictionary:dictionary[@"result"]];
    }
    return self;
}

@end


@implementation FTGooglePlacesAPIDetailResponse (Private)

//  Private methods are prefixed to avoid methods names collisions on subclassing

- (void)ftgp_importDictionary:(NSDictionary *)dictionary
{
    _itemId = [dictionary ftgp_nilledObjectForKey:@"id"];
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
    
    _formattedAddress = [dictionary ftgp_nilledObjectForKey:@"formatted_address"];
    
    _formattedPhoneNumber = [dictionary ftgp_nilledObjectForKey:@"formatted_phone_number"];
    _internationalPhoneNumber = [dictionary ftgp_nilledObjectForKey:@"international_phone_number"];
    
    _iconImageUrl = [dictionary ftgp_nilledObjectForKey:@"icon"];
    _rating = [[dictionary ftgp_nilledObjectForKey:@"rating"] floatValue];
    _reference = [dictionary ftgp_nilledObjectForKey:@"reference"];
    _types = [dictionary ftgp_nilledObjectForKey:@"types"];
    
    _url = [NSURL URLWithString:[dictionary ftgp_nilledObjectForKey:@"url"]];
    _websiteUrl = [NSURL URLWithString:[dictionary ftgp_nilledObjectForKey:@"website"]];
    
    _utcOffset = [[dictionary ftgp_nilledObjectForKey:@"utc_offset"] doubleValue];
}

@end