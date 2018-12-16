//
//  ViewController.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "FLRadarChartView.h"
#import "FLRadarChartModel.h"

@interface ViewController ()

@property (nonatomic, strong) FLRadarChartView *radarChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(test_changeDate)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.view addSubview:self.radarChartView];
    [_radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0.0);
        make.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(self.radarChartView.mas_width);
    }];
    
    [self test_changeDate];
    
    
}


- (void)test_changeDate {
    FLRadarChartModel *model_1 = [[FLRadarChartModel alloc]init];
    model_1.name = @"啦啦啦学校平均能力";
    model_1.valueArray = [self p_getRandomNumber:6];
    model_1.strokeColor = [self fl_colorWithHexString:@"00A8FF"];
    model_1.fillColor = [self fl_colorWithHexString:@"00A8FF" alpha:0.8];

    FLRadarChartModel *model_2 = [[FLRadarChartModel alloc]init];
    model_2.name = @"啦啦啦学生个人能力";
    model_2.valueArray = [self p_getRandomNumber:6];
    model_2.strokeColor = [self fl_colorWithHexString:@"FED700"];
    model_2.fillColor = [self fl_colorWithHexString:@"FED700" alpha:0.8];

    FLRadarChartModel *model_3 = [[FLRadarChartModel alloc]init];
    model_3.name = @"啦啦啦啦屌丝能力";
    model_3.valueArray = [self p_getRandomNumber:6];
    model_3.strokeColor = [self fl_colorWithHexString:@"FFC0CB"];
    model_3.fillColor = [self fl_colorWithHexString:@"FFC0CB" alpha:0.8];
    
    FLRadarChartModel *model_4 = [[FLRadarChartModel alloc]init];
    model_4.name = @"好嗨呦~";
    model_4.valueArray = [self p_getRandomNumber:6];
    model_4.strokeColor = [self fl_colorWithHexString:@"DCDCDC"];
    model_4.fillColor = [self fl_colorWithHexString:@"DCDCDC" alpha:0.8];
    
    self.radarChartView.classifyDataArray = @[@"Objective-C",@"Swift",@"Python",@"Java",@"C",@"C++"];
    self.radarChartView.dataArray = @[model_1, model_2, model_3, model_4];
    [self.radarChartView fl_redrawRadarChart];
}



- (NSArray *)p_getRandomNumber:(NSInteger)count {
    NSMutableArray *numberArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        //修改随机数可以查看溢出数据
        NSInteger randomNumber = arc4random() % 101;
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

@end
