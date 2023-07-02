//
//  NSString+ZFXCategory.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "NSString+ZFXCategory.h"

@implementation NSString (ZFXCategory)

+ (NSString *)uuid {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

+ (NSString *)random_uuid {
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    
    CFRelease(uuidRef);
    CFRelease(uuidStrRef);
    
    return uuid;
}

@end
