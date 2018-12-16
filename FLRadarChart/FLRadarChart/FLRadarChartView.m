//
//  FLRadarChartView.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "FLRadarChartView.h"
#import "UIView+FLFrame.h"
#import "NSString+FLTextSize.h"
#import "FLRadarChartModel.h"

//由角度转换弧度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

@interface FLRadarChartView ()

/**
 半径
 */
@property (nonatomic, assign) CGFloat chartRadius;

/**
 图表中心位置
 */
@property (nonatomic, assign) CGPoint chartCenter;

/**
 背景线layer
 */
@property (nonatomic, strong) CAShapeLayer *backgroundLineLayer;

/**
 需要绘制的雷达图
 */
@property (nonatomic, strong) CAShapeLayer *valueLayer;

/**
 分类颜色描述
 */
@property (nonatomic, strong) CAShapeLayer *colorDescribeLayer;

@end

@implementation FLRadarChartView

- (instancetype)init {
    if (self = [super init]) {
        [self p_setupDefaultRadarChart];
    }
    return self;
}

- (void)p_setupDefaultRadarChart {
    self.minValue = 0;
    self.maxValue = 100;
    self.lineInterval = 20;
    //    self.backgroundColor = [UIColor whiteColor];
    self.radarChartLineWidth = 1;
    self.radarChartLineColor = [UIColor grayColor];
    self.classifyTextFont = [UIFont systemFontOfSize:12.0];
    self.classifyTextColor = [UIColor grayColor];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - setter
- (void)setClassifyDataArray:(NSArray<NSString *> *)classifyDataArray {
    _classifyDataArray = classifyDataArray;
    NSAssert(classifyDataArray.count >= 3, @"分类数据不能小于三组");
}

#pragma mark - layoutSubviews

- (void)drawRect:(CGRect)rect {
    [self fl_drawRadarChartBackgroundLine];
    [self fl_drawRadarChartWithValue];
    [self fl_drawRadarChartWithColorDescribe];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //上下预留30的间距，做文字和颜色描述描述
    self.chartRadius = MIN(self.fl_width, self.fl_height) / 2  - 60;
    //    self.chartCenter = CGPointMake(MIN(self.fl_width, self.fl_height)/2, MIN(self.fl_width, self.fl_height)/2);
    //    self.chartCenter = CGPointMake(MAX(self.fl_width, self.fl_height)/2, MAX(self.fl_width, self.fl_height)/2);
    self.chartCenter = CGPointMake(self.fl_width / 2, self.fl_height / 2);
}

#pragma mark - methods

- (void)fl_redrawRadarChart {
    [_valueLayer removeFromSuperlayer];
    _valueLayer = nil;
    [_colorDescribeLayer removeFromSuperlayer];
    _colorDescribeLayer = nil;
    [self fl_drawRadarChartWithValue];
    [self fl_drawRadarChartWithColorDescribe];
}



/**
 绘制雷达图
 */
- (void)fl_drawRadarChartWithValue {
    for (FLRadarChartModel *dataModel in self.dataArray) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = self.radarChartLineWidth;
        layer.strokeColor = dataModel.strokeColor.CGColor;
        layer.fillColor = dataModel.fillColor.CGColor;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        //不能使用forin遍历 如果数组中存在相同数据 indexOfObject 获取的 index 是错误的
        for (NSInteger i = 0; i < dataModel.valueArray.count; i ++) {
            NSNumber *value = dataModel.valueArray[i];
            CGFloat numeric = value.floatValue;
            
            //判断当前值是否超过最大最小值
            if (value.floatValue > self.maxValue) {
                numeric = MIN(value.floatValue, self.maxValue);
            } else if (value.floatValue < self.minValue) {
                numeric = MAX(value.floatValue, self.minValue);
            }
            
            NSInteger subAngle = 360 / self.classifyDataArray.count;
            
            
            //NSInteger index = [dataModel.valueArray indexOfObject:value];
            
            NSInteger angle = i * subAngle;
            CGFloat radian = kDegreesToRadian(angle);
            //每个数值的最小半径
            CGFloat minValueRadius = (self.maxValue - self.minValue) / self.chartRadius;
            
            CGFloat x = self.chartCenter.x + sinf(radian) * (numeric / minValueRadius);
            CGFloat y = self.chartCenter.y - cosf(radian) * (numeric / minValueRadius);
            
            CGPoint valuePoint = CGPointMake(x, y);
            if (i == 0) {
                [bezierPath moveToPoint:valuePoint];
            } else {
                [bezierPath addLineToPoint:valuePoint];
            }
        }
        
        [bezierPath closePath];
        layer.path = bezierPath.CGPath;
        [self.valueLayer addSublayer:layer];
    }
    [self.layer addSublayer:self.valueLayer];
}

/**
 绘制颜色描述
 */
- (void)fl_drawRadarChartWithColorDescribe {
    for (FLRadarChartModel *model in self.dataArray) {
        NSInteger index = [self.dataArray indexOfObject:model];
        CGSize textSize = [model.name fl_sizeForFont:self.classifyTextFont];
        CGFloat textInterval = 5;
        
        CGRect textFrame = CGRectMake(self.fl_width - textSize.width - 3 * textInterval, self.fl_height - (index + 1) * textSize.height - 2 * (index + 1) * textInterval, textSize.width, textSize.height);
        CGRect colorCircleFrame = CGRectMake(textFrame.origin.x - textInterval - textSize.height, textFrame.origin.y, textSize.height, textSize.height);
        
        CAShapeLayer *colorCircleLayer = [self fl_getColorCircleLayerWithColor:model.strokeColor frame:colorCircleFrame];
        [self.colorDescribeLayer addSublayer:colorCircleLayer];
        
        CATextLayer *colorDescribeLayer = [self fl_getTextLayerWithString:model.name backgroundColor:[UIColor clearColor] frame:textFrame];
        [self.colorDescribeLayer addSublayer:colorDescribeLayer];
    }
    [self.layer addSublayer:self.colorDescribeLayer];
}

/**
 绘制雷达图背景
 */
- (void)fl_drawRadarChartBackgroundLine {
    //雷达图需要绘制的底线数量
    NSInteger radarCount = self.classifyDataArray.count;
    //半径
    CGFloat radius = self.chartRadius;
    //子角度
    //1/360 的角度
    NSInteger subAngle = 360 / radarCount;
    
    //雷达图间隔可以画的次数
    NSInteger lines = ceilf(radius / self.lineInterval);
    
    NSMutableArray *borderPointArray = [NSMutableArray array];
    self.backgroundLineLayer = [CAShapeLayer layer];
    self.backgroundLineLayer.lineWidth = self.radarChartLineWidth;
    self.backgroundLineLayer.strokeColor = self.radarChartLineColor.CGColor;
    self.backgroundLineLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *backgroundLinePath = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < lines; i ++) {
        //循环绘制每一圈的背景线
        NSMutableArray<NSValue *> *pointArray = [NSMutableArray array];
        for (NSInteger idx = 0; idx < radarCount; idx++ ) {
            NSInteger angle = idx * subAngle;
            CGFloat radian = kDegreesToRadian(angle);
            
            CGFloat x = self.chartCenter.x + sinf(radian) * radius;
            CGFloat y = self.chartCenter.y - cosf(radian) * radius;
            
            //CGFloat x = self.view.center.x + cos(radian) * radius;
            //CGFloat y = self.view.center.y + sin(radian) * radius;
            
            CGPoint point = CGPointMake(x, y);
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            
            if (idx == 0) {
                [backgroundLinePath moveToPoint:point];
            } else {
                [backgroundLinePath addLineToPoint:point];
            }
        }
        //重新连接第一个点
        //        [backgroundLinePath addLineToPoint:pointArray.firstObject.CGPointValue];
        [backgroundLinePath closePath];
        radius -= self.lineInterval;
        if (i == 0) {
            [borderPointArray setArray:pointArray];
        }
    }
    //竖向直线
    for (NSValue *boardValue in borderPointArray) {
        CGPoint boardPoint = boardValue.CGPointValue;
        [backgroundLinePath moveToPoint:boardPoint];
        [backgroundLinePath addLineToPoint:self.chartCenter];
    }
    
    self.backgroundLineLayer.path = backgroundLinePath.CGPath;
    [self.layer addSublayer:self.backgroundLineLayer];
    
    [self fl_drawRadarChartClassifyTextWithPointArray:borderPointArray];
}

/**
 绘制雷达图分类属性文字
 
 @param pointArray 每个角的坐标数组
 */
- (void)fl_drawRadarChartClassifyTextWithPointArray:(NSArray<NSValue *> *)pointArray {
    for (NSInteger j = 0; j < pointArray.count; j ++) {
        //边框的位置
        CGPoint textPoint = pointArray[j].CGPointValue;
        
        CATextLayer *textLayer = nil;
        //文字
        NSString *text = self.classifyDataArray[j];
        //文字大小
        CGSize textSize = [text fl_sizeForFont:self.classifyTextFont];
        //文字的间隔
        CGFloat textInterval = 10;
        //多加一个判断条件
        if (textPoint.x < self.chartCenter.x && (self.chartCenter.x - textPoint.x) > 0.05) {
            CGRect frame = CGRectMake(textPoint.x - textSize.width - textInterval, textPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
        } else if (textPoint.x > self.chartCenter.x && (textPoint.x - self.chartCenter.x) > 0.05) {
            CGRect frame = CGRectMake(textPoint.x + textInterval, textPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
        } else  { //textPoint.x == self.chartCenter.x
            if (textPoint.y < self.chartCenter.y) {
                CGRect frame = CGRectMake(textPoint.x - textSize.width / 2, textPoint.y - textSize.height - textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            } else {
                CGRect frame = CGRectMake(textPoint.x - textSize.width / 2, textPoint.y + textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            }
        }
        [self.layer addSublayer:textLayer];
    }
}



- (CATextLayer *)fl_getTextLayerWithString:(NSString *)text backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame {
    //初始化一个CATextLayer
    CATextLayer *textLayer = [CATextLayer layer];
    //设置文字frame
    textLayer.frame = frame;
    //设置文字
    textLayer.string = text;
    //设置文字大小
    textLayer.fontSize = self.classifyTextFont.pointSize;
    //设置文字颜色
    textLayer.foregroundColor = self.classifyTextColor.CGColor;
    //设置背景颜色
    textLayer.backgroundColor = backgroundColor.CGColor;
    //设置对齐方式
    textLayer.alignmentMode = kCAAlignmentCenter;
    //设置分辨率
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

- (CAShapeLayer *)fl_getColorCircleLayerWithColor:(UIColor *)color frame:(CGRect)frame {
    CAShapeLayer *colorCircleLayer = [CAShapeLayer layer];
    colorCircleLayer.fillColor = [color CGColor];
    colorCircleLayer.strokeColor = [color CGColor];
    colorCircleLayer.lineCap = kCALineCapRound;
    colorCircleLayer.lineWidth = 1;
    UIBezierPath *colorCircleLayerPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    colorCircleLayer.path = colorCircleLayerPath.CGPath;
    return colorCircleLayer;
}

#pragma mark - lazy load.
- (CAShapeLayer *)valueLayer {
    if (!_valueLayer) {
        _valueLayer = [CAShapeLayer layer];
    }
    return _valueLayer;
}

- (CAShapeLayer *)colorDescribeLayer {
    if (!_colorDescribeLayer) {
        _colorDescribeLayer = [CAShapeLayer layer];
    }
    return _colorDescribeLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
