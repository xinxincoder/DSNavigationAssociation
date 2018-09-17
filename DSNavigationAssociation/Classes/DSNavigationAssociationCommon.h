//
//  DSNavigationAssociationCommon.h
//  DSNavigationAssociationDemo
//
//  Created by XXL on 2017/8/30.
//  Copyright © 2017年 CustomUI. All rights reserved.
//

#ifndef DSNavigationAssociationCommon_h
#define DSNavigationAssociationCommon_h
#import <objc/runtime.h>

CG_INLINE void
SwizzlingMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

#ifdef DEBUG

#define DSLog(...) NSLog(__VA_ARGS__)

#else

#define DSLog(...)

#endif


#endif /* DSNavigationAssociationCommon_h */

