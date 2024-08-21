//
//  ViewController.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import "ViewController.h"
#import "FirstViewController.h"

#import "XXAppTool.h"
#import "XXDeviceTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",__func__);
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FirstViewController *vc = [[FirstViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:vc animated:NO completion:nil];
    });
    
    NSLog(@"应用名：%@", [XXAppTool appName]);
    NSLog(@"应用 version：%@", [XXAppTool appVersion]);
    NSLog(@"应用 build：%@", [XXAppTool appBuild]);
    NSLog(@"应用包名：%@", [XXAppTool appIdentifier]);
    NSLog(@"是否横屏：%d", [XXAppTool isLandscape]);
    
    NSLog(@"设备名：%@", [XXDeviceTool deviceName]);
    NSLog(@"系统名：%@", [XXDeviceTool systemName]);
    NSLog(@"系统版本：%@", [XXDeviceTool systemVersion]);
    NSLog(@"当前时间：%@",[XXDeviceTool timestamp]);
}


@end
