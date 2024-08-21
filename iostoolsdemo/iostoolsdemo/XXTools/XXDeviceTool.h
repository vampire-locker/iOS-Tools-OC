//
//  XXDeviceTool.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXDeviceTool : NSObject


/// 设备名（设置 -> 通用 -> 关于本机 -> 名称）
+ (NSString *)deviceName;


/// 设备系统名
+ (NSString *)systemName;


/// 设备系统版本（设置 -> 通用 -> 关于本机 -> iOS版本）
+ (NSString *)systemVersion;


/// 当前时间戳
+ (NSNumber *)timestamp;


@end

NS_ASSUME_NONNULL_END
