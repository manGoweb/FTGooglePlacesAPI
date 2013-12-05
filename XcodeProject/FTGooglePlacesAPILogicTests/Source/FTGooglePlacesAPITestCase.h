//
//  FTGooglePlacesAPITestCase.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 20/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface FTGooglePlacesAPITestCase : XCTestCase

/**
 *  This a set of helper methods for loading resources required
 *  in tests
 *
 */
+ (NSData *)dataFromFileNamed:(NSString *)filename;
+ (NSString *)stringFromFileNamed:(NSString *)filename usingEncoding:(NSStringEncoding)encoding;
+ (id)JSONFromFileNamed:(NSString *)filename;

@end
