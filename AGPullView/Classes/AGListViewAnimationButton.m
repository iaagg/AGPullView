//
//
//  AGPullView
//
//  Created by Alexey Getman on 11/06/16.
//  Copyright © 2016 Alexey Getman. All rights reserved.
//

#import "AGListViewAnimationButton.h"

@implementation AGListViewAnimationButton {
    BOOL isMotionTouchDetected;
}

//Throw touches to ListViewManagers's controller ([self.superview nextResponder])

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    isMotionTouchDetected = false;
    [super touchesBegan:touches withEvent:event];
    [[self.superview nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (isMotionTouchDetected) {
        [[self.superview nextResponder] touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    isMotionTouchDetected = true;
    [[self.superview nextResponder] touchesMoved:touches withEvent:event];
}

@end
