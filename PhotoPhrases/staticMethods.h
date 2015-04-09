//
//  staticMethods.h
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface staticMethods : NSObject

+ (void)flagChainActivity:(NSString *)objectId;
+ (void)blockUser:(NSString *)objectId;

+ (void)flagChain:(NSString *)objectId;
+ (void)blockChainUsers:(NSString *)objectId;
+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;
@end
