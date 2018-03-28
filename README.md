# RFInitializing

[![Build Status](https://travis-ci.org/RFUI/RFInitializing.svg?branch=master)](https://travis-ci.org/RFUI/RFInitializing)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/RFInitializing.svg)
[![Platform](https://img.shields.io/cocoapods/p/RFInitializing.svg?style=flat)](http://cocoadocs.org/docsets/RFInitializing)

By using RFInitializing, object initialization becomes easier.

Let's compare it with an example.

In root class:

<table>
<tr><th>Before</th><th>After</th></tr>
<tr><td>

```objective-c
@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    // do something
}

@end
```

</td><td>

```objective-c
@implementation BaseView
RFInitializingRootForUIView

- (void)onInit {
    // do the common setup
}

- (void)afterInit {
    // do somthing after the inistance
    // has been initialized
}

@end
```

</td></tr>
</table>

In subclass:

<table>
<tr><th>Before</th><th>After</th></tr>
<tr><td>

```objective-c
@implementation FooView

- (instancetype)initWithBar:(Bar)bar {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonSetupForSubclasss];
        _bar = bar;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetupForSubclasss];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetupForSubclasss];
    }
    return self;
}

- (void)commonSetupForSubclasss {
    // do something
}

@end
```

</td><td>

```objective-c
@implementation FooView

- (instancetype)initWithBar:(Bar)bar {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _bar = bar;
    }
    return self;
}

- (void)onInit {
    [super onInit];
    // common setup for subclasss
}

@end
```

</td></tr>
</table>

## Purpose

It´s boring to write the init method again and again, especially there are many init mehods to overwrite. For example, if you want subclass UIView, you may overwrite ini, initWithFrame:, initWithColder:. And if you want subclass that class you also should overwrite these methods again, WTF.

It´s time to end these meaningless repetition. By conforms to `RFInitializing`, you can only write these init method in root class once, then in subclass you can only implement `onInit` and `afterInit`, no more init.

Attention, if a class conforms to RFInitializing, `onInit` should be called during init and before init method return. But `afterInit` should called after the method finished which init was called in it usually. eg:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    // RFButton conforms to RFInitializing.
    RFButton *button = [[RFButton alloc] init];
    // `onInit` was called before here.

    // Do some config.
    button.icon = [UIImage imageNamed:@"pic"];

    // Any other code.
    // `afterInit` won't be called in this scope.
}
// `afterInit` will be called after viewDidLoad executed in this example.
```

## Usage

You should only call `onInit` and `afterInit` in root object which conforms to this protocol. And `afterInit` must be delayed. Here is a example:

```objective-c
- (id)init {
    self = [super init];
    if (self) {
        [self onInit];
        // Delay execute afterInit, you can also use GCD.
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}
```

In subclass, you must not call these method in init method. You may implemente onInit or afterInit for customize. And you should call super at some point in your implementation if you override onInit or afterInit. eg:

```objective-c
// If you had to add another init method.
- (instancetype)initWithSomething:(id)some {
    self = [super init];
    if (self) {
        // Don't call onInit or afterInit.
        self.something = some;
    }
    return self;
}

- (void)onInit {
    [super onInit];
    // Something
}

- (void)afterInit {
    [super afterInit];
    // Something
}
```

## More

You can find more example at https://github.com/RFUI. eg RFCheckbox.