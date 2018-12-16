//
//  NSString+FLTextSize.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "NSString+FLTextSize.h"

@implementation NSString (FLTextSize)

#pragma mark - 字符串大小计算

- (CGSize)fl_sizeForFont:(UIFont *)font constrainedSize:(CGSize)constrainedSize mode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName: paragraph};
    return [self boundingRectWithSize:constrainedSize
                              options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine)
                           attributes:attributes
                              context:nil].size;
}

- (CGSize)fl_sizeForFont:(UIFont *)font {
    return [self fl_sizeForFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
}

- (CGFloat)fl_widthForFont:(UIFont *)font {
    return [self fl_sizeForFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping].width;
}

- (CGFloat)fl_heightForFont:(UIFont *)font width:(CGFloat)width {
    return [self fl_sizeForFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping].height;
}

@end
