//
//  FTGooglePlaceReviewItem.m
//  Aniways
//
//  Created by Danny Shmueli on 5/15/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import "FTGooglePlaceReviewItem.h"
#import "FTGooglePlacesAPICommon.h"

@implementation FTGooglePlaceReviewItem

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self)
        return nil;
    
    self.authorName = [dictionary ftgp_nilledObjectForKey:@"author_name"];
    self.authorURL = [dictionary ftgp_nilledObjectForKey:@"author_url"];
    self.reviewBody = [dictionary ftgp_nilledObjectForKey:@"text"];
    self.rating = [[dictionary ftgp_nilledObjectForKey:@"rating"] doubleValue];
    self.time = [[dictionary ftgp_nilledObjectForKey:@"time"] doubleValue];
    
    return self;
}

@end
