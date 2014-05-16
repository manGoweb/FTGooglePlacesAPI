//
//  FTGooglePlaceReviewItem.h
//  Aniways
//
//  Created by Danny Shmueli on 5/15/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTGooglePlaceReviewItem : NSObject

@property (nonatomic, copy) NSString *authorName, *authorURL, *reviewBody;
@property (nonatomic) float rating;

@end
