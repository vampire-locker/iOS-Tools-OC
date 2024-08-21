//
//  XXDeviceTool.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/21.
//

#import "XXDeviceTool.h"

@implementation XXDeviceTool


#pragma mark - public

// 设备名（设置 -> 通用 -> 关于本机 -> 名称）
+ (NSString *)deviceName {
    return [[UIDevice currentDevice] name];
}


// 设备系统名 iOS / iPad
+ (NSString *)systemName {
    return [[UIDevice currentDevice] systemName];
}


// 设备系统版本（设置 -> 通用 -> 关于本机 -> iOS版本）
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}


// 当前时间戳 1724211643
+ (NSNumber *)timestamp {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return [NSNumber numberWithLong:timeInterval];
}

@end
