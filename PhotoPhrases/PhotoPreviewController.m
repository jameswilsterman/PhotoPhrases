//
//  PhotoPreviewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "PhotoPreviewController.h"
#import <Parse/Parse.h>
#import "WritePhraseViewController.h"
#import "staticMethods.h"

@interface PhotoPreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFObject *photo = [self.selectedObject objectForKey:@"Photo"];
    
    PFFile *imageFile = [photo objectForKey:@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if (!error){
                self.photoImageView.image = [UIImage imageWithData:data];
            }else {
                NSLog(@"Could not get image: %@",[error localizedDescription]);
            }
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFlagOptions:(id)sender {
    
    UIAlertController *timeSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Flag as offensive" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [staticMethods flagChainActivity:self.selectedObject.objectId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Block user" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        PFUser *fromUserForChain = [self.selectedObject objectForKey:@"fromPFUser"];
        NSString *objectId = fromUserForChain.objectId;
        [staticMethods flagChainActivity:self.selectedObject.objectId];
        [staticMethods blockUser:objectId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:timeSheet animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WritePhraseViewController *wpvc = segue.destinationViewController;
    wpvc.selectedObject = self.selectedObject;
    
}


@end
