# GDInspect

GDInspect is the runtime class/object inspecting category built on top of the NSObject class.

## Adding GDInspect to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add GDInspect to your project.

1. Add a pod entry for GDInspect to your Podfile `pod 'GDInspect'`
2. Install the pod(s) by running `pod install`.
3. Include GDInspect wherever you need it with `#import "NSObject+Inspect.h"`.

### Source files

Alternatively you can directly add the `NSObject+Inspect.h` and `NSObject+Inspect.m` source files to your project.

1. Download the [latest code version](https://github.com/GDXRepo/GDInspect/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `NSObject+Inspect.h` and `NSObject+Inspect.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include GDInspect wherever you need it with `#import "NSObject+Inspect.h"`.

## License

Apache. See `LICENSE` for details.
