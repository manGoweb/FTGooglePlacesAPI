//
//  MockAFHTTPRequestOperationManager.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 09/12/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "MockAFHTTPRequestOperationManager.h"

@implementation MockAFHTTPRequestOperationManager {
    
    BOOL _shouldFireFailureBlock;
    NSError *_failureErrorToReturn;
    id _responseObject;
}

#pragma mark Mock implementation

- (void)setFailureErrorToReturn:(NSError *)error
{
    _shouldFireFailureBlock = YES;
    _failureErrorToReturn = error;
}

- (void)setResponseObjectToReturn:(id)responseObject
{
    _responseObject = responseObject;
}

#pragma mark - Superclass mock overrides

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    if (_shouldFireSuccessBlock && success) {
        success(nil, _responseObject);
    }

    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return _requestOperation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    if (_shouldFireSuccessBlock && success) {
        success(nil);
    }
    
    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return nil;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    if (_shouldFireSuccessBlock && success) {
        success(nil, _responseObject);
    }
    
    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return nil;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    
    if (_shouldFireSuccessBlock && success) {
        success(nil, _responseObject);
    }
    
    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return nil;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    if (_shouldFireSuccessBlock && success) {
        success(nil, _responseObject);
    }
    
    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return nil;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _lastURLString = URLString;
    _lastURLRequest = [super.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    if (_shouldFireSuccessBlock && success) {
        success(nil, _responseObject);
    }
    
    if (_shouldFireFailureBlock && failure) {
        failure(nil, _failureErrorToReturn);
    }
    
    return nil;
}

@end
