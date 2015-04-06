//
//  UIColor+ColorExtensions.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 4/5/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "UIColor+ColorExtensions.h"

@implementation UIColor (ColorExtensions)

+ (UIColor *) backgroundPurpleColor
{
    return [UIColor colorWithRed:137.0/255.0 green:144.0/255.0 blue:175.0/255.0 alpha:1.0];
}

+ (UIColor *) logoBlueColor
{
    return [UIColor colorWithRed:215.0/255.0 green:246.0/255.0 blue:254.0/255.0 alpha:1.0];
}

+ (UIColor *) logoBlueColorWithAlpha
{
    return [UIColor colorWithRed:215.0/255.0 green:246.0/255.0 blue:254.0/255.0 alpha:0.5];
}

+ (UIColor *) accentRedColor
{
    return [UIColor colorWithRed:247.0/255.0 green:66.0/255.0 blue:93.0/255.0 alpha:1.0];
}

+ (UIColor *) textGrayColor
{
    return [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
}

@end
