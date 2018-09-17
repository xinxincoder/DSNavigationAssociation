//
//  CollectionController.m
//  EMMNavigationAssociationDemo
//
//  Created by XXL on 2017/8/23.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "CollectionController.h"
#import "UIScrollView+DSNavigationAssociation.h"
#import "DSNavigationAssociationCommon.h"

@interface CollectionController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionController

- (void)dealloc {
    
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.navigationBarGradientAlphaEnable = YES;
    self.collectionView.navigationBarGradientAlphaDistance = 50;
    
    [self.collectionView DS_monitorScrollWithScrollDistance:300 scrollBlock:^(UIScrollView *scrollView, BOOL scrollToDistance) {
       
        DSLog(@"contentOffset = %f",scrollView.contentOffset.y);
        DSLog(@"scrollToDistance = %zd",scrollToDistance);
        
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)*1.0/255 green:arc4random_uniform(256)*1.0/255 blue:arc4random_uniform(256)*1.0/255 alpha:1];
    
    return cell;
}
@end
