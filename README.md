# AGPullView

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

# Demo

Short demo of AGPullView performance.


![Demo](https://s32.postimg.org/vgslyjjed/AGPull_View_demo.gif)


----------


# Usage

First, import AGPullViewConfigurator
For SWIFT - you should import AGPullViewConfigurator in bridging header first to use AGPullView

```ObjC
import "AGPullViewConfigurator.h"
```


----------


### Initialization

Just use standart initialization

*Objective-C*
```ObjC
self.configurator = [AGPullViewConfigurator new];
```
*SWIFT*
```Swift
let configurator = AGPullViewConfigurator()
```


----------


### Setting up
Then setup AGPullView for your view like so (white preset color scheme - default):

*Objective-C*
```ObjC
[self.configurator setupPullViewForSuperview:self.view];
```
*SWIFT*
```Swift
self.configurator.setupPullView(forSuperview: self.view)
```

Or you can setup AGPullView with one of preset color schemes

*Objective-C*
```ObjC
[self.configurator setupPullViewForSuperview:self.view colorScheme:ColorSchemeTypeGrayTransparent];
```
*SWIFT*
```Swift
self.configurator.setupPullView(forSuperview: self.view, colorScheme:ColorSchemeTypeDarkTransparent)
```

Then you also should override several your superview's UIResponder methods with calling AGPullView methods there:

*Objective-C*
```ObjC
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurator handleTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurator handleTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
[self.configurator handleTouchesEnded:touches];
}
```
*SWIFT*
```Swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
self.configurator.handleTouchesBegan(touches)
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
self.configurator.handleTouchesMoved(touches)
}

override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
self.configurator.handleTouchesEnded(touches)
}
```

Great! Now your AGPullView is ready for using!


----------


### Delegation

Use AGconfiguratorDelegate methods for full control
```ObjC
self.configurator.delegate
```


----------


### Customization
You can fill AGPullView with your content by accessing property contentView like so:
```ObjC
self.configurator.contentView
```

There is also a convenient method for filling whole content view with your content (ex. UITableView). It will also create necessary constraints for you.

*Objective-C*
```ObjC
[self.configurator fullfillContentViewWithView:tableView];
```
*SWIFT*
```Swift
self.configurator.fullfillContentView(with: table)
```

You can turn on/off blur effect like so: 

1) *ON*

*Objective-C*
```ObjC
[self.configurator enableBlurEffectWithBlurStyle:UIBlurEffectStyleLight];
```
*SWIFT*
```Swift
self.configurator.enableBlurEffect(withBlurStyle: .dark)
```
2) *OFF*

*Objective-C*
```ObjC
[self.configurator undoBlurEffect];
```
*SWIFT*
```Swift
self.configurator.undoBlurEffect()
```

Animation control is provided with these useful methods:

*Objective-C*
```ObjC
self.configurator.enableShowingWithTouch = YES;
self.configurator.enableHidingWithTouch = YES;

[self.configurator hideAnimated:YES];
[self.configurator showAnimated:YES];
```
*SWIFT*
```Swift
self.configurator.enableShowingWithTouch = true;
self.configurator.enableHidingWithTouch = true;

self.configurator.hide(animated: true)
self.configurator.hide(animated: true)
```

There is batch of useful settings for your AGPullView instance:
```ObjC
self.configurator.colorSchemeType

self.configurator.animationDuration

self.configurator.blurStyle

self.configurator.needBounceEffect

self.configurator.percentOfFilling
```

AGPullView uses KVO, so some performance can be changed in runtime with theese properties
```ObjC
self.configurator.enableShowingWithTouch
self.configurator.enableHidingWithTouch
self.configurator.blurStyle
self.configurator.colorSchemeType
```


----------


And here is a demo of random changing properties 'blurStyle' and 'colorSchemeType'

![Demo](https://media.giphy.com/media/2AmsmlYktMzFS/giphy.gif)

## Author

Aleksey Getman, getmanag@gmail.com

## License

AGPullView is available under the MIT license. See the LICENSE file for more info.
