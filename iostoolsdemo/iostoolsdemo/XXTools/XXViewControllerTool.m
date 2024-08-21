//
//  XXViewControllerTool.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import "XXViewControllerTool.h"

@implementation XXViewControllerTool


#pragma mark - public

// 获取当前屏幕显示的 ViewController
+ (UIViewController *)getCurrentViewController {
    
    UIViewController *rootVC = [self getKeyWindow].rootViewController;
    UIViewController *curVC = [self getCurrentViewControllerWithRootVC:rootVC];
    
    #ifdef DEBUG
    NSLog(@"currentVC == %@", curVC);
    #endif
    
    return curVC;
    
}


// 获取主窗口
+ (UIWindow *)getKeyWindow {
    
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        // iOS 13+ 通过 UIScene 获取
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                // 遍历场景中的所有窗口，确保获取到 isKeyWindow 的窗口
                for (UIWindow *candidateWindow in scene.windows) {
                    if (candidateWindow.isKeyWindow) {
                        window = candidateWindow;
                        break;
                    }
                }
                if (window) {
                    break;
                }
            }
        }
    } else {
        // iOS 12 及以下，依旧使用传统方法
        window = [UIApplication sharedApplication].delegate.window;
    }
    
    // 如果获取到的窗口不符合条件，遍历所有窗口，获取最合适的 UIWindowLevelNormal 的窗口
    if (window.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *targetWindow in [UIApplication sharedApplication].windows) {
            if (targetWindow.windowLevel == UIWindowLevelNormal && targetWindow.isKeyWindow) {
                window = targetWindow;
                break;
            }
        }
    }
    
    return window;
    
}


// 根据应用根 ViewController 获取当前 ViewController
+ (UIViewController *)getCurrentViewControllerWithRootVC:(UIViewController *)rootVC {
    
    if ([rootVC presentedViewController]) {
        // 递归找到最终被 presented 的视图控制器
        return [self getCurrentViewControllerWithRootVC:[rootVC presentedViewController]];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为 UITabBarController
        return [self getCurrentViewControllerWithRootVC:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为 UINavigationController
        return [self getCurrentViewControllerWithRootVC:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        return rootVC;
    }
    
}


// 获取 present 队列下面的 ViewController
+ (UIViewController*)getRootVCUnderPresentingQueue:(UIViewController*)curVC {
    
    if (!curVC) {
        return nil;
    }
    
    UIViewController *presentingVC = curVC.presentingViewController;
    // 判断 presentingViewController 是否与 presentQueueTopVC 相同父类
    if ([presentingVC isKindOfClass:[curVC superclass]]) {
        //循环查找队列中与 presentQueueTopVC 同父类的最底层 ViewController
        while (presentingVC && [presentingVC.presentingViewController isKindOfClass:[curVC superclass]]) {
            presentingVC = presentingVC.presentingViewController;
        }
    } else {
        // 如果直接父类不同，则返回自身
        presentingVC = curVC;
    }
    // 返回最终的 presentingViewController
    return presentingVC.presentingViewController;
    
}


@end
