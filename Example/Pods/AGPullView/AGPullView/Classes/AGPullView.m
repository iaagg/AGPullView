//
// 
//  AGPullView
//
//  Created by Alexey Getman on 11/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#import "AGPullView.h"
#import "AGPullMarginView.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger const kAGPullMarginHeight = 20;
static NSInteger const kAGPullMarginRoundedRectHeight = 10;
static NSInteger const kAGPullMarginRoundedRectWidth = 40;

@interface AGPullView ()

@property (strong, nonatomic, readwrite) UIView           *contentView;
@property (strong, nonatomic, readwrite) AGPullMarginView *pullMarginView;
@property (strong, nonatomic) UIView                      *roundedRectView;

@end

@implementation AGPullView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        self.opaque = NO;
    }

    return self;
}

- (void)p_setupSubviews {
    [self p_drawPullMarginView];
    [self p_drawContentView];
}

- (void)p_drawPullMarginView {
    self.pullMarginView = [[AGPullMarginView alloc] initWithFrame:CGRectZero];
    self.pullMarginView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pullMarginView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pullMarginView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:kAGPullMarginHeight]];
    
    self.roundedRectView = [[UIView alloc] initWithFrame:CGRectZero];
    self.roundedRectView.translatesAutoresizingMaskIntoConstraints = NO;
    self.roundedRectView.backgroundColor = [UIColor clearColor];
    [self.pullMarginView addSubview:self.roundedRectView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundedRectView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundedRectView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundedRectView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:kAGPullMarginRoundedRectHeight]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundedRectView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:kAGPullMarginRoundedRectWidth]];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                            0,
                                                                            kAGPullMarginRoundedRectWidth,
                                                                            kAGPullMarginRoundedRectHeight)
                                                    cornerRadius:5];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor clearColor].CGColor;
    self.roundedRectView.layer.mask = fillLayer;
    
    [self p_cutOutPullMarginRoundedRect];
}

- (void)p_cutOutPullMarginRoundedRect {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, self.pullMarginView.bounds);
    CGPathAddRoundedRect(path, nil, self.roundedRectView.frame, self.roundedRectView.frame.size.height / 2, self.roundedRectView.frame.size.height / 2);
    maskLayer.path = path;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.pullMarginView.layer.mask = maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self p_cutOutPullMarginRoundedRect];
}

- (void)p_drawContentView {
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pullMarginView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
}

@end
