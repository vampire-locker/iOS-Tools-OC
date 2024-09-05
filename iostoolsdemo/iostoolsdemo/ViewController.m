//
//  ViewController.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import "ViewController.h"
#import "FirstViewController.h"

#import "NSString+XXExtension.h"

#import "XXAppTool.h"
#import "XXDeviceTool.h"
#import "XXStringTool.h"
#import "XXKeychainTool.h"

@interface ViewController ()

// keychainTool 必须作为 ViewController 属性持有，如果作为临时变量，可能会被 ViewController 提前释放
@property (nonatomic, strong) XXKeychainTool *keychainTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",__func__);
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    __weak typeof(self)weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        FirstViewController *vc = [[FirstViewController alloc] init];
//        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        [weakSelf presentViewController:vc animated:NO completion:nil];
//    });
    
    // NSString+XXExtension.h
    if (XX_STRING_EMPTY(@"2333")) {
        NSLog(@"字符串为空");
    } else {
        NSLog(@"字符串不为空");
    }
    
    // XXAppTool
    NSLog(@"应用名：%@", [XXAppTool appName]);
    NSLog(@"应用 version：%@", [XXAppTool appVersion]);
    NSLog(@"应用 build：%@", [XXAppTool appBuild]);
    NSLog(@"应用包名：%@", [XXAppTool appIdentifier]);
    NSLog(@"是否横屏：%d", [XXAppTool isLandscape]);
    
    NSLog(@"设备名：%@", [XXDeviceTool deviceName]);
    NSLog(@"系统名：%@", [XXDeviceTool systemName]);
    NSLog(@"系统版本：%@", [XXDeviceTool systemVersion]);
    NSLog(@"当前时间：%@",[XXDeviceTool timestamp]);
    
    // XXStringTool
    NSDictionary *jsonDic = @{
        @"person": @{
            @"name": @"Alice",
            @"contact": @{
                @"email": @"alice@example.com",
                @"phones": @[@"123-4567", @"890-1234"]
            }
        }
    };
    NSString *result = [XXStringTool objectToJSON:jsonDic];
    NSLog(@"%@", result);
    
    NSDictionary *dic = [XXStringTool JSONToObject:result];
    NSLog(@"%@", dic);
    
    NSString *string = @"123";
    NSString *md5 = [XXStringTool MD5ForStringLowercase:string];
    NSLog(@"%@ : %@", string, md5);
    md5 = [XXStringTool MD5ForStringUppercase:string];
    NSLog(@"%@ : %@", string, md5);
    
    NSString *base64 = [XXStringTool encodeToBase64String:string];
    NSLog(@"%@ : %@", string, base64);
    NSString *str = [XXStringTool decodeBase64String:base64];
    NSLog(@"%@ : %@", base64, str);
    
    // XXKeychainTool
    NSString *service = @"custom service";
    NSString *account = @"custom account";
    
    // self.keychainTool = [[XXKeychainTool alloc] initWithService:service account:account];
    // ==>
    self.keychainTool = [[XXKeychainTool alloc] initWithType:XXSecClassTypeGenericPassword
                                                 accessGroup:nil
                                                     service:service
                                                     account:account
                                                       label:nil
                                              synchronizable:NO];
    
    // 增
    [weakSelf.keychainTool storeString:@"2333" completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"keychain store success");
        } else {
            NSLog(@"keychain store fail: %@", error);
        }
    }];
    
    // 查
    [weakSelf.keychainTool retrieveStringWithCompletion:^(NSString * _Nullable string, NSError * _Nullable error) {
        if (string) {
            NSLog(@"keychain retrieve success: %@", string);
        } else {
            NSLog(@"keychain retrieve fail: %@", error);
        }
    }];
    
    // 改
    [weakSelf.keychainTool updateString:@"6666" completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"keychain update success");
        } else {
            NSLog(@"keychain update fail: %@", error);
        }
    }];
    
    // 查
    [weakSelf.keychainTool retrieveStringWithCompletion:^(NSString * _Nullable string, NSError * _Nullable error) {
        if (string) {
            NSLog(@"keychain retrieve success: %@", string);
        } else {
            NSLog(@"keychain retrieve fail: %@", error);
        }
    }];
    
    // 删
    [weakSelf.keychainTool deleteStringWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"keychain delete success");
        } else {
            NSLog(@"keychain delete fail: %@", error);
        }
    }];
    
}


@end
