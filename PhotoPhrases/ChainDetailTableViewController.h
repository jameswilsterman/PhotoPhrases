//
//  ChainDetailTableViewController.h
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface ChainDetailTableViewController : UITableViewController
@property (nonatomic, strong) PFObject *selectedChain;
@end
