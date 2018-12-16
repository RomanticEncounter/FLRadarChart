# FLRadarChart
## 雷达图
> 用`UIBezierPath` + `CAShaperLayer`绘制，先给展示一张最终的效果图，然后咱们慢慢来说思路

<img src="https://upload-images.jianshu.io/upload_images/2871024-3a806bdafbd5ddc5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" "雷达图最终效果" align=center style="zoom:50%">
<!--![雷达图最终效果](https://upload-images.jianshu.io/upload_images/2871024-3a806bdafbd5ddc5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)-->

#### 步骤 + 思路
1. 绘制背景（蜘蛛网效果）和 分类属性名的绘制

外层的多边形：把雷达图看成一个圆形，最外层的点都是在圆上的，这样我们就可以在圆上找多个点，然后连接在一起，去绘制了。
<img src="http://upload-images.jianshu.io/upload_images/2871024-f6cb963b45243668.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" "圆形的路径" align=center style="zoom:50%">
<!--![圆形的路径](http://upload-images.jianshu.io/upload_images/2871024-f6cb963b45243668.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)-->

首先创建一个`RadarChartView`，开始着手，最外层边框线的绘制，先要根据分类的数据才能确定圆上有几个点。
```objective-c
- (void)fl_drawRadarChartBorderLine {
    CAShapeLayer *layer = [CAShapeLayer layer];
    //线条宽度
    layer.lineWidth = 1.0;
    //线条颜色
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //拿到view的中心点坐标chartCenter,不能用self.center，这个获取的是view在父视图中的坐标
    CGPoint chartCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    //假数据
    NSArray *dataArray = @[@"Objective-C",@"Swift",@"Python",@"Java",@"C",@"c++"];
    //圆半径
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2 - 20;
    //子角度
    //1/360 的角度
    NSInteger subAngle = 360 / dataArray.count;
    
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        //角度
        NSInteger angle = i * subAngle;
        //弧度  角度转弧度
        CGFloat radian = (M_PI * (angle) / 180.0);
        //弧度转坐标
        CGFloat x = chartCenter.x + sinf(radian) * radius;
        CGFloat y = chartCenter.y - cosf(radian) * radius;
        CGPoint point = CGPointMake(x, y);
        if (i == 0) {
            //第一个点
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    //将路径闭合，即将起点和终点连起
    [path closePath];
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}
//用drawRect开始绘制
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self fl_drawRadarChartBorderLine];
}
```
<img src="https://upload-images.jianshu.io/upload_images/2871024-eec0ec8428f90e52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" "边框线条绘制效果" align=center style="zoom:50%">
<!--![边框线条绘制效果](https://upload-images.jianshu.io/upload_images/2871024-eec0ec8428f90e52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
-->
雷达图的雏形就已经绘制好了，现在开始绘制每一层的线条
```objective-c
- (void)fl_drawRadarChartBorderBackgroundLine {
    CAShapeLayer *layer = [CAShapeLayer layer];
    //线条宽度
    layer.lineWidth = 1.0;
    //线条颜色
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //拿到view的中心点坐标chartCenter,不能用self.center，这个获取的是view在父视图中的坐标
    CGPoint chartCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    //假数据
    NSArray *dataArray = @[@"Objective-C",@"Swift",@"Python",@"Java",@"C",@"c++"];
    //圆半径
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2 - 20;
    //子角度
    //1/360 的角度
    NSInteger subAngle = 360 / dataArray.count;
    //每条线的间隔
    CGFloat lineInterval = 20.0;
    
    //雷达图间隔可以画的次数，向上取整
    NSInteger lines = ceilf(radius / lineInterval);
    //保存最外层的坐标点，可用于绘制竖直的线条
    NSMutableArray *borderPointArray = [NSMutableArray array];
    //根据可绘制的线条数量循环
    for (NSInteger idx = 0; idx < lines; idx ++) {
        //循环绘制每一圈的背景线
        NSMutableArray<NSValue *> *pointArray = [NSMutableArray array];
        for (NSInteger i = 0; i < dataArray.count; i ++) {
            //角度
            NSInteger angle = i * subAngle;
            //弧度  角度转弧度
            CGFloat radian = (M_PI * (angle) / 180.0);
            //弧度转坐标
            CGFloat x = chartCenter.x + sinf(radian) * radius;
            CGFloat y = chartCenter.y - cosf(radian) * radius;
            CGPoint point = CGPointMake(x, y);
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            if (i == 0) {
                //第一个点
                [path moveToPoint:point];
            } else {
                [path addLineToPoint:point];
            }
        }
        //将路径闭合，即将起点和终点连起
        [path closePath];
        //减去线条间隔
        radius -= lineInterval;
        if (idx == 0) {
            //获取最外层的坐标数组
            [borderPointArray setArray:pointArray];
        }
    }
    //竖向直线
    for (NSValue *boardValue in borderPointArray) {
        CGPoint boardPoint = boardValue.CGPointValue;
        //连接最外层坐标点和雷达图中心点
        [path moveToPoint:boardPoint];
        [path addLineToPoint:chartCenter];
    }
    
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}
```
![蜘蛛网图绘制效果](https://upload-images.jianshu.io/upload_images/2871024-5dfca94da9bd875b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
绘制完成后，开始着手分类属性名称的绘制，这里可以使用`UILabel`或`CATextLayer`，`UILabel`就不用讲太多了，既然是图表，还是选择`CATextLayer`。

最外层的坐标点数组，这里就还可以用来计算每个分类属性文字的位置。计算文字的大小可以用系统的
```objective-c
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 7_0);
```
或是
```objective-c
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 6_0);
```
接下来绘制雷达图分类属性文字，根据边框上的点来计算，文本应该显示的位置，下面的代码，进行了封装，和上面无异
![根据中心点的位计算文本位置](https://upload-images.jianshu.io/upload_images/2871024-36dd920af5ecf4be.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objective-c
/**
 绘制雷达图分类属性文字
 
 @param pointArray 每个角的坐标数组
 */
- (void)fl_drawRadarChartClassifyTextWithPointArray:(NSArray<NSValue *> *)pointArray {
    for (NSInteger j = 0; j < pointArray.count; j ++) {
        //边框的位置
        CGPoint borderPoint = pointArray[j].CGPointValue;
        
        CATextLayer *textLayer = nil;
        //文字
        NSString *text = self.classifyDataArray[j];
        //文字大小
        CGSize textSize = [text fl_sizeForFont:self.classifyTextFont];
        //文字的间隔
        CGFloat textInterval = 10;
        
        if (borderPoint.x < self.chartCenter.x && (self.chartCenter.x - borderPoint.x) > 0.05) {
            //判断是否在圆中心点的左侧，多加一个判断条件，主要用于判断文本上下两点的，边框绘制的点和实际chartCenter.有一点点偏差
            CGRect frame = CGRectMake(borderPoint.x - textSize.width - textInterval, borderPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            
        } else if (borderPoint.x > self.chartCenter.x && (borderPoint.x - self.chartCenter.x) > 0.05) {
            //判断是否在圆中心点的右侧
            CGRect frame = CGRectMake(borderPoint.x + textInterval, borderPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            
        } else  { //textPoint.x == self.chartCenter.x
            if (borderPoint.y < self.chartCenter.y) {
                //判断是否在圆中心点的正上方
                CGRect frame = CGRectMake(borderPoint.x - textSize.width / 2, borderPoint.y - textSize.height - textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
                
            } else {
                //判断是否在圆中心点的正下方
                CGRect frame = CGRectMake(borderPoint.x - textSize.width / 2, borderPoint.y + textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
                
            }
        }
        [self.backgroundLineLayer addSublayer:textLayer];
    }
}


/**
 获取CATextLayer

 @param text 文本
 @param backgroundColor 背景色
 @param frame 位置大小
 @return CATextLayer
 */
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
```
![雷达图底层绘制效果](https://upload-images.jianshu.io/upload_images/2871024-d32a8faa44dd4d71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 根据数据绘制数据图层
数据无非就是0-100、0-1或是100-1000等之间的数值，并不确定，反观雷达图中心点肯定就是最小值，边框就是最大值，所以我们需要确定图表中的`minValue`和`maxValue`，每个图层都有它的名称，线条颜色，填充颜色和数值，数值的数量基本是和分类属性数量是一致的，所以我们写了个`FLRadarChartModel`，定义了以下四个个属性。
```obejective-c
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
```
然后就可以根据我们自己定义的`model`来进行多层绘制。初始化三个假数据

```obejective-c
FLRadarChartModel *model_1 = [[FLRadarChartModel alloc]init];
model_1.name = @"平均能力";
model_1.valueArray = @[@50,@100,@80,@35,@10,@65];
model_1.strokeColor = [UIColor fl_colorWithHexString:@"00A8FF"];
model_1.fillColor = [UIColor fl_colorWithHexString:@"00A8FF" alpha:0.8];

FLRadarChartModel *model_2 = [[FLRadarChartModel alloc]init];
model_2.name = @"个人能力";
model_2.valueArray = @[@60,@50,@30,@100,@90,@75,];
model_2.strokeColor = [UIColor fl_colorWithHexString:@"FED700"];
model_2.fillColor = [UIColor fl_colorWithHexString:@"FED700" alpha:0.8];

FLRadarChartModel *model_3 = [[FLRadarChartModel alloc]init];
model_3.name = @"屌丝能力";
model_3.valueArray = @[@20,@30,@40,@50,@60,@25,];
model_3.strokeColor = [UIColor fl_colorWithHexString:@"FFC0CB"];
model_3.fillColor = [UIColor fl_colorWithHexString:@"FFC0CB" alpha:0.8];
        
self.dataArray = @[model_1, model_2, model_3];
```

```obejective-c
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
            
            //是否允许数据溢出
            if (!self.allowOverflow) {
                //判断当前值是否超过最大最小值
                if (value.floatValue > self.maxValue) {
                    numeric = MIN(value.floatValue, self.maxValue);
                } else if (value.floatValue < self.minValue) {
                    numeric = MAX(value.floatValue, self.minValue);
                }
            }
            
            NSInteger subAngle = 360 / self.classifyDataArray.count;
            
            //error：NSInteger index = [dataModel.valueArray indexOfObject:value];
            
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
```
已经绘制好数据图层了，就还剩图层颜色和名称的描述，我将颜色和文字描述定位在`view`的右下角。颜色圆形用`CAShapeLayer`，文字用`CATextLayer`。

```obejective-c
/**
 绘制颜色和文字描述
 */
- (void)fl_drawRadarChartWithColorDescribe {
    for (FLRadarChartModel *model in self.dataArray) {
        NSInteger index = [self.dataArray indexOfObject:model];
        CGSize textSize = [model.name fl_sizeForFont:self.classifyTextFont];
        CGFloat textInterval = 5;
        
        //计算文字的绘制位置
        CGRect textFrame = CGRectMake(self.fl_width - textSize.width - 3 * textInterval, self.fl_height - (index + 1) * textSize.height - 2 * (index + 1) * textInterval, textSize.width, textSize.height);
        //计算颜色圆形的绘制位置
        CGRect colorCircleFrame = CGRectMake(textFrame.origin.x - textInterval - textSize.height, textFrame.origin.y, textSize.height, textSize.height);
        
        CAShapeLayer *colorCircleLayer = [self fl_getColorCircleLayerWithColor:model.strokeColor frame:colorCircleFrame];
        [self.colorDescribeLayer addSublayer:colorCircleLayer];
        
        CATextLayer *colorDescribeLayer = [self fl_getTextLayerWithString:model.name backgroundColor:[UIColor clearColor] frame:textFrame];
        [self.colorDescribeLayer addSublayer:colorDescribeLayer];
    }
    [self.layer addSublayer:self.colorDescribeLayer];
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
```
最终效果如图
![最终效果图](https://upload-images.jianshu.io/upload_images/2871024-c8647e943cc76ff9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

雷达图的显示基本上绘制完成了。希望能对大家有用。