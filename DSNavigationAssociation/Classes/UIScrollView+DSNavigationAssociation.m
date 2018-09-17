//
//  UIScrollView+DSNavigationAssociation.m
//  DSNavigationAssociationDemo
//
//  Created by XXL on 2017/8/30.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#import "UIScrollView+DSNavigationAssociation.h"
#import <objc/runtime.h>
#import "DSNavigationAssociationCommon.h"

#pragma mark - UIView-Interface
@interface UIView (DSNavigationAssociation)

- (UIViewController *)DS_findResponserController;

@end

#pragma mark - UIViewController-Interface
@interface UIViewController (DSNavigationAssociation)
/** 导航栏的透明度 */
@property (nonatomic, assign) CGFloat navigationBarAlpha;

@end

#pragma mark - UINavigationController-Interface
@interface UINavigationController (DSNavigationAssociation)

- (void)DS_setNeedsNavigationBackgroundAlpha:(CGFloat)alpha;

@end


@interface UIScrollView ()

@property (nonatomic, weak) UIViewController *responserController;

@property (nonatomic, copy) DSScrollBlock scrollBlock;

@property (nonatomic, assign) CGFloat scrollDistance;

@end

@implementation UIScrollView (DSNavigationAssociation)

#pragma mark - GetSet方法

- (CGFloat)scrollDistance {
    
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    
    return result.floatValue;
}

- (void)setScrollDistance:(CGFloat)scrollDistance {
    
    return objc_setAssociatedObject(self, @selector(scrollDistance), @(scrollDistance), OBJC_ASSOCIATION_ASSIGN);
}

- (DSScrollBlock)scrollBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setScrollBlock:(DSScrollBlock)scrollBlock {
    
    objc_setAssociatedObject(self, @selector(scrollBlock), scrollBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setNavigationBarGradientAlphaEnable:(BOOL)navigationBarGradientAlphaEnable {
    
    if (navigationBarGradientAlphaEnable&&!self.navigationBarGradientAlphaEnable) {
        
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
        self.responserController = [self DS_findResponserController];
        self.responserController.navigationBarAlpha = 0;
    }
    
    objc_setAssociatedObject(self,@selector(navigationBarGradientAlphaEnable), @(navigationBarGradientAlphaEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (BOOL)navigationBarGradientAlphaEnable {
    
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    return result.boolValue;
}

- (void)setNavigationBarGradientAlphaDistance:(CGFloat)navigationBarGradientAlphaDistance {
    
    objc_setAssociatedObject(self, @selector(navigationBarGradientAlphaDistance), @(navigationBarGradientAlphaDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)navigationBarGradientAlphaDistance {
    
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    
    if (result.floatValue == 0) {
        
        return 64;
    }
    
    return result.floatValue;
}

- (void)setResponserController:(UIViewController *)responserController {
    
    objc_setAssociatedObject(self, @selector(responserController), responserController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)responserController {
    
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - 系统方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if ([self isMemberOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
        return;
    }
    
    if (self.navigationBarGradientAlphaEnable) {
        
        [self removeObserver:self forKeyPath:@"bounds" context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"bounds"]) {
        
        NSValue *value = change[NSKeyValueChangeNewKey];
        
        CGRect rect = value.CGRectValue;
        
        CGFloat contentOffsetY = rect.origin.y + self.contentInset.top;
        
        CGFloat alpha = contentOffsetY/self.navigationBarGradientAlphaDistance*1.0;
        

        if (self.scrollBlock) {
            
            if (self.navigationBarGradientAlphaEnable) {
                
                self.scrollBlock(self, contentOffsetY >= self.navigationBarGradientAlphaDistance);
                
            }else {
                
                self.scrollBlock(self, contentOffsetY >= self.scrollDistance);   
            }
        }
        
        alpha = MIN(1, alpha);
        
        self.responserController.navigationBarAlpha = alpha;
    }
    
}

#pragma mark - 自定义方法
- (void)DS_monitorScrollWithNavigationBarGradientAlphaDistance:(CGFloat)distance scrollBlock:(DSScrollBlock)scrollBlock; {
    
    self.navigationBarGradientAlphaDistance = distance;
    self.scrollBlock = scrollBlock;

}

- (void)DS_monitorScrollWithScrollDistance:(CGFloat)scrollDistance scrollBlock:(DSScrollBlock)scrollBlock {
    
    self.scrollDistance = scrollDistance;
    self.scrollBlock = scrollBlock;
}

@end


#pragma mark - UIView-Implementation
@implementation UIView (DSNavigationAssociation)

- (UIViewController *)DS_findResponserController {
    
    UIResponder *responser = self;
    while (![responser isKindOfClass:[UIViewController class]]) {
        
        if (!responser) break;
        
        responser = responser.nextResponder;
        
    }
    
    if (responser) {
        
        return (UIViewController*)responser;
    }
    
    return nil;
}

@end

#pragma mark - UIViewController-Implementation
@implementation UIViewController (DSNavigationAssociation)

- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    
    navigationBarAlpha = MIN(1.0, MAX(0.0, navigationBarAlpha));
    
    objc_setAssociatedObject(self, @selector(navigationBarAlpha), @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationController DS_setNeedsNavigationBackgroundAlpha:navigationBarAlpha];
}

- (CGFloat)navigationBarAlpha {
    
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    
    if (!result) {
        
        [self.navigationController DS_setNeedsNavigationBackgroundAlpha:1.0];
        
        return 1.0;
    }
    
    return result.floatValue;
}


@end

#pragma mark - UINavigationController-Implementation

@implementation UINavigationController (DSNavigationAssociation)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SwizzlingMethod([self class], @selector(popViewControllerAnimated:), @selector(DS_popViewControllerAnimated:));
        
        SwizzlingMethod([self class], @selector(popToViewController:animated:), @selector(DS_popToViewController:animated:));
        
        SwizzlingMethod([self class], @selector(popToRootViewControllerAnimated:), @selector(DS_popToRootViewControllerAnimated:));
        
        SwizzlingMethod([self class], @selector(navigationBar:shouldPopItem:), @selector(DS_navigationBar:shouldPopItem:));
        
    });
    
}


- (nullable NSArray<__kindof UIViewController *> *) DS_popToRootViewControllerAnimated:(BOOL)animated {
    
    UIViewController *controller = self.viewControllers.firstObject;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        
        [self DS_setNeedsNavigationBackgroundAlpha:controller.navigationBarAlpha];
        
    }];
    
    return [self DS_popToRootViewControllerAnimated:animated];
    
}

- (UIViewController *)DS_popViewControllerAnimated:(BOOL)animated {
    
    if (self.viewControllers.count > 1) {
        
        NSUInteger count = self.viewControllers.count;
        
        UIViewController *controller = self.viewControllers[count - 2];
        
        if (self.topViewController.navigationBarAlpha != controller.navigationBarAlpha) {
            
            [self DS_setNeedsNavigationBackgroundAlpha:self.topViewController.navigationBarAlpha];
            
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
                
                [self DS_setNeedsNavigationBackgroundAlpha:controller.navigationBarAlpha];
            }];
        }
    }
    
    return [self DS_popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)DS_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        
        [self DS_setNeedsNavigationBackgroundAlpha:viewController.navigationBarAlpha];
        
    }];
    
    return [self DS_popToViewController:viewController animated:animated];
}

- (BOOL)DS_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.topViewController.transitionCoordinator;
    
    if (transitionCoordinator) {
        
        if ([transitionCoordinator respondsToSelector:@selector(notifyWhenInteractionChangesUsingBlock:)]) {
            
            [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                UIViewController *fromController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
                
                UIViewController *toController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
                
                if (fromController.navigationBarAlpha != toController.navigationBarAlpha) {
                    
                    if (context.isCancelled) {
                        
                        NSTimeInterval time = context.transitionDuration*context.percentComplete;
                        
                        [UIView animateWithDuration:time animations:^{
                            
                            [self DS_setNeedsNavigationBackgroundAlpha:fromController.navigationBarAlpha];
                        }];
                        
                        
                    }else {
                        
                        NSTimeInterval time = context.transitionDuration*(1 - context.percentComplete);
                        
                        [UIView animateWithDuration:time animations:^{
                            
                            [self DS_setNeedsNavigationBackgroundAlpha:toController.navigationBarAlpha];
                        }];
                        
                    }
                    
                }
                
            }];
            
        }else {
            
            [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                UIViewController *fromController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
                
                UIViewController *toController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
                
                if (fromController.navigationBarAlpha != toController.navigationBarAlpha) {
                    if (context.isCancelled) {
                        
                        NSTimeInterval time = context.transitionDuration*context.percentComplete;
                        
                        [UIView animateWithDuration:time animations:^{
                            
                            [self DS_setNeedsNavigationBackgroundAlpha:fromController.navigationBarAlpha];
                        }];
                        
                        
                    }else {
                        
                        NSTimeInterval time = context.transitionDuration*(1 - context.percentComplete);
                        
                        [UIView animateWithDuration:time animations:^{
                            
                            [self DS_setNeedsNavigationBackgroundAlpha:toController.navigationBarAlpha];
                        }];
                        
                    }
                }
                
            }];
            
        }
    }
    
    return [self DS_navigationBar:navigationBar shouldPopItem:item];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    
    UIViewController *fromController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    UIViewController *toController = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [self DS_setNeedsNavigationBackgroundAlpha:fromController.navigationBarAlpha];
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        
        [self DS_setNeedsNavigationBackgroundAlpha:toController.navigationBarAlpha];
        
    }];
    
    return YES;
    
}

//更新导航栏透明度
- (void)DS_setNeedsNavigationBackgroundAlpha:(CGFloat)alpha {
    
    UIView *barBackgroundView = self.navigationBar.subviews.firstObject;
    
    UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
    
    if (shadowView) {
        
        shadowView.alpha = alpha;
        shadowView.hidden = alpha == 0;
    }
    
    if (self.navigationBar.translucent) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue > 10.0) {
            
            UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
            backgroundEffectView.alpha = alpha;
            
        }else {
            
            UIView *adaptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
            adaptiveBackdrop.alpha = alpha;
        }
    }
    
    barBackgroundView.alpha = alpha;
    
}

@end
