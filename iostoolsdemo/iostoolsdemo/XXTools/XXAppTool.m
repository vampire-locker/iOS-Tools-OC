//
//  XXAppTool.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/21.
//

#import "XXAppTool.h"

@implementation XXAppTool


#pragma mark - public

/// 应用名称
+ (NSString *)appName {
    NSDictionary *infoDic = [self appInfoDic];
    // 应用显示名称，如果在 Info.plist 中配置了本地化显示名，这个键会返回适合当前语言环境的名称。
    NSString *name = [infoDic objectForKey:@"CFBundleDisplayName"];
    if (!name) {
        // 应用的内部名称，作为应用的通用标识符。如果没有设置 CFBundleDisplayName，通常会使用这个值。
        name = [infoDic objectForKey:@"CFBundleName"];
    }
    return name;
}


/// 应用 version
+ (NSString *)appVersion {
    return [[self appInfoDic] objectForKey:@"CFBundleShortVersionString"];
}


/// 应用 build
+ (NSString *)appBuild {
    return [[self appInfoDic] objectForKey:@"CFBundleVersion"];
}


/// 应用包名
+ (NSString *)appIdentifier {
    return [[self appInfoDic] objectForKey:@"CFBundleIdentifier"];
}


/// 根据 key 获取 value
+ (NSString *)mainBundleValueWithKey:(NSString *)key {
    if (!key || key.length == 0) {
        return nil;
    }
    return [[self appInfoDic] objectForKey:key];
}


// 应用是否横屏
+ (BOOL)isLandscape {
    // iOS 13 及以上，优先使用当前场景的界面方向
    if (@available(iOS 13.0, *)) {
        UIWindowScene *currentScene = [UIApplication sharedApplication].keyWindow.windowScene;
        if (currentScene) {
            return UIInterfaceOrientationIsLandscape(currentScene.interfaceOrientation);
        }

        // 如果无法获取当前场景，则遍历获取前台激活的场景方向
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                return UIInterfaceOrientationIsLandscape(scene.interfaceOrientation);
            }
        }
    }

    // iOS 13 以下或无法获取当前窗口场景时，使用 UIInterfaceOrientation 作为备选
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// 切换到主线程
+ (void)switchToMainThread:(void(^)(void))handler {
    
    if ([[NSThread currentThread] isMainThread]) {
        if (handler) {
            handler();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
    }
    
}


#pragma mark - private

+ (NSDictionary*)appInfoDic {
    return [[NSBundle mainBundle] infoDictionary];
}


@end
