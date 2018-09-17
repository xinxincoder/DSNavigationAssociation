//
//  TableController.m
//  EMMNavigationAssociationDemo
//
//  Created by XXL on 2017/8/23.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "TableController.h"
#import "UIScrollView+DSNavigationAssociation.h"
#import "DSNavigationAssociationCommon.h"

@interface TableController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation TableController

- (void)dealloc {
    
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    self.tableView.navigationBarGradientAlphaEnable = YES;
    self.tableView.navigationBarGradientAlphaDistance = 200;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    headerView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = headerView;
    
    self.headerView = headerView;
    
    [self.tableView DS_monitorScrollWithNavigationBarGradientAlphaDistance:200 scrollBlock:^(UIScrollView *scrollView, BOOL scrollToDistance) {
        
        
        
    }];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)*1.0/255 green:arc4random_uniform(256)*1.0/255 blue:arc4random_uniform(256)*1.0/255 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewController *controller = [[UITableViewController alloc] init];
    controller.view.backgroundColor = [UIColor grayColor];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

@end
