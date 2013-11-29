//
//  FTGooglePlacesAPICommon.m
//
//  Created by Lukas Kukacka on 10/29/13.
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

#import "FTGooglePlacesAPICommon.h"

NSString * const FTGooglePlacesAPIErrorDomain = @"FTGooglePlacesAPIErrorDomain";

@implementation FTGooglePlacesAPIUtils

+ (NSString *)deviceLanguage
{
    //  Try to determine default language as a currently active language
    //  from the NSUserDefaults
    //  See https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/Articles/ChoosingLocalizations.html
    //  Current language is cached so we have to always check agains NSUserDefaults
    //  Language should never change while the app is running, so it should be ok
    static NSString *CurrentAppLanguage = nil;
    static BOOL AlreadyTriedToFindLanguage;
    
    if (!AlreadyTriedToFindLanguage && !CurrentAppLanguage) {
        NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if ([languages count] > 0) {
            CurrentAppLanguage = languages[0];
        }
        AlreadyTriedToFindLanguage = YES;
    }
    
    return CurrentAppLanguage;
}

@end

@implementation NSDictionary (FTGPAdditions)

- (id)ftgp_nilledObjectForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    return (object == [NSNull null] ? nil : object);
}

- (id)ftgp_nilledValueForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    return (value == [NSNull null] ? nil : value);
}

@end
