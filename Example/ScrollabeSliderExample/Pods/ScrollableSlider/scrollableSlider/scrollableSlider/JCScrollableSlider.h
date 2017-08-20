//
//  JCScrollableSlider.h
//  scrollableSlider
//
//  Created by Jai Chaudhry on 20/08/17.
//  Copyright © 2017 jc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCScrollableSliderDelegate;

@interface JCScrollableSliderConfig : NSObject

/**
 The minimum value representing the slider. This property is compulsary to be initialized for the slider to work. Default value is 0.
 */
@property (nonatomic, assign) CGFloat minValue;

/**
 The maximum value representing the slider. This property is compulsary to be initialized for the slider to work. Default value is 0.
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 The width of the ticks of slider. Default is 2 pixels.
 */
@property (nonatomic, assign) CGFloat tickWidth;

/**
 The distance between the ticks of slider. Default is 30 pixels.
 */
@property (nonatomic, assign) CGFloat tickDistance;

/**
 The color of the ticks. Default is [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *tickColor;

/**
 The offset from where the slider would start being visible. Default is half of the width of slider. 
 @note The indictor would be place at this offset, if it is set.
 */
@property (nonatomic, assign) CGFloat offset;

/**
 The indicator image used to indicate what the current value is. If not provided a default image would be used.
 */
@property (nonatomic, strong) UIImage *indicatorImage;


@end

@interface JCScrollableSlider : UIView

- (instancetype)initWithSliderConfig:(JCScrollableSliderConfig *)config;

/**
 This can be used to update the look and feel of slider.

 @param config The new configuration for the slider.
 */
- (void)updateWithConfig:(JCScrollableSliderConfig *)config;

@property (nonatomic, weak) id<JCScrollableSliderDelegate> delegate;

@end

@protocol JCScrollableSliderDelegate <NSObject>

/**
 Implement this delegate method to get the updated values as the slider moves.
 */
- (void)scrollableSlider:(JCScrollableSlider *)slider didSelectValue:(CGFloat)value;
@optional

/**
 Implement this method to know when the slider starts updating.
 */
- (void)scrollableSliderDidStartUpdating:(JCScrollableSlider *)slider;

/**
 Implement this method to know when the slider stops updating.
 */
- (void)scrollableSliderDidStopUpdating:(JCScrollableSlider *)slider;

@end
