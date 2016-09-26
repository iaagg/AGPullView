# AGPullView

[![CI Status](http://img.shields.io/travis/Aleksey Getman/AGPullView.svg?style=flat)](https://travis-ci.org/Aleksey Getman/AGPullView)
[![Version](https://img.shields.io/cocoapods/v/AGPullView.svg?style=flat)](http://cocoapods.org/pods/AGPullView)
[![License](https://img.shields.io/cocoapods/l/AGPullView.svg?style=flat)](http://cocoapods.org/pods/AGPullView)
[![Platform](https://img.shields.io/cocoapods/p/AGPullView.svg?style=flat)](http://cocoapods.org/pods/AGPullView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0 +

## Installation

AGPullView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AGPullView"
```

#Demo

Short demo of AGPullView performance.


![Demo](https://s32.postimg.org/vgslyjjed/AGPull_View_demo.gif)

#Usage

First, import AGPullViewConfigurer

```ObjC
import "AGPullViewConfigurer.h"
```

##Initialization

Just use standart initialization
```ObjC
self.configurer = [AGPullViewConfigurer new];
```

Then setup AGPullView for your view like so (white preset color scheme - default):
```ObjC
[self.configurer setupPullViewForSuperview:self.view];
```

Or you can setup AGPullView with one of preset color schemes
```ObjC
[self.configurer setupPullViewForSuperview:self.view colorScheme:ColorSchemeTypeGrayTransparent];
```

Then you also should override several your superview's UIResponder methods with calling AGPullView methods there:
```ObjC
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurer handleTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurer handleTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurer handleTouchesEnded:touches];
}

```

Great! Now your AGPullView is ready for using!

##Settings

Use AGConfigurerDelegate methods for full control
```ObjC
self.configurer.delegate
```

You can fill AGPullView with your content by accessing property contentView like so:
```ObjC
self.configurer.contentView
```

There is also a convenient method for filling whole content view with your content (ex. UITableView). It will also create necessary constraints for you.
```ObjC
[self.configurer fullfillContentViewWithView:tableView];
```

You can turn on/off blur effect like so:

ON
```ObjC
[self.configurer enableBlurEffectWithBlurStyle:UIBlurEffectStyleLight];
```
OFF
```ObjC
[self.configurer undoBlurEffect];
```

Animation control is provided with these useful properties and methods:
```ObjC
self.configurer.enableShowingWithTouch = YES;
self.configurer.enableHidingWithTouch = YES;

[self.configurer hideAnimated:YES];
[self.configurer showAnimated:YES];
```

There is batch of useful settings for your AGPullView instance:
```ObjC
self.configurer.colorSchemeType

self.configurer.animationDuration

self.configurer.blurStyle

self.configurer.needBounceEffect

self.configurer.percentOfFilling
```

## Author

Aleksey Getman, getmanag@gmail.com

## License

AGPullView is available under the MIT license. See the LICENSE file for more info.
