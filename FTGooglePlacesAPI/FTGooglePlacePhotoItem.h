//
//  FTGooglePlacePhotoItem.h
//  Aniways
//
//  Created by Danny Shmueli on 5/15/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface FTGooglePlacePhotoItem : NSObject

@property (nonatomic, strong) NSArray *htmlAttributions;
@property (nonatomic, copy) NSString *photoReference;
@property (nonatomic) NSInteger height, width;

-(void)resolveImage:(void(^)(UIImage *))completion;

@end
