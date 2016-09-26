//
//  AGConfigurerDelegate.h
//  AGPullView
//
//  Created by Alexey Getman on 12/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#ifndef AGConfigurerDelegate_h
#define AGConfigurerDelegate_h
@class AGPullView;

@protocol AGConfigurerDelegate <NSObject>

@optional
- (void)didShowPullView:(AGPullView *)pullView;
- (void)didHidePullView:(AGPullView *)pullView;
- (void)didDragPullView:(AGPullView *)pullView withOpeningPercent:(float)openingPercent;
- (void)didTouchToShowPullView:(AGPullView *)pullView;
- (void)didTouchToHidePullView:(AGPullView *)pullView;
@end

#endif /* AGConfigurerDelegate_h */
