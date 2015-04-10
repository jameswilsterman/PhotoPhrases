//
//  FriendTableViewController.h
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 4/6/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendTableViewController : UITableViewController
@property (nonatomic, strong) PFUser *selectedUser;
@property (nonatomic, copy) void (^somethingHappenedInModalVC)(PFUser *response);
@end