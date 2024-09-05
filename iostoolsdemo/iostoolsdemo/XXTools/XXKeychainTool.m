//
//  XXKeychainTool.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/28.
//

#import "XXKeychainTool.h"
#import <Security/Security.h>

static NSString * const XXKeychainToolErrorDomain = @"XXKeychainToolErrorDomain";

@implementation XXKeychainTool {
    dispatch_queue_t _serialQueue;
}

#pragma mark - init

- (instancetype)initWithType:(XXSecClassType)type
                 accessGroup:(NSString * _Nullable)accessGroup
                     service:(NSString *)service
                     account:(NSString *)account
                       label:(NSString * _Nullable)label
              synchronizable:(BOOL)synchronizable {
    
    self = [super init];
    if (self) {
        NSAssert(service.length > 0, @"Service cannot be empty");
        NSAssert(account.length > 0, @"Account cannot be empty");
        
        _type = type;
        _accessGroup = accessGroup;
        _service = [service copy];
        _account = [account copy];
        _label = [label copy];
        _synchronizable = synchronizable;
        
        // 初始化串行队列，用于防止连续操作下出现竞态条件
        _serialQueue = dispatch_queue_create("com.xxkeychaintool.serialqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
    
}


- (instancetype)initWithService:(NSString *)service
                        account:(NSString *)account {
    
    return [self initWithType:XXSecClassTypeGenericPassword
                  accessGroup:nil
                      service:service
                      account:account
                        label:nil
               synchronizable:NO];
    
}



#pragma mark - string

- (void)storeString:(NSString *)string
         completion:(XXKeychainCompletionBlock)completion {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self storeData:data completion:completion];
    
}


- (void)retrieveStringWithCompletion:(XXKeychainStringCompletionBlock)completion {
    
    [self retrieveDataWithCompletion:^(NSData *data, NSError *error) {
        NSString *result = nil;
        if (data) {
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (completion) {
            completion(result, error);
        }
    }];
    
}


- (void)deleteStringWithCompletion:(XXKeychainCompletionBlock)completion {
    
    [self deleteDataWithCompletion:completion];
    
}


- (void)updateString:(NSString *)string 
          completion:(XXKeychainCompletionBlock)completion {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self updateData:data completion:completion];
    
}



#pragma mark - data

- (void)storeData:(NSData*)data
       completion:(XXKeychainCompletionBlock)completion {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) {
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Self was deallocated"}];
                    completion(nil, error);
                }
            }];
            return;
        }
        
        NSMutableDictionary *query = [strongSelf keychainQuery];
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        
        if (strongSelf.type == XXSecClassTypeInternetPassword || strongSelf.type == XXSecClassTypeGenericPassword) {
            // kSecClassInternetPassword、kSecClassGenericPassword
            attributesToUpdate[(__bridge id)kSecValueData] = data;
        } else if (strongSelf.type == XXSecClassTypeCertificate){
            // kSecClassCertificate
            @try {
                SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data);
                if (certificate == NULL) {
                    @throw [NSException exceptionWithName:@"InvalidCertificateData"
                                                   reason:@"Failed to create certificate from data"
                                                 userInfo:nil];
                }
                attributesToUpdate[(__bridge id)kSecValueRef] = (__bridge id)certificate;
                CFRelease(certificate);
            } @catch (NSException *exception) {
                [strongSelf switchToMainThread:^{
                    if (completion) {
                        NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                             code:-1
                                                         userInfo:@{NSLocalizedDescriptionKey: exception.reason}];
                        completion(NO, error);
                    }
                }];
            }
            
        } else {
            // kSecClassKey、kSecClassIdentity 暂不支持
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Not supported yet"}];
                    completion(nil, error);
                }
            }];
            return;
        }
        
        // 先尝试更新
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
        
        if (status == errSecItemNotFound) {
            // 如果项目不存在，尝试添加
            [query addEntriesFromDictionary:attributesToUpdate];
            status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        }
        [strongSelf switchToMainThread:^{
            if (completion) {
                if (status == errSecSuccess) {
                    completion(YES, nil);
                } else {
                    NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                         code:status
                                                     userInfo:nil];
                    completion(NO, error);
                }
            }
        }];
    });
    
}


- (void)retrieveDataWithCompletion:(XXKeychainDataCompletionBlock)completion {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) {
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Self was deallocated"}];
                    completion(nil, error);
                }
            }];
            return;
        }
        
        NSMutableDictionary *query = [strongSelf keychainQuery];
        
        if (strongSelf.type == XXSecClassTypeInternetPassword || strongSelf.type == XXSecClassTypeGenericPassword) {
            // kSecClassInternetPassword、kSecClassGenericPassword
            query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
            
            CFTypeRef result = NULL;
            OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSData *data = (__bridge_transfer NSData *)result;
                    if (status == errSecSuccess) {
                        completion(data, nil);
                    } else {
                        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                             code:status
                                                         userInfo:nil];
                        completion(nil, error);
                    }
                }
            }];
            
        } else if (strongSelf.type == XXSecClassTypeCertificate) {
            // kSecClassCertificate
            query[(__bridge id)kSecReturnRef] = (__bridge id)kCFBooleanTrue;
            
            SecCertificateRef certificate = NULL;
            OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&certificate);

            @try {
                [strongSelf switchToMainThread:^{
                    if (completion) {
                        if (status == errSecSuccess && certificate != NULL) {
                            NSData *certData = (__bridge_transfer NSData *)SecCertificateCopyData(certificate);
                            completion(certData, nil);
                        } else {
                            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                                 code:status
                                                             userInfo:nil];
                            completion(nil, error);
                        }
                    }
                }];
                
            } @catch (NSException *exception) {
                [strongSelf switchToMainThread:^{
                    if (completion) {
                        NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                             code:-1
                                                         userInfo:@{NSLocalizedDescriptionKey: exception.reason}];
                        completion(nil, error);
                    }
                }];
                
            } @finally {
                if (certificate != NULL) {
                    CFRelease(certificate);
                }
            }
        } else {
            // kSecClassKey、kSecClassIdentity 暂不支持
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Not supported yet"}];
                    completion(nil, error);
                }
            }];
        }
    });
    
}


- (void)deleteDataWithCompletion:(XXKeychainCompletionBlock)completion {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) {
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Self was deallocated"}];
                    completion(NO, error);
                }
            }];
            return;
        }
        
        NSMutableDictionary *query = [strongSelf keychainQuery];
        
        if (strongSelf.type == XXSecClassTypeInternetPassword || strongSelf.type == XXSecClassTypeGenericPassword || strongSelf.type == XXSecClassTypeCertificate) {
            
            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
            [strongSelf switchToMainThread:^{
                if (completion) {
                    if (status == errSecSuccess || status == errSecItemNotFound) {
                        completion(YES, nil);
                    } else {
                        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                             code:status
                                                         userInfo:nil];
                        completion(NO, error);
                    }
                }
            }];
            
        } else {
            // kSecClassKey、kSecClassIdentity 暂不支持
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Not supported yet"}];
                    completion(nil, error);
                }
            }];
        }
    });
    
}


- (void)updateData:(NSData *)data
        completion:(XXKeychainCompletionBlock)completion {
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(_serialQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) {
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Self was deallocated"}];
                    completion(NO, error);
                }
            }];
            return;
        }
        
        NSMutableDictionary *query = [self keychainQuery];
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        
        if (strongSelf.type == XXSecClassTypeInternetPassword || strongSelf.type == XXSecClassTypeGenericPassword || strongSelf.type == XXSecClassTypeCertificate) {
            
            if (strongSelf.type == XXSecClassTypeInternetPassword || strongSelf.type == XXSecClassTypeGenericPassword) {
                // kSecClassInternetPassword、kSecClassGenericPassword
                attributesToUpdate[(__bridge id)kSecValueData] = data;
                
            } else {
                // kSecClassCertificate
                
                SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data);
                if (certificate) {
                    @try {
                        attributesToUpdate[(__bridge id)kSecValueRef] = (__bridge id)certificate;
                    } @finally {
                        CFRelease(certificate);
                    }
                } else {
                    [strongSelf switchToMainThread:^{
                        if (completion) {
                            NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                                 code:-1
                                                             userInfo:@{NSLocalizedDescriptionKey: @"Failed to create certificate from data"}];
                            completion(NO, error);
                        }
                    }];
                    return;
                }
            }
            
            OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
            [strongSelf switchToMainThread:^{
                if (completion) {
                    if (status == errSecSuccess) {
                        completion(YES, nil);
                    } else {
                        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                             code:status
                                                         userInfo:nil];
                        completion(NO, error);
                    }
                }
            }];
            
        } else {
            // kSecClassKey、kSecClassIdentity 暂不支持
            [strongSelf switchToMainThread:^{
                if (completion) {
                    NSError *error = [NSError errorWithDomain:XXKeychainToolErrorDomain
                                                         code:-1
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Not supported yet"}];
                    completion(nil, error);
                }
            }];
        }
    });
    
}



#pragma mark - private

- (NSMutableDictionary *)keychainQuery {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    if (self.type == XXSecClassTypeInternetPassword) {
        
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        
    } else if (self.type == XXSecClassTypeGenericPassword) {
        
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
        
    } else if (self.type == XXSecClassTypeCertificate) {
        
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassCertificate;
        
    } else if (self.type == XXSecClassTypeKey) {
        
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassKey;
        
    } else if (self.type == XXSecClassTypeIdentity) {
        
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassIdentity;
        
    } else {
        // 默认 kSecClassGenericPassword
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    }
    
    query[(__bridge id)kSecAttrService] = self.service;
    query[(__bridge id)kSecAttrAccount] = self.account;
    
    if (self.accessGroup && self.accessGroup.length != 0){
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if (self.label && self.label.length != 0){
        query[(__bridge id)kSecAttrLabel] = self.label;
    }
    
    if (self.synchronizable) {
        query[(__bridge id)kSecAttrSynchronizable] = (__bridge id)kCFBooleanTrue;
    }
    return query;
    
}


- (void)switchToMainThread:(void(^)(void))handler {
    
    if (!handler) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), handler);
    
}



#pragma mark - setter

- (void)setType:(XXSecClassType)type {
    _type = type;
}

- (void)setAccessGroup:(NSString *)accessGroup {
    _accessGroup = accessGroup;
}

- (void)setLabel:(NSString *)label {
    _label = label;
}

- (void)setSynchronizable:(BOOL)synchronizable {
    _synchronizable = synchronizable;
}


@end
