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

@end
