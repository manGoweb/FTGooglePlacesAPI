//
//  FTGooglePlacesAPITestCase.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTGooglePlacesAPITestCase.h"

@implementation FTGooglePlacesAPITestCase

+ (NSData *)dataFromFileNamed:(NSString *)filename
{
    NSString *name = [filename stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:name withExtension:extension];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

+ (NSString *)stringFromFileNamed:(NSString *)filename usingEncoding:(NSStringEncoding)encoding
{
    NSData *data = [[self class] dataFromFileNamed:filename];
    
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (id)JSONFromFileNamed:(NSString *)filename
{
    NSData *data = [[self class] dataFromFileNamed:filename];
    
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:NULL];
    
    return json;
}


@end
