//
//  XXAppTool.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAppTool : NSObject


/// 应用名称
+ (NSString *)appName;


/// 应用 version
+ (NSString *)appVersion;


/// 应用 build
+ (NSString *)appBuild;


/// 应用包名
+ (NSString *)appIdentifier;


/// 应用是否横屏
+ (BOOL)isLandscape;


/// 切换到主线程
/// - Parameter handler: 完成回调
+ (void)switchToMainThread:(void(^)(void))handler;


@end

NS_ASSUME_NONNULL_END
