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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WritePhraseViewController *wpvc = segue.destinationViewController;
    wpvc.selectedObject = self.selectedObject;
    
}


@end
