//
//  FTGooglePlacesAPIPhotoRequest.h
//  Aniways
//
//  Created by Danny Shmueli on 5/16/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTGooglePlacesAPICommon.h"

@interface FTGooglePlacesAPIPhotoRequest : NSObject <FTGooglePlacesAPIRequest>


@property (nonatomic, copy, readonly) NSString *reference;
@property (nonatomic, strong, readonly) NSNumber *maxHeight, *maxWidth;

- (instancetype)initWithReference:(NSString *)reference maxWidth:(NSNumber *)maxWidth maxHeight:(NSNumber *)maxHeight;

@end
