//
//  UIImage+RoundedCornerAdditions.h
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 4/5/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end