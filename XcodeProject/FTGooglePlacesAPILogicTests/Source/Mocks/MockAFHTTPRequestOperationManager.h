//
//  MockAFHTTPRequestOperationManager.h
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 09/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface MockAFHTTPRequestOperationManager : AFHTTPRequestOperationManager

@property (nonatomic, assign) BOOL shouldFireSuccessBlock;
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
@property (nonatomic, strong, readonly) NSString *lastRequestUrlString;

- (void)setFailureErrorToReturn:(NSError *)error;
- (void)setResponseObjectToReturn:(id)responseObject;

@end
