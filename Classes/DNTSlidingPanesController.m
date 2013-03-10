//
//  DNTSlidingPanesController.m
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import "DNTSlidingPanesController.h"
#import "UIColor+DNTSlidingPanes.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, DNTSlidingPanesState) {
    DNTSlidingPanesIdleState = 0,
    DNTSlidingPanesLeftState,
    DNTSlidingPanesRightState
};

#define kGestureRecognizerViewMultiplier 3
#define kLeftViewControllerViewTag 57
#define kRightViewControllerViewTag 75

#define kGestureRecognizerWidth 60.f
#define kDefaultPaneWidth 260.f
#define kDefaultCornerRadius 9.f

@interface DNTSlidingPanesController ( /* Private */ )

@property (nonatomic) DNTSlidingPanesState state;
@property (nonatomic, readwrite) UIViewController *rootViewController;
@property (nonatomic) UINavigationController *navigationViewController;
@property (nonatomic) UISwipeGestureRecognizer *leftGestureRecognizer;
@property (nonatomic) UISwipeGestureRecognizer *rightGestureRecognizer;
@property (nonatomic) NSMutableDictionary *panes;
@property (nonatomic) NSMutableDictionary *navigationItems;

@end

@implementation DNTSlidingPanesController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.rootViewController = rootViewController;
        self.navigationViewController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
        self.panes = [NSMutableDictionary dictionaryWithCapacity:DNTSlidingPanesPositionCount];
        self.navigationItems = [NSMutableDictionary dictionaryWithCapacity:DNTSlidingPanesPositionCount];
    }
    return self;
}

#pragma mark - UIVIewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add the root controller
    [self addRootViewController];

    // Set the view controllers
    NSInteger position;
    for ( position = 0; position < DNTSlidingPanesPositionCount; position++ ) {
        UIViewController *vc = [self viewControllerAtPosition:position];
        if (vc) {
            [self setViewController:vc atPosition:position withBarButtonItem:self.navigationItems[@(position)]];
        }
    }
}

#pragma mark - Private API

- (void)addRootViewController {
    // Make sure that the navigation bar is not hidden
    self.navigationViewController.navigationBarHidden = YES;
    self.rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addChildViewController:self.navigationViewController];
    self.navigationViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.navigationViewController.view];
    [self.navigationViewController didMoveToParentViewController:self];
    CGFloat cornerRadius = self.delegate ? [self.delegate cornerRadiusForSlidingPanesControllers:self] : kDefaultCornerRadius;
    self.navigationViewController.view.layer.cornerRadius = cornerRadius;
    self.navigationViewController.view.layer.masksToBounds = YES;
}

- (void)addViewController:(UIViewController *)viewController atPosition:(DNTSlidingPanesPosition)position {
    NSParameterAssert(viewController);
    self.navigationViewController.navigationBarHidden = NO;
    // Add the view controller
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view insertSubview:viewController.view belowSubview:self.navigationViewController.view];
    [viewController didMoveToParentViewController:self];
    viewController.view.tag = position == DNTSlidingPanesLeftPosition ? kLeftViewControllerViewTag : kRightViewControllerViewTag;
}

- (void)setBarButtonItem:(UIBarButtonItem *)barButtonItem atPosition:(DNTSlidingPanesPosition)position {

    // Set the target/action
    [barButtonItem setTarget:self];
    if ( position == DNTSlidingPanesLeftPosition ) {
        [barButtonItem setAction:@selector(toggleLeftPane:)];
        self.rootViewController.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        [barButtonItem setAction:@selector(toggleRightPane:)];
        self.rootViewController.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)addGestureRecognizerAtPosition:(DNTSlidingPanesPosition)position {
    NSInteger tag = kGestureRecognizerViewMultiplier * (position == DNTSlidingPanesLeftPosition ? kLeftViewControllerViewTag : kRightViewControllerViewTag);
    UIView *view = [self.view viewWithTag:tag];
    if ( !view ) {

        // Define the rect
        CGFloat x;
        CGFloat y = !self.navigationViewController.navigationBarHidden ? CGRectGetHeight(self.navigationViewController.navigationBar.frame) : 0.f;
        UISwipeGestureRecognizer *swipe = nil;

        if ( position == DNTSlidingPanesLeftPosition ) {
            x = 0.f;
            self.leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLeftPane:)];
            self.leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
            swipe = self.leftGestureRecognizer;

        } else {
            x = CGRectGetWidth(self.view.bounds) - kGestureRecognizerWidth;
            self.rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRightPane:)];
            self.rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            swipe = self.rightGestureRecognizer;
        }

        CGRect rect = CGRectMake(x, y, kGestureRecognizerWidth, CGRectGetHeight(self.view.bounds));

        view = [[UIView alloc] initWithFrame:rect];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view.tag = tag;
        view.backgroundColor = [view color];
        [view addGestureRecognizer:swipe];

        [self.navigationViewController.view insertSubview:view aboveSubview:self.navigationViewController.view];
    }
}

- (IBAction)toggleLeftPane:(id)sender {
    if ( self.state == DNTSlidingPanesIdleState ) {
        [self navigateToState:DNTSlidingPanesLeftState animated:YES];
        self.leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    } else {
        [self navigateToState:DNTSlidingPanesIdleState animated:YES];
        self.leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
}

- (IBAction)toggleRightPane:(id)sender {
    if ( self.state == DNTSlidingPanesIdleState ) {
        [self navigateToState:DNTSlidingPanesRightState animated:YES];
        self.rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    } else {
        [self navigateToState:DNTSlidingPanesIdleState animated:YES];
        self.rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
}

- (CGRect)frameForState:(DNTSlidingPanesState)state {

    CGRect frame = self.navigationViewController.view.frame;
    CGRect rect = frame;

    switch (state) {

        case DNTSlidingPanesLeftState: {
            rect.origin.x = self.delegate ? [self.delegate slidingPaneController:self widthOfPaneInPosition:DNTSlidingPanesLeftPosition] : kDefaultPaneWidth;
        } break;

        case DNTSlidingPanesRightState: {
            rect.origin.x = - ( self.delegate ? [self.delegate slidingPaneController:self widthOfPaneInPosition:DNTSlidingPanesRightPosition] : kDefaultPaneWidth );
        } break;

        default:
            rect = self.view.bounds;
            break;
    }

    return rect;
}

- (void)navigateToState:(DNTSlidingPanesState)state animated:(BOOL)animated {
    if ( self.state != state ) {

        // Get the state
        CGRect frame = [self frameForState:state];

        // Animate the frame
        if ( animated ) {
            [UIView animateWithDuration:0.2 animations:^{
                self.navigationViewController.view.frame = frame;
            }];
        } else {
            self.navigationViewController.view.frame = frame;
        }

        // Update the state
        self.state = state;
    }
}

#pragma mark - Public API

- (UIViewController *)viewControllerAtPosition:(DNTSlidingPanesPosition)position {
    return self.panes[@(position)];
}

- (void)setViewController:(UIViewController *)viewController
               atPosition:(DNTSlidingPanesPosition)position
        withBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSParameterAssert(viewController);

    if ( [self isViewLoaded] ) {

        // Add the view controller
        [self addViewController:viewController atPosition:position];

        // Set the navigation item
        [self setBarButtonItem:barButtonItem atPosition:position];

        // Add a gesture recognizer
        [self addGestureRecognizerAtPosition:position];

    } else {
        [self.panes setObject:viewController forKey:@(position)];
        [self.navigationItems setObject:barButtonItem forKey:@(position)];
    }
}


@end
