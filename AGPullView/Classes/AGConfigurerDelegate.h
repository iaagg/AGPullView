//
//  Created by Alexey Getman on 12/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#ifndef AGConfigurerDelegate_h
#define AGConfigurerDelegate_h
@class AGPullView;

@protocol AGConfigurerDelegate <NSObject>

@optional

/*!
 * @discussion didShowPullView
 * @brief Called when AGPullView becomes shown
 * @param pullView - AGPullView
 */
- (void)didShowPullView:(AGPullView *)pullView;

/*!
 * @discussion didHidePullView
 * @brief Called when AGPullView becomes hidden
 * @param pullView - AGPullView
 */
- (void)didHidePullView:(AGPullView *)pullView;

/*!
 * @discussion didDrag
 * @brief Called when user is draging AGPulView in any direction (up/down)
 * @param pullView - AGPullView
 * @param openingPercent - value from 0 to 1 shows percent of opening AGPullView to it's max size
 */
- (void)didDragPullView:(AGPullView *)pullView withOpeningPercent:(float)openingPercent;

/*!
 * @discussion didTouchToShowPullView
 * @brief Called when user touched on AGPulView when it hidden to show it
 * @param pullView - AGPullView
 */
- (void)didTouchToShowPullView:(AGPullView *)pullView;

/*!
 * @discussion didTouchToHidePullView
 * @brief Called when user touched on AGPulView when it shown to hide it
 * @param pullView - AGPullView
 */
- (void)didTouchToHidePullView:(AGPullView *)pullView;
@end

#endif /* AGConfigurerDelegate_h */

