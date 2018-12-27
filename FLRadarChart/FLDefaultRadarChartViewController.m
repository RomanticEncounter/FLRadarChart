//
//  FLDefaultRadarChartViewController.m
//  FLRadarChart
//
//  Created by LingPin on 2018/12/27.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "FLDefaultRadarChartViewController.h"
#import <Masonry/Masonry.h>
#import "FLRadarChartView.h"
#import "FLRadarChartModel.h"

@interface FLDefaultRadarChartViewController ()

@property (nonatomic, strong) FLRadarChartView *radarChartView;

@property (nonatomic, strong) UISwitch *allowOverflowSwitch;

@property (nonatomic, strong) UISwitch *colorFillSwitch;

@property (nonatomic, strong) UILabel *allowOverflowLabel;

@property (nonatomic, strong) UILabel *colorFillLabel;

@property (nonatomic, strong) UISlider *alphaSlider;
@end

@implementation FLDefaultRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(test_changeData)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.view addSubview:self.radarChartView];
    
    [self.view addSubview:self.allowOverflowSwitch];
    [self.view addSubview:self.allowOverflowLabel];

    [self.view addSubview:self.colorFillSwitch];
    [self.view addSubview:self.colorFillLabel];
    
    [self.view addSubview:self.alphaSlider];
    
    [_radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_topMargin);
        make.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(self.radarChartView.mas_width);
    }];
    [_allowOverflowSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.radarChartView.mas_bottom).mas_offset(10.0);
    }];
    [_colorFillSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.allowOverflowSwitch.mas_bottom).mas_offset(10.0);
    }];
    [_alphaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
        make.top.mas_equalTo(self.colorFillSwitch.mas_bottom).mas_offset(20.0);
    }];
    _allowOverflowSwitch.on = self.radarChartView.allowOverflow;
    _alphaSlider.enabled = self.colorFillSwitch.on;
    _alphaSlider.value = 0.3;
    [self test_changeData];
}

- (void)test_changeData {
    FLRadarChartModel *model_1 = [[FLRadarChartModel alloc]init];
    model_1.name = @"啦啦啦学校平均能力";
    model_1.valueArray = [self p_getRandomNumber:6];
    model_1.strokeColor = [self fl_colorWithHexString:@"00A8FF"];
    model_1.fillColor = self.colorFillSwitch.isOn ? [self fl_colorWithHexString:@"00A8FF" alpha:self.alphaSlider.value] : [UIColor clearColor];
    
    FLRadarChartModel *model_2 = [[FLRadarChartModel alloc]init];
    model_2.name = @"啦啦啦学生个人能力";
    model_2.valueArray = [self p_getRandomNumber:6];
    model_2.strokeColor = [self fl_colorWithHexString:@"FED700"];
    model_2.fillColor = self.colorFillSwitch.isOn ? [self fl_colorWithHexString:@"FED700" alpha:self.alphaSlider.value] : [UIColor clearColor];
    
    FLRadarChartModel *model_3 = [[FLRadarChartModel alloc]init];
    model_3.name = @"啦啦啦啦屌丝能力";
    model_3.valueArray = [self p_getRandomNumber:6];
    model_3.strokeColor = [self fl_colorWithHexString:@"FFC0CB"];
    model_3.fillColor = self.colorFillSwitch.isOn ? [self fl_colorWithHexString:@"FFC0CB" alpha:self.alphaSlider.value] : [UIColor clearColor];
    
    FLRadarChartModel *model_4 = [[FLRadarChartModel alloc]init];
    model_4.name = @"好嗨呦~";
    model_4.valueArray = [self p_getRandomNumber:6];
    model_4.strokeColor = [self fl_colorWithHexString:@"FF0000"];
    model_4.fillColor = self.colorFillSwitch.isOn ? [self fl_colorWithHexString:@"FF0000" alpha:self.alphaSlider.value] : [UIColor clearColor];
    
    self.radarChartView.classifyDataArray = @[@"Objective-C",@"Swift",@"Python",@"Java",@"C",@"C++"];
    self.radarChartView.dataArray = @[model_1, model_2, model_3, model_4];
    [self.radarChartView fl_redrawRadarChart];
}

- (void)allowOverflowSwitchAction:(UISwitch *)allowSwitch {
    self.radarChartView.allowOverflow = allowSwitch.isOn;
    [self.radarChartView fl_redrawRadarChart];
}

- (void)colorFillSwitchAction:(UISwitch *)fillSwitch {
    self.alphaSlider.enabled = fillSwitch.on;
    [self.radarChartView.dataArray enumerateObjectsUsingBlock:^(FLRadarChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fillColor = self.colorFillSwitch.isOn ? [obj.strokeColor colorWithAlphaComponent:self.alphaSlider.value] : [UIColor clearColor];
    }];
    [self.radarChartView fl_redrawRadarChart];
}

- (void)alphaSliderAction:(UISlider *)slider {
    [self.radarChartView.dataArray enumerateObjectsUsingBlock:^(FLRadarChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fillColor = [obj.strokeColor colorWithAlphaComponent:slider.value];
    }];
    [self.radarChartView fl_redrawRadarChart];
}

- (NSArray *)p_getRandomNumber:(NSInteger)count {
    NSMutableArray *numberArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        //修改随机数可以查看溢出数据
        NSInteger randomNumber = arc4random() % 150;
        [numberArray addObject:@(randomNumber)];
    }
    return [numberArray copy];
}

- (UIColor *)fl_colorWithHexString:(NSString *)hexString {
    return [self fl_colorWithHexString:hexString alpha:1.0];
}

- (UIColor *)fl_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    //剔除#
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}

#pragma mark - lazy load.
- (FLRadarChartView *)radarChartView {
    if (!_radarChartView) {
        _radarChartView = [[FLRadarChartView alloc] init];
        _radarChartView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _radarChartView.minValue = 0.0;
        _radarChartView.maxValue = 100.0;
        _radarChartView.allowOverflow = YES;
        
    }
    return _radarChartView;
}

- (UISwitch *)allowOverflowSwitch {
    if (!_allowOverflowSwitch) {
        _allowOverflowSwitch = [[UISwitch alloc]init];
        [_allowOverflowSwitch addTarget:self action:@selector(allowOverflowSwitchAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _allowOverflowSwitch;
}

- (UISwitch *)colorFillSwitch {
    if (!_colorFillSwitch) {
        _colorFillSwitch = [[UISwitch alloc]init];
        [_colorFillSwitch addTarget:self action:@selector(colorFillSwitchAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _colorFillSwitch;
}

- (UISlider *)alphaSlider {
    if (!_alphaSlider) {
        _alphaSlider = [[UISlider alloc] init];
        _alphaSlider.minimumValue = 0.0;
        _alphaSlider.maximumValue = 1.0;
        [_alphaSlider addTarget:self action:@selector(alphaSliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _alphaSlider;
}


- (UILabel *)allowOverflowLabel {
    if (!_allowOverflowLabel) {
        _allowOverflowLabel = [[UILabel alloc] init];
        _allowOverflowLabel.textColor = [UIColor blackColor];
        _allowOverflowLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _allowOverflowLabel;
}


- (UILabel *)colorFillLabel {
    if (!_colorFillLabel) {
        _colorFillLabel = [[UILabel alloc] init];
        _colorFillLabel.textColor = [UIColor blackColor];
        _colorFillLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _colorFillLabel;
}



- (void)dealloc {
    NSLog(@"%@ has been released",self.class);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
