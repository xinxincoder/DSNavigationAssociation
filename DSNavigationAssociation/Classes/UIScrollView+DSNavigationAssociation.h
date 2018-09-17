//
//  UIScrollView+DSNavigationAssociation.h
//  DSNavigationAssociationDemo
//
//  Created by XXL on 2017/8/30.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DSScrollBlock)(UIScrollView *scrollView, BOOL scrollToDistance);

@interface UIScrollView (DSNavigationAssociation)

@property (nonatomic, assign) BOOL navigationBarGradientAlphaEnable;

@property (nonatomic, assign) CGFloat navigationBarGradientAlphaDistance;


/**
 设置透明度变成1的距离
 
 @param distance 距离
 @param scrollBlock 回调滚动的距离和是否达到设置的距离的bool
 */
- (void)DS_monitorScrollWithNavigationBarGradientAlphaDistance:(CGFloat)distance scrollBlock:(DSScrollBlock)scrollBlock;


/**
 检测scrollview的滚动，并且监听滚动的距离有没有达到设置的距离

 @param scrollDistance 滚动的距离
 @param scrollBlock 回调UIScrollView和是否大于等于设置滚动距离的点（bool 值）
 */
- (void)DS_monitorScrollWithScrollDistance:(CGFloat)scrollDistance scrollBlock:(DSScrollBlock)scrollBlock;

@end
