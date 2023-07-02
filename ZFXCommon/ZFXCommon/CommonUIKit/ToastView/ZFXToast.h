//
//  ZFXToast.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFXToast : NSObject

+ (void)showToast:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END
