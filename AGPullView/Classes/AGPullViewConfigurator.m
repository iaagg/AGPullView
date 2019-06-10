//
//
//  AGPullView
//
//  Created by Alexey Getman on 11/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#import "AGPullViewConfigurator.h"
#import "AGListViewAnimationButton.h"
#import "AGPullMarginView.h"
#import "AGPullView.h"

//Size values
#define INITIAL_HEIGHT              50
#define MINIMUM_HEIGHT              50
#define MINIMUM_ORIGIN_Y            [self p_minimumOrigin]
#define DRAG_MARGIN_HEIGHT          20
#define MAXIMUM_ORIGIN_Y            self.superview.frame.size.height - MINIMUM_HEIGHT
#define MAXIMUM_HEIGHT              self.superview.frame.size.height - MINIMUM_ORIGIN_Y

//Colors
#define WHITE_COLOR                 [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]
#define WHITE_TRANSPARENT_COLOR     [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.5]
#define GRAY_COLOR                  [UIColor colorWithRed:192./255. green:192./255. blue:192./255. alpha:1.0]
#define GRAY_TRANSPARENT_COLOR      [UIColor colorWithRed:192./255. green:192./255. blue:192./255. alpha:0.5]
#define DARK_GRAY_COLOR             [UIColor colorWithRed:43./255. green:43./255. blue:43./255. alpha:1.0]
#define DARK_TRANSPARENT_GRAY_COLOR [UIColor colorWithRed:43./255. green:43./255. blue:43./255. alpha:0.5]

//iOS version checking
#define IOS_8PLUS ([[UIDevice currentDevice].systemVersion intValue] >= 8)

//Observed values
#define SHOWING_WITH_TOUCH @"enableShowingWithTouch"
#define HIDING_WITH_TOUCH  @"enableHidingWithTouch"
#define COLOR_SCHEME_TYPE  @"colorSchemeType"
#define BLUR_EFFECT        @"blurStyle"

typedef enum {
    DRAGGING,
    SHOWN,
    HIDDEN
} ViewState;

static NSString *const AGDirectInitEnabledFlag = @"kAGPullViewConfiguratorDirectInitEnabled";
static NSString *const AGDirectInitExeptionMessage = @"You shold use \"configurator\" singleton instead of direct initialization";

@interface AGPullViewConfigurator ()

@property (strong, nonatomic) AGPullView                            *pullView;
@property (weak, nonatomic) UIView                                  *superview;
@property (strong, nonatomic) UIVisualEffectView                    *blurEffectView;
@property (nonatomic, assign) ViewState                             viewState;
@property (nonatomic, assign) CGFloat                               closedConst;
@property (nonatomic, assign) CGFloat                               openedConst;
@property (strong, nonatomic) NSLayoutConstraint                    *heightConst;
@property (strong, nonatomic) NSLayoutConstraint                    *toTopConst;
@property (strong, nonatomic, readwrite, getter=contentView) UIView *contentView;
@property (assign, nonatomic, getter=animDuration) float            animDuration;
@property (assign, nonatomic, getter=needBounceEff) BOOL            needBounceEff;


@end

@implementation AGPullViewConfigurator {
    ViewState               _lastViewState;
    CGFloat                 oldY;
    BOOL                    dragging;
    AGListViewAnimationButton *upperButton;
    AGListViewAnimationButton *bottomButton;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:SHOWING_WITH_TOUCH options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.enableShowingWithTouch = true;
        
        [self addObserver:self forKeyPath:HIDING_WITH_TOUCH options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.enableHidingWithTouch = true;
        
        [self addObserver:self forKeyPath:COLOR_SCHEME_TYPE options:NSKeyValueObservingOptionNew context:nil];
        self.colorSchemeType = ColorSchemeTypeWhite;
        
        [self addObserver:self forKeyPath:BLUR_EFFECT options:NSKeyValueObservingOptionNew context:nil];
        
        self.needBounceEffect = false;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:HIDING_WITH_TOUCH];
    [self removeObserver:self forKeyPath:SHOWING_WITH_TOUCH];
    [self removeObserver:self forKeyPath:COLOR_SCHEME_TYPE];
    [self removeObserver:self forKeyPath:BLUR_EFFECT];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:SHOWING_WITH_TOUCH]) {
        BOOL newValue = [change[@"new"] boolValue];
        BOOL oldValue = [change[@"old"] boolValue];
        
        if (!self.superview) {
            return;
        }
        
        if (newValue && !oldValue) {
            [self p_setupTouchButtons];
        } else if (!newValue && oldValue) {
            [bottomButton removeFromSuperview];
            bottomButton = nil;
        }
        
        return;
        
    } else if ([keyPath isEqualToString:HIDING_WITH_TOUCH]) {
        BOOL newValue = [change[@"new"] boolValue];
        BOOL oldValue = [change[@"old"] boolValue];
        
        if (!self.superview) {
            return;
        }
        
        if (newValue && !oldValue) {
            [self p_setupTouchButtons];
        } else if (!newValue && oldValue) {
            [upperButton removeFromSuperview];
            upperButton = nil;
        }
        
        return;
        
    } else if ([keyPath isEqualToString:COLOR_SCHEME_TYPE]) {
        PullViewColorSchemeType newValue = [change[@"new"] intValue];
        [self p_switchColorSchemeType:newValue];
        return;
        
    } else if ([keyPath isEqualToString:BLUR_EFFECT]) {
        [self p_changeBlurEffect];
    }
    
}

- (void)fullfillContentViewWithView:(UIView *)view {
    if (self.contentView) {
        
        for (UIView *subview in self.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        [self.contentView addSubview:view];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    }
}

- (CGFloat)p_minimumOrigin {
    if (self.superview && self.percentOfFilling) {
        CGFloat minOrigin = 40.;
        CGFloat maxOrigin = self.superview.bounds.size.height - 50.;
        CGFloat range = maxOrigin - minOrigin;
        
        CGFloat percent = [self.percentOfFilling floatValue] > 100. ? 1. : [self.percentOfFilling floatValue] / 100.;
        percent = percent < 0? 0 : percent;
        
        CGFloat filledAdditionalSpace = range * percent;
        
        
        minOrigin = minOrigin + (range - filledAdditionalSpace);
        return minOrigin;
    } else {
        return 40.;
    }
}

- (float)animDuration {
    float dur;
    
    if (!self.animationDuration) {
        dur = 0.3;
        return dur;
    }
    
    if ([self.animationDuration floatValue] > 0) {
        dur = [self.animationDuration floatValue] > 1. ? 1. : [self.animationDuration floatValue];
    } else  if ([self.animationDuration floatValue] == 0){
        dur = 0;
    } else {
        dur = 0.3;
    }
    
    return dur;
}

- (BOOL)needBounceEff {
    BOOL need = self.needBounceEffect ? true : false;
    
    return need;
}

- (UIView * _Nullable)contentView {
    return self.pullView.contentView;
}

- (CGFloat)closedConst {
    return INITIAL_HEIGHT;
}

- (CGFloat)openedConst {
    return self.superview.bounds.size.height - MINIMUM_ORIGIN_Y;
}

#pragma mark Setting up

- (void)setupPullViewForSuperview:(UIView *)superview colorScheme:(PullViewColorSchemeType)scheme {
    self.colorSchemeType = scheme;
    [self setupPullViewForSuperview:superview];
}

- (void)setupPullViewForSuperview:(UIView *)superview {
    
    self.superview = superview;
    
    self.pullView = [[AGPullView alloc] initWithFrame:CGRectZero];
    [self p_setupBlurEffect];
    [self p_turnOffBlurEffect];
    [self.pullView performSelector:@selector(p_setupSubviews)];
    [self.superview addSubview:self.pullView];
    self.pullView.backgroundColor = [UIColor clearColor];
    
    //setup shadow
    self.pullView.layer.masksToBounds = NO;
    self.pullView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pullView.layer.shadowOffset = CGSizeMake(0, -2.5);
    self.pullView.layer.shadowRadius = 3;
    self.pullView.layer.shadowOpacity = 0.2;
    
    //Default isShown state settting
    self.viewState = HIDDEN;
    
    [self p_configurePullView];
}

- (void)p_configurePullView {
    
    if (!self.heightConst) {
        
        //Adding ListView constraints
        self.heightConst = [NSLayoutConstraint constraintWithItem:self.pullView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.closedConst];
        self.heightConst.priority = 750.; //High while closed
        
        self.toTopConst = [NSLayoutConstraint constraintWithItem:self.pullView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:MAXIMUM_ORIGIN_Y];
        self.toTopConst.priority = 250.; //Low while closed
        
        NSLayoutConstraint *bottomConst = [NSLayoutConstraint constraintWithItem:self.pullView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *leftConst = [NSLayoutConstraint constraintWithItem:self.pullView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *rightConst = [NSLayoutConstraint constraintWithItem:self.pullView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        [self.superview addConstraints:@[self.heightConst, self.toTopConst, bottomConst, leftConst, rightConst]];
    }
    
    //setup buttons for animations launching
    if (!upperButton && !bottomButton && self.enableShowingWithTouch && self.enableHidingWithTouch) {
        
        [self p_setupTouchButtons];
    }
    
    [self p_switchColorSchemeType:self.colorSchemeType];
    
    [self.pullView layoutIfNeeded];
    [self.pullView layoutSubviews];
}

- (void)p_setupTouchButtons {
    upperButton = [[AGListViewAnimationButton alloc] initWithFrame:CGRectZero];
    upperButton.translatesAutoresizingMaskIntoConstraints = NO;
    [upperButton addTarget:self action:@selector(p_hideButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    upperButton.userInteractionEnabled = true;
    upperButton.hidden = true;
    
    bottomButton = [[AGListViewAnimationButton alloc] initWithFrame:CGRectZero];
    bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomButton addTarget:self action:@selector(p_showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.userInteractionEnabled = true;
    bottomButton.hidden = false;
    [self.superview addSubview:bottomButton];
    [self.superview addSubview:upperButton];
    
    
    //Adding buttons cnstraints
    NSDictionary *views = NSDictionaryOfVariableBindings(upperButton, bottomButton, _pullView);
    NSDictionary *metrics = @{@"upperButtonHeight": @(MINIMUM_ORIGIN_Y + DRAG_MARGIN_HEIGHT), @"bottomButtonHeight": @(INITIAL_HEIGHT)};
    
    [self.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperButton]-[_pullView]" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upperButton]|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomButton(bottomButtonHeight)]|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomButton]|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
}

- (void)p_switchColorSchemeType:(PullViewColorSchemeType)type {
    
    switch (type) {
        case ColorSchemeTypeClear:
            self.pullView.pullMarginView.backgroundColor = [UIColor clearColor];
            self.pullView.contentView.backgroundColor = [UIColor clearColor];
            break;
        case ColorSchemeTypeWhite:
            self.pullView.pullMarginView.backgroundColor = WHITE_COLOR;
            self.pullView.contentView.backgroundColor = WHITE_COLOR;
            break;
        case ColorSchemeTypeGray:
            self.pullView.pullMarginView.backgroundColor = GRAY_COLOR;
            self.pullView.contentView.backgroundColor = GRAY_COLOR;
            break;
        case ColorSchemeTypeDark:
            self.pullView.pullMarginView.backgroundColor = DARK_GRAY_COLOR;
            self.pullView.contentView.backgroundColor = DARK_GRAY_COLOR;
            break;
        case ColorSchemeTypeWhiteTransparent:
            self.pullView.pullMarginView.backgroundColor = WHITE_TRANSPARENT_COLOR;
            self.pullView.contentView.backgroundColor = WHITE_TRANSPARENT_COLOR;
            break;
        case ColorSchemeTypeGrayTransparent:
            self.pullView.pullMarginView.backgroundColor = GRAY_TRANSPARENT_COLOR;
            self.pullView.contentView.backgroundColor = GRAY_TRANSPARENT_COLOR;
            break;
        case ColorSchemeTypeDarkTransparent:
            self.pullView.pullMarginView.backgroundColor = DARK_TRANSPARENT_GRAY_COLOR;
            self.pullView.contentView.backgroundColor = DARK_TRANSPARENT_GRAY_COLOR;
            break;
        default:
            break;
    }
}

- (void)enableBlurEffectWithBlurStyle:(UIBlurEffectStyle)style {
    self.blurStyle = style;
    [self p_turnOnBlurEffect];
}

- (void)undoBlurEffect {
    [self p_turnOffBlurEffect];
}

- (void)p_setupBlurEffect {
    if (!UIAccessibilityIsReduceTransparencyEnabled() &&
        IOS_8PLUS) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];
        
        if (!self.blurEffectView) {
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurEffectView.frame = CGRectZero;
            self.blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.pullView addSubview:self.blurEffectView];
            
            [self.pullView addConstraint:[NSLayoutConstraint constraintWithItem:_blurEffectView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_pullView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0]];
            
            [self.pullView addConstraint:[NSLayoutConstraint constraintWithItem:_blurEffectView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_pullView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:0]];
            
            [self.pullView addConstraint:[NSLayoutConstraint constraintWithItem:_blurEffectView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_pullView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1
                                                                       constant:0]];
            
            [self.pullView addConstraint:[NSLayoutConstraint constraintWithItem:_blurEffectView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_pullView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:0]];
        }
    }
}

- (void)p_turnOnBlurEffect {
    if (IOS_8PLUS) {
        if (self.blurEffectView) {
            self.blurEffectView.hidden = false;
        }
    }
}

- (void)p_turnOffBlurEffect {
    if (IOS_8PLUS) {
        if (self.blurEffectView) {
            self.blurEffectView.hidden = true;
        }
    }
}

- (void)p_changeBlurEffect {
    if (IOS_8PLUS) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];
        
        if (self.blurEffectView) {
            self.blurEffectView.effect = blurEffect;
        }
    }
}

#pragma mark - Button Actions

- (void)p_hideButtonTouched:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTouchToHidePullView:)]) {
        [self.delegate didTouchToHidePullView:self.pullView];
    }
    
    [self hideAnimated:true];
}

- (void)p_showButtonTouched:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTouchToShowPullView:)]) {
        [self.delegate didTouchToShowPullView:self.pullView];
    }
    
    [self showAnimated:true];
}

#pragma mark - Animations
//Hides self with animation
- (void)hideAnimated:(BOOL)animated {
    
    if (animated) {
        
        float bounce = self.needBounceEff ? 0.7 : 1.;
        
        [UIView animateWithDuration:self.animDuration
                              delay:0.
             usingSpringWithDamping:bounce
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             self.heightConst.priority = 750.; //High while closed
                             self.heightConst.constant = self.closedConst;
                             
                             self.toTopConst.priority = 250.;  //Low while closed
                             self.toTopConst.constant = MAXIMUM_ORIGIN_Y;
                             
                             [self.superview layoutIfNeeded];
                             
                             
                         } completion:^(BOOL finished) {
                             
                             self.viewState = HIDDEN;
                             
                             if ([self.delegate respondsToSelector:@selector(didHidePullView:)]) {
                                 [self.delegate didHidePullView:self.pullView];
                             }
                             
                             [self p_switchButtons];
                             
                         }];
        
    } else {
        [self p_setupToHiddenState];
    }
}

//Opens self with animation
- (void)showAnimated:(BOOL)animated {
    [self p_showAnimated:animated completionAction:nil];
}

- (void)p_showAnimated:(BOOL)animated completionAction:(void(^)(void))completionAction {
    if (animated) {
        float bounce = self.needBounceEff ? 0.7 : 1.;

        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:self.animDuration
                                  delay:0.
                 usingSpringWithDamping:bounce
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{

                                 self.heightConst.priority = 250.; //Low while opened
                                 self.heightConst.constant = self.openedConst;

                                 self.toTopConst.priority = 750.; //High while opened
                                 self.toTopConst.constant = MINIMUM_ORIGIN_Y;

                                 [self.superview layoutIfNeeded];

                             } completion:^(BOOL finished) {

                                 self.viewState = SHOWN;

                                 if ([self.delegate respondsToSelector:@selector(didShowPullView:)]) {
                                     [self.delegate didShowPullView:self.pullView];
                                 }

                                 [self p_switchButtons];

                                 if (completionAction) {
                                     completionAction();
                                 }

                             }];
        });
    } else {
        [self p_setupToShownState];
    }
}

- (void)showAnimated:(BOOL)animated forPercent:(NSInteger)percent {
    NSNumber *savedPrecent = [self.percentOfFilling copy];
    percent = percent > 0 ? percent : 0;
    percent = percent < 100 ? percent : 100;
    CGFloat multiplier = percent / 100.;
    NSNumber *tmpPercent = @([self.percentOfFilling floatValue] * multiplier);
    self.percentOfFilling = tmpPercent;
    __weak typeof(self) welf = self;
    
    [self p_showAnimated:animated completionAction:^{
        welf.percentOfFilling = savedPrecent;
    }];
}
- (void)p_switchButtons {
    if (self.viewState == HIDDEN) {
        upperButton.hidden = true;
        bottomButton.hidden = false;
    } else if (self.viewState == SHOWN) {
        upperButton.hidden = false;
        bottomButton.hidden = true;
    }
}

- (void)p_setupToShownState {
    self.heightConst.priority = 250.; //Low while opened
    self.heightConst.constant = self.openedConst;
    self.toTopConst.priority = 750.; //High while opened
    self.toTopConst.constant = MINIMUM_ORIGIN_Y;
    
    if (self.viewState != SHOWN) {
        
        if ([self.delegate respondsToSelector:@selector(didShowPullView:)]) {
            [self.delegate didShowPullView:self.pullView];
        }
    }
    
    self.viewState = SHOWN;
    [self p_switchButtons];
}

- (void)p_setupToHiddenState {
    self.heightConst.priority = 750.; //High while closed
    self.heightConst.constant = self.closedConst;
    self.toTopConst.priority = 250.;  //Low while closed
    self.toTopConst.constant = MAXIMUM_ORIGIN_Y;
    
    if (self.viewState != HIDDEN) {
        
        if ([self.delegate respondsToSelector:@selector(didHidePullView:)]) {
            [self.delegate didHidePullView:self.pullView];
        }
    }
    
    self.viewState = HIDDEN;
    [self p_switchButtons];
}

#pragma mark - Messages from controller

- (void)handleTouchesBegan:(NSSet<UITouch *> *)touches {
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchLocation = [touch locationInView:self.pullView];
    
    //Recognize touch on ImageView on top of List view
    switch (self.viewState) {
        case HIDDEN:
        {
            BOOL pulling = [[touch.view class] isSubclassOfClass:[AGListViewAnimationButton class]] ||
            [[touch.view class] isSubclassOfClass:[AGPullMarginView class]] ||
            [[[touch.view superview] class] isSubclassOfClass:[AGPullMarginView class]];
            
            if (pulling) {
                dragging = YES;
                oldY = touchLocation.y;
            }
            break;
        }
        case SHOWN:
        {
            BOOL pulling = [[touch.view class] isSubclassOfClass:[AGPullMarginView class]] ||
            [[[touch.view superview] class] isSubclassOfClass:[AGPullMarginView class]];
            
            if (pulling) {
                dragging = YES;
                oldY = touchLocation.y;
            }
            break;
        }
        default:
            break;
    }
}

- (void)handleTouchesEnded:(NSSet<UITouch *> *)touches {
    CGPoint point = [[[touches allObjects] lastObject] locationInView:self.superview];
    
    if (!dragging) {
        return;
    }
    
    CGFloat pointOfStep = self.superview.bounds.size.height - ((MAXIMUM_ORIGIN_Y - MINIMUM_ORIGIN_Y) / 2.);
    if (_lastViewState == SHOWN) {
        pointOfStep = self.superview.bounds.size.height - ((MAXIMUM_ORIGIN_Y - MINIMUM_ORIGIN_Y) / 1.0);
    } else if (_lastViewState == HIDDEN) {
        pointOfStep = self.superview.bounds.size.height - ((MAXIMUM_ORIGIN_Y - MINIMUM_ORIGIN_Y) / 4.0);
    }
    
    if (self.heightConst.constant == MAXIMUM_HEIGHT ||
        self.heightConst.constant == MINIMUM_HEIGHT) {
        return;
    }
    
    if (point.y > pointOfStep) {
        [self hideAnimated:true];
    } else {
        [self showAnimated:true];
    }
    
    dragging = NO;
}

- (void)handleTouchesMoved:(NSSet<UITouch *> *)touches {
    UITouch *touch = [[touches allObjects] lastObject];
    
    //Recognize touch on ImageView on top of List view
    BOOL pullingView = [[touch.view class] isSubclassOfClass:[AGListViewAnimationButton class]] ||
    [[touch.view class] isSubclassOfClass:[AGPullMarginView class]]            ||
    [[[touch.view superview] class] isSubclassOfClass:[AGPullMarginView class]];
    
    if (pullingView) {
        
        //User drags list view in the moment
        if (dragging) {
            CGPoint touchLocation = [touch locationInView:self.pullView];
            float deltaY = touchLocation.y - oldY;
            
            //Expected height constraint value
            CGFloat height = fabs(self.heightConst.constant + -deltaY);
            
            //Expected TopToTop constraint value
            CGFloat topConst = fabs(self.toTopConst.constant + deltaY);
            
            if (height > MAXIMUM_HEIGHT) {  //Blocks pulling view lower than maximum Y (hidden state)
                self.heightConst.constant = MAXIMUM_HEIGHT;
                self.toTopConst.constant = MINIMUM_ORIGIN_Y;
                [self p_setupToShownState];
            } else if (height < MINIMUM_HEIGHT) { //Blocks pulling view higher than minimum Y (shown state)
                self.heightConst.constant = MINIMUM_HEIGHT;
                self.toTopConst.constant = MAXIMUM_ORIGIN_Y;
                [self p_setupToHiddenState];
            } else {
                
                //Setup last view state before dragging began
                if (self.viewState != DRAGGING) {
                    _lastViewState = self.viewState;
                }
                
                self.viewState = DRAGGING;
                
                if ([self.delegate respondsToSelector:@selector(didDragPullView:withOpeningPercent:)]) {
                    [self.delegate didDragPullView:self.pullView
                                withOpeningPercent:[self countOpeningPercentWithHeight:height]];
                }
                
                //Just assign constraints new values
                self.heightConst.constant = height;
                self.toTopConst.constant = topConst;
            }
            
            // self.listView.frame = frame;
            [self.pullView layoutIfNeeded];
        }
    }
}

- (float)countOpeningPercentWithHeight:(CGFloat)height {
    CGFloat possibleRange = self.superview.bounds.size.height - MINIMUM_ORIGIN_Y - MINIMUM_HEIGHT;
    CGFloat currentChange = height - MINIMUM_HEIGHT;
    float percent = currentChange / possibleRange;
    return percent;
}

- (void)layoutPullView {
    [self.pullView layoutIfNeeded];
    [self.pullView layoutSubviews];
}

@end
