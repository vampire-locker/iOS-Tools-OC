//
//  ThirdViewController.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import "ThirdViewController.h"
#import "XXViewControllerTool.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",__func__);
    
    self.view.backgroundColor = [UIColor blueColor];
    
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XXViewControllerTool getRootVCUnderPresentingQueue:weakSelf] dismissViewControllerAnimated:NO completion:nil];
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
