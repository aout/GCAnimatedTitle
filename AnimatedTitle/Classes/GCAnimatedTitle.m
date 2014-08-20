//
//  GCAnimatedTitle.m
//  GCAnimatedTitle
//
//  Created by Guillaume CASTELLANA on 19/6/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GCAnimatedTitle.h"

@interface GCAnimatedTitle () <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray* titles;
@property (nonatomic, retain) NSArray* labels;
@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, retain) CAGradientLayer* maskLayer;

@end

@implementation GCAnimatedTitle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Initialization

- (void) setup
{
    UIScrollView* aScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    aScrollView.delegate = self;
    self.labels = [self addLabelsToScrollView:aScrollView];
    self.scrollView = aScrollView;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    [self addSubview:aScrollView];
    
    [self createOpacityLayer];
}

- (void) createOpacityLayer
{
    self.maskLayer = [CAGradientLayer new];
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    
    self.maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                             (__bridge id)outerColor,
                             (__bridge id)innerColor,
                             (__bridge id)innerColor,
                             (__bridge id)outerColor, nil];
    self.maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.1],
                                [NSNumber numberWithFloat:0.2],
                                [NSNumber numberWithFloat:0.8],
                                [NSNumber numberWithFloat:1.0], nil];
    
    [self.maskLayer setStartPoint:CGPointMake(0, 0.5)];
    [self.maskLayer setEndPoint:CGPointMake(1, 0.5)];
    
    self.maskLayer.bounds = CGRectMake(0, 0,
                                       self.frame.size.width,
                                       self.frame.size.height);
    self.maskLayer.anchorPoint = CGPointZero;
    
    self.layer.mask = self.maskLayer;
}

- (NSArray*) addLabelsToScrollView:(UIScrollView*)aScrollView
{
    NSMutableArray* labels = [NSMutableArray new];
    if (self.titles.count == 0) {
        aScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    } else {
        float frameWidth = self.frame.size.width;
        float frameHeight = self.frame.size.height;
        
        for (int i = 0; i < self.titles.count; ++i) {
            CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            UILabel* label = [[UILabel alloc] initWithFrame:frame];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = self.titles[i];
            label.font = [UIFont boldSystemFontOfSize:18];
            [label setTextColor:[UIColor whiteColor]];
            [label sizeToFit];
            // If it's the first label
            if (i == 0) {
                CGRect newFrame = CGRectMake(frameWidth / 2 - label.frame.size.width / 2,
                                             frameHeight/ 2 - label.frame.size.height / 2,
                                             label.frame.size.width,
                                             label.frame.size.height);
                label.frame = newFrame;
            }
            else {
                UILabel* previousLabel = labels[i - 1];
                float labelXPos = frameWidth / 2 + previousLabel.frame.size.width / 2 + previousLabel.frame.origin.x;
                CGRect newFrame = CGRectMake(labelXPos,
                                             frameHeight/ 2 - label.frame.size.height / 2,
                                             label.frame.size.width,
                                             label.frame.size.height);
                label.frame = newFrame;
            }
            [labels addObject:label];
            [aScrollView addSubview:label];
        }
        UILabel* lastLabel = [labels lastObject];
        aScrollView.contentSize = CGSizeMake(lastLabel.frame.origin.x + lastLabel.frame.size.width / 2 + frameWidth / 2,
                                             self.frame.size.height);
    }
    
    return labels;
}

- (void) removeLabelsFromScrollView:(UIScrollView*)aScrollView
{
    for (UILabel* label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = Nil;
}

- (void) updateLabelsOpacityForOffset:(float)xOffset
{
    float frameSize = self.frame.size.width;
    
    // Change label opacity according to scroll
    for (int i = 0; i < self.labels.count; ++i) {
        UILabel* label = self.labels[i];
        
        // Compute label opacity range
        CGFloat opacity = 0.f;
        float minOffset = -label.frame.size.width;
        float maxOffset = frameSize;
        
        CGPoint relativePos = [self convertPoint:label.bounds.origin fromView:label];
        float progress = (relativePos.x - minOffset) / fabsf(maxOffset - minOffset);
        
        if (relativePos.x > minOffset && relativePos.x < maxOffset) {
            opacity = cosf((progress + .5f) * 2 * M_PI) / 2.f + 0.5f;
        } else {
            opacity = 0.f;
        }
        
        [label setAlpha:opacity];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLabelsOpacityForOffset:scrollView.contentOffset.x];
}


#pragma mark - Public Interfaces

- (void) createLabelsFromTitles:(NSArray *)titles
{
    self.titles = titles;
    if (self.labels.count) {
        [self removeLabelsFromScrollView:self.scrollView];
    }
    self.labels = [self addLabelsToScrollView:self.scrollView];
}

- (void) scrollTo:(float)progress
{
    if (!self.labels.count) {
        return;
    }
    
    float step = 1 / ((float)self.labels.count - 1);
    int n = floor(progress / step);
    if (n < 0) {
        n = 0;
    } else if (n >= self.labels.count) {
        n = (int)self.labels.count - 1;
    }
    
    float start = 0.0f;
    float end = 0.0f;
    
    UILabel* firstLabel = self.labels[n];
    start = firstLabel.frame.origin.x + (firstLabel.frame.size.width / 2) - self.frame.size.width / 2;
    
    if (n == self.labels.count - 1) {
        end = start + self.frame.size.width / 2;
    } else {
        UILabel* secondLabel = self.labels[n + 1];
        end = secondLabel.frame.origin.x + (secondLabel.frame.size.width / 2) - self.frame.size.width / 2;
    }
    
    float nStart = n * step;
    float nEnd = (n + 1) * step;
    float newProgress = (progress - nStart) / (nEnd - nStart);
    float newScrollPos = interpolate(start, end, newProgress);
    
    self.scrollView.contentOffset = CGPointMake(newScrollPos, 0);
}

#pragma mark - C Helper

float interpolate(float min, float max, float t)
{
    return min + (max - min) * t;
}

@end
