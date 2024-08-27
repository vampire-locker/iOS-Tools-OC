//
//  NSString+XXExtension.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/27.
//

#import "NSString+XXExtension.h"

@implementation NSString (XXExtension)

+ (BOOL)isEmpty:(NSString*)string {
    
    if (string == nil || string.length == 0) {
        return YES;
    }
    
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedStr.length == 0;
    
}

@end
