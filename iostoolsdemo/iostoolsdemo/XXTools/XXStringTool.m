//
//  XXStringTool.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/27.
//

#import "XXStringTool.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation XXStringTool


#pragma mark - JSON

+ (NSString *)objectToJSON:(id)object {
    
    if (!object) {
        return nil;
    }
    // 检查对象是否可以序列化
    if (![NSJSONSerialization isValidJSONObject:object]) {
        NSLog(@"objectToJson: Invalid JSON object: %@", object);
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        NSLog(@"objectToJson: JSON serialization error: %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


+ (id)JSONToObject:(NSString *)json {
    
    if (!json || json.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"jsonToObject: JSON deserialization error: %@", error);
        return nil;
    }
    return jsonObject;
    
}


+ (id)dataToJSON:(NSData *)data {
    
    if (!data || data.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    id dataJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"dataToJson: JSON deserialization error: %@", error);
        return nil;
    }
    return dataJson;
    
}


#pragma mark - base64

+ (NSString *)encodeToBase64String:(NSString *)string {
    
    if (!string || string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
    
}


+ (NSString *)decodeBase64String:(NSString *)base64String {
    
    if (!base64String || base64String.length == 0) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}


#pragma mark - MD5

+ (NSString *)MD5ForStringLowercase:(NSString *)string {
    if (!string || string.length == 0) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self MD5ForData:data uppercase:NO];
}


+ (NSString *)MD5ForStringUppercase:(NSString *)string {
    
    if (!string || string.length == 0) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self MD5ForData:data uppercase:YES];
    
}


+ (NSString *)MD5ForData:(NSData *)data uppercase:(BOOL)uppercase {
    
    if (!data) {
        return nil;
    }
    
    // 计算 MD5 哈希值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    
    // 将哈希值转换为 NSString
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    NSString *format = uppercase ? @"%02X" : @"%02x"; // 根据大小写选择格式
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:format, result[i]];
    }
    
    return [hash copy];
    
}


@end
