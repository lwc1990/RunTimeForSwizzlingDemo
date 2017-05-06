//
//  NSMutableArray+Swizzling.m
//  RunTimeForSwizzlingDemo
//
//  Created by syl on 2017/5/6.
//  Copyright © 2017年 personCompany. All rights reserved.
//

#import "NSMutableArray+Swizzling.h"
#import <objc/runtime.h>
@implementation NSMutableArray (Swizzling)
+(void)load
{
    SEL safeSel = @selector(safeObjectAtIndex:);
    SEL unSafeSel = @selector(objectAtIndex:);
    Class class = NSClassFromString(@"__NSArrayM");
    Method safeMethod = class_getInstanceMethod(class,safeSel);
    Method unSafeMethod = class_getInstanceMethod(class,unSafeSel);
    method_exchangeImplementations(unSafeMethod,safeMethod);
}
-(id)safeObjectAtIndex:(NSInteger)index
{
    if (index > (self.count - 1))
    {
        NSAssert(NO,@"数组越界了");
        return nil;
    }
    else
    {
        return [self safeObjectAtIndex:index];
    }
}
@end
