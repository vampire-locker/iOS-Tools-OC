//
//  XXKeychainTool.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NS_ENUM kSecClassGenericPassword

// kSecClass 数据类型
typedef NS_ENUM(NSInteger, XXSecClassType) {
    // kSecClassInternetPassword 互联网密码
    XXSecClassTypeInternetPassword,
    // kSecClassGenericPassword 通用密码（最常用）
    XXSecClassTypeGenericPassword,
    // kSecClassCertificate 证书
    XXSecClassTypeCertificate,
    // kSecClassKey 秘钥（暂不支持）
    XXSecClassTypeKey,
    // kSecClassIdentity 身份信息（暂不支持）
    XXSecClassTypeIdentity
};


#pragma mark - block

/// 通用完成回调
typedef void (^XXKeychainCompletionBlock)(BOOL success,  NSError * _Nullable error);

/// 字符串检索完成回调
typedef void (^XXKeychainStringCompletionBlock)(NSString * _Nullable string, NSError * _Nullable error);

/// 数据检索完成回调
typedef void (^XXKeychainDataCompletionBlock)(NSData * _Nullable data, NSError * _Nullable error);


@interface XXKeychainTool : NSObject

#pragma mark - property

/// kSecClass 数据类型
@property (nonatomic, assign) XXSecClassType type;

/// kSecAttrAccessGroup 秘钥链组
@property (nonatomic, strong) NSString *accessGroup;

/// kSecAttrService 服务标识符
@property (nonatomic, strong) NSString *service;

/// kSecAttrAccount 用户标识符
@property (nonatomic, strong) NSString *account;

/// kSecAttrLabel 标签标识符
@property (nonatomic, strong) NSString *label;

/// kSecAttrSynchronizable 是否在启用了 iCloud Keychain 的设备之间进行同步
@property (nonatomic, assign) BOOL synchronizable;


#pragma mark - init

- (instancetype)init NS_UNAVAILABLE;


/// 实例化
/// - Parameters:
///   - type: 存储类型
///   - accessGroup: 秘钥链组，确保前面拼接：$(AppIdentifierPrefix)
///   - service: 服务标识符
///   - account: 用户标识符
///   - label: 标签标识符
///   - synchronizable: 是否在启用了 iCloud Keychain 的设备之间进行同步
- (instancetype)initWithType:(XXSecClassType)type 
                 accessGroup:(NSString * _Nullable)accessGroup
                     service:(NSString *)service
                     account:(NSString *)account
                       label:(NSString * _Nullable)label
              synchronizable:(BOOL)synchronizable NS_DESIGNATED_INITIALIZER;


/// 实例化，默认 XXSecClassTypeGenericPassword 类型，不在启用了 iCloud Keychain 的设备之间进行同步
/// - Parameters:
///   - service: 服务标识符
///   - account: 用户标识符
- (instancetype)initWithService:(NSString *)service
                        account:(NSString *)account;


#pragma mark - string

/// 存储字符串到 Keychain
/// - Parameters:
///   - string: 要存储的字符串
///   - completion: 完成回调
- (void)storeString:(NSString *)string
         completion:(XXKeychainCompletionBlock)completion;


/// 从 Keychain 检索字符串
/// - Parameter completion: 完成回调，返回检索到的字符串或错误
- (void)retrieveStringWithCompletion:(XXKeychainStringCompletionBlock)completion;


/// 从 Keychain 删除字符串
/// - Parameter completion: 完成回调
- (void)deleteStringWithCompletion:(XXKeychainCompletionBlock)completion;


/// 更新 Keychain 中的字符串
/// - Parameters:
///   - string: 要更新的新字符串
///   - completion: 完成回调
- (void)updateString:(NSString *)string 
          completion:(XXKeychainCompletionBlock)completion;


#pragma mark - data

/// 存储数据到 Keychain
/// - Parameters:
///   - data: 要存储的数据
///   - completion: 完成回调
- (void)storeData:(NSData *)data
       completion:(XXKeychainCompletionBlock)completion;


/// 从 Keychain 检索数据
/// - Parameter completion: 完成回调，返回检索到的数据或错误
- (void)retrieveDataWithCompletion:(XXKeychainDataCompletionBlock)completion;


/// 从 Keychain 删除数据
/// - Parameter completion: 完成回调
- (void)deleteDataWithCompletion:(XXKeychainCompletionBlock)completion;


/// 更新 Keychain 中的数据
/// - Parameters:
///   - data: 要更新的新数据
///   - completion: 完成回调
- (void)updateData:(NSData *)data 
        completion:(XXKeychainCompletionBlock)completion;


@end

NS_ASSUME_NONNULL_END
