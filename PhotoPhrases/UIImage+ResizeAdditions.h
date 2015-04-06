//
//  UIImage+ResizeAdditions.h
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 4/5/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

@end
