//
//  ViewController.m
//  ScrollabeSliderExample
//
//  Created by Jai Chaudhry on 20/08/17.
//  Copyright © 2017 jc. All rights reserved.
//

#import "ViewController.h"

#import <ScrollableSlider/JCScrollableSlider.h>

@interface ViewController () <JCScrollableSliderDelegate>

@property (nonatomic, strong) JCScrollableSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JCScrollableSliderConfig *sliderConfig = [[JCScrollableSliderConfig alloc] init];
    sliderConfig.minValue = -8;
    sliderConfig.maxValue = 8;
    sliderConfig.tickWidth = 2;
    sliderConfig.tickDistance = 40;
    sliderConfig.offset = 230;
    sliderConfig.tickColor = [UIColor blackColor];
    
    _slider = [[JCScrollableSlider alloc] initWithSliderConfig:sliderConfig];
    _slider.frame = CGRectMake(0, self.view.center.y, self.view.frame.size.width, 44);
    _slider.delegate = self;
    [self.view addSubview:_slider];
}

- (void)scrollableSlider:(JCScrollableSlider *)slider didSelectValue:(CGFloat)value {
    NSLog(@"value %f",value);
}

@end
