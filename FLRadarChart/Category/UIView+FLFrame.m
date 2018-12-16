//
//  UIView+FLFrame.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/15.
//  Copyright © 2018 RomanticEncounter. All rights reserved.
//

#import "UIView+FLFrame.h"

@implementation UIView (FLFrame)

- (CGFloat)fl_x {
    return self.frame.origin.x;
}

- (void)setFl_x:(CGFloat)fl_x {
    CGRect frame = self.frame;
    frame.origin.x = fl_x;
    self.frame = frame;
}

- (CGFloat)fl_y {
    return self.frame.origin.y;
}

- (void)setFl_y:(CGFloat)fl_y {
    CGRect frame = self.frame;
    frame.origin.y = fl_y;
    self.frame = frame;
}

- (CGFloat)fl_width {
    return CGRectGetWidth(self.frame);
}

- (void)setFl_width:(CGFloat)fl_width {
    CGRect frame = self.frame;
    frame.size.width = fl_width;
    self.frame = frame;
}

- (CGFloat)fl_height {
    return CGRectGetHeight(self.frame);
}

- (void)setFl_height:(CGFloat)fl_height {
    CGRect frame = self.frame;
    frame.size.height = fl_height;
    self.frame = frame;
}

- (CGFloat)fl_top {
    return CGRectGetMinY(self.frame);
}

- (void)setFl_top:(CGFloat)fl_top {
    CGRect frame = self.frame;
    frame.origin.y = fl_top;
    self.frame = frame;
}

- (CGFloat)fl_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setFl_bottom:(CGFloat)fl_bottom {
    CGRect frame = self.frame;
    frame.origin.y = fl_bottom - CGRectGetHeight(frame);
    self.frame = frame;
}

- (CGFloat)fl_left {
    return CGRectGetMinX(self.frame);
}

- (void)setFl_left:(CGFloat)fl_left {
    CGRect frame = self.frame;
    frame.origin.x = fl_left;
    self.frame = frame;
}

- (CGFloat)fl_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setFl_right:(CGFloat)fl_right {
    CGRect frame = self.frame;
    frame.origin.x = fl_right - CGRectGetWidth(frame);
    self.frame = frame;
}

- (CGFloat)fl_centerX {
    return self.center.x;
}

- (void)setFl_centerX:(CGFloat)fl_centerX {
    CGPoint center = self.center;
    center.x = fl_centerX;
    self.center = center;
}

- (CGFloat)fl_centerY {
    return self.center.y;
}

- (void)setFl_centerY:(CGFloat)fl_centerY {
    CGPoint center = self.center;
    center.y = fl_centerY;
    self.center = center;
}

- (CGPoint)fl_origin {
    return self.frame.origin;
}

- (void)setFl_origin:(CGPoint)fl_origin {
    CGRect frame = self.frame;
    frame.origin = fl_origin;
    self.frame = frame;
}

- (CGSize)fl_size {
    return self.frame.size;
}

- (void)setFl_size:(CGSize)fl_size {
    CGRect frame = self.frame;
    frame.size = fl_size;
    self.frame = frame;
}

- (CGPoint)fl_leftTop {
    return self.frame.origin;
}

- (void)setFl_leftTop:(CGPoint)fl_leftTop {
    CGRect frame = self.frame;
    frame.origin = fl_leftTop;
    self.frame = frame;
}

- (CGPoint)fl_rightTop {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (void)setFl_rightTop:(CGPoint)fl_rightTop {
    CGRect frame = self.frame;
    frame.origin.x = fl_rightTop.x - CGRectGetWidth(frame);
    frame.origin.y = fl_rightTop.y;
    self.frame = frame;
}

- (CGPoint)fl_leftBottom {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setFl_leftBottom:(CGPoint)fl_leftBottom {
    CGRect frame = self.frame;
    frame.origin.x = fl_leftBottom.x;
    frame.origin.y = fl_leftBottom.y - CGRectGetHeight(frame);
    self.frame = frame;
}

- (CGPoint)fl_rightBottom {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setFl_rightBottom:(CGPoint)fl_rightBottom {
    CGRect frame = self.frame;
    frame.origin.x = fl_rightBottom.x - CGRectGetWidth(frame);
    frame.origin.y = fl_rightBottom.y - CGRectGetHeight(frame);
    self.frame = frame;
}

- (CGPoint)fl_leftCenter {
    return CGPointMake(CGRectGetMinX(self.frame), self.center.y);
}

- (void)setFl_leftCenter:(CGPoint)fl_leftCenter {
    CGPoint center = self.center;
    center.x = fl_leftCenter.x + CGRectGetWidth(self.frame) * 0.5;
    center.y = fl_leftCenter.y;
    self.center = center;
}

- (CGPoint)fl_rightCenter {
    return CGPointMake(CGRectGetMaxX(self.frame), self.center.y);
}

- (void)setFl_rightCenter:(CGPoint)fl_rightCenter {
    CGPoint center = self.center;
    center.x = fl_rightCenter.x - CGRectGetWidth(self.frame) * 0.5;
    center.y = fl_rightCenter.y;
    self.center = center;
}

- (CGPoint)fl_topCenter {
    return CGPointMake(self.center.x, CGRectGetMinY(self.frame));
}

- (void)setFl_topCenter:(CGPoint)fl_topCenter {
    CGPoint center = self.center;
    center.x = fl_topCenter.x;
    center.y = fl_topCenter.y + CGRectGetHeight(self.frame) * 0.5;
    self.center = center;
}

- (CGPoint)fl_bottomCenter {
    return CGPointMake(self.center.x, CGRectGetMaxY(self.frame));
}

- (void)setFl_bottomCenter:(CGPoint)fl_bottomCenter {
    CGPoint center = self.center;
    center.x = fl_bottomCenter.x;
    center.y = fl_bottomCenter.y - CGRectGetHeight(self.frame) * 0.5;
    self.center = center;
}

@end
