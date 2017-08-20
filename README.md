# ScrollableSlider

This can be used to create a scrollable slider which indicates the current values just like a Scale i.e. representing the values using ticks. 

# Install

Just add the following line to your podfile.

`pod 'ScrollabeSlider'`

# Add it in your project easily

First import the scrollable slider in your project.

```objc
#import <ScrollableSlider/JCScrollableSlider.h>
```
Then configure it as follow

```objc
// Initialize the slider config first. The minimum and maximum are required values for the slider to be setup properly. You can check other customizable properties available in JCScrollableSliderConfig.
JCScrollableSliderConfig *sliderConfig = [[JCScrollableSliderConfig alloc] init];
sliderConfig.minValue = -4;
sliderConfig.maxValue = 4;

// Initialize the slider with above created configuration.
JCScrollableSlider *slider = [[JCScrollableSlider alloc] initWithSliderConfig:sliderConfig];
// Add the frame for your slider
slider.frame = CGRectMake(0, 0, 375, 50);
// Add it to your controller 
[self.view addSubview:slider];
```

You can also set the delegate for the slider to look for the changes happening to the values of slider. Your class would need to follow JCScrollableSliderDelegate protocol

```objc
slider.delegate = self
```

Now you can implement the following methods in your project

```objc
- (void)scrollableSlider:(JCScrollableSlider *)slider didSelectValue:(CGFloat)value {
    // Use this method to look for the updated values on scroll of slider.
}

- (void)scrollableSliderDidStopUpdating:(JCScrollableSlider *)slider {
    // Use this method to know when the slider stops updating.
}

- (void)scrollableSliderDidStartUpdating:(JCScrollableSlider *)slider {
    // Use this method to know when the slider starts updating values.
}
```

# Preview
Your slider would look something like following after integration.

![](http://www.imageno.com/thumbs/20170820/801b85u6i8vg.jpg)
