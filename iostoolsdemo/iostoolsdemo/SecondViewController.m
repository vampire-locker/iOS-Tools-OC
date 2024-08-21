//
//  SecondViewController.m
//  iostoolsdemo
//
//  Created by apple_new on 2024/8/20.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s",__func__);
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ThirdViewController *vc = [[ThirdViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:vc animated:NO completion:nil];
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
