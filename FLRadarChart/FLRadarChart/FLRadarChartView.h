//
//  FLRadarChartView.h
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLRadarChartModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLRadarChartView : UIView

/**
 最小值
 */
@property (nonatomic, assign) CGFloat minValue;

/**
 最大值
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 是否允许数据溢出 默认：YES
 */
@property (nonatomic, assign) BOOL allowOverflow;

/**
 雷达图间隔
 */
@property (nonatomic, assign) CGFloat lineInterval;

/**
 背景线宽度
 */
@property (nonatomic, assign) CGFloat radarChartLineWidth;

/**
 雷达图背景线颜色
 */
@property (nonatomic, strong) UIColor *radarChartLineColor;

/**
 数据源
 */
@property (nonatomic, strong) NSArray<FLRadarChartModel *> *dataArray;

/**
 分类属性数组 不能小于三组数据
 */
@property (nonatomic, strong) NSArray<NSString *> *classifyDataArray;

/**
 分类字体大小
 */
@property (nonatomic, strong) UIFont *classifyTextFont;

/**
 分类字体颜色
 */
@property (nonatomic, strong) UIColor *classifyTextColor;

/**
 重新绘制雷达图
 */
- (void)fl_redrawRadarChart;

@end

NS_ASSUME_NONNULL_END
