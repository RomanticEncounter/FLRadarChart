# FLRadarChart
## 雷达图
> 使用`UIBezierPath` + `CAShaperLayer`绘制


## 如何使用

### 创建

```objc
FLRadarChartView *radarChartView = [[FLRadarChartView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
radarChartView.backgroundColor = [UIColor groupTableViewBackgroundColor];
radarChartView.minValue = 0.0;
radarChartView.maxValue = 100.0;
radarChartView.allowOverflow = YES;
[self.view addSubview:radarChartView];

```
### 传入数据源

```objc
FLRadarChartModel *model_1 = [[FLRadarChartModel alloc]init];
model_1.name = @"能力1";
model_1.valueArray = @[@10, @20, @30, @40, @50, @60];
model_1.strokeColor = [UIColor redColor];
model_1.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    
FLRadarChartModel *model_2 = [[FLRadarChartModel alloc]init];
model_2.name = @"能力2";
model_2.valueArray =  @[@100, @90, @80, @70, @60];
model_2.strokeColor = [UIColor greenColor];
model_2.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];

//设置分类数据标题
radarChartView.classifyDataArray = @[@"Objective-C",@"Swift",@"Python",@"Java",@"C",@"C++"];

//设置数据源
radarChartView.dataArray = @[model_1, model_2];

//绘制
[radarChartView fl_redrawRadarChart];
```


