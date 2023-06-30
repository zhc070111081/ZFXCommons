//
//  ZFXLogManager.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ZFXLOG(_level_,_fmt_,...) [[ZFXLogManager shareInstance] logWithLevel:_level_ File:__FILE__ line:__LINE__ format:_fmt_,##__VA_ARGS__];

#define ZFX_DEBUG(fmt,...)   ZFXLOG(ZFXLogLevelDebug,fmt,##__VA_ARGS__)
#define ZFX_INFO(fmt,...)    ZFXLOG(ZFXLogLevelInfo,fmt,##__VA_ARGS__)
#define ZFX_WARNING(fmt,...) ZFXLOG(ZFXLogLevelWarning,fmt,##__VA_ARGS__)
#define ZFX_ERROR(fmt,...)   ZFXLOG(ZFXLogLevelError,fmt,##__VA_ARGS__)
#define ZFX_CLEARLOG         [[ZFXLogManager shareInstance] clearAllLog];

typedef NS_ENUM(NSUInteger, ZFXLogLevel){
    ZFXLogLevelDebug = 0, // DEBUG
    ZFXLogLevelInfo,      // INFO
    ZFXLogLevelWarning,   // WARNING
    ZFXLogLevelError      // ERROR
};

@interface ZFXLogManager : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 日志文件夹名称和日志等级
/// - Parameters:
///   - logName: 日志名称
///   - level: 日志等级 默认 error
- (void)setAppLogName:(nullable NSString *)logName level:(ZFXLogLevel)level;

/// write log with document
/// @param level log level
/// @param file file name
/// @param line line number
/// @param format log content
- (void)logWithLevel:(ZFXLogLevel)level File:(const char *)file line:(int)line format:(NSString *)format,...NS_FORMAT_FUNCTION(4, 5);

/// clear all log
- (void)clearAllLog;

@end

NS_ASSUME_NONNULL_END
