//
//  ZFXUncaughtExceptionHandler.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFXUncaughtExceptionHandler : NSObject

+ (instancetype)defaultExceptionHandler;

//错误日志路径
@property (nullable, nonatomic,copy) NSString *crashFilePath;

ZFXUncaughtExceptionHandler * InstanceUncaughtExceptionHandler(void);

@end

NS_ASSUME_NONNULL_END
