//
//  ZFXUncaughtExceptionHandler.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "ZFXUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <stdatomic.h>


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

atomic_int UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

/// max save log days
static NSInteger const ZFXCrasZFXAXSaveDay = 7;

/// log file folder name
static NSString *const ZFXCrashFolderName = @"CrashLOG";


static ZFXUncaughtExceptionHandler *_handler = nil;

@interface ZFXUncaughtExceptionHandler ()

// 创建崩溃信息
/// date formatter
@property (strong, nonatomic, nullable) NSDateFormatter *dateFormatter;

/// time dateformatter
@property (strong, nonatomic, nullable) NSDateFormatter *timeFormatter;

/// file manager
@property (strong, nonatomic, nullable) NSFileManager *fileManager;

@end


@implementation ZFXUncaughtExceptionHandler


+ (instancetype)defaultExceptionHandler {
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _handler = [[ZFXUncaughtExceptionHandler alloc] init];
    });
    
    return _handler;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _handler = [super allocWithZone:zone];
    });
    
    return _handler;
}

- (id)copyWithZone:(NSZone *)zone {
    return _handler;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self uiConfig];
    }
    return self;
}

#pragma mark - 设置日志存取的路径
- (void)uiConfig{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.dateFormatter = dateFormatter;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:sss"];
    self.timeFormatter = timeFormatter;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.fileManager = fileManager;
    
    [self checkLogSaveDay];
}

- (NSString *)crashFilePath {
    return [self absoluteFolderPath];
}

#pragma mark - private method

- (void)checkLogSaveDay {
    if (![self.fileManager fileExistsAtPath:[self absoluteFolderPath]]) return;
    
    // 检查日志日期 大于7天的日志 自动清除
    NSArray *files = [self.fileManager contentsOfDirectoryAtPath:[self absoluteFolderPath] error:nil];
    if (files.count == 0) return;
    
    // 遍历文件夹内容数组，删除过期的日志
    for (NSString *fileName in files) {
        
        // 获取日志文件的日期
        NSArray *fileDates = [fileName componentsSeparatedByString:@"_crash"];
        NSString *fileDateStr = [fileDates firstObject];
        NSDate *fileDate = [self.dateFormatter dateFromString:fileDateStr];
        NSDate *currentDate = [self getCurrentDate];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;
        NSDateComponents *components = [calendar components:unit fromDate:fileDate toDate:currentDate options:0];
        if (components.day > ZFXCrasZFXAXSaveDay) {
            // 删除大于7天的日志
            NSString *filePath = [[self absoluteFolderPath] stringByAppendingPathComponent:fileName];
            [self.fileManager removeItemAtPath:filePath error:nil];
        }
    }
}

///APP CRASH LOG file folder
- (NSString *)absoluteFolderPath {
    return [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",ZFXCrashFolderName]];
}

- (NSDate *)getCurrentDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

- (void)handleException:(NSException *)exception{
    //保存日志 可以发送日志到自己的服务器上
    [self validateAndSaveCriticalApplicationData:exception];
//    NSString *userInfo = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
//
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//    while (!_dismissed){
//        for (NSString *mode in (__bridge NSArray *)allModes) {
//            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//        }
//    }
//    CFRelease(allModes);
#pragma clang diagnostic pop
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }else{
        [exception raise];
    }
}

+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

#pragma mark - 保存错误信息日志
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception{
    NSLog(@"%@",self.crashFilePath);
    // 获取当前日期作为文件名称
    NSString *fileName = [NSString stringWithFormat:@"%@_crash",[self.dateFormatter stringFromDate:[NSDate date]]];
    NSString *filePath = [[[self absoluteFolderPath] stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"log"];
    
    NSString *exceptionMessage = [NSString stringWithFormat:NSLocalizedString(@"\n******************** %@ 异常原因如下: ********************\n%@\n%@\n==================== End ====================\n\n", nil), [self currentTimeString], [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    
    NSData *writeData = [exceptionMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![self.fileManager fileExistsAtPath:self.crashFilePath]) {
        [self.fileManager createDirectoryAtPath:self.crashFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    // 若文件不存在,则创建该文件
    if (![self.fileManager fileExistsAtPath:filePath]) {
        [writeData writeToFile:filePath atomically:NO];
    }
    else{
        // NSFileHandle 用于处理文件内容
        // 读取文件到上下文，并且是更新模式
        NSFileHandle* fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:self.crashFilePath];
        
        // 跳到文件末尾
        [fileHandler seekToEndOfFile];
        
        // 追加数据
        [fileHandler writeData:writeData];
        
        // 关闭文件
        [fileHandler closeFile];
    }
    
//    if(self.pathBlock){
//        self.pathBlock(self.crashFilePath);
//    }
}

- (NSString *)currentTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

//- (ZFXUncaughtExceptionHandler *(^)(BOOL isShow))showAlert{
//    return ^(BOOL isShow) {
//        self.isShowAlert = isShow;
//        return [ZFXUncaughtExceptionHandler defaultExceptionHandler];
//    };
//}
//
//- (ZFXUncaughtExceptionHandler *(^)(BOOL isShow))showErrorInfor{
//    return ^(BOOL isShow) {
//        self.isShowErrorInfor = isShow;
//        return [ZFXUncaughtExceptionHandler defaultExceptionHandler];
//    };
//}
//
//- (ZFXUncaughtExceptionHandler *(^)(void(^ logPathBlock)(NSString *pathStr)))getlogPathBlock{
//    return ^(void(^ logPathBlock)(NSString *pathStr)) {
//        self.pathBlock = logPathBlock;
//        return [ZFXUncaughtExceptionHandler defaultExceptionHandler];
//    };
//}

@end


void HandleException(NSException *exception){
    
    int exceptionCount = atomic_fetch_add_explicit(&UncaughtExceptionCount, 1, memory_order_relaxed);//  OSAtomicIncrement32(&UncaughtExceptionCount);
    //如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    //获取调用堆栈
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    //在主线程中，执行制定的方法, withObject是执行方法传入的参数
    [[ZFXUncaughtExceptionHandler defaultExceptionHandler] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}

void SignalHandler (int signal){
    int exceptionCount = atomic_fetch_add_explicit(&UncaughtExceptionCount, 1, memory_order_relaxed); //OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [ZFXUncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[ZFXUncaughtExceptionHandler defaultExceptionHandler] performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal] userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
}

ZFXUncaughtExceptionHandler *InstanceUncaughtExceptionHandler(void){
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    return [ZFXUncaughtExceptionHandler defaultExceptionHandler];
}
