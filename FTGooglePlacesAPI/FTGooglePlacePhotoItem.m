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

-(void)resolveImage:(void(^)(UIImage *))completion
{
    FTGooglePlacesAPIPhotoRequest *photoRequest =[[FTGooglePlacesAPIPhotoRequest alloc] initWithReference:self.photoReference maxWidth:@(1600) maxHeight:nil];
    
    [FTGooglePlacesAPIService executePhotoRequest:photoRequest withCompletionHandler:^(UIImage *image, NSError *error)
    {
        completion(image);
    }];
}

@end
