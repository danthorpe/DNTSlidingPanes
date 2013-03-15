//
//  DNTAppDelegate.m
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import "DNTAppDelegate.h"

#import "DNTSlidingPanesController.h"
#import "DNTDemoViewController.h"

@interface DNTAppDelegate ( /* Private */ ) <DNTSlidingPanesControllerDelegate>

@end

@implementation DNTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    DNTDemoViewController *root = [[DNTDemoViewController alloc] init];

    DNTSlidingPanesController *controller = [[DNTSlidingPanesController alloc] initWithRootViewController:root];
    controller.delegate = self;
    self.window.rootViewController = controller;

    DNTDemoViewController *left = [[DNTDemoViewController alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];

    DNTDemoViewController *right = [[DNTDemoViewController alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];

    [controller setViewController:left atPosition:DNTSlidingPanesLeftPosition withBarButtonItem:leftItem];
    [controller setViewController:right atPosition:DNTSlidingPanesRightPosition withBarButtonItem:rightItem];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - DNTSlidingPanesControllerDelegate

- (CGFloat)slidingPaneController:(DNTSlidingPanesController *)controller widthOfPaneInPosition:(DNTSlidingPanesPosition)position {
    return 260.f;
}

- (CGSize)cornerRadiiForSlidingPaneController:(DNTSlidingPanesController *)controller {
    return CGSizeMake(9.f, 9.f);
}

- (UIRectCorner)roundedCornersForSlidingPaneController:(DNTSlidingPanesController *)controller {
    return UIRectCornerTopLeft | UIRectCornerTopRight;
}

@end
