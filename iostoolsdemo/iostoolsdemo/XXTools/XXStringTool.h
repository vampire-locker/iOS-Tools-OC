//
//  XXStringTool.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXStringTool : NSObject


#pragma mark - JSON

/// object 转 JSON
/// - Parameter object: 待转为 JSON 格式的对象
+ (NSString *)objectToJSON:(id)object;


/// JSON 转 object
/// - Parameter json: JSON 字符串
+ (id)JSONToObject:(NSString *)json;


/// data 转 JSON
/// - Parameter data: 待转为 JSON 格式的对象
+ (id)dataToJSON:(NSData *)data;


#pragma mark - base64

/// base64 编码
/// - Parameter string: 待编码字符串
+ (NSString *)encodeToBase64String:(NSString *)string;


/// base64 解码
/// - Parameter base64String: 待解码字符串
+ (NSString *)decodeBase64String:(NSString *)base64String;


#pragma mark - MD5

/// 小写MD5，32位
/// - Parameter string: 待 MD5 字符串
+ (NSString *)MD5ForStringLowercase:(NSString *)string;


/// 大写MD5，32位
/// - Parameter string: 待 MD5 字符串
+ (NSString *)MD5ForStringUppercase:(NSString *)string;


/// MD5
/// - Parameters:
///   - data: 待 MD5 字符串
///   - uppercase: 是否大写
+ (NSString *)MD5ForData:(NSData *)data uppercase:(BOOL)uppercase;


@end

NS_ASSUME_NONNULL_END
