//
//  DNTSlidingPanesController.h
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DNTSlidingPanesPosition) {
    DNTSlidingPanesLeftPosition = 0,
    DNTSlidingPanesRightPosition,
    DNTSlidingPanesPositionCount
};

@class DNTSlidingPanesController;

@protocol DNTSlidingPanesControllerDelegate <NSObject>

/**
 * @abstract
 * Allow the delegate to override the default width of the pane
 * in each position.
 */
- (CGFloat)slidingPaneController:(DNTSlidingPanesController *)controller widthOfPaneInPosition:(DNTSlidingPanesPosition)position;

@end

@interface DNTSlidingPanesController : UIViewController

@property (nonatomic, weak) id <DNTSlidingPanesControllerDelegate> delegate;

/**
 * @abstract
 * Designated initializer
 *
 * @discussion
 * Initialize the view controller with a root controller which appears
 * as the primary screen.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController;

/**
 * @abstract
 * The view controller at the given position
 */
- (UIViewController *)viewControllerAtPosition:(DNTSlidingPanesPosition)position;

/**
 * @abstract
 * Sets the view controller at the left or right position
 *
 * @discussion
 * The view controller will replace any previously set view controller at that position
 * and the navigation item will be set on the root view controller.
 */
- (void)setViewController:(UIViewController *)viewController atPosition:(DNTSlidingPanesPosition)position withBarButtonItem:(UIBarButtonItem *)barButtonItem;

@end
