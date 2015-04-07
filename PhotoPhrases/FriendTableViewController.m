//
//  FriendTableViewController.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 4/6/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "FriendTableViewController.h"
#import "FriendTableViewCell.h"
#import <Parse/Parse.h>

@interface FriendTableViewController ()
@property (nonatomic) NSArray *myFriends;
@end

@implementation FriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad FriendTableViewController");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear FriendTableViewController");
    self.myFriends = @[];
    
    [[PFUser currentUser] fetch];
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        NSArray *facebookFriends = [currentUser objectForKey:@"facebookFriends"];
        NSLog(@"facebookFriends.count: %lu", (unsigned long)facebookFriends.count);
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"facebookId" containedIn:facebookFriends];
        [query orderByAscending:@"displayName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error){
                self.myFriends = objects;
                NSLog(@"self.myFriends.count: %lu", (unsigned long)self.myFriends.count);
                [self.tableView reloadData];
            } else {
                NSLog(@"Something went wrong %@:",[error description]);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    } else {
        // show the signup or login screen?
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.myFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFriendCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    //NSLog(@"Getting cell for row: %d tagged: %d",indexPath.row,cell.tag);
    PFUser *friendForRow = [self.myFriends objectAtIndex:indexPath.row];
    
    NSString *friendDisplayName = [friendForRow objectForKey:@"displayName"];
    
    if (friendDisplayName == (id)[NSNull null] || friendDisplayName.length == 0 ) {
        cell.friendNameLabel.text = @"Anonymous";
    } else {
        cell.friendNameLabel.text = [NSString stringWithFormat:@"%@", friendDisplayName];
    }
    
    PFFile *profilePictureSmall = [friendForRow objectForKey:@"profilePictureSmall"];
    [profilePictureSmall getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error){
            NSLog(@"got profilePicture image data");
            cell.profileImage.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"Could not get image: %@",[error localizedDescription]);
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"Row Selected: %d",indexPath.row);
    
    if (self.myFriends && self.myFriends.count) {
        // PFUser *selectedUser = [self.myFriends objectAtIndex:indexPath.row];
        
        // [self performSegueWithIdentifier:@"photoPreviewSegue" sender:nil];
            
    } else {
        NSLog(@"Friend array is empty!");
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
