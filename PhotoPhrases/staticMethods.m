//
//  staticMethods.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "staticMethods.h"

@implementation staticMethods

+ (void)flagChainActivity:(NSString *)objectId {
    NSLog(@"flagChainActivity...");
    
    [PFCloud callFunctionInBackground:@"flagChainActivity"
                       withParameters:@{@"objectId":objectId}
                                block:^(id result, NSError *error) {
                                    // ?
                                }];
}

+ (void)blockUser:(NSString *)objectId {
    NSLog(@"blockUser...");
    
    [PFCloud callFunctionInBackground:@"blockUser"
                       withParameters:@{@"objectId":objectId}
                                block:^(id result, NSError *error) {
                                    // ?
                                }];
}

+ (void)flagChain:(NSString *)objectId {
    NSLog(@"flagChain...");
    
    [PFCloud callFunctionInBackground:@"flagChain"
                       withParameters:@{@"objectId":objectId}
                                block:^(id result, NSError *error) {
                                    // ?
                                }];
    
}

+ (void)blockChainUsers:(NSString *)objectId {
    NSLog(@"blockChainUsers...");
    
    [PFCloud callFunctionInBackground:@"blockChainUsers"
                       withParameters:@{@"objectId":objectId}
                                block:^(id result, NSError *error) {
                                    // ?
                                }];
    
}

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
