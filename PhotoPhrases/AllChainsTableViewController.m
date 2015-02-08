//
//  AllChainsTableViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "AllChainsTableViewController.h"
#import "ChainDetailTableViewController.h"
#import <Parse/Parse.h>

@interface AllChainsTableViewController ()
@property (nonatomic) NSArray *allChains;
@end

@implementation AllChainsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *allCompletedChainsQuery = [PFQuery queryWithClassName:@"Chain"];
    [allCompletedChainsQuery whereKey:@"final" equalTo:@YES];
    [allCompletedChainsQuery includeKey:@"startedBy"];
    [allCompletedChainsQuery orderByDescending:@"createdAt"];
    [allCompletedChainsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            self.allChains = objects;
            [self.tableView reloadData];
        }else {
            NSLog(@"Something went wrong %@:",[error description]);
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    
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
    return self.allChains.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chainCell" forIndexPath:indexPath];
    
    PFObject *chainForRow = [self.allChains objectAtIndex:indexPath.row];
    
    PFUser *startedBy = [chainForRow objectForKey:@"startedBy"];
    cell.textLabel.text = [NSString stringWithFormat:@"Chain started by: %@",[startedBy objectForKey:@"displayName"]];
    cell.detailTextLabel.text = chainForRow.objectId;
    
    return cell;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
        ChainDetailTableViewController *chainDetail = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        PFObject *selectedChain = [self.allChains objectAtIndex:indexPath.row];
        
        chainDetail.selectedChain = selectedChain;
        

}


@end
