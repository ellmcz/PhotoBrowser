//
//  Singleton.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#define Singleton_h(name)   + (instancetype)shared##name;
#if __has_feature(objc_arc)     //ARC模式
#define Singleton_m(name) \
\
+ (instancetype)shared##name{ \
static id instance=nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance=[[self alloc]init];\
});\
return instance;\
} \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
static id instance=nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance=[super allocWithZone:zone]; \
}); \
return instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone{ \
return self; \
}
#else     //非ARC模式(MRC)
#define Singleton_m(name) \
\
+ (instancetype)shared##name{ \
    static id instance=nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance=[[self alloc]init];\
    });\
    return instance;\
} \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
    static id instance=nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance=[super allocWithZone:zone]; \
    }); \
    return instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone{ \
    return self; \
} \
\
-(oneway void)release{ \
   \
}\
\
-(instancetype)autorelease{ \
    return self; \
} \
\
- (instancetype)retain{ \
    return self; \
} \
\
- (NSUInteger)retainCount{ \
    return 1;\
}
#endif