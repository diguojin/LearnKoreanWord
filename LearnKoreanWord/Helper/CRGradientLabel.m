//
//  CRGradientLabel.m
//  CRGradientLabel
//
//  Created by diguojin on 15/6/29.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//
//
//

#import "CRGradientLabel.h"

@import CoreGraphics;

@interface CRGradientLabel ()

@end

@implementation CRGradientLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[self.gradientColors count]];

    [self.gradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIColor class]]) {
            [colors addObject:(__bridge id)[obj CGColor]];
        } else if (CFGetTypeID((__bridge void *)obj) == CGColorGetTypeID()) {
            [colors addObject:obj];
        } else {
            @throw [NSException exceptionWithName:@"CRGradientLabelError"
                                           reason:@"Object in gradientColors array is not a UIColor or CGColorRef"
                                         userInfo:NULL];
        }
    }];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);

    [super drawRect: rect];
}

@end
