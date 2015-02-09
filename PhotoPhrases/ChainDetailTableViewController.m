//
//  ChainDetailTableViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import <Parse/Parse.h>
#import "ChainDetailTableViewController.h"
#import "PhotoTableViewCell.h"


@interface ChainDetailTableViewController ()
@property (nonatomic, strong) NSArray *chainActivities;
@end

@implementation ChainDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chainActivities = @[];
  /*  [self.tableView registerClass: [PhotoTableViewCell class] forCellReuseIdentifier:@"photoCell"];
     [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"phraseCell"];
   */
    PFQuery *query = [PFQuery queryWithClassName:@"ChainActivity"];
    [query whereKey:@"partOfChain" equalTo:self.selectedChain];
    [query includeKey:@"fromPFUser"];
    [query includeKey:@"Photo"];
    [query orderByAscending:@"linkIndex"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            self.chainActivities = objects;
            [self.tableView reloadData];
            
        }else {
            NSLog(@"Something went wrong %@:",[error description]);
        }
    }];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.chainActivities.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chainActivity = [self.chainActivities objectAtIndex:indexPath.row];
    
    if ([chainActivity objectForKey:@"Photo"]){
        return 250.00;
    }
    
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *chainActivity = [self.chainActivities objectAtIndex:indexPath.row];
    
    if ([chainActivity objectForKey:@"Photo"]){
        
        PhotoTableViewCell *photoCell = [self.tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        PFObject *photo = [chainActivity objectForKey:@"Photo"];
        
        PFFile *imageFile = [photo objectForKey:@"image"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if (!error){
                photoCell.photoImageView.image = [UIImage imageWithData:data];
                
                PFUser *fromUser = [chainActivity objectForKey:@"fromPFUser"];
                NSString *fromUserDisplayName = [fromUser objectForKey:@"displayName"];
                if (fromUserDisplayName == (id)[NSNull null] || fromUserDisplayName.length == 0 ) {
                    photoCell.photoCredit.text = @" Photo by Anonymous\t";
                } else {
                    photoCell.photoCredit.text = [NSString stringWithFormat:@" Photo by %@\t",fromUserDisplayName];
                }
            }else {
                NSLog(@"Could not get image: %@",[error localizedDescription]);
            }
        }];
        
        return photoCell;
        
    }else if ([chainActivity objectForKey:@"phraseText"]){
       
        UITableViewCell *cell   = [self.tableView dequeueReusableCellWithIdentifier:@"phraseCell" forIndexPath:indexPath];
        
        PFUser *fromUserForChain = [chainActivity objectForKey:@"fromPFUser"];
        cell.textLabel.text = [chainActivity objectForKey:@"phraseText"];
        NSString *fromUserDisplayName = [fromUserForChain objectForKey:@"displayName"];
        if (fromUserDisplayName == (id)[NSNull null] || fromUserDisplayName.length == 0 ) {
            cell.detailTextLabel.text = @"Phrase by Anonymous";
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Phrase by %@",fromUserDisplayName];
        }
        
        return cell;

    }else{
        NSLog(@"Can't determine chain activity type!");
    }
    
    return nil;
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
