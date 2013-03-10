//
//  DNTSlidingPanesControllerTests.m
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OCMock/OCMock.h>

#import "DNTSlidingPanesController.h"

@interface DNTSlidingPanesControllerTests : SenTestCase
@property (nonatomic) NSString *classUnderTest;
@property (nonatomic) UIViewController *viewController;
@property (nonatomic) DNTSlidingPanesController *controller;
@end

@interface DNTSlidingPanesController ( TestSupport )

@property (nonatomic, readwrite) UIViewController *rootViewController;
@property (nonatomic) UINavigationController *navigationViewController;
@property (nonatomic) UISwipeGestureRecognizer *leftGestureRecognizer;
@property (nonatomic) UISwipeGestureRecognizer *rightGestureRecognizer;
@property (nonatomic) NSMutableDictionary *panes;
@property (nonatomic) NSMutableDictionary *navigationItems;

- (void)addRootViewController;

@end

@implementation DNTSlidingPanesControllerTests

- (void)setUp {
    [super setUp];
    self.classUnderTest = NSStringFromClass([DNTSlidingPanesController class]);
    self.viewController = [[UIViewController alloc] init];
    self.controller = [[DNTSlidingPanesController alloc] initWithRootViewController:self.viewController];
}

- (void)tearDown {
    self.classUnderTest = nil;
    self.viewController = nil;
    self.controller = nil;
    [super tearDown];
}

- (void)test_initalizer {
    STAssertNotNil(self.controller, @"Not correctly initalized %@", self.classUnderTest);
    STAssertNotNil(self.controller.panes, @"Should have a dictionary for the panes after initalizing: %@", self.classUnderTest);
    STAssertNotNil(self.controller.navigationItems, @"Should have a dictionary for the navigation items after initalizing: %@", self.classUnderTest);
    STAssertNotNil(self.controller.navigationViewController, @"Should have a navigation controller after initalizing: %@", self.classUnderTest);
    STAssertEqualObjects(self.controller.rootViewController, self.viewController, @"The controller's rootViewController: %@ should be equal to %@", self.controller.rootViewController, self.viewController);
    STAssertEqualObjects(self.controller.navigationViewController.topViewController, self.viewController, @"The controller's topViewController: %@ should be equal to %@", self.controller.rootViewController, self.viewController);
}

- (void)test_addingRootViewController {

    [self.controller addRootViewController];

    STAssertTrue([self.controller.childViewControllers containsObject:self.controller.navigationViewController], @"The controller should have the navigation controller as a child view controller.");
    STAssertTrue([self.controller.view.subviews containsObject:self.controller.navigationViewController.view], @"The view should have the navigation controller's view as a subview.");
}

@end
