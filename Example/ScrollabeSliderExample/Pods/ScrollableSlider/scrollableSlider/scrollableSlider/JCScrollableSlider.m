//
//  JCScrollableSlider.m
//  scrollableSlider
//
//  Created by Jai Chaudhry on 20/08/17.
//  Copyright © 2017 jc. All rights reserved.
//

#import "JCScrollableSlider.h"

static NSString * const kReusableIdentifier = @"JCSliderResuableIdentifier";
static CGFloat const kIndicatorDimension = 10;

@implementation JCScrollableSliderConfig

- (instancetype)init {
    if (self = [super init]) {
        self.minValue = 0;
        self.maxValue = 0;
        self.tickWidth = 2;
        self.tickDistance = 30;
        self.tickColor = [UIColor whiteColor];
        self.offset = 0;
        self.indicatorImage = [UIImage imageNamed:@"indicator"];
    }
    return self;
}

@end

@interface JCScrollableSlider () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *sliderCollectionView;
@property (nonatomic, strong) JCScrollableSliderConfig *config;
@property (nonatomic, assign) CGFloat lastUpdatedValue;
@property (nonatomic, assign) BOOL needsUpdating;
@property (nonatomic, strong) UIImageView *indicatorImageView;

@end

@implementation JCScrollableSlider

- (instancetype)initWithSliderConfig:(JCScrollableSliderConfig *)config {
    if (self = [super init]) {
        _config = config;
        [self p_initSubviews];
    }
    return self;
}

- (void)setCurrentValue:(CGFloat)currentValue {
    _lastUpdatedValue = currentValue;
    _needsUpdating = YES;
    [_sliderCollectionView layoutIfNeeded];
}

- (void)updateWithConfig:(JCScrollableSliderConfig *)config {
    _config = config;
    [self layoutIfNeeded];
    [_sliderCollectionView reloadData];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize viewSize = self.bounds.size;
    
    CGFloat xOffset = _config.offset > 0 ? _config.offset - kIndicatorDimension/2 : (viewSize.width - kIndicatorDimension)/2;
    _indicatorImageView.frame = CGRectMake(xOffset, 0, kIndicatorDimension, kIndicatorDimension);
    _sliderCollectionView.frame = CGRectMake(0, kIndicatorDimension, viewSize.width, viewSize.height - kIndicatorDimension);
    CGFloat offset = _config.offset > 0 ? _config.offset : self.bounds.size.width/2;
    _sliderCollectionView.contentInset = UIEdgeInsetsMake(0, offset, 0, viewSize.width - offset);
    if (_needsUpdating) {
        CGFloat offset = (_lastUpdatedValue - _config.minValue)*(_config.tickWidth + _config.tickDistance);
        [_sliderCollectionView setContentOffset:CGPointMake(offset - _sliderCollectionView.contentInset.left, _sliderCollectionView.contentOffset.y)];
        _needsUpdating = NO;
    }
}

#pragma mark - UICollectionViewDataSource methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _config.tickColor;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _config.maxValue - _config.minValue + 1;
}

#pragma mark - UICollectionViewDelegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_config.tickWidth, self.frame.size.height - kIndicatorDimension);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self p_updateValueWithScrollView:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(scrollableSliderDidStartUpdating:)]) {
        [_delegate scrollableSliderDidStartUpdating:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(scrollableSliderDidStopUpdating:)]) {
        [_delegate scrollableSliderDidStopUpdating:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if ([_delegate respondsToSelector:@selector(scrollableSliderDidStopUpdating:)]) {
            [_delegate scrollableSliderDidStopUpdating:self];
        }
    }
}

#pragma mark - Methods

- (void)p_updateValueWithScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width == 0) {
        return;
    }
    CGFloat percentCovered = (scrollView.contentInset.left + scrollView.contentOffset.x)/(scrollView.contentSize.width);
    CGFloat requiredValue = _config.minValue + ((_config.maxValue - _config.minValue) * percentCovered);
    if (requiredValue < _config.minValue) {
        requiredValue = _config.minValue;
    } else if (requiredValue > _config.maxValue) {
        requiredValue = _config.maxValue;
    }
    
    // No need to call the delegate method, if the updated value is same as before.
    if ([self.delegate respondsToSelector:@selector(scrollableSlider:didSelectValue:)] && _lastUpdatedValue != requiredValue) {
        [self.delegate scrollableSlider:self didSelectValue:requiredValue];
        _lastUpdatedValue = requiredValue;
    }
}

- (void)p_initSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = _config.tickDistance;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _sliderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _sliderCollectionView.backgroundColor = [UIColor clearColor];
    _sliderCollectionView.delegate = self;
    _sliderCollectionView.dataSource = self;
    _sliderCollectionView.showsVerticalScrollIndicator = NO;
    _sliderCollectionView.showsHorizontalScrollIndicator = NO;
    [_sliderCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReusableIdentifier];
    [self addSubview:_sliderCollectionView];
    
    _indicatorImageView = [[UIImageView alloc] initWithImage:_config.indicatorImage];
    _indicatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_indicatorImageView];
}

@end
