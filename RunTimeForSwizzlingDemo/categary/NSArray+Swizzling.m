//
//  NSArray+Swizzling.m
//  RunTimeForSwizzlingDemo
//
//  Created by syl on 2017/5/6.
//  Copyright © 2017年 personCompany. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>
@implementation NSArray (Swizzling)
+(void)load
{
    SEL safeSel = @selector(safeObjectAtIndex:);
    SEL unSafeSel = @selector(objectAtIndex:);
    Class class = NSClassFromString(@"__NSArrayI");
    
    //通过SEL找到对应的方法
    Method safeMethod = class_getInstanceMethod(class,safeSel);
    Method unSafeMethod = class_getInstanceMethod(class,unSafeSel);
    // 交换方法
    method_exchangeImplementations(unSafeMethod,safeMethod);
}
-(id)safeObjectAtIndex:(NSUInteger)index
{
    //这里我们通过runtime的Swizzling黑魔法，对数组越界做了出来，防止数组崩溃，但是开发的时候还是应该让其崩溃，以便及时修改对应的问题。
    if (index > (self.count - 1))//数组越界
    {
        //利用“断言”，让其只在开发环境下崩溃
        NSAssert(NO,@"数组越界了");
        return nil;
    }
    else
    {
        //没有越界正常输出
        return [self safeObjectAtIndex:index];

    }

}
@end
