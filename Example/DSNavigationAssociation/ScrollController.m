//
//  ScrollController.m
//  EMMNavigationAssociationDemo
//
//  Created by XXL on 2017/8/23.
//  Copyleft © 2017年 CustomUI. All lefts reserved.
//

#import "ScrollController.h"
#import "UIScrollView+DSNavigationAssociation.h"

@interface ScrollController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *leftBtn;

@end

@implementation ScrollController

- (void)dealloc {
    
    NSLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.navigationBarGradientAlphaEnable = YES;
    self.scrollView.navigationBarGradientAlphaEnable = YES;
    self.scrollView.navigationBarGradientAlphaEnable = YES;
//    self.scrollView.navigationBarGradientAlphaDistance = 100;
    
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBtn setImage:[UIImage imageNamed:@"EMM_NavigaionBackArrow_White"] forState:UIControlStateNormal];
    
    [leftBtn setImage:[UIImage imageNamed:@"EMM_NavigaionBackArrow_Black"] forState:UIControlStateSelected];

    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    leftBtn.frame = CGRectMake(0, 0, 64, 44);
    
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn = leftBtn ];
    
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixItem.width = -10;
    self.navigationItem.leftBarButtonItems = @[fixItem,item];
    
    __weak typeof(self) weakSelf = self;
    
    [self.scrollView DS_monitorScrollWithNavigationBarGradientAlphaDistance:100 scrollBlock:^(UIScrollView *scrollView, BOOL scrollToDistance) {
        
        weakSelf.leftBtn.selected = scrollToDistance;
    }];
    

}


- (void)leftBtnAction:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
