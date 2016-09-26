//
//
//  AGPullView
//
//  Created by Alexey Getman on 11/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AGSettingsEnums.h"
#import "AGConfigurerDelegate.h"

@interface AGPullViewConfigurer : NSObject

/*!
 * @brief You can access to pull view's content view with this property
 */
@property (strong, nonatomic, readonly) UIView                               *contentView;

/*!
 * @brief You can setup one of several presets of drag margin appearences.
 */
@property (assign, nonatomic) PullViewColorSchemeType                        colorSchemeType;

/*!
 * @brief Shows if pull view needs ability to become shown with any touch beneath it. Default - YES
 */
@property (assign, nonatomic) BOOL                                           enableShowingWithTouch;

/*!
 * @brief Shows if pull view needs ability to become hidden with any touch above it. Default - YES
 */
@property (assign, nonatomic) BOOL                                           enableHidingWithTouch;

/*!
 * @brief Duration of show/hide animation shuld be in range 0.0 - 1.0. Default - 0.3
 */
@property (strong, nonatomic) NSNumber                                       *animationDuration;

/*!
 * @brief Style of blur effect. First enable with calling "enableBlurEffectWithBlurStyle:". Then you can change blur style dynamically
 */
@property (assign, nonatomic) UIBlurEffectStyle                              blurStyle;

/*!
 * @brief Shows if pull view need bounce effect in the end of show/hide animation. Default - NO
 */
@property (assign, nonatomic) BOOL                                           needBounceEffect;

/*!
 * @brief Delegate conforms to protocol <AGConfigurerDelegate>
 */
@property (strong, nonatomic) id <AGConfigurerDelegate>                      delegate;

/*!
 * @brief Default - 100 percent. Value should be from 0 to 100. Value with 0 will be equal to default minimum height.
 */
@property (strong, nonatomic) NSNumber                                       *percentOfFilling;

/*!
 * @brief Call to add pull view to your view as subview
 * @param superview An UIView to which you want to add pull view as subview
 * @warning your view's height should be at least 100pt
 */
- (void)setupPullViewForSuperview:(UIView *)superview;

/*!
 * @brief Call to add pull view to your view as subview
 * @param superview An UIView to which you want to add pull view as subview
 * @param pullMarginType One of several presets of drag margin appearences
 * @warning Your view's height should be at least 100pt
 */
- (void)setupPullViewForSuperview:(UIView *)superview colorScheme:(PullViewColorSchemeType)scheme;

/*!
 * @brief Call to fulfill whole pull view's content view with your view (for example UITableView). It will also add all constraints and remove all previous content view's subviews
 * @param view Your view which have to fullfill pull view's content view
 */
- (void)fullfillContentViewWithView:(UIView *)view;

/*!
 * @brief call to apply blur effect on pull view
 * @param style UIBlurEffectStyle enum value
 * @warning iOS 8 and higher
 */
- (void)enableBlurEffectWithBlurStyle:(UIBlurEffectStyle)style;

/*!
 * @brief call to undo blur effect which was set earlier on pull view
 */
- (void)undoBlurEffect;

/*!
 * @brief Call in touchesBegan method of superview to have an ability to drag pull view
 * @param touches Touches recieved in your view's touchesBegan method
 */
- (void)handleTouchesBegan:(NSSet<UITouch *> *)touches;

/*!
 * @brief Call in touchesEnded method of superview to have an ability to drag pull view
 * @warning Do not call this method if you don't want AGPullView to be automatically hidden/showed with animation when user will stop draging
 * @param touches Touches recieved in your view's touchesEnded method
 */
- (void)handleTouchesEnded:(NSSet<UITouch *> *)touches;

/*!
 * @brief Call in touchesMoved method of superview to have an ability to drag pull view
 * @param touches Touches recieved in your view's touchesMoved method
 */
- (void)handleTouchesMoved:(NSSet<UITouch *> *)touches;

/*!
 * @brief Call to hide pull view
 * @param animated Choose if hiding should be animated or not
 */
- (void)hideAnimated:(BOOL)animated;

/*!
 * @brief Call to show pull view
 * @param animated Choose if showing should be animated or not
 */
- (void)showAnimated:(BOOL)animated;


@end
