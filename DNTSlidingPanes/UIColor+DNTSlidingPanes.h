//
//  UIColor+DNTSlidingPanes.h
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DNTSlidingPanes)

/**
 * @abstract
 * Utility class method to get a color based on
 * an objects memory location.
 */
+ (UIColor *)colorForObject:(id<NSObject>)object;

@end

@interface NSObject (DNTSlidingPanes)

/**
 * @abstract
 * Get a color which represents the receiver's
 * location in memory. Very handy for debugging
 * layout of subviews.
 */
- (UIColor *)color;

@end
