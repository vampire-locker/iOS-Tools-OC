//
//  NSString+XXExtension.h
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XX_STRING_EMPTY(a) [NSString isEmpty:a]

@interface NSString (XXExtension)


/// 判断字符串是否为空
/// - Parameter string: 待检查字符串
+ (BOOL)isEmpty:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
