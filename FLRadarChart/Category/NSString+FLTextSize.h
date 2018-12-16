//
//  NSString+FLTextSize.h
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSString (FLTextSize)

/**
 根据字体的大小和限制的大小获取对应的字符串size
 
 @param font 字体大小
 @param constrainedSize 约束的范围
 @param lineBreakMode 截取字符串的方式
 @return CGSize
 */
- (CGSize)fl_sizeForFont:(nonnull UIFont *)font constrainedSize:(CGSize)constrainedSize mode:(NSLineBreakMode)lineBreakMode;

/**
 根据字体大小获取获取对应字符串的size
 
 @param font 字体大小
 @return CGSize
 */
- (CGSize)fl_sizeForFont:(nonnull UIFont *)font;

/**
 根据字体的大小获取宽度
 
 @param font 字体大小
 @return CGFloat
 */
- (CGFloat)fl_widthForFont:(nonnull UIFont *)font;

/**
 根据字体的大小和约束的宽度来获取高度
 
 @param font 字体大小
 @param width 宽度
 @return CGFloat
 */
- (CGFloat)fl_heightForFont:(nonnull UIFont *)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
