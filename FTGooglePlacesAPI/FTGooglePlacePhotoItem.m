//
//  FTGooglePlacePhotoItem.m
//  Aniways
//
//  Created by Danny Shmueli on 5/15/14.
//  Copyright (c) 2014 Ram Greenberg. All rights reserved.
//

#import "FTGooglePlacePhotoItem.h"
#import "FTGooglePlacesAPIService.h"
#import "FTGooglePlacesAPIPhotoRequest.h"

@implementation FTGooglePlacePhotoItem

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self)
        return nil;
    
    self.photoReference = dictionary[@"photo_reference"];
    self.htmlAttributions = dictionary[@"html_attributions"];
    self.height = [[dictionary ftgp_nilledObjectForKey:@"height"] floatValue];
    self.width = [[dictionary ftgp_nilledObjectForKey:@"width"] floatValue];
    
    return self;
}

-(void)resolveImage:(void(^)(UIImage *))completion
{
    FTGooglePlacesAPIPhotoRequest *photoRequest =[[FTGooglePlacesAPIPhotoRequest alloc] initWithReference:self.photoReference maxWidth:@(1600) maxHeight:nil];
    
    [FTGooglePlacesAPIService executePhotoRequest:photoRequest withCompletionHandler:^(UIImage *image, NSError *error)
    {
        completion(image);
    }];
}

@end
