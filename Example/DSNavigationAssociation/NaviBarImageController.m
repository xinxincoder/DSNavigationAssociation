//
//  NaviBarImageController.m
//  EMMNavigationAssociationDemo
//
//  Created by XXL on 2017/8/23.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "NaviBarImageController.h"

@interface NaviBarImageController ()

@end

@implementation NaviBarImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navi"] forBarMetrics:UIBarMetricsDefault];

    id target = self.interactivePopGestureRecognizer.delegate;
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
#pragma clang diagnostic pop
    
    [self.view addGestureRecognizer:pan];
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
