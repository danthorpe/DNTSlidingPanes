//
//  UIColor+DNTSlidingPanes.m
//  DNTSlidingPanes
//
//  Created by Daniel Thorpe on 10/03/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import "UIColor+DNTSlidingPanes.h"

@implementation UIColor (DNTSlidingPanes)

+ (UIColor *)colorForObject:(id<NSObject>)object {
    return [UIColor colorWithRed: (((int)object) & 0xFF) / 255.0
                           green: (((int)object >> 8) & 0xFF) / 255.0
                            blue: (((int)object >> 16) & 0xFF) / 255.0
                           alpha: 0.5f];
}

@end

@implementation NSObject (DNTSlidingPanes)

- (UIColor *)color {
    return [UIColor colorForObject:self];
}

@end

