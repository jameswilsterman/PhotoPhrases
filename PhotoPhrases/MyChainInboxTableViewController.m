//
//  MyChainInboxTableViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "MyChainInboxTableViewController.h"
#import <Parse/Parse.h>
#import "PhotoPreviewController.h"
#import "PhrasePreviewController.h"

@interface MyChainInboxTableViewController ()
@property (nonatomic) NSArray *myChainInbox;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@end

@implementation MyChainInboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emptyLabel.hidden = YES;
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.myChainInbox = @[];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChainActivity"];
    [query whereKey:@"toPFUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"responded" equalTo:@NO];
    [query includeKey:@"fromPFUser"];
    [query includeKey:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            self.myChainInbox = objects;
            
            if (!self.myChainInbox || !self.myChainInbox.count) {
                self.emptyLabel.hidden = NO;
                //self.tableView.hidden = YES;
            }
            
            [self.tableView reloadData];
            
        }else {
            NSLog(@"Something went wrong %@:",[error description]);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.myChainInbox.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInBoxCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    //NSLog(@"Getting cell for row: %d tagged: %d",indexPath.row,cell.tag);
    PFObject *chainForRow = [self.myChainInbox objectAtIndex:indexPath.row];

    NSString *chainType = @"Chain";
    if ([chainForRow objectForKey:@"Photo"]) {
        chainType = @"Photo";
    } else if ([chainForRow objectForKey:@"phraseText"]){
        chainType = @"Fraze";
    } else{
        NSLog(@"Can't determine chain type!");
    }
    
    PFUser *fromUserForChain = [chainForRow objectForKey:@"fromPFUser"];
    NSString *fromUserDisplayName = [fromUserForChain objectForKey:@"displayName"];
    if (fromUserDisplayName == (id)[NSNull null] || fromUserDisplayName.length == 0 ) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ from Anonymous", chainType];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ from %@", chainType, fromUserDisplayName];
    }
    
    // cell.detailTextLabel.text = chainForRow.objectId;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *date = [df stringFromDate:chainForRow.createdAt];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"on %@", date];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"Row Selected: %d",indexPath.row);
    
    if (self.myChainInbox && self.myChainInbox.count) {
        PFObject *selectedChain = [self.myChainInbox objectAtIndex:indexPath.row];
        
        if ([selectedChain objectForKey:@"Photo"]){
            [self performSegueWithIdentifier:@"photoPreviewSegue" sender:nil];
            
        } else if ([selectedChain objectForKey:@"phraseText"]){
            
            [self performSegueWithIdentifier:@"phrasePreviewSegue" sender:nil];
        } else{
            NSLog(@"Can't determine chain type!");
        }
    } else {
         NSLog(@"Chain array is empty!");
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"photoPreviewSegue"]) {
        
        PhotoPreviewController *photoPreview = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        PFObject *selectedObject = [self.myChainInbox objectAtIndex:indexPath.row];
        
        photoPreview.selectedObject = selectedObject;
        
    } else if ([segue.identifier isEqualToString:@"phrasePreviewSegue"]) {
        
        PhrasePreviewController *phrasePreview = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        PFObject *selectedObject = [self.myChainInbox objectAtIndex:indexPath.row];
        
        phrasePreview.selectedObject = selectedObject;
    }
}


@end
