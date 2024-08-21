//
//  XXViewControllerTool.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXViewControllerTool : NSObject


/// 获取当前的 ViewController
+ (UIViewController *)getCurrentViewController;


/// 获取应用主窗口
+ (UIWindow *)getKeyWindow;


/// 根据应用根 ViewController 获取当前 ViewController
/// - Parameter rootVC: 应用根 ViewController
+ (UIViewController *)getCurrentViewControllerWithRootVC:(UIViewController *)rootVC;


/// 使用场景举例：
/// 假设应用根控制器为 RootViewController，继承自 UIViewController
/// 现有 CustomViewController，也继承自 UIViewController
/// FirstViewController、SecondViewController、ThirdViewController 都继承自 CustomViewController
/// 在 RootViewController 上 present 出 FirstViewController
/// 在 FirstViewController 上 present 出 SecondViewController
/// 在 SecondViewController 上 present 出 ThirdViewController
/// 现需要一次性关闭所有三个：FirstViewController、SecondViewController、ThirdViewController
/// 通过本方法传入 ThirdViewController，可以获取到 RootViewController
/// - Parameter curVC: 当前 present 队列最上层的 ViewController
+ (UIViewController*)getRootVCUnderPresentingQueue:(UIViewController*)curVC;


@end

NS_ASSUME_NONNULL_END
