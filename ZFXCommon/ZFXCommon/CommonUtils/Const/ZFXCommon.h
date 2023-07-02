//
//  ZFXCommon.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#ifndef ZFXCommon_h
#define ZFXCommon_h

/**
 Synthsize a weak or strong reference.
 
 Example:
 @zfx_weakify(self)
 [self doSomething^{
 @zfx_strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef zfx_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define zfx_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define zfx_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define zfx_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define zfx_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef zfx_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define zfx_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define zfx_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define zfx_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define zfx_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* ZFXCommon_h */
