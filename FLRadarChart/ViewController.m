//
//  ViewController.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "FLDefaultRadarChartViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"雷达图";
    
    [self.view addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0.0);
    }];
    _titleLabel.text = @"轻触跳转";
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[FLDefaultRadarChartViewController new] animated:YES];
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

@end
