//
//  FLRadarChartModel.h
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLRadarChartModel : NSObject

/**
 数值数组
 */
@property (nonatomic, strong) NSArray<NSNumber *> *valueArray;

/**
 名称
 */
@property (nonatomic, strong) NSString *name;

/**
 绘制颜色
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

@end

NS_ASSUME_NONNULL_END
