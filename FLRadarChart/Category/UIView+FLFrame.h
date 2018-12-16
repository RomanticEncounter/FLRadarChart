//
//  UIView+FLFrame.h
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/15.
//  Copyright © 2018 RomanticEncounter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FLFrame)

@property (nonatomic, assign) CGFloat fl_x;
@property (nonatomic, assign) CGFloat fl_y;
@property (nonatomic, assign) CGFloat fl_width;
@property (nonatomic, assign) CGFloat fl_height;

@property (nonatomic, assign) CGFloat fl_top;
@property (nonatomic, assign) CGFloat fl_bottom;
@property (nonatomic, assign) CGFloat fl_left;
@property (nonatomic, assign) CGFloat fl_right;

@property (nonatomic, assign) CGFloat fl_centerX;
@property (nonatomic, assign) CGFloat fl_centerY;

@property (nonatomic, assign) CGPoint fl_origin;
@property (nonatomic, assign) CGSize  fl_size;

@property (nonatomic, assign) CGPoint fl_leftTop;
@property (nonatomic, assign) CGPoint fl_rightTop;
@property (nonatomic, assign) CGPoint fl_leftBottom;
@property (nonatomic, assign) CGPoint fl_rightBottom;

@property (nonatomic, assign) CGPoint fl_leftCenter;
@property (nonatomic, assign) CGPoint fl_rightCenter;
@property (nonatomic, assign) CGPoint fl_topCenter;
@property (nonatomic, assign) CGPoint fl_bottomCenter;

@end

NS_ASSUME_NONNULL_END
